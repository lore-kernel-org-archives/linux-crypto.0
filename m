From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305
 ciphers
Date: Wed, 8 Jul 2015 06:13:02 +0800
Message-ID: <20150707221301.GB7655@gondor.apana.org.au>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45382 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbbGGWNF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 18:13:05 -0400
Content-Disposition: inline
In-Reply-To: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2015 at 09:36:46PM +0200, Martin Willi wrote:
>
> poly1305-generic:
> testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-generic,poly1305-generic)) encryption
> test 0 (288 bit key, 16 byte blocks): 902007 operations in 1 seconds (14432112 bytes)
> test 1 (288 bit key, 64 byte blocks): 945302 operations in 1 seconds (60499328 bytes)
> test 2 (288 bit key, 256 byte blocks): 559910 operations in 1 seconds (143336960 bytes)
> test 3 (288 bit key, 512 byte blocks): 365334 operations in 1 seconds (187051008 bytes)
> test 4 (288 bit key, 1024 byte blocks): 213663 operations in 1 seconds (218790912 bytes)
> test 5 (288 bit key, 2048 byte blocks): 117263 operations in 1 seconds (240154624 bytes)
> test 6 (288 bit key, 4096 byte blocks): 61915 operations in 1 seconds (253603840 bytes)
> test 7 (288 bit key, 8192 byte blocks): 31662 operations in 1 seconds (259375104 bytes)

Running the speed test with sec=1 makes no sense because it's
too short.  Please use sec=0 and count cycles instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
