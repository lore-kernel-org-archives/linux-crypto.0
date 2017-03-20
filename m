From: Mahipal Reddy <mahipalreddy2006@gmail.com>
Subject: Re: [PATCH] crypto: zip - Memory corruption in zip_clear_stats()
Date: Mon, 20 Mar 2017 19:52:21 +0530
Message-ID: <CALyTkE_msYfR72Sjs_2x92SjzrppHdOXNft0j9eVcDjz17SW=w@mail.gmail.com>
References: <20170317204621.GD16505@mwanda> <58CD0AE2.3070006@bfs.de> <20170318105927.GA4343@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: walter harms <wharms@bfs.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jan Glauber <jglauber@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170318105927.GA4343@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Mar 18, 2017 at 4:29 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Mar 18, 2017 at 11:24:34AM +0100, walter harms wrote:
>>
>>
>> Am 17.03.2017 21:46, schrieb Dan Carpenter:
>> > There is a typo here.  It should be "stats" instead of "state".  The
>> > impact is that we clear 224 bytes instead of 80 and we zero out memory
>> > that we shouldn't.

Thank you Dan for identifying the issue. Yes there is a typo and it needs a fix.


>> > Fixes: 09ae5d37e093 ("crypto: zip - Add Compression/Decompression statistics")
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> >
>> > diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
>> > index 0951e20b395b..6ff13d80d82e 100644
>> > --- a/drivers/crypto/cavium/zip/zip_main.c
>> > +++ b/drivers/crypto/cavium/zip/zip_main.c
>> > @@ -530,7 +530,7 @@ static int zip_clear_stats(struct seq_file *s, void *unused)
>> >     for (index = 0; index < MAX_ZIP_DEVICES; index++) {
>> >             if (zip_dev[index]) {
>> >                     memset(&zip_dev[index]->stats, 0,
>> > -                          sizeof(struct zip_state));
>> > +                          sizeof(struct zip_stats));

Yes this resolves the issue.
Thanks for this fix.
Mahipal

>>
>> as future FIXME some show find a name that differ in more than just the last char.
>> NTL maybe
>>  sizeof(zip_dev[index]->stats)
>> can be used here ?
>
> That's sort of unweildy.  I don't fear that change because I'm confident
> I would catch it with static analysis.
>
> regards,
> dan carpenter
>
