From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 3/7] crypto: octeon - add instruction definitions for SHA1/256/512
Date: Sun,  8 Mar 2015 22:07:43 +0200
Message-ID: <1425845267-14413-4-git-send-email-aaro.koskinen@iki.fi>
References: <1425845267-14413-1-git-send-email-aaro.koskinen@iki.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
	Aaro Koskinen <aaro.koskinen@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425845267-14413-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add instruction definitions for SHA1/256/512.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/cavium-octeon/crypto/octeon-crypto.h | 83 ++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 4 deletions(-)

diff --git a/arch/mips/cavium-octeon/crypto/octeon-crypto.h b/arch/mips/cavium-octeon/crypto/octeon-crypto.h
index e2a4aec..3550725 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-crypto.h
+++ b/arch/mips/cavium-octeon/crypto/octeon-crypto.h
@@ -5,7 +5,8 @@
  *
  * Copyright (C) 2012-2013 Cavium Inc., All Rights Reserved.
  *
- * MD5 instruction definitions added by Aaro Koskinen <aaro.koskinen@iki.fi>.
+ * MD5/SHA1/SHA256/SHA512 instruction definitions added by
+ * Aaro Koskinen <aaro.koskinen@iki.fi>.
  *
  */
 #ifndef __LINUX_OCTEON_CRYPTO_H
@@ -21,11 +22,11 @@ extern void octeon_crypto_disable(struct octeon_cop2_state *state,
 				  unsigned long flags);
 
 /*
- * Macros needed to implement MD5:
+ * Macros needed to implement MD5/SHA1/SHA256:
  */
 
 /*
- * The index can be 0-1.
+ * The index can be 0-1 (MD5) or 0-2 (SHA1), 0-3 (SHA256).
  */
 #define write_octeon_64bit_hash_dword(value, index)	\
 do {							\
@@ -36,7 +37,7 @@ do {							\
 } while (0)
 
 /*
- * The index can be 0-1.
+ * The index can be 0-1 (MD5) or 0-2 (SHA1), 0-3 (SHA256).
  */
 #define read_octeon_64bit_hash_dword(index)		\
 ({							\
@@ -72,4 +73,78 @@ do {							\
 	: [rt] "d" (value));				\
 } while (0)
 
+/*
+ * The value is the final block dword (64-bit).
+ */
+#define octeon_sha1_start(value)			\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x4057"				\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
+/*
+ * The value is the final block dword (64-bit).
+ */
+#define octeon_sha256_start(value)			\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x404f"				\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
+/*
+ * Macros needed to implement SHA512:
+ */
+
+/*
+ * The index can be 0-7.
+ */
+#define write_octeon_64bit_hash_sha512(value, index)	\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x0250+" STR(index)		\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
+/*
+ * The index can be 0-7.
+ */
+#define read_octeon_64bit_hash_sha512(index)		\
+({							\
+	u64 __value;					\
+							\
+	__asm__ __volatile__ (				\
+	"dmfc2 %[rt],0x0250+" STR(index)		\
+	: [rt] "=d" (__value)				\
+	: );						\
+							\
+	__value;					\
+})
+
+/*
+ * The index can be 0-14.
+ */
+#define write_octeon_64bit_block_sha512(value, index)	\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x0240+" STR(index)		\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
+/*
+ * The value is the final block word (64-bit).
+ */
+#define octeon_sha512_start(value)			\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x424f"				\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
 #endif /* __LINUX_OCTEON_CRYPTO_H */
-- 
2.2.0
