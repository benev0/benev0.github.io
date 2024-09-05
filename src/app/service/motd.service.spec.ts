import { TestBed } from '@angular/core/testing';

import { MotdService } from './motd.service';

describe('MotdService', () => {
  let service: MotdService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MotdService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
