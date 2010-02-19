From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 06/19] crypto: salsa20_generic - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:08 +0100
Message-ID: <1266538929-3278-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/salsa20_generic.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index eac10c1..31f03bb 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -50,8 +50,7 @@ Public domain.
 	(((u32)((p)[0])      ) | ((u32)((p)[1]) <<  8) | \
 	 ((u32)((p)[2]) << 16) | ((u32)((p)[3]) << 24)   )
 
-struct salsa20_ctx
-{
+struct salsa20_ctx {
 	u32 input[16];
 };
 
@@ -98,7 +97,7 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
 	for (i = 0; i < 16; ++i)
 		x[i] += input[i];
 	for (i = 0; i < 16; ++i)
-		U32TO8_LITTLE(output + 4 * i,x[i]);
+		U32TO8_LITTLE(output + 4 * i, x[i]);
 }
 
 static const char sigma[16] = "expand 32-byte k";
@@ -188,8 +187,7 @@ static int encrypt(struct blkcipher_desc *desc,
 
 	salsa20_ivsetup(ctx, walk.iv);
 
-	if (likely(walk.nbytes == nbytes))
-	{
+	if (likely(walk.nbytes == nbytes)) {
 		salsa20_encrypt_bytes(ctx, walk.dst.virt.addr,
 				      walk.src.virt.addr, nbytes);
 		return blkcipher_walk_done(desc, &walk, 0);
@@ -248,5 +246,5 @@ module_init(salsa20_generic_mod_init);
 module_exit(salsa20_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION ("Salsa20 stream cipher algorithm");
+MODULE_DESCRIPTION("Salsa20 stream cipher algorithm");
 MODULE_ALIAS("salsa20");
-- 
1.6.6.1
