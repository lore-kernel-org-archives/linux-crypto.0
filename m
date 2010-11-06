From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH 4/4] crypto: algif_skcipher - User-space interface for
 skcipher operations
Date: Sat, 06 Nov 2010 13:23:34 +0100
Message-ID: <1289046214.24626.63.camel@martin>
References: <20101104173456.GA1321@gondor.apana.org.au>
	 <E1PE3jY-0000Ml-7B@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80024.hsr.ch ([152.96.80.24]:40492 "EHLO strongswan.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0KFNVs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Nov 2010 09:21:48 -0400
In-Reply-To: <E1PE3jY-0000Ml-7B@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I did a proof-of-concept implementation for our crypto library, the
interface looks good so far. All our hash, hmac, xcbc and cipher test
vectors matched.

> +			sg_assign_page(sg + i, alloc_page(GFP_KERNEL));

Every skcipher operation leaks memory on my box (this page?). Should be
reproducible by doing encryption with any cipher.

Regards
Martin
