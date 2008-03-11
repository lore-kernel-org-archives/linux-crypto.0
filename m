From: "Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH -mm crypto] AES: remove crypto_fl_tab and replace
	crypto_il_tab with isb_tab
Date: Tue, 11 Mar 2008 12:42:56 +0800
Message-ID: <1205210576.3676.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>,
	Alexander Kjeldaas <astor@fast.no>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4100 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYCKEm0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2008 00:42:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove crypto_fl_tab from aes implementation. Because mix_col(1,n) = n,
all information in cryto_fl_tab is in crypto_ft_tab too.
crypto_il_tab is replaced by isb_tab, the byte shift is done
during decryption.

These changes reduce the encryption cache footprint to 50% and
decryption cache footprint to 53.1%. The code size is increased
slightly. On my Intel CORE micro-architecture CPU, there is almost no
performance penalty.

This patch has been built and tested against 2.6.25-rc3-mm1.

This patch is only for generic C implementation. If this kind of idea
is desired, I will implement the ASM version for x86.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/aes_generic.c |   47 ++++++++++++++++-------------------------------
 include/crypto/aes.h |    2 --
 2 files changed, 16 insertions(+), 33 deletions(-)

--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -63,18 +63,14 @@ static inline u8 byte(const u32 x, const
 static u8 pow_tab[256] __initdata;
 static u8 log_tab[256] __initdata;
 static u8 sbx_tab[256] __initdata;
-static u8 isb_tab[256] __initdata;
+static u8 isb_tab[256];
 static u32 rco_tab[10];
 
 u32 crypto_ft_tab[4][256];
-u32 crypto_fl_tab[4][256];
 u32 crypto_it_tab[4][256];
-u32 crypto_il_tab[4][256];
 
 EXPORT_SYMBOL_GPL(crypto_ft_tab);
-EXPORT_SYMBOL_GPL(crypto_fl_tab);
 EXPORT_SYMBOL_GPL(crypto_it_tab);
-EXPORT_SYMBOL_GPL(crypto_il_tab);
 
 static inline u8 __init f_mult(u8 a, u8 b)
 {
@@ -122,12 +118,6 @@ static void __init gen_tabs(void)
 	for (i = 0; i < 256; ++i) {
 		p = sbx_tab[i];
 
-		t = p;
-		crypto_fl_tab[0][i] = t;
-		crypto_fl_tab[1][i] = rol32(t, 8);
-		crypto_fl_tab[2][i] = rol32(t, 16);
-		crypto_fl_tab[3][i] = rol32(t, 24);
-
 		t = ((u32) ff_mult(2, p)) |
 		    ((u32) p << 8) |
 		    ((u32) p << 16) | ((u32) ff_mult(3, p) << 24);
@@ -139,12 +129,6 @@ static void __init gen_tabs(void)
 
 		p = isb_tab[i];
 
-		t = p;
-		crypto_il_tab[0][i] = t;
-		crypto_il_tab[1][i] = rol32(t, 8);
-		crypto_il_tab[2][i] = rol32(t, 16);
-		crypto_il_tab[3][i] = rol32(t, 24);
-
 		t = ((u32) ff_mult(14, p)) |
 		    ((u32) ff_mult(9, p) << 8) |
 		    ((u32) ff_mult(13, p) << 16) |
@@ -173,10 +157,10 @@ static void __init gen_tabs(void)
 } while (0)
 
 #define ls_box(x)		\
-	crypto_fl_tab[0][byte(x, 0)] ^	\
-	crypto_fl_tab[1][byte(x, 1)] ^	\
-	crypto_fl_tab[2][byte(x, 2)] ^	\
-	crypto_fl_tab[3][byte(x, 3)]
+	(crypto_ft_tab[2][byte(x, 0)] & 0x000000ff) ^	\
+	(crypto_ft_tab[3][byte(x, 1)] & 0x0000ff00) ^	\
+	(crypto_ft_tab[0][byte(x, 2)] & 0x00ff0000) ^	\
+	(crypto_ft_tab[1][byte(x, 3)] & 0xff000000)
 
 #define loop4(i)	do {		\
 	t = ror32(t, 8);		\
@@ -303,11 +287,12 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 	k += 4;			\
 } while (0)
 
-#define f_rl(bo, bi, n, k)	do {				\
-	bo[n] = crypto_fl_tab[0][byte(bi[n], 0)] ^			\
-		crypto_fl_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
-		crypto_fl_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-		crypto_fl_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
+#define f_rl(bo, bi, n, k)	do {					    \
+	bo[n] = (crypto_ft_tab[2][byte(bi[n], 0)] & 0x000000ff) ^ 	    \
+		(crypto_ft_tab[3][byte(bi[(n + 1) & 3], 1)] & 0x0000ff00) ^ \
+		(crypto_ft_tab[0][byte(bi[(n + 2) & 3], 2)] & 0x00ff0000) ^ \
+		(crypto_ft_tab[1][byte(bi[(n + 3) & 3], 3)] & 0xff000000) ^ \
+		*(k + n);						    \
 } while (0)
 
 #define f_lround(bo, bi, k)	do {\
@@ -375,11 +360,11 @@ static void aes_encrypt(struct crypto_tf
 	k += 4;			\
 } while (0)
 
-#define i_rl(bo, bi, n, k)	do {			\
-	bo[n] = crypto_il_tab[0][byte(bi[n], 0)] ^		\
-	crypto_il_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
-	crypto_il_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-	crypto_il_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
+#define i_rl(bo, bi, n, k)	do {					\
+	bo[n] = (u32)isb_tab[byte(bi[n], 0)] ^				\
+	((u32)isb_tab[byte(bi[(n + 3) & 3], 1)] << 8) ^			\
+	((u32)isb_tab[byte(bi[(n + 2) & 3], 2)] << 16) ^		\
+	((u32)isb_tab[byte(bi[(n + 1) & 3], 3)] << 24) ^ *(k + n);	\
 } while (0)
 
 #define i_lround(bo, bi, k)	do {\
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -22,9 +22,7 @@ struct crypto_aes_ctx {
 };
 
 extern u32 crypto_ft_tab[4][256];
-extern u32 crypto_fl_tab[4][256];
 extern u32 crypto_it_tab[4][256];
-extern u32 crypto_il_tab[4][256];
 
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);

