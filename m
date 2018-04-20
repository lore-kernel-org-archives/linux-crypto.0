From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND PATCH] crypto: Add zstd support
Date: Sat, 21 Apr 2018 00:50:33 +0800
Message-ID: <20180420165032.ufqzoefyvnym75s3@gondor.apana.org.au>
References: <20180330191453.3535287-1-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        kernel-team@fb.com, Chris Mason <clm@fb.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Geliang Tang <geliangtang@gmail.com>
To: Nick Terrell <terrelln@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180330191453.3535287-1-terrelln@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 30, 2018 at 12:14:53PM -0700, Nick Terrell wrote:
> Adds zstd support to crypto and scompress. Only supports the default
> level.
> 
> Previously we held off on this patch, since there weren't any users.
> Now zram is ready for zstd support, but depends on CONFIG_CRYPTO_ZSTD,
> which isn't defined until this patch is in. I also see a patch adding
> zstd to pstore [0], which depends on crypto zstd.
> 
> [0] lkml.kernel.org/r/9c9416b2dff19f05fb4c35879aaa83d11ff72c92.1521626182.git.geliangtang@gmail.com
> 
> Signed-off-by: Nick Terrell <terrelln@fb.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
