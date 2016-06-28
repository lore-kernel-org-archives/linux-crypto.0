From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: tcrypt: Fix linkage error on ARM on division
 of s64
Date: Tue, 28 Jun 2016 16:41:38 +0800
Message-ID: <20160628084138.GD15985@gondor.apana.org.au>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57811 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbcF1Ilm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 04:41:42 -0400
Content-Disposition: inline
In-Reply-To: <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 28, 2016 at 09:23:07AM +0200, Krzysztof Kozlowski wrote:
> gcc 4.7.3 for ARM on Ubuntu couldn't link tcrypt module because of
> division of s64:
> 	ERROR: "__aeabi_ldivmod" [crypto/tcrypt.ko] undefined!
> 
> Fixes: 087bcd225c56 ("crypto: tcrypt - Add speed tests for SHA multibuffer algorithms")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

I'd prefer to be consistent here and just use unsigned long like
every other speed test in tcrypt.  This code has some serious
issues, such as not waiting for completion in case of an error.

Let me try to fix them up.

Thanks!

---8<---
Subject: crypto: tcrypt - Use unsigned long for mb ahash cycle counter

For the timescales we are working against there is no need to
go beyond unsigned long.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2f84583..1537a1c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -415,7 +415,7 @@ char result[8][64];
 struct ahash_request *req[8];
 struct tcrypt_result tresult[8];
 char *xbuf[8][XBUFSIZE];
-cycles_t start[8], end[8], mid;
+unsigned long start[8], end[8], mid;
 
 static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 					struct hash_speed *speed)
@@ -424,6 +424,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 	void *hash_buff;
 	int ret = -ENOMEM;
 	struct crypto_ahash *tfm;
+	unsigned long cycles;
 
 	tfm = crypto_alloc_ahash(algo, 0, 0);
 	if (IS_ERR(tfm)) {
@@ -498,10 +499,9 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 			end[k] = get_cycles();
 		}
 
-		printk("\nBlock: %lld cycles (%lld cycles/byte), %d bytes\n",
-			(s64) (end[7]-start[0])/1,
-			(s64) (end[7]-start[0])/(8*speed[i].blen),
-			8*speed[i].blen);
+		cycles = end[7] - start[0];
+		printk("\nBlock: %6lu cycles (%4lu cycles/byte)\n",
+		       cycles, cycles / (8 * speed[i].blen));
 	}
 	ret = 0;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
