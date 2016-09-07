From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: echainiv not working as supposed to be?
Date: Wed, 7 Sep 2016 18:42:08 +0800
Message-ID: <20160907104208.GA16455@gondor.apana.org.au>
References: <CA+rthh9_=PsJgZDtfoHQsaFZ2fH2hz4w_sbhn8fnx7a3LOatXQ@mail.gmail.com>
 <20160906160810.GA10311@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56660 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754452AbcIGKm2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 06:42:28 -0400
Content-Disposition: inline
In-Reply-To: <20160906160810.GA10311@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 07, 2016 at 12:08:10AM +0800, Herbert Xu wrote:
>
> > So, should echainiv use a per-context per-cpu array instead that --
> > for simplicity -- gets initialised with random bytes and will be
> > updated as it's now, just not with a single global per-cpu array, but
> > a per-context one?
> 
> As I said, the per-cpu IV is never seen by anyone so there is no
> need to make it per-tfm.

On second thought you're right.  The global array was a very lame
idea.  This patch changes it so that it instead does a multiply
with the salt.

---8<--
Subject: crypto: echainiv - Replace chaining with multiplication

The current implementation uses a global per-cpu array to store
data which are used to derive the next IV.  This is insecure as
the attacker may change the stored data.

This patch removes all traces of chaining and replaces it with
multiplication of the salt and the sequence number.

Fixes: a10f554fa7e0 ("crypto: echainiv - Add encrypted chain IV...")
Cc: stable@vger.kernel.org
Reported-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 1b01fe9..e3d889b 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -1,8 +1,8 @@
 /*
  * echainiv: Encrypted Chain IV Generator
  *
- * This generator generates an IV based on a sequence number by xoring it
- * with a salt and then encrypting it with the same key as used to encrypt
+ * This generator generates an IV based on a sequence number by multiplying
+ * it with a salt and then encrypting it with the same key as used to encrypt
  * the plain text.  This algorithm requires that the block size be equal
  * to the IV size.  It is mainly useful for CBC.
  *
@@ -24,81 +24,17 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/percpu.h>
-#include <linux/spinlock.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
-#define MAX_IV_SIZE 16
-
-static DEFINE_PER_CPU(u32 [MAX_IV_SIZE / sizeof(u32)], echainiv_iv);
-
-/* We don't care if we get preempted and read/write IVs from the next CPU. */
-static void echainiv_read_iv(u8 *dst, unsigned size)
-{
-	u32 *a = (u32 *)dst;
-	u32 __percpu *b = echainiv_iv;
-
-	for (; size >= 4; size -= 4) {
-		*a++ = this_cpu_read(*b);
-		b++;
-	}
-}
-
-static void echainiv_write_iv(const u8 *src, unsigned size)
-{
-	const u32 *a = (const u32 *)src;
-	u32 __percpu *b = echainiv_iv;
-
-	for (; size >= 4; size -= 4) {
-		this_cpu_write(*b, *a);
-		a++;
-		b++;
-	}
-}
-
-static void echainiv_encrypt_complete2(struct aead_request *req, int err)
-{
-	struct aead_request *subreq = aead_request_ctx(req);
-	struct crypto_aead *geniv;
-	unsigned int ivsize;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	if (err)
-		goto out;
-
-	geniv = crypto_aead_reqtfm(req);
-	ivsize = crypto_aead_ivsize(geniv);
-
-	echainiv_write_iv(subreq->iv, ivsize);
-
-	if (req->iv != subreq->iv)
-		memcpy(req->iv, subreq->iv, ivsize);
-
-out:
-	if (req->iv != subreq->iv)
-		kzfree(subreq->iv);
-}
-
-static void echainiv_encrypt_complete(struct crypto_async_request *base,
-					 int err)
-{
-	struct aead_request *req = base->data;
-
-	echainiv_encrypt_complete2(req, err);
-	aead_request_complete(req, err);
-}
-
 static int echainiv_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
 	struct aead_request *subreq = aead_request_ctx(req);
-	crypto_completion_t compl;
-	void *data;
+	__be64 nseqno;
+	u64 seqno;
 	u8 *info;
 	unsigned int ivsize = crypto_aead_ivsize(geniv);
 	int err;
@@ -108,8 +44,6 @@ static int echainiv_encrypt(struct aead_request *req)
 
 	aead_request_set_tfm(subreq, ctx->child);
 
-	compl = echainiv_encrypt_complete;
-	data = req;
 	info = req->iv;
 
 	if (req->src != req->dst) {
@@ -127,29 +61,30 @@ static int echainiv_encrypt(struct aead_request *req)
 			return err;
 	}
 
-	if (unlikely(!IS_ALIGNED((unsigned long)info,
-				 crypto_aead_alignmask(geniv) + 1))) {
-		info = kmalloc(ivsize, req->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
-		if (!info)
-			return -ENOMEM;
-
-		memcpy(info, req->iv, ivsize);
-	}
-
-	aead_request_set_callback(subreq, req->base.flags, compl, data);
+	aead_request_set_callback(subreq, req->base.flags,
+				  req->base.complete, req->base.data);
 	aead_request_set_crypt(subreq, req->dst, req->dst,
 			       req->cryptlen, info);
 	aead_request_set_ad(subreq, req->assoclen);
 
-	crypto_xor(info, ctx->salt, ivsize);
+	memcpy(&nseqno, info + ivsize - 8, 8);
+	seqno = be64_to_cpu(nseqno);
+	memset(info, 0, ivsize);
+
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
-	echainiv_read_iv(info, ivsize);
 
-	err = crypto_aead_encrypt(subreq);
-	echainiv_encrypt_complete2(req, err);
-	return err;
+	do {
+		u64 a;
+
+		memcpy(&a, ctx->salt + ivsize - 8, 8);
+
+		a |= 1;
+		a *= seqno;
+
+		memcpy(info + ivsize - 8, &a, 8);
+	} while ((ivsize -= 8));
+
+	return crypto_aead_encrypt(subreq);
 }
 
 static int echainiv_decrypt(struct aead_request *req)
@@ -196,8 +131,7 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	alg = crypto_spawn_aead_alg(spawn);
 
 	err = -EINVAL;
-	if (inst->alg.ivsize & (sizeof(u32) - 1) ||
-	    inst->alg.ivsize > MAX_IV_SIZE)
+	if (inst->alg.ivsize & (sizeof(u64) - 1) || !inst->alg.ivsize)
 		goto free_inst;
 
 	inst->alg.encrypt = echainiv_encrypt;
@@ -206,7 +140,6 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	inst->alg.init = aead_init_geniv;
 	inst->alg.exit = aead_exit_geniv;
 
-	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 	inst->alg.base.cra_ctxsize = sizeof(struct aead_geniv_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
