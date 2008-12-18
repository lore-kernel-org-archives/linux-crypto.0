From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH/RFC 1/8] crypto: testmgr - Correct comment about
	deflate parameters
Date: Thu, 18 Dec 2008 17:17:57 +1100
Message-ID: <20081218061757.GA27951@gondor.apana.org.au>
References: <20081217163634.998961917@vixen.sonytel.be> <20081217164036.475086811@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46799 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbYLRGSB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Dec 2008 01:18:01 -0500
Content-Disposition: inline
In-Reply-To: <20081217164036.475086811@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 17, 2008 at 05:36:36PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> The comment for the deflate test vectors says the winbits parameter is 11,
> while the deflate module actually uses -11 (a negative window bits parameter
> enables the raw deflate format instead of the zlib format).
> Correct this, to avoid confusion about the format used.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Patch applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
