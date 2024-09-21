import { Component, OnDestroy, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

import { routes } from '../app.routes';
import { RouterModule } from '@angular/router';
import { SettingsService } from '../service/settings.service';
import { Subscription } from 'rxjs';


@Component({
  selector: 'app-nav-bar',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule
  ],
  templateUrl: './nav-bar.component.html',
  styleUrl: './nav-bar.component.css'
})
export class NavBarComponent implements OnInit, OnDestroy{
  public routes = routes.filter((route) => {
    return route.data !== undefined && route.data!["navBar"];
  });

  public isDarkMode: boolean = false;
  private DarkModeSubscription?: Subscription;


  constructor(private SettingsService : SettingsService) {}

  ngOnInit(): void {
    this.DarkModeSubscription = this.SettingsService.isDarkModeSubject.subscribe((newValue) => {
      this.isDarkMode = newValue;
    });
  }

  ngOnDestroy(): void {
    this.DarkModeSubscription?.unsubscribe();
  }
}
