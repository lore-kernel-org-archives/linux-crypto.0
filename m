From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 1/7] staging: ccree: fix hash import/export
Date: Sun, 25 Jun 2017 09:21:30 +0300
Message-ID: <CAOtvUMfKaMq_vG+fuDRpwWFkN-9Fz6MfZ=n8rjNSDL06_iXOuw@mail.gmail.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
 <1498138623-6126-2-git-send-email-gilad@benyossef.com> <20170622135811.4wbh7dqi634j5d2c@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35519 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdFYGVb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Jun 2017 02:21:31 -0400
Received: by mail-yw0-f182.google.com with SMTP id j11so8233011ywa.2
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2017 23:21:31 -0700 (PDT)
In-Reply-To: <20170622135811.4wbh7dqi634j5d2c@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 22, 2017 at 4:58 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Jun 22, 2017 at 04:36:55PM +0300, Gilad Ben-Yossef wrote:
>>  static int ssi_ahash_export(struct ahash_request *req, void *out)
>>  {
>>       struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
>>       struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
>> +     struct device *dev = &ctx->drvdata->plat_dev->dev;
>> +     struct ahash_req_ctx *state = ahash_request_ctx(req);
>> +     u8 *curr_buff = state->buff_index ? state->buff1 : state->buff0;
>> +     u32 curr_buff_cnt = state->buff_index ? state->buff1_cnt :
>> +                             state->buff0_cnt;
>> +     const u32 tmp = CC_EXPORT_MAGIC;
>> +
>> +     CHECK_AND_RETURN_UPON_FIPS_ERROR();
>>
>> -     return ssi_hash_export(ctx, out);
>> +     memcpy(out, &tmp, sizeof(u32));
>> +     out += sizeof(u32);
>> +
>> +     dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
>> +                             ctx->inter_digestsize, DMA_BIDIRECTIONAL);
>> +     memcpy(out, state->digest_buff, ctx->inter_digestsize);
>> +     out += ctx->inter_digestsize;
>> +
>> +     if (state->digest_bytes_len_dma_addr) {
>> +             dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
>> +                                     HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
>> +             memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
>> +     }
>> +     out += HASH_LEN_SIZE;
>
> I'm sorry to ask this question now instead of on my first review.  I was
> waiting for my other computer to get ready so I could look up how this
> is called.  But now that I've looked at it, I'm still not sure how this
> is called.

No reason to be sorry. I value every review I get, no matter the timing :-)

>
> Anyway, my question is, is out zeroed memory?  Should we have something
> like:
>         } else {
>                 memset(out, 0, HASH_LEN_SIZE);
>         }
>         out += HASH_LEN_SIZE;
>

The export/import function serialize internal hash state into/from a
user supplied
buffer, which may or may not be zeroed.

The import/output is an opaque struct to the user, and in these
specific circumstances
that field (location in hashed data) is simply not used.

After thinking about it, I think the correct thing to do here is to
poison the unused field,
rather than zero it to make it easier to debug cases where someone
passes to export
an import of a different hash/parameters.

Thanks for pointing it out.


> The ->import() function has a similar snippet.

That one is easier as the internal data that is being imported is
simply not allocated
in this scenario at all.

Thanks!
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
