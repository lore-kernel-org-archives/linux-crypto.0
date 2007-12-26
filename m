From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: OOPS: 2.6.23.11 in PadLock-AES when used in LRW-Mode
Date: Thu, 27 Dec 2007 00:48:11 +1100
Message-ID: <20071226134811.GA9765@gondor.apana.org.au>
References: <60C7157B-A303-435A-92D3-A6DA1C0CC178@tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, michal@logix.cz,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alexander Eichhorn <alexander.eichhorn@tu-ilmenau.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3018 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823AbXLZNs2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Dec 2007 08:48:28 -0500
Content-Disposition: inline
In-Reply-To: <60C7157B-A303-435A-92D3-A6DA1C0CC178@tu-ilmenau.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 23, 2007 at 06:22:14PM +0000, Alexander Eichhorn wrote:
>
> BUG: unable to handle kernel paging request at virtual address f8000000
>  printing eip:
> c03bbc8c
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT
> Modules linked in:
> CPU:    0
> EIP:    0060:[<c03bbc8c>]    Not tainted VLI
> EFLAGS: 00010282   (2.6.23.11-vanilla #1)
> EIP is at aes_encrypt+0x17/0x1f
> eax: f4679400   ebx: f4679450   ecx: 00000001   edx: f4679420
> esi: f7fffff0   edi: f7fffff0   ebp: f7557e40   esp: f7557de4

Thanks for the report.  This is due to the fact that xcryptecb always
processes an even number of blocks.

Please let me know if the following patch fixes the problem for you.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 6154cf1..a3e14ce 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -417,20 +417,65 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 /* ====== Encryption/decryption routines ====== */
 
 /* These are the real call to PadLock. */
+static inline void padlock_reset_key(void)
+{
+	asm volatile ("pushfl; popfl");
+}
+
+static inline void padlock_xcrypt(const u8 *input, u8 *output, void *key,
+				  void *control_word)
+{
+	asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
+		      : "+S"(input), "+D"(output)
+		      : "d"(control_word), "b"(key), "c"(1));
+}
+
+static void aes_crypt_copy(const u8 *in, u8 *out, u32 *key, struct cword *cword)
+{
+	u8 tmp[AES_BLOCK_SIZE * 2]
+		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
+
+	memcpy(tmp, in, AES_BLOCK_SIZE);
+	padlock_xcrypt(tmp, out, key, cword);
+}
+
+static inline void aes_crypt(const u8 *in, u8 *out, u32 *key,
+			     struct cword *cword)
+{
+	/* padlock_xcrypt requires at least two blocks of data. */
+	if (unlikely(!(((unsigned long)in ^ (PAGE_SIZE - AES_BLOCK_SIZE)) &
+		       (PAGE_SIZE - 1)))) {
+		aes_crypt_copy(in, out, key, cword);
+		return;
+	}
+
+	padlock_xcrypt(in, out, key, cword);
+}
+
 static inline void padlock_xcrypt_ecb(const u8 *input, u8 *output, void *key,
 				      void *control_word, u32 count)
 {
-	asm volatile ("pushfl; popfl");		/* enforce key reload. */
-	asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
+	if (count == 1) {
+		aes_crypt(input, output, key, control_word);
+		return;
+	}
+
+	asm volatile ("test $1, %%cl;"
+		      "je 1f;"
+		      "lea -1(%%ecx), %%eax;"
+		      "mov $1, %%ecx;"
+		      ".byte 0xf3,0x0f,0xa7,0xc8;"	/* rep xcryptecb */
+		      "mov %%eax, %%ecx;"
+		      "1:"
+		      ".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
 		      : "+S"(input), "+D"(output)
-		      : "d"(control_word), "b"(key), "c"(count));
+		      : "d"(control_word), "b"(key), "c"(count)
+		      : "ax");
 }
 
 static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 				     u8 *iv, void *control_word, u32 count)
 {
-	/* Enforce key reload. */
-	asm volatile ("pushfl; popfl");
 	/* rep xcryptcbc */
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"
 		      : "+S" (input), "+D" (output), "+a" (iv)
@@ -441,13 +486,15 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_xcrypt_ecb(in, out, ctx->E, &ctx->cword.encrypt, 1);
+	padlock_reset_key();
+	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
 }
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_xcrypt_ecb(in, out, ctx->D, &ctx->cword.decrypt, 1);
+	padlock_reset_key();
+	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
 }
 
 static struct crypto_alg aes_alg = {
@@ -479,6 +526,8 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
+	padlock_reset_key();
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -501,6 +550,8 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
+	padlock_reset_key();
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -545,6 +596,8 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
+	padlock_reset_key();
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -569,6 +622,8 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
+	padlock_reset_key();
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
