From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 1/2] crypto: lz4,lz4hc - fix decompression
Date: Fri, 22 Aug 2014 10:44:35 +0200
Message-ID: <1408697076-20272-1-git-send-email-hidden@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from max.sch.bme.hu ([152.66.208.194]:27273 "EHLO max.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaHVIu1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Aug 2014 04:50:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The lz4 library has two functions for decompression, with slightly
different signatures and behaviour. The lz4_decompress_crypto() function
seemed to be using the one that assumes that the decompressed length is
known in advance.

This patch switches to the other decompression function and makes sure
that the length of the decompressed output is properly returned to the
caller.

The same issue was present in the lz4hc algorithm.

Coincidentally, this change also makes very basic lz4 and lz4hc
compression tests in testmgr pass.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---
 crypto/lz4.c   | 2 +-
 crypto/lz4hc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 4586dd1..34d072b 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -68,7 +68,7 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	size_t tmp_len = *dlen;
 	size_t __slen = slen;
 
-	err = lz4_decompress(src, &__slen, dst, tmp_len);
+	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
 	if (err < 0)
 		return -EINVAL;
 
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 151ba31..9218b3f 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -68,7 +68,7 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	size_t tmp_len = *dlen;
 	size_t __slen = slen;
 
-	err = lz4_decompress(src, &__slen, dst, tmp_len);
+	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
 	if (err < 0)
 		return -EINVAL;
 
-- 
2.1.0
