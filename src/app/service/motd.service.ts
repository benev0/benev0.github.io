import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MOTD } from '../types/motd';
import { firstValueFrom, map, of, tap } from 'rxjs';
import { ModuleTeardownOptions } from '@angular/core/testing';


@Injectable({
  providedIn: 'root'
})
export class MOTDService {
  private MOTDUrl = "https://raw.githubusercontent.com/benev0/blog/main/motd-list.json";
  private urlWithTimestamp = `${this.MOTDUrl}?t=${new Date().getTime()}`;
  private MOTDList : MOTD[] | null = null;

  constructor(private http: HttpClient) {}

  getMOTDList(): Promise<MOTD[]> {
    if (this.MOTDList) {
      return firstValueFrom(of(this.MOTDList));
    }

    return firstValueFrom(
      this.http.get<MOTD[]>(this.urlWithTimestamp).pipe(
        map((rawData: any[]) => this.processData(rawData)),
        tap((processedData: MOTD[]) => {
          this.MOTDList = processedData;
        })
      )
    );
  }

  private processData(rawData: any[]): MOTD[] {
    return rawData.map(item => ({
      message: item.message ?? "",
      urlIsLocal: item.urlIsLocal ?? true,
      url: item.url ?? ""
    }));
  }

  async getRandomMOTD() : Promise<MOTD> {
    await this.getMOTDList();

    if (this.MOTDList == null) {
      return firstValueFrom(of({message:"*You Get Nothing*", urlIsLocal:true, url:""}));
    }

    return firstValueFrom(of(this.MOTDList[Math.floor(Math.random() * this.MOTDList.length)]));
  }

}
