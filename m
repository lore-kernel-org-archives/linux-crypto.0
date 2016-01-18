From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: ixp4xx: avoid uninitialized variable use
Date: Mon, 18 Jan 2016 16:40:15 +0100
Message-ID: <4569235.PkyVAB6DSj@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	Krzysztof =?utf-8?B?SGHFgmFzYQ==?= <khalasa@piap.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The move to the new AEAD interface introduced a path through the
aead_perform() function in the ixp4xx_crypto driver that leaves
lastlen uninitialized, as gcc warns:

crypto/ixp4xx_crypto.c:1072:5: error: 'lastlen' may be used uninitialized in this function [-Werror=maybe-uninitialized]
crypto/ixp4xx_crypto.c: In function 'aead_perform':
  if (unlikely(lastlen < authsize)) {

I don't really understand what the code does, but the warning
appears to be correct, and this is my best guess at how it
should behave instead: I'm introducing a temporary variable
that indicates whether we need to allocate an extra buffer
or not, and defaults that variable to 'false', so we only
allocate the buffer if one of the cases happen where we know
that "lastlen < authsize".

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: d7295a8dc965 ("crypto: ixp4xx - Convert to new AEAD interface")
---

Hi Herbert,

It was one of your patches that introduced the warning, so you may
be able to come up with a better fix than I did. Please see this as
a bug report. I have applied it in my ARM randconfig test tree to shut
up the warning for now.

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index e52496a172d0..00c39a5aa4c7 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -999,6 +999,7 @@ static int aead_perform(struct aead_request *req, int encrypt,
 				GFP_KERNEL : GFP_ATOMIC;
 	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
 	unsigned int lastlen;
+	bool shortbuf = false;
 
 	if (qmgr_stat_full(SEND_QID))
 		return -EAGAIN;
@@ -1052,6 +1053,8 @@ static int aead_perform(struct aead_request *req, int encrypt,
 			if (lastlen >= authsize)
 				crypt->icv_rev_aes = buf->phys_addr +
 						     buf->buf_len - authsize;
+			else
+				shortbuf = true;
 		}
 	}
 
@@ -1067,9 +1070,11 @@ static int aead_perform(struct aead_request *req, int encrypt,
 		if (lastlen >= authsize)
 			crypt->icv_rev_aes = buf->phys_addr +
 					     buf->buf_len - authsize;
+		else
+			shortbuf = true;
 	}
 
-	if (unlikely(lastlen < authsize)) {
+	if (unlikely(shortbuf)) {
 		/* The 12 hmac bytes are scattered,
 		 * we need to copy them into a safe buffer */
 		req_ctx->hmac_virt = dma_pool_alloc(buffer_pool, flags,
