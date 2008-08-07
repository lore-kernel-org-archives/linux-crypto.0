From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Thu, 7 Aug 2008 22:53:12 +0800
Message-ID: <20080807145312.GA11073@gondor.apana.org.au>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc> <20080402065015.GA7421@gondor.apana.org.au> <20080402071722.GF32234@Chamillionaire.breakpoint.cc> <20080402072258.GA7720@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Hellermann <stefan@the2masters.de>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37977 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbYHGOx0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Aug 2008 10:53:26 -0400
Content-Disposition: inline
In-Reply-To: <20080402072258.GA7720@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 02, 2008 at 03:22:58PM +0800, Herbert Xu wrote:
> On Wed, Apr 02, 2008 at 09:17:22AM +0200, Sebastian Siewior wrote:
> > I'm not sure if they have SMP or multicore out / plans but I gave a
> > little thought on this early morning: The only problem is if we get
> > swapped to another cores before encryption process beginns and after key
> > reset thing. If the scheduler decides to swap cores than EFLAGS should
> > be reloaded and wer are fine. The only problem that I see with cpus > 1
> > is that we might reload the key if it is not required. This could be
> > solved with old_ctx pointer beeing a percpu. 
> 
> Yeah I think having a percpu would be good even if it isn't needed
> right now.

I've coded this up with the per-cpu structure and it seems to work.
It doesn't make much of a difference for ECB/CBC but with LRW/XTS
it gives a huge boost.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 54a2a16..c71256a 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -15,6 +15,8 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/smp.h>
 #include <asm/byteorder.h>
 #include "padlock.h"
 
@@ -48,6 +50,8 @@ struct aes_ctx {
 	u32 *D;
 };
 
+static DEFINE_PER_CPU(struct cword *, last_cword);
+
 /* Tells whether the ACE is capable to generate
    the extended key for a given key_len. */
 static inline int
@@ -88,6 +92,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	const __le32 *key = (const __le32 *)in_key;
 	u32 *flags = &tfm->crt_flags;
 	struct crypto_aes_ctx gen_aes;
+	int cpu;
 
 	if (key_len % 8) {
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -117,7 +122,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 	/* Don't generate extended keys if the hardware can do it. */
 	if (aes_hw_extkey_available(key_len))
-		return 0;
+		goto ok;
 
 	ctx->D = ctx->d_data;
 	ctx->cword.encrypt.keygen = 1;
@@ -130,19 +135,34 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
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
 {
-	asm volatile ("pushfl; popfl");
+	int cpu = raw_smp_processor_id();
+
+	if (cword != per_cpu(last_cword, cpu))
+		asm volatile ("pushfl; popfl");
+}
+
+static inline void padlock_store_cword(struct cword *cword)
+{
+	per_cpu(last_cword, raw_smp_processor_id()) = cword;
 }
 
 static inline void padlock_xcrypt(const u8 *input, u8 *output, void *key,
-				  void *control_word)
+				  struct cword *control_word)
 {
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
 		      : "+S"(input), "+D"(output)
@@ -205,15 +225,17 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.encrypt);
 	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
+	padlock_store_cword(&ctx->cword.encrypt);
 }
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.decrypt);
 	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
+	padlock_store_cword(&ctx->cword.decrypt);
 }
 
 static struct crypto_alg aes_alg = {
@@ -245,7 +267,7 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.encrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -258,6 +280,8 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
+	padlock_store_cword(&ctx->cword.encrypt);
+
 	return err;
 }
 
@@ -269,7 +293,7 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.decrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -282,6 +306,8 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
+	padlock_store_cword(&ctx->cword.decrypt);
+
 	return err;
 }
 
@@ -315,7 +341,7 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.encrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -330,6 +356,8 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
+	padlock_store_cword(&ctx->cword.encrypt);
+
 	return err;
 }
 
@@ -341,7 +369,7 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	padlock_reset_key(&ctx->cword.decrypt);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -354,6 +382,8 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
+	padlock_store_cword(&ctx->cword.decrypt);
+
 	return err;
 }
 
