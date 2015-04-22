From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: add key wrapping block chaining mode
Date: Wed, 22 Apr 2015 06:36:59 +0200
Message-ID: <6218629.uO4632Hmli@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34236 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbbDVEhE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 00:37:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch implements the AES key wrapping as specified in
NIST SP800-38F and RFC3394.

The implementation covers key wrapping without padding. The caller may
provide an IV. If no IV is provided, the default IV defined in SP800-38F
is used for key wrapping and unwrapping.

The key wrapping is an authenticated encryption operation without
associated data. Therefore, setting of AAD is permissible, but that data
is not used by the cipher implementation.

Albeit the standards define the key wrapping for AES only, the template
can be used with any other block cipher that has a block size of 16
bytes.

Testing with CAVS test vectors for AES 128, 192, 256 in encryption and decryption up to 4096 bytes plaintext has been conducted successfully.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig   |   6 +
 crypto/Makefile  |   1 +
 crypto/keywrap.c | 518 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c |  16 ++
 crypto/testmgr.h |  38 ++++
 5 files changed, 579 insertions(+)
 create mode 100644 crypto/keywrap.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8aaf298..c3e1779 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -217,6 +217,12 @@ config CRYPTO_GCM
 	  Support for Galois/Counter Mode (GCM) and Galois Message
 	  Authentication Code (GMAC). Required for IPSec.
 
+config CRYPTO_KEYWRAP
+	tristate "Key wrapping support"
+	select CRYPTO_AEAD
+	help
+	  Support for key wrapping (NIST SP800-38F / RFC3394).
+
 config CRYPTO_SEQIV
 	tristate "Sequence Number IV Generator"
 	select CRYPTO_AEAD
diff --git a/crypto/Makefile b/crypto/Makefile
index 97b7d3a..2e8e053 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
+obj-$(CONFIG_CRYPTO_KEYWRAP) += keywrap.o
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_MCRYPTD) += mcryptd.o
diff --git a/crypto/keywrap.c b/crypto/keywrap.c
new file mode 100644
index 0000000..68cf552
--- /dev/null
+++ b/crypto/keywrap.c
@@ -0,0 +1,518 @@
+/*
+ * Key Wrapping: RFC3394 / NIST SP800-38F
+ *
+ * Implemented modes as defined in NIST SP800-38F: KW
+ *
+ * Copyright (C) 2015, Stephan Mueller <smueller@chronox.de>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, and the entire permission notice in its entirety,
+ *    including the disclaimer of warranties.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * ALTERNATIVELY, this product may be distributed under the terms of
+ * the GNU General Public License, in which case the provisions of the GPL2
+ * are required INSTEAD OF the above restrictions.  (This clause is
+ * necessary due to a potential bad interaction between the GPL and
+ * the restrictions contained in a BSD-style copyright.)
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+ * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+ * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ */
+
+/*
+ * Note for using key wrapping as an AEAD cipher:
+ *
+ *	* For encryption, the ciphertext is larger by one half block size. The
+ *	  caller must ensure that the destination buffer is sufficiently large.
+ *	  That half blocksize is considered as the "authentication tag" (even
+ *	  though the key wrapping does not have an authentication tag).
+ *
+ *	* AAD can be set with the key wrapping cipher, but it is not processed
+ *	  as such data is not needed.
+ *
+ *	* If the caller does not set an IV, the default IV from SP800-38F is
+ *	  used for encryption and decryption. If an IV is set, it must be
+ *	  exactly be as large as half a block of the cipher.
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/aead.h>
+
+struct crypto_kw_ctx {
+	struct crypto_cipher *child;
+};
+
+struct crypto_kw_block {
+#define SEMIBSIZE 8
+	u8 A[SEMIBSIZE];
+	u8 R[SEMIBSIZE];
+};
+
+/* convert 64 bit integer into its string representation */
+static inline void crypto_kw_cpu_to_be64(u64 val, u8 *buf)
+{
+	struct s {
+		__be64 conv;
+	};
+	struct s *conversion = (struct s *) buf;
+
+	conversion->conv = cpu_to_be64(val);
+}
+
+static inline void crypto_kw_copy_scatterlist(struct scatterlist *src,
+					      struct scatterlist *dst)
+{
+	memcpy(dst, src, sizeof(struct scatterlist));
+}
+
+/* find the next memory block in scatter_walk of given size */
+static inline bool crypto_kw_scatterwalk_find(struct scatter_walk *walk,
+					      unsigned int size)
+{
+	int n = scatterwalk_clamp(walk, size);
+
+	if (!n) {
+		scatterwalk_start(walk, sg_next(walk->sg));
+		n = scatterwalk_clamp(walk, size);
+	}
+	if (n != size)
+		return false;
+	return true;
+}
+
+/*
+ * Copy out the memory block from or to scatter_walk of requested size
+ * before the walk->offset pointer. The scatter_walk is processed in reverse.
+ */
+static bool crypto_kw_scatterwalk_memcpy_rev(struct scatter_walk *walk,
+					     unsigned int *walklen,
+					     u8 *buf, unsigned int bufsize,
+					     bool out)
+{
+	u8 *ptr = NULL;
+
+	walk->offset -= bufsize;
+	if (!crypto_kw_scatterwalk_find(walk, bufsize))
+		return false;
+
+	ptr = scatterwalk_map(walk);
+	if (out)
+		memcpy(ptr, buf, bufsize);
+	else
+		memcpy(buf, ptr, bufsize);
+	*walklen -= bufsize;
+	scatterwalk_unmap(ptr);
+	scatterwalk_done(walk, 0, *walklen);
+
+	return true;
+}
+
+/*
+ * Copy the memory block from or to scatter_walk of requested size
+ * at the walk->offset pointer. The scatter_walk is processed forward.
+ */
+static bool crypto_kw_scatterwalk_memcpy(struct scatter_walk *walk,
+					 unsigned int *walklen,
+					 u8 *buf, unsigned int bufsize,
+					 bool out)
+{
+	u8 *ptr = NULL;
+
+	if (!crypto_kw_scatterwalk_find(walk, bufsize))
+		return false;
+
+	ptr = scatterwalk_map(walk);
+	if (out)
+		memcpy(ptr, buf, bufsize);
+	else
+		memcpy(buf, ptr, bufsize);
+	*walklen -= bufsize;
+	scatterwalk_unmap(ptr);
+	scatterwalk_advance(walk, bufsize);
+	scatterwalk_done(walk, 0, *walklen);
+
+	return true;
+}
+
+static int crypto_kw_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_kw_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_cipher *tfm = ctx->child;
+	unsigned long alignmask = crypto_cipher_alignmask(tfm);
+	unsigned int src_nbytes, dst_nbytes, i;
+	struct scatter_walk src_walk, dst_walk;
+	struct crypto_kw_block block;
+	u8 tmpblock[SEMIBSIZE];
+	u64 t = 6 * ((req->cryptlen - SEMIBSIZE) >> 3);
+	int ret = -EAGAIN;
+	struct scatterlist src, dst;
+	/* IV of KW defined by section 6.2 */
+	u8 *default_iv = "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6";
+	unsigned int outcryptlen = req->cryptlen - SEMIBSIZE;
+
+	/*
+	 * Require at least 3 semiblocks as defined in SP800-38F and ensure
+	 * that the given data is aligned to semiblock.
+	 */
+	if (req->cryptlen < (3 * SEMIBSIZE) || req->cryptlen % 8)
+		return -EINVAL;
+
+	/*
+	 * src scatterlist is read only. dst scatterlist is r/w. During the
+	 * first loop, src points to req->src and dst to req->dst. For any
+	 * subsequent round, the code operates on req->dst only.
+	 */
+	crypto_kw_copy_scatterlist(req->src, &src);
+	crypto_kw_copy_scatterlist(req->dst, &dst);
+
+	for (i = 0; i < 6; i++) {
+		u8 tbe_buffer[SEMIBSIZE + alignmask];
+		/* alignment for the crypto_xor operation */
+		u8 *tbe = PTR_ALIGN(tbe_buffer + 0, alignmask + 1);
+		bool first_loop = true;
+
+		scatterwalk_start(&src_walk, &src);
+		scatterwalk_start(&dst_walk, &dst);
+
+		src_nbytes = dst_nbytes = outcryptlen;
+		if (!i) {
+			src_nbytes = req->cryptlen;
+			if (!crypto_kw_scatterwalk_memcpy(&src_walk,
+				&src_nbytes, block.A, SEMIBSIZE, false))
+			goto out;
+		}
+
+		/*
+		 * Point to the end of the source scatterlist to walk them
+		 * backwards.
+		 */
+		src_walk.offset += src_nbytes;
+		dst_walk.offset += dst_nbytes;
+
+		while (src_nbytes) {
+			if (!crypto_kw_scatterwalk_memcpy_rev(&src_walk,
+				&src_nbytes, block.R, SEMIBSIZE, false))
+				goto out;
+			crypto_kw_cpu_to_be64(t, tbe);
+			crypto_xor(block.A, tbe, SEMIBSIZE);
+			t--;
+			crypto_cipher_decrypt_one(tfm, (u8*)&block,
+						  (u8*)&block);
+			if (!first_loop) {
+				/*
+				 * Copy block.R from last round into
+				 * place.
+				 */
+				if (!crypto_kw_scatterwalk_memcpy_rev(&dst_walk,
+					&dst_nbytes, tmpblock, SEMIBSIZE, true))
+						goto out;
+			} else {
+				first_loop = false;
+			}
+
+			/*
+			 * Store current block.R in temp buffer to
+			 * copy it in place in the next round.
+			 */
+			memcpy(&tmpblock, block.R, SEMIBSIZE);
+		}
+
+		/* process the final block.R */
+		if (!crypto_kw_scatterwalk_memcpy_rev(&dst_walk, &dst_nbytes,
+						     tmpblock, SEMIBSIZE, true))
+			goto out;
+
+		/* we now start to operate on the dst buffers only */
+		crypto_kw_copy_scatterlist(req->dst, &src);
+		crypto_kw_copy_scatterlist(req->dst, &dst);
+	}
+
+	if (req->iv)
+		ret = crypto_memneq(block.A, req->iv, SEMIBSIZE);
+	else
+		ret = crypto_memneq(block.A, default_iv, SEMIBSIZE);
+
+	if (ret)
+		ret = -EBADMSG;
+	else
+		ret = 0;
+out:
+	memzero_explicit(&block, sizeof(struct crypto_kw_block));
+	memzero_explicit(tmpblock, sizeof(tmpblock));
+
+	return ret;
+}
+
+static int crypto_kw_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_kw_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_cipher *tfm = ctx->child;
+	unsigned long alignmask = crypto_cipher_alignmask(tfm);
+	unsigned int src_nbytes, dst_nbytes, i;
+	struct scatter_walk src_walk, dst_walk;
+	struct crypto_kw_block block;
+	u8 tmpblock[SEMIBSIZE];
+	u64 t = 1;
+	struct scatterlist src, dst;
+	/* IV of KW defined by section 6.2 */
+	u8 *default_iv = "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6";
+	int ret = -EAGAIN;
+
+	/*
+	 * Require at least 2 semiblocks (note, the 3rd semiblock that is
+	 * required by SP800-38F is the IV that occupies the first semiblock.
+	 * This means that the dst memory must be one semiblock larger than src.
+	 * Also ensure that the given data is aligned to semiblock.
+	 */
+	if (req->cryptlen < (2 * SEMIBSIZE) || req->cryptlen % 8)
+		return -EINVAL;
+
+	if (req->iv)
+		memcpy(&block.A, req->iv, SEMIBSIZE);
+	else
+		memcpy(&block.A, default_iv, SEMIBSIZE);
+
+	/*
+	 * src scatterlist is read only. dst scatterlist is r/w. During the
+	 * first loop, src points to req->src and dst to req->dst. For any
+	 * subsequent round, the code operates on req->dst only.
+	 */
+	crypto_kw_copy_scatterlist(req->src, &src);
+	crypto_kw_copy_scatterlist(req->dst, &dst);
+
+	for (i = 0; i < 6; i++) {
+		u8 tbe_buffer[SEMIBSIZE + alignmask];
+		u8 *tbe = PTR_ALIGN(tbe_buffer + 0, alignmask + 1);
+		bool first_loop = true;
+
+		scatterwalk_start(&src_walk, &src);
+		scatterwalk_start(&dst_walk, &dst);
+
+		/*
+		 * In the first round, we do not need to advance the buffer
+		 * as our first buffer is the IV copied in place above already
+		 * and we start picking up the first block from the plaintext.
+		 *
+		 * In subsequent rounds, the first semiblock is empty and
+		 * reserved for the last block.A.
+		 */
+		if (i) {
+			if (!crypto_kw_scatterwalk_find(&src_walk, SEMIBSIZE))
+				goto out;
+			scatterwalk_advance(&src_walk, SEMIBSIZE);
+		}
+		src_nbytes = req->cryptlen;
+
+		/* Advance the buffer to leave the first semiblock untouched. */
+		if (!crypto_kw_scatterwalk_find(&dst_walk, SEMIBSIZE))
+			goto out;
+		scatterwalk_advance(&dst_walk, SEMIBSIZE);
+		dst_nbytes = req->cryptlen;
+
+		while (src_nbytes) {
+			if (!crypto_kw_scatterwalk_memcpy(&src_walk,
+				&src_nbytes, block.R, SEMIBSIZE, false))
+				goto out;
+			crypto_cipher_encrypt_one(tfm, (u8*)&block,
+						  (u8*)&block);
+			crypto_kw_cpu_to_be64(t, tbe);
+			crypto_xor(block.A, tbe, SEMIBSIZE);
+			t++;
+			if (!first_loop) {
+				/*
+				 * Copy block.R from last round into
+				 * place.
+				 */
+				if (!crypto_kw_scatterwalk_memcpy(&dst_walk,
+					&dst_nbytes, tmpblock, SEMIBSIZE, true))
+						goto out;
+			} else {
+				first_loop = false;
+			}
+
+			/*
+			 * Store current block.R in temp buffer to
+			 * copy it in place in the next round.
+			 */
+			memcpy(&tmpblock, block.R, SEMIBSIZE);
+		}
+
+		/* process the final block.R */
+		if (!crypto_kw_scatterwalk_memcpy(&dst_walk, &dst_nbytes,
+						  tmpblock, SEMIBSIZE, true))
+			goto out;
+
+		/* we now start to operate on the dst buffers only */
+		crypto_kw_copy_scatterlist(req->dst, &src);
+		crypto_kw_copy_scatterlist(req->dst, &dst);
+	}
+
+	scatterwalk_start(&dst_walk, &dst);
+	dst_nbytes = req->cryptlen + SEMIBSIZE;
+	/* establish the first semiblock of ciphertext */
+	crypto_kw_scatterwalk_memcpy(&dst_walk, &dst_nbytes, block.A,
+					  SEMIBSIZE, true);
+
+	ret = 0;
+out:
+	memzero_explicit(&block, sizeof(struct crypto_kw_block));
+	memzero_explicit(tmpblock, sizeof(tmpblock));
+	return ret;
+}
+
+static int crypto_kw_setkey(struct crypto_aead *aead, const u8 *key,
+				 unsigned int keylen)
+{
+	struct crypto_kw_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_cipher *child = ctx->child;
+	int err;
+
+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(child, crypto_aead_get_flags(aead) &
+				       CRYPTO_TFM_REQ_MASK);
+	err = crypto_cipher_setkey(child, key, keylen);
+	crypto_aead_set_flags(aead, crypto_cipher_get_flags(child) &
+				     CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int crypto_kw_setauthsize(struct crypto_aead *tfm,
+				      unsigned int authsize)
+{
+	if (authsize == SEMIBSIZE)
+		return 0;
+	return -EINVAL;
+}
+
+
+static int crypto_kw_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_cipher *cipher;
+
+	cipher = crypto_spawn_cipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+
+	tfm->crt_aead.reqsize = 0;
+
+	return 0;
+}
+
+static void crypto_kw_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_cipher(ctx->child);
+}
+
+static struct crypto_instance *crypto_kw_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst = NULL;
+	struct crypto_alg *alg = NULL;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(alg))
+		return ERR_CAST(alg);
+
+	inst = ERR_PTR(-EINVAL);
+	/* Section 5.1 requirement for KW and KWP */
+	if (alg->cra_blocksize != 2 * SEMIBSIZE)
+		goto err;
+
+	inst = crypto_alloc_instance("kw", alg);
+	if (IS_ERR(inst))
+		goto err;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = SEMIBSIZE;
+
+	/* We access the data in semiblocks. */
+	BUILD_BUG_ON(sizeof(u64) != SEMIBSIZE);
+	inst->alg.cra_alignmask = alg->cra_alignmask | (__alignof__(u64) - 1);
+
+	inst->alg.cra_type = &crypto_aead_type;
+
+	inst->alg.cra_aead.ivsize = SEMIBSIZE;
+	inst->alg.cra_aead.maxauthsize = SEMIBSIZE;
+
+	inst->alg.cra_ctxsize = sizeof(struct crypto_kw_ctx);
+
+	inst->alg.cra_init = crypto_kw_init_tfm;
+	inst->alg.cra_exit = crypto_kw_exit_tfm;
+
+	inst->alg.cra_aead.setkey = crypto_kw_setkey;
+	inst->alg.cra_aead.setauthsize = crypto_kw_setauthsize;
+	inst->alg.cra_aead.encrypt = crypto_kw_encrypt;
+	inst->alg.cra_aead.decrypt = crypto_kw_decrypt;
+
+err:
+	crypto_mod_put(alg);
+	return inst;
+}
+
+static void crypto_kw_free(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+
+static struct crypto_template crypto_kw_tmpl = {
+	.name = "kw",
+	.alloc = crypto_kw_alloc,
+	.free = crypto_kw_free,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_kw_init(void)
+{
+	return crypto_register_template(&crypto_kw_tmpl);
+}
+
+static void __exit crypto_kw_exit(void)
+{
+	crypto_unregister_template(&crypto_kw_tmpl);
+}
+
+module_init(crypto_kw_init);
+module_exit(crypto_kw_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Key Wrapping (RFC3394 / NIST SP800-38F)");
+MODULE_ALIAS_CRYPTO("kw");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f9bce3d..eaaebc9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3095,6 +3095,22 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "kw(aes)",
+		.test = alg_test_aead,
+		.fips_allowed = 1,
+		.suite = {
+			.aead = {
+				.enc = {
+					.vecs = aes_kw_enc_tv_template,
+					.count = ARRAY_SIZE(aes_kw_enc_tv_template)
+				},
+				.dec = {
+					.vecs = aes_kw_dec_tv_template,
+					.count = ARRAY_SIZE(aes_kw_dec_tv_template)
+				}
+			}
+		}
+	}, {
 		.alg = "lrw(aes)",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 62e2485..d952e19 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -20704,6 +20704,44 @@ static struct aead_testvec aes_ccm_rfc4309_dec_tv_template[] = {
 };
 
 /*
+ * All key wrapping test vectors taken from
+ * http://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
+ */
+static struct aead_testvec aes_kw_enc_tv_template[] = {
+	{
+		.key	= "\x75\x75\xda\x3a\x93\x60\x7c\xc2"
+			  "\xbf\xd8\xce\xc7\xaa\xdf\xd9\xa6",
+		.klen	= 16,
+		.input	= "\x42\x13\x6d\x3c\x38\x4a\x3e\xea"
+			  "\xc9\x5a\x06\x6f\xd2\x8f\xed\x3f",
+		.ilen	= 16,
+		.result	= "\x03\x1f\x6b\xd7\xe6\x1e\x64\x3d\xf6\x85\x94\x81"
+			  "\x6f\x64\xca\xa3\xf5\x6f\xab\xea\x25\x48\xf5\xfb",
+		.rlen	= 24,
+		/* default IV as the testmgr uses a NULL IV otherwise */
+		.iv	= "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6",
+	},
+};
+
+static struct aead_testvec aes_kw_dec_tv_template[] = {
+	{
+		.key	= "\x80\xaa\x99\x73\x27\xa4\x80\x6b"
+			  "\x6a\x7a\x41\xa5\x2b\x86\xc3\x71"
+			  "\x03\x86\xf9\x32\x78\x6e\xf7\x96"
+			  "\x76\xfa\xfb\x90\xb8\x26\x3c\x5f",
+		.klen	= 32,
+		.input	= "\x42\x3c\x96\x0d\x8a\x2a\xc4\xc1\xd3\x3d\x3d\x97"
+			  "\x7b\xf0\xa9\x15\x59\xf9\x9c\x8a\xcd\x29\x3d\x43",
+		.ilen	= 24,
+		.result	= "\x0a\x25\x6b\xa7\x5c\xfa\x03\xaa"
+			  "\xa0\x2b\xa9\x42\x03\xf1\x5b\xaa",
+		.rlen	= 16,
+		/* default IV as the testmgr uses a NULL IV otherwise */
+		.iv	= "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6",
+	},
+};
+
+/*
  * ANSI X9.31 Continuous Pseudo-Random Number Generator (AES mode)
  * test vectors, taken from Appendix B.2.9 and B.2.10:
  *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
-- 
2.1.0
