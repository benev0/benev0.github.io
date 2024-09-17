import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MarkdownComponent } from 'ngx-markdown';
import { BlogManifestService } from '../service/blog-manifest.service';
import { BlogEntry } from '../types/blog-entry';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-blog-content',
  standalone: true,
  imports: [
    MarkdownComponent,
    CommonModule
  ],
  templateUrl: './blog-content.component.html',
  styleUrl: './blog-content.component.css'
})
export class BlogContentComponent implements OnInit{
  name!: string;
  content: string = '';
  BlogEntries: BlogEntry[] = [];
  isMarkdownReady: boolean = false;

  constructor(private route: ActivatedRoute, private blogManifest: BlogManifestService) {}

  ngOnInit(): void {
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

    this.name = this.route.snapshot.paramMap.get('name')!;

    this.blogManifest.getPage(this.name).then(
      (response: string) => {
        this.content = response;
        console.log(this.content);
        this.isMarkdownReady = true;
    }).catch(
      (error) => {
        console.error('Error (cant acquire page):', error);
      }
    );
  }
}
