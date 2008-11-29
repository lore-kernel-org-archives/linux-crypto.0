From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ESP output when using NULL encryption and NON authentication
Date: Sat, 29 Nov 2008 12:33:39 +0800
Message-ID: <E1L6HWV-0000zI-B5@gondolin.me.apana.org.au>
References: <200811271813.18727.djenkins@mvista.com>
Cc: linux-crypto@vger.kernel.org
To: djenkins@mvista.com (Dean Jenkins)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48304 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbYK2Edp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Nov 2008 23:33:45 -0500
In-Reply-To: <200811271813.18727.djenkins@mvista.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dean Jenkins <djenkins@mvista.com> wrote:
>
> However, ESP's call to crypto_aead_decrypt() puts the start of the 
> encapsulated packet (first 16 bytes) into the IV field of the AEAD request 
> instead of wholly in the src scatterlist. The dst scatterlist is in fact the 
> same src scatterlist.

Well if you're using NULL encryption then the IV size will be zero.
So even though the IV field has the pointer to the start of the
payload so does the src scatterlist.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
