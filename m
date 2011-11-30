From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: serpent-sse2 - should select CRYPTO_CRYPTD
Date: Wed, 30 Nov 2011 16:18:28 +0800
Message-ID: <20111130081828.GB692@gondor.apana.org.au>
References: <4ECD527E.8000506@xenotime.net> <20111124063741.17986.23462.stgit@localhost6.localdomain6> <4ECE8E71.1080606@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4ECE8E71.1080606@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 24, 2011 at 10:35:29AM -0800, Randy Dunlap wrote:
> On 11/23/2011 10:37 PM, Jussi Kivilinna wrote:
> > Since serpent_sse2_glue.c uses cryptd, CRYPTO_SERPENT_SSE2_X86_64 and
> > CRYPTO_SERPENT_SSE2_586 should be selecting CRYPTO_CRYPTD.
> > 
> > Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Patch applied.  Thanks
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
