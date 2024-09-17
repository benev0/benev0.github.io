import { Component, OnInit } from '@angular/core';
import { RouterModule, ActivatedRoute, NavigationEnd, Router} from '@angular/router';
import { CommonModule } from '@angular/common';
import { filter } from 'rxjs/operators';
import { LatexParagraphComponent } from '../latex-paragraph/latex-paragraph.component';
import { BlogEntry } from '../types/blog-entry';
import { BlogManifestService } from '../service/blog-manifest.service';

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
  BlogEntries : BlogEntry[] = []

  isBlogActive: boolean = false;

  constructor(private router: Router, private route: ActivatedRoute, private blogManifest: BlogManifestService) {}

  ngOnInit(): void {
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      this.isBlogActive = this.route.children.length > 0;
    });

    this.isBlogActive = this.route.children.length > 0;

    this.blogManifest.getManifest().then(
      (response: BlogEntry[]) => {
        this.BlogEntries = response;
        console.log('Processed data', this.BlogEntries)
      }
    ).catch(
      (error) => {
        console.error('Error (cant acquire manifest):', error);
      }
    );
  }
}
