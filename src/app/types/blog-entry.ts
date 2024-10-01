export interface BlogEntry
{
        title: string;
        path: string;
        blurb: string;
        source: string;

        author?: string;
        authorLink?: string;
        published?: Date;
}
