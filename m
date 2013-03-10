From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix typo "CRYPTO_AHASH"
Date: Sun, 10 Mar 2013 18:17:43 +0800
Message-ID: <20130310101743.GG10910@gondor.apana.org.au>
References: <1362490396.16460.87.camel@x61.thuisdomein>
 <20130307185127.a525f832276be2b30153aedf@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paul Bolle <pebolle@tiscali.nl>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:51237 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964Ab3CJKRx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Mar 2013 06:17:53 -0400
Content-Disposition: inline
In-Reply-To: <20130307185127.a525f832276be2b30153aedf@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 07, 2013 at 06:51:27PM -0600, Kim Phillips wrote:
> On Tue, 5 Mar 2013 14:33:16 +0100
> Paul Bolle <pebolle@tiscali.nl> wrote:
> 
> > The Kconfig entry for CAAM's hash algorithm implementations has always
> > selected CRYPTO_AHASH. But there's no corresponding Kconfig symbol.
> > 
> > It seems it was intended to select CRYPTO_HASH, like other crypto
> > drivers do. That would apparently (indirectly) select CRYPTO_HASH2,
> > which would enable the ahash functionality this driver uses.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> 
> Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
