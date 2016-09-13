From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Kernel panic - encryption/decryption failed when open file on Arm64
Date: Tue, 13 Sep 2016 08:56:50 +0100
Message-ID: <CAKv+Gu9y_UDadH1Qu1b=rRmoagEjHj40Y3OHEredHxP5np_zrQ@mail.gmail.com>
References: <57D15BD3.40903@huawei.com> <20160908124709.GA26586@gondor.apana.org.au>
 <57D28CB8.4080904@huawei.com> <CAKv+Gu9JDCHDteOvgpEg4SJP4OKgM6=euF3pzBcXDJxTt=dAYg@mail.gmail.com>
 <CAKv+Gu8w+BuwxQjOtpnFPHnJNUzq7m0K+KJ8=FG2wHigaB54ng@mail.gmail.com>
 <00B10D30F2BAA743B48953A4D86C96D54C8A8A@SZXEMI506-MBS.china.huawei.com>
 <CAKv+Gu9jaVyJ4PYsxZfiZXB3Uezr26YWhSyE-g+n6-AuWFcneQ@mail.gmail.com> <20160913064329.GA26933@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: liushuoran <liushuoran@huawei.com>, Xiakaixu <xiakaixu@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "mh1@iki.fi" <mh1@iki.fi>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wangbintian <bintian.wang@huawei.com>,
        Huxinwei <huxinwei@huawei.com>,
        "zhangzhibin (C)" <zhangzhibin.zhang@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913064329.GA26933@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 13 September 2016 at 07:43, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Sep 12, 2016 at 06:40:15PM +0100, Ard Biesheuvel wrote:
>>
>> So to me, it seems like we should be taking the blkcipher_next_slow()
>> path, which does a kmalloc() and bails with -ENOMEM if that fails.
>
> Indeed.  This was broken a long time ago.  It does seem to be
> fixed in the new skcipher_walk code but here is a patch to fix
> it for older kernels.
>
> ---8<---
> Subject: crypto: skcipher - Fix blkcipher walk OOM crash
>
> When we need to allocate a temporary blkcipher_walk_next and it
> fails, the code is supposed to take the slow path of processing
> the data block by block.  However, due to an unrelated change
> we instead end up dereferencing the NULL pointer.
>
> This patch fixes it by moving the unrelated bsize setting out
> of the way so that we enter the slow path as inteded.
>
inteNded ^^^

> Fixes: 7607bd8ff03b ("[CRYPTO] blkcipher: Added blkcipher_walk_virt_block")
> Cc: stable@vger.kernel.org
> Reported-by: xiakaixu <xiakaixu@huawei.com>
> Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>

This fixes the issue for me

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I will follow up with fixes for the ARM and arm64 CTR code shortly.

Thanks,
Ard.

> diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
> index 3699995..a832426 100644
> --- a/crypto/blkcipher.c
> +++ b/crypto/blkcipher.c
> @@ -233,6 +233,8 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
>                 return blkcipher_walk_done(desc, walk, -EINVAL);
>         }
>
> +       bsize = min(walk->walk_blocksize, n);
> +
>         walk->flags &= ~(BLKCIPHER_WALK_SLOW | BLKCIPHER_WALK_COPY |
>                          BLKCIPHER_WALK_DIFF);
>         if (!scatterwalk_aligned(&walk->in, walk->alignmask) ||
> @@ -245,7 +247,6 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
>                 }
>         }
>
> -       bsize = min(walk->walk_blocksize, n);
>         n = scatterwalk_clamp(&walk->in, n);
>         n = scatterwalk_clamp(&walk->out, n);
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
