import { Component, OnInit } from '@angular/core';
import { RouterModule, ActivatedRoute, NavigationEnd, Router} from '@angular/router';
import { CommonModule } from '@angular/common';
import { filter } from 'rxjs/operators';
import { LatexParagraphComponent } from '../latex-paragraph/latex-paragraph.component';

@Component({
  selector: 'app-blog',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    LatexParagraphComponent
  ],
  templateUrl: './blog.component.html',
  styleUrl: './blog.component.css'
})
export class BlogComponent implements OnInit {
  BlogEntries = [
    {title:"blog1", blurb:"$f(0)=0$"},
    {title:"blog2", blurb:"$f(1)=1$"},
    {title:"blog3", blurb:"$f(n)=f(n-2)+f(n-1)$"},
  ]

  isBlogActive: boolean = false;

  constructor(private router: Router, private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      this.isBlogActive = this.route.children.length > 0;
    });
  }
}
