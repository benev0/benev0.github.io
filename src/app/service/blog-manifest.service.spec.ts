import { TestBed } from '@angular/core/testing';

import { BlogManifestService } from './blog-manifest.service';

describe('BlogManifestService', () => {
  let service: BlogManifestService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BlogManifestService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
