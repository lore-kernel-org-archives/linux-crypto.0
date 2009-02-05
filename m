From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: zeroing tfms in crypto_free_tfm()
Date: Thu, 5 Feb 2009 23:13:50 +1100
Message-ID: <20090205121350.GA26477@gondor.apana.org.au>
References: <alpine.LRH.2.00.0902041606460.29216@vixen.sonytel.be> <20090205055437.GF22749@gondor.apana.org.au> <alpine.LRH.2.00.0902051159530.4290@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41639 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753432AbZBEMOA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 07:14:00 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902051159530.4290@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 05, 2009 at 12:03:20PM +0100, Geert Uytterhoeven wrote:
> 
> It doesn't crash because crypto_shash_type.tfmsize =
> offsetof(struct crypto_shash, base) = zero.

Ah yes, I took out all the members from crypto_shash so it was
harmless :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
