From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND PATCH] crypto: Add zstd support
Date: Sat, 31 Mar 2018 01:14:59 +0800
Message-ID: <20180330171459.GB27856@gondor.apana.org.au>
References: <20180321224929.3076350-1-terrelln@fb.com>
 <20180322043230.GD3181@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180322043230.GD3181@jagdpanzerIV>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 22, 2018 at 01:32:30PM +0900, Sergey Senozhatsky wrote:
> On (03/21/18 15:49), Nick Terrell wrote:
> > depends on CONFIG_CRYPTO_ZSTD, which isn't defined until this patch is in
> 
> Yikes! How come I missed that... :)
> 
> > [0] lkml.kernel.org/r/9c9416b2dff19f05fb4c35879aaa83d11ff72c92.1521626182.git.geliangtang@gmail.com
> 
> Signed-off-by: Nick Terrell <terrelln@fb.com> ?

Please resend with sign-off.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
