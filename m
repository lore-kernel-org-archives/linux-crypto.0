From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/3] crypto: chacha20 - convert generic and x86
 versions to skcipher
Date: Wed, 28 Dec 2016 17:20:27 +0800
Message-ID: <20161228092027.GA12415@gondor.apana.org.au>
References: <1481294033-23508-1-git-send-email-ard.biesheuvel@linaro.org>
 <1481294033-23508-2-git-send-email-ard.biesheuvel@linaro.org>
 <20161227100452.GB10629@gondor.apana.org.au>
 <20161228091801.GA12318@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60927 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750758AbcL1JUd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 04:20:33 -0500
Content-Disposition: inline
In-Reply-To: <20161228091801.GA12318@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 28, 2016 at 05:18:01PM +0800, Herbert Xu wrote:
> On Tue, Dec 27, 2016 at 06:04:52PM +0800, Herbert Xu wrote:
> > On Fri, Dec 09, 2016 at 02:33:51PM +0000, Ard Biesheuvel wrote:
> > > This converts the ChaCha20 code from a blkcipher to a skcipher, which
> > > is now the preferred way to implement symmetric block and stream ciphers.
> > > 
> > > This ports the generic and x86 versions at the same time because the
> > > latter reuses routines of the former.
> > > 
> > > Note that the skcipher_walk() API guarantees that all presented blocks
> > > except the final one are a multiple of the chunk size, so we can simplify
> > > the encrypt() routine somewhat.
> > > 
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > Patch applied.  Thanks.
> 
> I'm reverting this patch because it breaks the build on ARM without
> the two subsequent patches.
> 
> When resubmitting please make sure that the kernel can build and
> work after each patch.  Otherwise git bisections will fail.

Sorry, it only broke the build because I applied your other two
patches first.

So I'll just revert all three and it should work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
