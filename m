From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Are there any drivers that use aead.ko
Date: Mon, 10 Nov 2008 14:57:31 +0800
Message-ID: <E1KzQiJ-0008ND-5M@gondolin.me.apana.org.au>
References: <200811071040.38853.djenkins@mvista.com>
Cc: linux-crypto@vger.kernel.org
To: djenkins@mvista.com (Dean Jenkins)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35132 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033AbYKJG5d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2008 01:57:33 -0500
In-Reply-To: <200811071040.38853.djenkins@mvista.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dean Jenkins <djenkins@mvista.com> wrote:
> 
> Are there any example drivers that make use of aead.ko ?

drivers/crypto/talitos

> Is it true that an AEAD driver can perform encryption and hashing in a single 
> call ?

Apparently yes according to Bilbo.

> I assume aead.ko is designed for hardware crypto drivers that can do both 
> encryption and hashing concurrently. Am I correct ?

That's one application.  Another reason is to support combined-
mode algorithms.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
