From: Myungho Jung <mhjungk@gmail.com>
Subject: [PATCH] crypto: lz4: fixed decompress function to return error code
Date: Sun,  9 Apr 2017 17:34:22 -0700
Message-ID: <1491784462-31424-1-git-send-email-mhjungk@gmail.com>
Cc: linux-crypto@vger.kernel.org, Myungho Jung <mhjungk@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35407 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752696AbdDJAf0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Apr 2017 20:35:26 -0400
Received: by mail-pg0-f67.google.com with SMTP id g2so23567482pge.2
        for <linux-crypto@vger.kernel.org>; Sun, 09 Apr 2017 17:35:26 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Decompress function in LZ4 library is supposed to return an error code or
negative result. But, it returns -1 when any error is detected. Return
error code when the library returns negative value.

Signed-off-by: Myungho Jung <mhjungk@gmail.com>
---
 crypto/lz4.c   | 2 +-
 crypto/lz4hc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 71eff9b..2ce2660 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -97,7 +97,7 @@ static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 	int out_len = LZ4_decompress_safe(src, dst, slen, *dlen);
 
 	if (out_len < 0)
-		return out_len;
+		return -EINVAL;
 
 	*dlen = out_len;
 	return 0;
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 03a34a8..2be14f0 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -98,7 +98,7 @@ static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
 	int out_len = LZ4_decompress_safe(src, dst, slen, *dlen);
 
 	if (out_len < 0)
-		return out_len;
+		return -EINVAL;
 
 	*dlen = out_len;
 	return 0;
-- 
2.7.4
