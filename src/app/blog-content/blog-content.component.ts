import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MarkdownComponent } from 'ngx-markdown';

@Component({
  selector: 'app-blog-content',
  standalone: true,
  imports: [
    MarkdownComponent,
  ],
  templateUrl: './blog-content.component.html',
  styleUrl: './blog-content.component.css'
})
export class BlogContentComponent implements OnInit{
  name!: string;

  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.name = this.route.snapshot.paramMap.get('name')!;
  }
}
