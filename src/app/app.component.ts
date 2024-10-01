import { Component, ElementRef, NgZone, OnDestroy, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { NavBarComponent } from './nav-bar/nav-bar.component';
import { LatexParagraphComponent } from './latex-paragraph/latex-paragraph.component';
import { Subscription, fromEvent, } from 'rxjs';
import { debounceTime } from 'rxjs/operators';
import { MOTD } from './types/motd';
import { MOTDService } from './service/motd.service';

const MAX_WIDTH: number = 920;

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    CommonModule,
    RouterOutlet,
    NavBarComponent,
    LatexParagraphComponent,
  ],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit, OnDestroy {
  over: boolean = true;
  title = 'github';
  resizeSubscription?: Subscription;
  DataMOTD?: MOTD;
  motdReady = false;

  constructor(private host: ElementRef, private zone: NgZone, private MOTDService: MOTDService) {}

  ngOnInit() {
    this.over = window.innerWidth > MAX_WIDTH;
    this.resizeSubscription = fromEvent(window, 'resize')
      .pipe(debounceTime(100))
      .subscribe(() => {
        const newWidth = window.innerWidth;
        this.over = newWidth > MAX_WIDTH;
    });

    this.MOTDService.getRandomMOTD()
      .then((value) => {
        this.DataMOTD = value;
        this.motdReady = true;
      }).catch((err) => {
        console.error(err);
      });
  }

  ngOnDestroy() {
    if (!this.resizeSubscription) {
      return;
    }

    this.resizeSubscription.unsubscribe();
  }

}
