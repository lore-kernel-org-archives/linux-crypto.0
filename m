From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto test build failure
Date: Fri, 15 Feb 2008 19:19:58 +0800
Message-ID: <20080215111958.GA13284@gondor.apana.org.au>
References: <20080209195232.GC11728@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33342 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762071AbYBOLUF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Feb 2008 06:20:05 -0500
Content-Disposition: inline
In-Reply-To: <20080209195232.GC11728@slug>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 09, 2008 at 08:52:32PM +0100, Frederik Deweerdt wrote:
> Hello Herbert,
> 
> Building latest git fails with the following error:
> 	ERROR: "crypto_alloc_ablkcipher" [crypto/tcrypt.ko] undefined!
> This appears to happen because CONFIG_CRYPTO_TEST is set while
> CONFIG_CRYPTO_BLKCIPHER is not.
> The following patch fixes the problem for me.

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
