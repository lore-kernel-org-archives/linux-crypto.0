From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Mon, 27 Apr 2015 16:29:35 +0800
Message-ID: <20150427082935.GA21691@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <3407264.GJDOVGtEDe@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55612 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbbD0I3l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 04:29:41 -0400
Content-Disposition: inline
In-Reply-To: <3407264.GJDOVGtEDe@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 26, 2015 at 12:08:20AM +0200, Stephan Mueller wrote:
> This patch implements the AES key wrapping as specified in
> NIST SP800-38F and RFC3394.

This is my attempt at turning kw into a givcipher.  The encrypt
part is complete but untested as I gave up after finding the
reverse SG problem with your decrypt code.

/*
 * Key Wrapping: RFC3394 / NIST SP800-38F
 *
 * Implemented modes as defined in NIST SP800-38F: Kw
 *
 * Copyright (C) 2015, Stephan Mueller <smueller@chronox.de>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, and the entire permission notice in its entirety,
 *    including the disclaimer of warranties.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior
 *    written permission.
 *
 * ALTERNATIVELY, this product may be distributed under the terms of
 * the GNU General Public License, in which case the provisions of the GPL2
 * are required INSTEAD OF the above restrictions.  (This clause is
 * necessary due to a potential bad interaction between the GPL and
 * the restrictions contained in a BSD-style copyright.)
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
 * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

/*
 * Note for using key wrapping:
 *
 *	* The result of the encryption operation is the ciphertext starting
 *	  with the 2nd semiblock. The first semiblock is provided as the IV.
 *	  The IV uses to start the encryption operation is the default IV.
 *
 *	* The input for the decryption is the first semiblock handed in as an
 *	  IV. The ciphertext is the data starting with the 2nd semiblock. The
 *	  return code of the decryption operation will be EBADMSG in case an
 *	  integrity error occurs.
 *
 * To obtain the full result of an encryption as expected by SP800-38F, the
 * caller must allocate a buffer of plaintext + 8 bytes:
 *
 *	unsigned int datalen = ptlen + crypto_ablkcipher_ivsize(tfm);
 *	u8 data[datalen];
 *	u8 *iv = data;
 *	u8 *pt = data + crypto_ablkcipher_ivsize(tfm);
 *		<ensure that pt contains the plaintext of size ptlen>
 *	sg_init_one(&sg, ptdata, ptlen);
 *	ablkcipher_request_set_crypt(req, &sg, &sg, ptlen, iv);
 *
 *	==> After encryption, data now contains full KW result as per SP800-38F.
 *
 * In case of decryption, ciphertext now already has the expected length
 * and must be segmented appropriately:
 *
 *	unsigned int datalen = CTLEN;
 *	u8 data[datalen];
 *		<ensure that data contains full ciphertext>
 *	u8 *iv = data;
 *	u8 *ct = data + crypto_ablkcipher_ivsize(tfm);
 *	unsigned int ctlen = datalen - crypto_ablkcipher_ivsize(tfm);
 *	sg_init_one(&sg, ctdata, ctlen);
 *	ablkcipher_request_set_crypt(req, &sg, &sg, ptlen, iv);
 *
 *	==> After decryption (which hopefully does not return EBADMSG), the ct
 *	pointer now points to the plaintext of size ctlen.
 */

#include <crypto/internal/skcipher.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

struct crypto_kw_ctx {
	struct crypto_cipher *child;
};

struct crypto_rfc3394_ctx {
	struct crypto_ablkcipher *child;
};

struct crypto_kw_block {
#define SEMIBSIZE sizeof(be64)
	union {
		struct {
			be64 A;
			be64 R;
		};
		u8 V[];
	};
};

/* convert 64 bit integer into its string representation */
static inline void crypto_kw_cpu_to_be64(u64 val, u8 *buf)
{
	struct s {
		__be64 conv;
	};
	struct s *conversion = (struct s *) buf;

	conversion->conv = cpu_to_be64(val);
}

static inline void crypto_kw_copy_scatterlist(struct scatterlist *src,
					      struct scatterlist *dst)
{
	memcpy(dst, src, sizeof(struct scatterlist));
}

/* find the next memory block in scatter_walk of given size */
static inline bool crypto_kw_scatterwalk_find(struct scatter_walk *walk,
					      unsigned int size)
{
	int n = scatterwalk_clamp(walk, size);

	if (!n) {
		scatterwalk_start(walk, sg_next(walk->sg));
		n = scatterwalk_clamp(walk, size);
	}
	if (n != size)
		return false;
	return true;
}

/*
 * Copy out the memory block from or to scatter_walk of requested size
 * before the walk->offset pointer. The scatter_walk is processed in reverse.
 */
static bool crypto_kw_scatterwalk_memcpy_rev(struct scatter_walk *walk,
					     unsigned int *walklen,
					     u8 *buf, unsigned int bufsize,
					     bool out)
{
	u8 *ptr = NULL;

	walk->offset -= bufsize;
	if (!crypto_kw_scatterwalk_find(walk, bufsize))
		return false;

	ptr = scatterwalk_map(walk);
	if (out)
		memcpy(ptr, buf, bufsize);
	else
		memcpy(buf, ptr, bufsize);
	*walklen -= bufsize;
	scatterwalk_unmap(ptr);
	scatterwalk_done(walk, 0, *walklen);

	return true;
}

/*
 * Copy the memory block from or to scatter_walk of requested size
 * at the walk->offset pointer. The scatter_walk is processed forward.
 */
static bool crypto_kw_scatterwalk_memcpy(struct scatter_walk *walk,
					 unsigned int *walklen,
					 u8 *buf, unsigned int bufsize,
					 bool out)
{
	u8 *ptr = NULL;

	if (!crypto_kw_scatterwalk_find(walk, bufsize))
		return false;

	ptr = scatterwalk_map(walk);
	if (out)
		memcpy(ptr, buf, bufsize);
	else
		memcpy(buf, ptr, bufsize);
	*walklen -= bufsize;
	scatterwalk_unmap(ptr);
	scatterwalk_advance(walk, bufsize);
	scatterwalk_done(walk, 0, *walklen);

	return true;
}

static int crypto_kw_decrypt(struct ablkcipher_request *req)
{
	struct scatterlist *src = req->src;
	struct scatterlist *dst = req->dst;
	unsigned int nbytes = req->nbytes;
	struct crypto_ablkcipher *tfm = crypto_ablkcipher_tfm(req);
	struct crypto_kw_ctx *ctx = crypto_ablkcipher_ctx(tfm);
	struct crypto_cipher *child = ctx->child;

	unsigned long alignmask = crypto_cipher_alignmask(child) | 7;
	unsigned int i;
	struct blkcipher_walk walk;

	u8 blockbuf[sizeof(struct crypto_kw_block) + alignmask];
	struct crypto_kw_block *block = (struct crypto_kw_block *)
					PTR_ALIGN(blockbuf + 0, alignmask + 1);

	u64 t = 6 * ((nbytes) >> 3);
	int ret;

	/*
	 * Require at least 2 semiblocks (note, the 3rd semiblock that is
	 * required by SP800-38F is the IV.
	 */
	if (nbytes < (2 * SEMIBSIZE) || nbytes % SEMIBSIZE)
		return -EINVAL;
	/*
	 * src scatterlist is read only. dst scatterlist is r/w. During the
	 * first loop, src points to req->src and dst to req->dst. For any
	 * subsequent round, the code operates on req->dst only.
	 */

	for (i = 0; i < 6; i++) {
		be64 tbe;

		blkcipher_walk_init(&walk, dst, src, nbytes);
		ret = blkcipher_walk_virt_ablkcipher(req, &walk);
		if (ret)
			goto out;

		/*
		 * Point to the end of the scatterlists to walk them backwards.
		 */
		src_walk.offset += src_nbytes;
		dst_walk.offset += dst_nbytes;

		while (src_nbytes) {
			if (!crypto_kw_scatterwalk_memcpy_rev(&src_walk,
				&src_nbytes, block->R, SEMIBSIZE, false))
				goto out;
			crypto_kw_cpu_to_be64(t, tbe);
			crypto_xor(block->A, tbe, SEMIBSIZE);
			t--;
			crypto_cipher_decrypt_one(child, (u8*)block,
						  (u8*)block);
			if (!first_loop) {
				/*
				 * Copy block->R from last round into
				 * place.
				 */
				if (!crypto_kw_scatterwalk_memcpy_rev(&dst_walk,
					&dst_nbytes, tmpblock, SEMIBSIZE, true))
						goto out;
			} else {
				first_loop = false;
			}

			/*
			 * Store current block->R in temp buffer to
			 * copy it in place in the next round.
			 */
			memcpy(&tmpblock, block->R, SEMIBSIZE);
		}

		/* process the final block->R */
		if (!crypto_kw_scatterwalk_memcpy_rev(&dst_walk, &dst_nbytes,
			tmpblock, SEMIBSIZE, true))
			goto out;

		/* we now start to operate on the dst buffers only */
		crypto_kw_copy_scatterlist(dst, &lsrc);
		crypto_kw_copy_scatterlist(dst, &ldst);
	}

	if (crypto_memneq("\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6", block->A,
			   SEMIBSIZE))
		ret = -EBADMSG;

out:
	memzero_explicit(&block, sizeof(struct crypto_kw_block));
	memzero_explicit(tmpblock, sizeof(tmpblock));

	return ret;
}

static int crypto_kw_encrypt(struct ablkcipher_request *req)
{
	struct scatterlist *src = req->src;
	struct scatterlist *dst = req->dst;
	unsigned int nbytes = req->nbytes;
	struct crypto_ablkcipher *tfm = crypto_ablkcipher_tfm(req);
	struct crypto_kw_ctx *ctx = crypto_ablkcipher_ctx(tfm);
	struct crypto_cipher *child = ctx->child;

	unsigned long alignmask = crypto_cipher_alignmask(child) | 7;
	unsigned int i;
	struct blkcipher_walk walk;

	u8 blockbuf[sizeof(struct crypto_kw_block) + alignmask];
	struct crypto_kw_block *block = (struct crypto_kw_block *)
					PTR_ALIGN(blockbuf + 0, alignmask + 1);

	u64 t = 1;
	int ret;

	/*
	 * Require at least 2 semiblocks (note, the 3rd semiblock that is
	 * required by SP800-38F is the IV that occupies the first semiblock.
	 * This means that the dst memory must be one semiblock larger than src.
	 * Also ensure that the given data is aligned to semiblock.
	 */
	if (nbytes < (2 * SEMIBSIZE) || nbytes % SEMIBSIZE)
		return -EINVAL;

	/*
	 * src scatterlist is read only. dst scatterlist is r/w. During the
	 * first loop, src points to req->src and dst to req->dst. For any
	 * subsequent round, the code operates on req->dst only.
	 */

	for (i = 0; i < 6; i++) {
		be64 tbe;

		blkcipher_walk_init(&walk, dst, src, nbytes);
		ret = blkcipher_walk_virt_ablkcipher(req, &walk);
		if (ret)
			goto out;

		while (walk.nbytes) {
			unsigned int leftover = walk.nbytes;
			be64 *vsrc = (be64 *)walk->src.virt.addr;

			block->A = *(be64 *)walk->iv;

			do {
				block->R = *vsrc++;
				crypto_cipher_encrypt_one(child, block->V,
							  block->V);
				*vdst++ = block->R;

				tbe = cpu_to_be64(t++);
				crypto_xor(block->A, tbe, SEMIBSIZE);
			} while ((leftover -= SEMIBSIZE) >= bsize);

			*(be64 *)walk->iv = block->A;

			ret = blkcipher_walk_done(desc, &walk, nbytes);
			if (ret)
				goto out;
		}

		/* we now start to operate on the dst buffers only */
		dst = src;
	}

	ret = 0;
out:
	memzero_explicit(&block, sizeof(struct crypto_kw_block));
	return ret;
}

static int crypto_kw_givencrypt(struct skcipher_givcrypt_request *req)
{
	memcpy(req->giv, "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6", SEMIBSIZE);
	memcpy(req->creq.info, req->giv, SEMIBSIZE);

	return crypto_kw_encrypt(&req->creq);
}

static int crypto_kw_givdecrypt(struct skcipher_givcrypt_request *req)
{
	int err = crypto_kw_decrypt(&req->creq);

	if (err)
		return err;

	return memcmp(req->creq.info, "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6",
		      SEMIBSIZE) ? -EBADMSG : 0;
}

static int crypto_kw_setkey(struct crypto_tfm *parent, const u8 *key,
			    unsigned int keylen)
{
	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(parent);
	struct crypto_cipher *child = ctx->child;
	int err;

	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
				       CRYPTO_TFM_REQ_MASK);
	err = crypto_cipher_setkey(child, key, keylen);
	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
				     CRYPTO_TFM_RES_MASK);
	return err;
}

static int crypto_kw_init_tfm(struct crypto_tfm *tfm)
{
	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(tfm);
	struct crypto_cipher *cipher;

	cipher = crypto_spawn_cipher(spawn);
	if (IS_ERR(cipher))
		return PTR_ERR(cipher);

	ctx->child = cipher;
	return 0;
}

static void crypto_kw_exit_tfm(struct crypto_tfm *tfm)
{
	struct crypto_kw_ctx *ctx = crypto_tfm_ctx(tfm);

	crypto_free_cipher(ctx->child);
}

static struct crypto_instance *crypto_kw_alloc(struct rtattr **tb)
{
	struct crypto_instance *inst = NULL;
	struct crypto_alg *alg = NULL;
	int err;

	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_GIVCIPHER |
					 CRYPTO_ALG_GENIV);
	if (err)
		return ERR_PTR(err);

	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
				  CRYPTO_ALG_TYPE_MASK);
	if (IS_ERR(alg))
		return ERR_CAST(alg);

	inst = ERR_PTR(-EINVAL);
	/* Section 5.1 requirement for KW and KWP */
	if (alg->cra_blocksize != 2 * SEMIBSIZE)
		goto err;

	inst = crypto_alloc_instance("kw", alg);
	if (IS_ERR(inst))
		goto err;

	inst->alg.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_GENIV;
	inst->alg.cra_priority = alg->cra_priority;
	inst->alg.cra_blocksize = SEMIBSIZE;
	inst->alg.cra_alignmask = 7;
	inst->alg.cra_type = &crypto_givcipher_type;
	inst->alg.cra_ablkcipher.ivsize = SEMIBSIZE;
	inst->alg.cra_ablkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
	inst->alg.cra_ablkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;

	inst->alg.cra_ctxsize = sizeof(struct crypto_kw_ctx);

	inst->alg.cra_init = crypto_kw_init_tfm;
	inst->alg.cra_exit = crypto_kw_exit_tfm;

	inst->alg.cra_ablkcipher.setkey = crypto_kw_setkey;
	inst->alg.cra_ablkcipher.encrypt = crypto_kw_encrypt;
	inst->alg.cra_ablkcipher.decrypt = crypto_kw_decrypt;
	inst->alg.cra_ablkcipher.givencrypt = crypto_kw_givencrypt;
	inst->alg.cra_ablkcipher.givdecrypt = crypto_kw_givdecrypt;

err:
	crypto_mod_put(alg);
	return inst;
}

static void crypto_kw_free(struct crypto_instance *inst)
{
	crypto_drop_spawn(crypto_instance_ctx(inst));
	kfree(inst);
}

static struct crypto_template crypto_kw_tmpl = {
	.name = "kw",
	.alloc = crypto_kw_alloc,
	.free = crypto_kw_free,
	.module = THIS_MODULE,
};

static int __init crypto_kw_init(void)
{
	return crypto_register_template(&crypto_kw_tmpl);
}

static void __exit crypto_kw_exit(void)
{
	crypto_unregister_template(&crypto_kw_tmpl);
}

module_init(crypto_kw_init);
module_exit(crypto_kw_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
MODULE_DESCRIPTION("Key Wrapping (RFC3394 / NIST SP800-38F)");
MODULE_ALIAS_CRYPTO("kw");

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
