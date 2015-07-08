From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305
 ciphers
Date: Thu, 9 Jul 2015 04:41:27 +0800
Message-ID: <20150708204127.GA27011@gondor.apana.org.au>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
 <20150707221301.GB7655@gondor.apana.org.au>
 <1436387783.2879.11.camel@martin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55601 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637AbbGHUlv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 16:41:51 -0400
Content-Disposition: inline
In-Reply-To: <1436387783.2879.11.camel@martin>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 08, 2015 at 10:36:23PM +0200, Martin Willi wrote:
> 
> I get less constant numbers between different runs when using sec=0,
> hence I've used sec=1. Below are the numbers of "average" runs for the
> AEAD measuring cycles; I'll use cycles in the individual patch notes in
> a v2.

If you're going to use sec you need to use at least 10 in order
for it to be meaningful as shorter values often result in bogus
numbers.  Of course sec=10 takes a long time which is why cycles
is the preferred method.

What sort of variance do you see with cycles? Do you get the
same variance for other algorithms, e.g., cbc/aes?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
