From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH net-next v4 18/20] crypto: port ChaCha20 to Zinc
Date: Sun, 16 Sep 2018 21:51:53 +0200
Message-ID: <72e893e7efbef428d4fd23b7332d9e829acd5e7d.camel@strongswan.org>
References: <20180914162240.7925-1-Jason@zx2c4.com>
         <20180914162240.7925-19-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180914162240.7925-19-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

> Now that ChaCha20 is in Zinc, we can have the crypto API code simply
> call into it.

>  delete mode 100644 arch/x86/crypto/chacha20-avx2-x86_64.S
>  delete mode 100644 arch/x86/crypto/chacha20-ssse3-x86_64.S

I did some trivial benchmarking with tcrypt for the ChaCha20Poly1305
AEAD as used by IPsec. This is on a box with AVX2, which is probably
the configuration mostly used these days. With Zinc I get:

> testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-software,poly1305-software)) decryption
> test 0 (288 bit key, 16 byte blocks): 743510 operations in 1 seconds (11896160 bytes)
> test 1 (288 bit key, 64 byte blocks): 743190 operations in 1 seconds (47564160 bytes)
> test 2 (288 bit key, 256 byte blocks): 701461 operations in 1 seconds (179574016 bytes)
> test 3 (288 bit key, 512 byte blocks): 681567 operations in 1 seconds (348962304 bytes)
> test 4 (288 bit key, 1024 byte blocks): 572854 operations in 1 seconds (586602496 bytes)
> test 5 (288 bit key, 2048 byte blocks): 434477 operations in 1 seconds (889808896 bytes)
> test 6 (288 bit key, 4096 byte blocks): 293553 operations in 1 seconds (1202393088 bytes)
> test 7 (288 bit key, 8192 byte blocks): 173351 operations in 1 seconds (1420091392 bytes)

Using the existing implementation, this was:

> testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) decryption
> test 0 (288 bit key, 16 byte blocks): 1064524 operations in 1 seconds (17032384 bytes)
> test 1 (288 bit key, 64 byte blocks): 1016046 operations in 1 seconds (65026944 bytes)
> test 2 (288 bit key, 256 byte blocks): 829566 operations in 1 seconds (212368896 bytes)
> test 3 (288 bit key, 512 byte blocks): 778912 operations in 1 seconds (398802944 bytes)
> test 4 (288 bit key, 1024 byte blocks): 622331 operations in 1 seconds (637266944 bytes)
> test 5 (288 bit key, 2048 byte blocks): 441790 operations in 1 seconds (904785920 bytes)
> test 6 (288 bit key, 4096 byte blocks): 280616 operations in 1 seconds (1149403136 bytes)
> test 7 (288 bit key, 8192 byte blocks): 158800 operations in 1 seconds (1300889600 bytes)

I've also experimented with the SIMD context save/restore amortization
from patch one on the existing implementation:

> testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) decryption
> test 0 (288 bit key, 16 byte blocks): 1088215 operations in 1 seconds (17411440 bytes)
> test 1 (288 bit key, 64 byte blocks): 1001788 operations in 1 seconds (64114432 bytes)
> test 2 (288 bit key, 256 byte blocks): 870193 operations in 1 seconds (222769408 bytes)
> test 3 (288 bit key, 512 byte blocks): 822149 operations in 1 seconds (420940288 bytes)
> test 4 (288 bit key, 1024 byte blocks): 647447 operations in 1 seconds (662985728 bytes)
> test 5 (288 bit key, 2048 byte blocks): 454734 operations in 1 seconds (931295232 bytes)
> test 6 (288 bit key, 4096 byte blocks): 286995 operations in 1 seconds (1175531520 bytes)
> test 7 (288 bit key, 8192 byte blocks): 162028 operations in 1 seconds (1327333376 bytes)

For large blocks your implementation is faster; for typical IPsec MTUs
this degrades performance by ~10% and more.

Martin
