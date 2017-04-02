From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH v5 3/4] crypto: glue_helper - remove the le128_gf128mul_x_ble function
Date: Sun,  2 Apr 2017 21:19:15 +0200
Message-ID: <20170402191916.9309-4-omosnacek@gmail.com>
References: <20170402191916.9309-1-omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Milan Broz <gmazyland@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35826 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751588AbdDBTUf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2017 15:20:35 -0400
Received: by mail-wr0-f196.google.com with SMTP id p52so28280990wrc.2
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2017 12:20:34 -0700 (PDT)
In-Reply-To: <20170402191916.9309-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The le128_gf128mul_x_ble function in glue_helper.h is now obsolete and
can be replaced with the gf128mul_x_ble function from gf128mul.h.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 arch/x86/crypto/glue_helper.c             |  3 ++-
 arch/x86/include/asm/crypto/glue_helper.h | 10 ----------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 260a060..24ac9fa 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -27,6 +27,7 @@
 
 #include <linux/module.h>
 #include <crypto/b128ops.h>
+#include <crypto/gf128mul.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
@@ -457,7 +458,7 @@ void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, le128 *iv,
 	le128 ivblk = *iv;
 
 	/* generate next IV */
-	le128_gf128mul_x_ble(iv, &ivblk);
+	gf128mul_x_ble(iv, &ivblk);
 
 	/* CC <- T xor C */
 	u128_xor(dst, src, (u128 *)&ivblk);
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 29e53ea..ed8b66d 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -125,16 +125,6 @@ static inline void le128_inc(le128 *i)
 	i->b = cpu_to_le64(b);
 }
 
-static inline void le128_gf128mul_x_ble(le128 *dst, const le128 *src)
-{
-	u64 a = le64_to_cpu(src->a);
-	u64 b = le64_to_cpu(src->b);
-	u64 _tt = ((s64)a >> 63) & 0x87;
-
-	dst->a = cpu_to_le64((a << 1) ^ (b >> 63));
-	dst->b = cpu_to_le64((b << 1) ^ _tt);
-}
-
 extern int glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
 				 struct blkcipher_desc *desc,
 				 struct scatterlist *dst,
-- 
2.9.3
