From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 10/11] crypto: move arch/x86/include/asm/serpent-{sse2|avx}.h
 to arch/x86/include/asm/crypto/
Date: Mon, 18 Jun 2012 14:07:45 +0300
Message-ID: <20120618110744.28985.57889.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50876 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2FRLHr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:47 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move serpent crypto headers to the new asm/crypto/ directory.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_avx_glue.c         |    2 -
 arch/x86/crypto/serpent_sse2_glue.c        |    2 -
 arch/x86/include/asm/crypto/serpent-avx.h  |   32 ++++++++++++++
 arch/x86/include/asm/crypto/serpent-sse2.h |   63 ++++++++++++++++++++++++++++
 arch/x86/include/asm/serpent-avx.h         |   32 --------------
 arch/x86/include/asm/serpent-sse2.h        |   63 ----------------------------
 6 files changed, 97 insertions(+), 97 deletions(-)
 create mode 100644 arch/x86/include/asm/crypto/serpent-avx.h
 create mode 100644 arch/x86/include/asm/crypto/serpent-sse2.h
 delete mode 100644 arch/x86/include/asm/serpent-avx.h
 delete mode 100644 arch/x86/include/asm/serpent-sse2.h

diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index c61b91a..b36bdac 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -38,7 +38,7 @@
 #include <crypto/xts.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
-#include <asm/serpent-avx.h>
+#include <asm/crypto/serpent-avx.h>
 #include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 49a32ee..d679c86 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -41,7 +41,7 @@
 #include <crypto/ctr.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
-#include <asm/serpent-sse2.h>
+#include <asm/crypto/serpent-sse2.h>
 #include <asm/crypto/ablk_helper.h>
 #include <asm/crypto/glue_helper.h>
 
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
new file mode 100644
index 0000000..432deed
--- /dev/null
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -0,0 +1,32 @@
+#ifndef ASM_X86_SERPENT_AVX_H
+#define ASM_X86_SERPENT_AVX_H
+
+#include <linux/crypto.h>
+#include <crypto/serpent.h>
+
+#define SERPENT_PARALLEL_BLOCKS 8
+
+asmlinkage void __serpent_enc_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					   const u8 *src, bool xor);
+asmlinkage void serpent_dec_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src);
+
+static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	__serpent_enc_blk_8way_avx(ctx, dst, src, false);
+}
+
+static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src)
+{
+	__serpent_enc_blk_8way_avx(ctx, dst, src, true);
+}
+
+static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	serpent_dec_blk_8way_avx(ctx, dst, src);
+}
+
+#endif
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
new file mode 100644
index 0000000..e6e77df
--- /dev/null
+++ b/arch/x86/include/asm/crypto/serpent-sse2.h
@@ -0,0 +1,63 @@
+#ifndef ASM_X86_SERPENT_SSE2_H
+#define ASM_X86_SERPENT_SSE2_H
+
+#include <linux/crypto.h>
+#include <crypto/serpent.h>
+
+#ifdef CONFIG_X86_32
+
+#define SERPENT_PARALLEL_BLOCKS 4
+
+asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__serpent_enc_blk_4way(ctx, dst, src, false);
+}
+
+static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
+					    const u8 *src)
+{
+	__serpent_enc_blk_4way(ctx, dst, src, true);
+}
+
+static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	serpent_dec_blk_4way(ctx, dst, src);
+}
+
+#else
+
+#define SERPENT_PARALLEL_BLOCKS 8
+
+asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	__serpent_enc_blk_8way(ctx, dst, src, false);
+}
+
+static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src)
+{
+	__serpent_enc_blk_8way(ctx, dst, src, true);
+}
+
+static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	serpent_dec_blk_8way(ctx, dst, src);
+}
+
+#endif
+
+#endif
diff --git a/arch/x86/include/asm/serpent-avx.h b/arch/x86/include/asm/serpent-avx.h
deleted file mode 100644
index 432deed..0000000
--- a/arch/x86/include/asm/serpent-avx.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef ASM_X86_SERPENT_AVX_H
-#define ASM_X86_SERPENT_AVX_H
-
-#include <linux/crypto.h>
-#include <crypto/serpent.h>
-
-#define SERPENT_PARALLEL_BLOCKS 8
-
-asmlinkage void __serpent_enc_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					   const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-					 const u8 *src);
-
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	__serpent_enc_blk_8way_avx(ctx, dst, src, false);
-}
-
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src)
-{
-	__serpent_enc_blk_8way_avx(ctx, dst, src, true);
-}
-
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	serpent_dec_blk_8way_avx(ctx, dst, src);
-}
-
-#endif
diff --git a/arch/x86/include/asm/serpent-sse2.h b/arch/x86/include/asm/serpent-sse2.h
deleted file mode 100644
index e6e77df..0000000
--- a/arch/x86/include/asm/serpent-sse2.h
+++ /dev/null
@@ -1,63 +0,0 @@
-#ifndef ASM_X86_SERPENT_SSE2_H
-#define ASM_X86_SERPENT_SSE2_H
-
-#include <linux/crypto.h>
-#include <crypto/serpent.h>
-
-#ifdef CONFIG_X86_32
-
-#define SERPENT_PARALLEL_BLOCKS 4
-
-asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src);
-
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__serpent_enc_blk_4way(ctx, dst, src, false);
-}
-
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-					    const u8 *src)
-{
-	__serpent_enc_blk_4way(ctx, dst, src, true);
-}
-
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	serpent_dec_blk_4way(ctx, dst, src);
-}
-
-#else
-
-#define SERPENT_PARALLEL_BLOCKS 8
-
-asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src);
-
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	__serpent_enc_blk_8way(ctx, dst, src, false);
-}
-
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src)
-{
-	__serpent_enc_blk_8way(ctx, dst, src, true);
-}
-
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	serpent_dec_blk_8way(ctx, dst, src);
-}
-
-#endif
-
-#endif
