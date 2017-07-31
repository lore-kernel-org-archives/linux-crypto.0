From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: serpent: improve __serpent_setkey with UBSAN
Date: Mon, 31 Jul 2017 22:43:55 +0200
Message-ID: <20170731204407.1396336-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When UBSAN is enabled, we get a very large stack frame for
__serpent_setkey, when the register allocator ends up using more registers
than it has, and has to spill temporary values to the stack. The code
was originally optimized for in-order x86-32 CPU implementations using
older compilers, but it now runs into a highly suboptimal case on all
CPU architectures, as seen by this warning:

crypto/serpent_generic.c: In function '__serpent_setkey':
crypto/serpent_generic.c:436:1: error: the frame size of 2720 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Disabling -fsanitize=alignment would avoid that warning, presumably the
option turns off a optimization step that is required for getting the
register allocation right, but there is no easy way to do that on gcc-7
(gcc-8 introduces a function attribute for this).

I tried to figure out a way to modify the source code instead, and noticed
that the two stages of the setkey() function (keyiter and sbox) each are
fine by themselves, but not when combined into one function. Splitting
out the entire sbox into a separate function also happens to work fine
with all compilers I tried (arm, arm64 and x86).

The setkey function uses a strange way to handle offsets into the key
array, using both negative and positive index values, as well as adjusting
the array pointer back and forth. I have checked that this actually
makes no difference to modern compilers, but I left that untouched
to make the patch easier to review and to keep the code closer to
the reference implementation.

Link: https://patchwork.kernel.org/patch/9189575/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/serpent_generic.c | 77 ++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 94970a794975..7c3382facc82 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -229,6 +229,46 @@
 	x4 ^= x2;					\
 	})
 
+static void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
+{
+	k += 100;
+	S3(r3, r4, r0, r1, r2); store_and_load_keys(r1, r2, r4, r3, 28, 24);
+	S4(r1, r2, r4, r3, r0); store_and_load_keys(r2, r4, r3, r0, 24, 20);
+	S5(r2, r4, r3, r0, r1); store_and_load_keys(r1, r2, r4, r0, 20, 16);
+	S6(r1, r2, r4, r0, r3); store_and_load_keys(r4, r3, r2, r0, 16, 12);
+	S7(r4, r3, r2, r0, r1); store_and_load_keys(r1, r2, r0, r4, 12, 8);
+	S0(r1, r2, r0, r4, r3); store_and_load_keys(r0, r2, r4, r1, 8, 4);
+	S1(r0, r2, r4, r1, r3); store_and_load_keys(r3, r4, r1, r0, 4, 0);
+	S2(r3, r4, r1, r0, r2); store_and_load_keys(r2, r4, r3, r0, 0, -4);
+	S3(r2, r4, r3, r0, r1); store_and_load_keys(r0, r1, r4, r2, -4, -8);
+	S4(r0, r1, r4, r2, r3); store_and_load_keys(r1, r4, r2, r3, -8, -12);
+	S5(r1, r4, r2, r3, r0); store_and_load_keys(r0, r1, r4, r3, -12, -16);
+	S6(r0, r1, r4, r3, r2); store_and_load_keys(r4, r2, r1, r3, -16, -20);
+	S7(r4, r2, r1, r3, r0); store_and_load_keys(r0, r1, r3, r4, -20, -24);
+	S0(r0, r1, r3, r4, r2); store_and_load_keys(r3, r1, r4, r0, -24, -28);
+	k -= 50;
+	S1(r3, r1, r4, r0, r2); store_and_load_keys(r2, r4, r0, r3, 22, 18);
+	S2(r2, r4, r0, r3, r1); store_and_load_keys(r1, r4, r2, r3, 18, 14);
+	S3(r1, r4, r2, r3, r0); store_and_load_keys(r3, r0, r4, r1, 14, 10);
+	S4(r3, r0, r4, r1, r2); store_and_load_keys(r0, r4, r1, r2, 10, 6);
+	S5(r0, r4, r1, r2, r3); store_and_load_keys(r3, r0, r4, r2, 6, 2);
+	S6(r3, r0, r4, r2, r1); store_and_load_keys(r4, r1, r0, r2, 2, -2);
+	S7(r4, r1, r0, r2, r3); store_and_load_keys(r3, r0, r2, r4, -2, -6);
+	S0(r3, r0, r2, r4, r1); store_and_load_keys(r2, r0, r4, r3, -6, -10);
+	S1(r2, r0, r4, r3, r1); store_and_load_keys(r1, r4, r3, r2, -10, -14);
+	S2(r1, r4, r3, r2, r0); store_and_load_keys(r0, r4, r1, r2, -14, -18);
+	S3(r0, r4, r1, r2, r3); store_and_load_keys(r2, r3, r4, r0, -18, -22);
+	k -= 50;
+	S4(r2, r3, r4, r0, r1); store_and_load_keys(r3, r4, r0, r1, 28, 24);
+	S5(r3, r4, r0, r1, r2); store_and_load_keys(r2, r3, r4, r1, 24, 20);
+	S6(r2, r3, r4, r1, r0); store_and_load_keys(r4, r0, r3, r1, 20, 16);
+	S7(r4, r0, r3, r1, r2); store_and_load_keys(r2, r3, r1, r4, 16, 12);
+	S0(r2, r3, r1, r4, r0); store_and_load_keys(r1, r3, r4, r2, 12, 8);
+	S1(r1, r3, r4, r2, r0); store_and_load_keys(r0, r4, r2, r1, 8, 4);
+	S2(r0, r4, r2, r1, r3); store_and_load_keys(r3, r4, r0, r1, 4, 0);
+	S3(r3, r4, r0, r1, r2); storekeys(r1, r2, r4, r3, 0);
+}
+
 int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 		     unsigned int keylen)
 {
@@ -395,42 +435,7 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 	keyiter(k[23], r1, r0, r3, 131, 31);
 
 	/* Apply S-boxes */
-
-	S3(r3, r4, r0, r1, r2); store_and_load_keys(r1, r2, r4, r3, 28, 24);
-	S4(r1, r2, r4, r3, r0); store_and_load_keys(r2, r4, r3, r0, 24, 20);
-	S5(r2, r4, r3, r0, r1); store_and_load_keys(r1, r2, r4, r0, 20, 16);
-	S6(r1, r2, r4, r0, r3); store_and_load_keys(r4, r3, r2, r0, 16, 12);
-	S7(r4, r3, r2, r0, r1); store_and_load_keys(r1, r2, r0, r4, 12, 8);
-	S0(r1, r2, r0, r4, r3); store_and_load_keys(r0, r2, r4, r1, 8, 4);
-	S1(r0, r2, r4, r1, r3); store_and_load_keys(r3, r4, r1, r0, 4, 0);
-	S2(r3, r4, r1, r0, r2); store_and_load_keys(r2, r4, r3, r0, 0, -4);
-	S3(r2, r4, r3, r0, r1); store_and_load_keys(r0, r1, r4, r2, -4, -8);
-	S4(r0, r1, r4, r2, r3); store_and_load_keys(r1, r4, r2, r3, -8, -12);
-	S5(r1, r4, r2, r3, r0); store_and_load_keys(r0, r1, r4, r3, -12, -16);
-	S6(r0, r1, r4, r3, r2); store_and_load_keys(r4, r2, r1, r3, -16, -20);
-	S7(r4, r2, r1, r3, r0); store_and_load_keys(r0, r1, r3, r4, -20, -24);
-	S0(r0, r1, r3, r4, r2); store_and_load_keys(r3, r1, r4, r0, -24, -28);
-	k -= 50;
-	S1(r3, r1, r4, r0, r2); store_and_load_keys(r2, r4, r0, r3, 22, 18);
-	S2(r2, r4, r0, r3, r1); store_and_load_keys(r1, r4, r2, r3, 18, 14);
-	S3(r1, r4, r2, r3, r0); store_and_load_keys(r3, r0, r4, r1, 14, 10);
-	S4(r3, r0, r4, r1, r2); store_and_load_keys(r0, r4, r1, r2, 10, 6);
-	S5(r0, r4, r1, r2, r3); store_and_load_keys(r3, r0, r4, r2, 6, 2);
-	S6(r3, r0, r4, r2, r1); store_and_load_keys(r4, r1, r0, r2, 2, -2);
-	S7(r4, r1, r0, r2, r3); store_and_load_keys(r3, r0, r2, r4, -2, -6);
-	S0(r3, r0, r2, r4, r1); store_and_load_keys(r2, r0, r4, r3, -6, -10);
-	S1(r2, r0, r4, r3, r1); store_and_load_keys(r1, r4, r3, r2, -10, -14);
-	S2(r1, r4, r3, r2, r0); store_and_load_keys(r0, r4, r1, r2, -14, -18);
-	S3(r0, r4, r1, r2, r3); store_and_load_keys(r2, r3, r4, r0, -18, -22);
-	k -= 50;
-	S4(r2, r3, r4, r0, r1); store_and_load_keys(r3, r4, r0, r1, 28, 24);
-	S5(r3, r4, r0, r1, r2); store_and_load_keys(r2, r3, r4, r1, 24, 20);
-	S6(r2, r3, r4, r1, r0); store_and_load_keys(r4, r0, r3, r1, 20, 16);
-	S7(r4, r0, r3, r1, r2); store_and_load_keys(r2, r3, r1, r4, 16, 12);
-	S0(r2, r3, r1, r4, r0); store_and_load_keys(r1, r3, r4, r2, 12, 8);
-	S1(r1, r3, r4, r2, r0); store_and_load_keys(r0, r4, r2, r1, 8, 4);
-	S2(r0, r4, r2, r1, r3); store_and_load_keys(r3, r4, r0, r1, 4, 0);
-	S3(r3, r4, r0, r1, r2); storekeys(r1, r2, r4, r3, 0);
+	__serpent_setkey_sbox(r0, r1, r2, r3, r4, ctx->expkey);
 
 	return 0;
 }
-- 
2.9.0
