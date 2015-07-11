From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305
 ciphers
Date: Sat, 11 Jul 2015 10:15:52 +0200
Message-ID: <1436602552.2882.16.camel@martin>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
	 <20150707221301.GB7655@gondor.apana.org.au>
	 <1436387783.2879.11.camel@martin>
	 <20150708204127.GA27011@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:55583 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbbGKIPz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Jul 2015 04:15:55 -0400
In-Reply-To: <20150708204127.GA27011@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> If you're going to use sec you need to use at least 10 in order
> for it to be meaningful as shorter values often result in bogus
> numbers.

Ok, I'll use sec=10 in v2. There is no fundamental difference compared
to sec=1 (except for very short blocks):

testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 9498006 operations in 10 seconds (151968096 bytes)
test 1 (288 bit key, 64 byte blocks): 9423516 operations in 10 seconds (603105024 bytes)
test 2 (288 bit key, 256 byte blocks): 7597253 operations in 10 seconds (1944896768 bytes)
test 3 (288 bit key, 512 byte blocks): 6979753 operations in 10 seconds (3573633536 bytes)
test 4 (288 bit key, 1024 byte blocks): 5629328 operations in 10 seconds (5764431872 bytes)
test 5 (288 bit key, 2048 byte blocks): 4071284 operations in 10 seconds (8337989632 bytes)
test 6 (288 bit key, 4096 byte blocks): 2627325 operations in 10 seconds (10761523200 bytes)
test 7 (288 bit key, 8192 byte blocks): 1492531 operations in 10 seconds (12226813952 bytes)

testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 896305 operations in 1 seconds (14340880 bytes)
test 1 (288 bit key, 64 byte blocks): 929638 operations in 1 seconds (59496832 bytes)
test 2 (288 bit key, 256 byte blocks): 750673 operations in 1 seconds (192172288 bytes)
test 3 (288 bit key, 512 byte blocks): 687636 operations in 1 seconds (352069632 bytes)
test 4 (288 bit key, 1024 byte blocks): 555209 operations in 1 seconds (568534016 bytes)
test 5 (288 bit key, 2048 byte blocks): 402049 operations in 1 seconds (823396352 bytes)
test 6 (288 bit key, 4096 byte blocks): 259861 operations in 1 seconds (1064390656 bytes)
test 7 (288 bit key, 8192 byte blocks): 147283 operations in 1 seconds (1206542336 bytes)

> What sort of variance do you see with cycles?

Here a very fast and a very slow run (these are extremes, though):

testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 1 operation in 3765 cycles (16 bytes)
test 1 (288 bit key, 64 byte blocks): 1 operation in 3823 cycles (64 bytes)
test 2 (288 bit key, 256 byte blocks): 1 operation in 4728 cycles (256 bytes)
test 3 (288 bit key, 512 byte blocks): 1 operation in 5135 cycles (512 bytes)
test 4 (288 bit key, 1024 byte blocks): 1 operation in 7026 cycles (1024 bytes)
test 5 (288 bit key, 2048 byte blocks): 1 operation in 8804 cycles (2048 bytes)
test 6 (288 bit key, 4096 byte blocks): 1 operation in 14674 cycles (4096 bytes)
test 7 (288 bit key, 8192 byte blocks): 1 operation in 24616 cycles (8192 bytes)

testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 1 operation in 15031 cycles (16 bytes)
test 1 (288 bit key, 64 byte blocks): 1 operation in 15670 cycles (64 bytes)
test 2 (288 bit key, 256 byte blocks): 1 operation in 13034 cycles (256 bytes)
test 3 (288 bit key, 512 byte blocks): 1 operation in 14045 cycles (512 bytes)
test 4 (288 bit key, 1024 byte blocks): 1 operation in 20944 cycles (1024 bytes)
test 5 (288 bit key, 2048 byte blocks): 1 operation in 26445 cycles (2048 bytes)
test 6 (288 bit key, 4096 byte blocks): 1 operation in 31912 cycles (4096 bytes)
test 7 (288 bit key, 8192 byte blocks): 1 operation in 61366 cycles (8192 bytes)

> Do you get the same variance for other algorithms, e.g., cbc/aes?

Yes, another extreme:

testing speed of cbc(aes) (cbc(aes-aesni)) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 593 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 1589 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 5311 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 20666 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 161483 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 593 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 1659 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 5609 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 21568 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 172484 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 612 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 1687 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 5836 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 22400 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 177799 cycles (8192 bytes)

testing speed of cbc(aes) (cbc(aes-aesni)) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 1130 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 3002 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 10135 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 39911 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 308130 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 1151 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 3096 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 11486 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 42155 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 328148 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 1186 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 3260 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 11909 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 44794 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 325349 cycles (8192 bytes)

I see that with all algorithms, both kvm-virtualized and on bare metal.

Regards
Martin
