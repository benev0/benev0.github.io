import { Injectable } from '@angular/core';
import { BlogManifestService } from './blog-manifest.service';

@Injectable({
  providedIn: 'root'
})
export class MotdService {
  constructor(private blogManifest: BlogManifestService) { }

}
