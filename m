From: xiakaixu <xiakaixu@huawei.com>
Subject: Re: Kernel panic - encryption/decryption failed when open file on
 Arm64
Date: Tue, 13 Sep 2016 10:05:11 +0800
Message-ID: <57D75ED7.7080602@huawei.com>
References: <57D15BD3.40903@huawei.com>
 <20160908124709.GA26586@gondor.apana.org.au> <57D28CB8.4080904@huawei.com>
 <CAKv+Gu9JDCHDteOvgpEg4SJP4OKgM6=euF3pzBcXDJxTt=dAYg@mail.gmail.com>
 <CAKv+Gu8w+BuwxQjOtpnFPHnJNUzq7m0K+KJ8=FG2wHigaB54ng@mail.gmail.com>
 <00B10D30F2BAA743B48953A4D86C96D54C8A8A@SZXEMI506-MBS.china.huawei.com>
 <CAKv+Gu9jaVyJ4PYsxZfiZXB3Uezr26YWhSyE-g+n6-AuWFcneQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: liushuoran <liushuoran@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "mh1@iki.fi" <mh1@iki.fi>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wangbintian <bintian.wang@huawei.com>,
        Huxinwei <huxinwei@huawei.com>,
        "zhangzhibin (C)" <zhangzhibin.zhang@huawei.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:32776 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753940AbcIMCGF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2016 22:06:05 -0400
In-Reply-To: <CAKv+Gu9jaVyJ4PYsxZfiZXB3Uezr26YWhSyE-g+n6-AuWFcneQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> On 12 September 2016 at 03:16, liushuoran <liushuoran@huawei.com> wrote:
>> Hi Ard,
>>
>> Thanks for the prompt reply. With the patch, there is no panic anymore. But it seems that the encryption/decryption is not successful anyway.
>>
>> As Herbert points out, "If the page allocation fails in blkcipher_walk_next it'll simply switch over to processing it block by block". So does that mean the encryption/decryption should be successful even if the page allocation fails? Please correct me if I misunderstand anything. Thanks in advance.
>>
>
> Perhaps Herbert can explain: I don't see how the 'n = 0' assignment
> results in the correct path being taken; this chunk (blkcipher.c:252)
>
> if (unlikely(n < bsize)) {
>      err = blkcipher_next_slow(desc, walk, bsize, walk->alignmask);
>      goto set_phys_lowmem;
> }
>
> is skipped due to the fact that n == 0 and therefore bsize == 0, and
> so the condition is always false for n == 0
>
> Therefore we end up here (blkcipher.c:257)
>
> walk->nbytes = n;
> if (walk->flags & BLKCIPHER_WALK_COPY) {
>      err = blkcipher_next_copy(walk);
>      goto set_phys_lowmem;
> }
>
> where blkcipher_next_copy() unconditionally calls memcpy() with
> walk->page as destination (even though we ended up here due to the
> fact that walk->page == NULL)
>
> So to me, it seems like we should be taking the blkcipher_next_slow()
> path, which does a kmalloc() and bails with -ENOMEM if that fails.

Hi Ard,

Thanks for such a detailed reply.

According to your reply, I just make a little change to take the
blkcipher_next_slow() path. I test it on arm64 board, there is
no panic anymore and seems the encryption/decryption is successful.

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 0122bec..5389d40 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -240,12 +240,13 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
                 walk->flags |= BLKCIPHER_WALK_COPY;
                 if (!walk->page) {
                         walk->page = (void *)__get_free_page(GFP_ATOMIC);
+                       walk->page = NULL;
                         if (!walk->page)
                                 n = 0;
                 }
         }

-       bsize = min(walk->walk_blocksize, n);
+       bsize = walk->walk_blocksize;
         n = scatterwalk_clamp(&walk->in, n);
         n = scatterwalk_clamp(&walk->out, n);

It is just a trial and not sure it makes sense. But anyway, we can do
something here to fix the crash result from the page allocation failure.

What's your opinions, Herbert?

Regards
Kaixu Xia
>
> .
>
