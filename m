From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305
 ciphers
Date: Wed, 08 Jul 2015 22:36:23 +0200
Message-ID: <1436387783.2879.11.camel@martin>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
	 <20150707221301.GB7655@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33473 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934094AbbGHUg0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 16:36:26 -0400
In-Reply-To: <20150707221301.GB7655@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

> Running the speed test with sec=1 makes no sense because it's
> too short.  Please use sec=0 and count cycles instead.

I get less constant numbers between different runs when using sec=0,
hence I've used sec=1. Below are the numbers of "average" runs for the
AEAD measuring cycles; I'll use cycles in the individual patch notes in
a v2.

Kind regards
Martin

--

generic:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-generic,poly1305-generic)) encryption
test 0 (288 bit key, 16 byte blocks): 1 operation in 9444 cycles (16 bytes)
test 1 (288 bit key, 64 byte blocks): 1 operation in 10692 cycles (64 bytes)
test 2 (288 bit key, 256 byte blocks): 1 operation in 18299 cycles (256 bytes)
test 3 (288 bit key, 512 byte blocks): 1 operation in 26952 cycles (512 bytes)
test 4 (288 bit key, 1024 byte blocks): 1 operation in 48493 cycles (1024 bytes)
test 5 (288 bit key, 2048 byte blocks): 1 operation in 83766 cycles (2048 bytes)
test 6 (288 bit key, 4096 byte blocks): 1 operation in 150899 cycles (4096 bytes)
test 7 (288 bit key, 8192 byte blocks): 1 operation in 296779 cycles (8192 bytes)

SSE2/SSSE3:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 1 operation in 9814 cycles (16 bytes)
test 1 (288 bit key, 64 byte blocks): 1 operation in 9998 cycles (64 bytes)
test 2 (288 bit key, 256 byte blocks): 1 operation in 12442 cycles (256 bytes)
test 3 (288 bit key, 512 byte blocks): 1 operation in 20321 cycles (512 bytes)
test 4 (288 bit key, 1024 byte blocks): 1 operation in 21098 cycles (1024 bytes)
test 5 (288 bit key, 2048 byte blocks): 1 operation in 33423 cycles (2048 bytes)
test 6 (288 bit key, 4096 byte blocks): 1 operation in 55183 cycles (4096 bytes)
test 7 (288 bit key, 8192 byte blocks): 1 operation in 102514 cycles (8192 bytes)

AVX2:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 1 operation in 9883 cycles (16 bytes)
test 1 (288 bit key, 64 byte blocks): 1 operation in 10891 cycles (64 bytes)
test 2 (288 bit key, 256 byte blocks): 1 operation in 12467 cycles (256 bytes)
test 3 (288 bit key, 512 byte blocks): 1 operation in 13538 cycles (512 bytes)
test 4 (288 bit key, 1024 byte blocks): 1 operation in 16783 cycles (1024 bytes)
test 5 (288 bit key, 2048 byte blocks): 1 operation in 23161 cycles (2048 bytes)
test 6 (288 bit key, 4096 byte blocks): 1 operation in 37359 cycles (4096 bytes)
test 7 (288 bit key, 8192 byte blocks): 1 operation in 64670 cycles (8192 bytes)
