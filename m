From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Sun, 31 Aug 2008 16:01:05 +1000
Message-ID: <20080831060105.GA8621@gondor.apana.org.au>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc> <20080402065015.GA7421@gondor.apana.org.au> <20080402071722.GF32234@Chamillionaire.breakpoint.cc> <20080402072258.GA7720@gondor.apana.org.au> <20080807145312.GA11073@gondor.apana.org.au> <20080809112013.GA7914@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Hellermann <stefan@the2masters.de>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55732 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751027AbYHaGBW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Aug 2008 02:01:22 -0400
Content-Disposition: inline
In-Reply-To: <20080809112013.GA7914@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 09, 2008 at 01:20:13PM +0200, Sebastian Siewior wrote:
>
> Well, the spec says the key reload takes a lot of time so it should give
> a big boost to everything what isn't supported directly in HW.
> The padlock supports a few other modes like OFB but I doubt they are
> required since they aren't even implemented in SW.

I've finally committed it as follows.

commit d94604ab04c6711d7cf9ad086cf5f6fa446d8eb6
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Aug 31 15:58:45 2008 +1000

    crypto: padlock - Avoid resetting cword on successive operations
    
    Resetting the control word is quite expensive.  Fortunately this
    isn't an issue for the common operations such as CBC and ECB as
    the whole operation is done through a single call.  However, modes
    such as LRW and XTS have to call padlock over and over again for
    one operation which really hurts if each call resets the control
    word.
    
    This patch uses an idea by Sebastian Siewior to store the last
    control word used on a CPU and only reset the control word if
    that changes.
    
    Note that any task switch automatically resets the control word
    so we only need to be accurate with regard to the stored control
    word when no task switches occur.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index bf2917d..856b3cc 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -15,6 +15,8 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/smp.h>
 #include <asm/byteorder.h>
 #include <asm/i387.h>
 #include "padlock.h"
@@ -49,6 +51,8 @@ struct aes_ctx {
 	u32 *D;
 };
 
+static DEFINE_PER_CPU(struct cword *, last_cword);
+
 /* Tells whether the ACE is capable to generate
    the extended key for a given key_len. */
 static inline int
@@ -89,6 +93,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	const __le32 *key = (const __le32 *)in_key;
 	u32 *flags = &tfm->crt_flags;
 	struct crypto_aes_ctx gen_aes;
+	int cpu;
 
 	if (key_len % 8) {
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -118,7 +123,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 	/* Don't generate extended keys if the hardware can do it. */
 	if (aes_hw_extkey_available(key_len))
-		return 0;
+		goto ok;
 
 	ctx->D = ctx->d_data;
 	ctx->cword.encrypt.keygen = 1;
@@ -131,15 +136,30 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 	memcpy(ctx->E, gen_aes.key_enc, AES_MAX_KEYLENGTH);
 	memcpy(ctx->D, gen_aes.key_dec, AES_MAX_KEYLENGTH);
+
+ok:
+	for_each_online_cpu(cpu)
+		if (&ctx->cword.encrypt == per_cpu(last_cword, cpu) ||
+		    &ctx->cword.decrypt == per_cpu(last_cword, cpu))
+			per_cpu(last_cword, cpu) = NULL;
+
 	return 0;
 }
 
 /* ====== Encryption/decryption routines ====== */
 
 /* These are the real call to PadLock. */
-static inline void padlock_reset_key(void)
+static inline void padlock_reset_key(struct cword *cword)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (cword != per_cpu(last_cword, cpu))
+		asm volatile ("pushfl; popfl");
+}
+
+static inline void padlock_store_cword(struct cword *cword)
 {
-	asm volatile ("pushfl; popfl");
+	per_cpu(last_cword, raw_smp_processor_id()) = cword;
 }
 
 /*
@@ -149,7 +169,7 @@ static inline void padlock_reset_key(void)
  */
 
 static inline void padlock_xcrypt(const u8 *input, u8 *output, void *key,
-				  void *control_word)
+				  struct cword *control_word)
 {
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
 		      : "+S"(input), "+D"(output)
@@ -213,22 +233,24 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	int ts_state;
-	padlock_reset_key();
 
+	padlock_reset_key(&ctx->cword.encrypt);
 	ts_state = irq_ts_save();
 	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
 	irq_ts_restore(ts_state);
+	padlock_store_cword(&ctx->cword.encrypt);
 }
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	int ts_state;
-	padlock_reset_key();
 
+	padlock_reset_key(&ctx->cword.encrypt);
 	ts_state = irq_ts_save();
 	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
 	irq_ts_restore(ts_state);
+	padlock_store_cword(&ctx->cword.encrypt);
 }
 
 static struct crypto_alg aes_alg = {
@@ -261,7 +283,7 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
 	int err;
 	int ts_state;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.encrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -276,6 +298,8 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
 	}
 	irq_ts_restore(ts_state);
 
+	padlock_store_cword(&ctx->cword.encrypt);
+
 	return err;
 }
 
@@ -288,7 +312,7 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
 	int err;
 	int ts_state;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.decrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -302,6 +326,9 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 	irq_ts_restore(ts_state);
+
+	padlock_store_cword(&ctx->cword.encrypt);
+
 	return err;
 }
 
@@ -336,7 +363,7 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 	int err;
 	int ts_state;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.encrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -353,6 +380,8 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 	}
 	irq_ts_restore(ts_state);
 
+	padlock_store_cword(&ctx->cword.decrypt);
+
 	return err;
 }
 
@@ -365,7 +394,7 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 	int err;
 	int ts_state;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.encrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -380,6 +409,9 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 	}
 
 	irq_ts_restore(ts_state);
+
+	padlock_store_cword(&ctx->cword.encrypt);
+
 	return err;
 }
 
Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
