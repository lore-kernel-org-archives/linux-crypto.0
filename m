From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drop unnecessary return statements
Date: Fri, 22 Sep 2017 18:15:49 +0800
Message-ID: <20170922101549.GP16270@gondor.apana.org.au>
References: <b17223142fc680eb5cca9964ba9451f59cc16076.1502447442.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b17223142fc680eb5cca9964ba9451f59cc16076.1502447442.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 28, 2017 at 10:00:07PM +0800, Geliang Tang wrote:
> Fix checkpatch.pl warnings:
> 
> WARNING: void function return statements are not generally useful
> FILE: crypto/rmd128.c:218:
> FILE: crypto/rmd160.c:261:
> FILE: crypto/rmd256.c:233:
> FILE: crypto/rmd320.c:280:
> FILE: crypto/tcrypt.c:385:
> FILE: drivers/crypto/ixp4xx_crypto.c:538:
> FILE: drivers/crypto/marvell/cesa.c:81:
> FILE: drivers/crypto/ux500/cryp/cryp_core.c:1755:
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
