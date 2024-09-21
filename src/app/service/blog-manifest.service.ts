import { Injectable } from '@angular/core';
import { BlogEntry } from '../types/blog-entry';
import { HttpClient } from '@angular/common/http';
import { tap, map } from 'rxjs/operators';
import { Observable, firstValueFrom, of } from 'rxjs';


@Injectable({
  providedIn: 'root'
})
export class BlogManifestService {
  private manifestUrl = "https://raw.githubusercontent.com/benev0/blog/main/blog-manifest.json";
  private urlWithTimestamp = `${this.manifestUrl}?t=${new Date().getTime()}`;
  private manifest : BlogEntry[] | null = null;

  private manifestMap : Map<string, BlogEntry> = new Map<string, BlogEntry>();

  constructor(private http: HttpClient) {}


  getManifest(): Promise<BlogEntry[]> {
    if (this.manifest) { // check cache
      return firstValueFrom(of(this.manifest));
    }

    return firstValueFrom(
      this.http.get<BlogEntry[]>(this.urlWithTimestamp).pipe(
        map((rawData: any[]) => this.processData(rawData)),
        tap((processedData: BlogEntry[]) => {
          this.manifest = processedData; // cache here
          for (let blog of this.manifest) {
            this.manifestMap.set(blog.path, blog);
          }
        })
      )
    );
  }

  private processData(rawData: any[]): BlogEntry[] {
    return rawData.map(item => ({
      title: item.title,
      path: item.title.replaceAll(' ', '_'),
      blurb: item.blurb,
      source: item.source,
    }));
  }

  async getPage(blogPath:string) : Promise<string> {
    await this.getManifest();
    let targetBlog = this.manifestMap.get(blogPath);

    if (targetBlog === undefined) {
      return firstValueFrom(of("# 404 Error\n# Blog Page Not Found"));
    }

    return firstValueFrom(this.http.get(targetBlog!.source, {responseType: 'text'}));
  }
}
