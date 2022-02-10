Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254E9C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 23:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345663AbiBJX2t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:28:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345656AbiBJX2n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 18:28:43 -0500
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F93F116D
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:41 -0800 (PST)
Received: by mail-ua1-x949.google.com with SMTP id a16-20020ab03c90000000b0033c71cc6a2cso3595882uax.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=d9YF2gn6l8jputdnpO3x6JGJt1dtz0Ft//7QQRNUVJE=;
        b=WmyyULPumeHgxc1ERw2+3vLQ75rhVUdGfGLcSVxJrslYBQod71h0STLWsMb5erYCQY
         BgoVelMIu1cwLYWJRUeF+JqoT7uGLg7MacGTAv0VpGMULrkN+FOdYVfb+Kf5mdGOkxIw
         t0dDUQBv0+LFWQLq9vTsvLdiKAdNEIF4UdfE6cn7FYPVbXsYWpR2jw3fyM52ES0YVwku
         IPC2cogx0MCek6WVMtCzX2NXUuvIMcquiyKuE6GDdPELReTIgsaBIK+ZOBr0bpDv3YDA
         ZbC5q/zztpsQCzit+SqFoQcyIEiuiStwa+NomXyyoQbx1Iiw8c5lqM9iSN9lFeVFTSA3
         h/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=d9YF2gn6l8jputdnpO3x6JGJt1dtz0Ft//7QQRNUVJE=;
        b=J7/4EUUTOX0PFUN0aA6IjO+sqPLok6yKk7xGDtONV80yjeWge0/GFRu65HjrvGvAXC
         uQnlucMrlfuhkg/gSpcDizPW/MfMdbR+hztjEi7bqhjqjPl1UoffJJ50Gq6Quw4FxdcY
         +Qo9RxHaBj5BWz92dLyH1G9QKgYa+31OUeyWHxbpADKE/Csp6OsNXn/fL2p0T28UnCBJ
         YwPYWKUjg52EAB+NI6PAy0wbC/ycxQgcIm47OqUSqY4n4OW1jTO4KFzJHvBATR4AP9Ej
         rXHoOuf4AHNzex9rNexc+AbmphvrRw6tnVAF5bcia87uWye2JNf7leI6aPaX2yQo1Mpt
         vCGg==
X-Gm-Message-State: AOAM533vzPp82aeQ2SPpu5oWfHdimydLcuEgMwxiYwAatjsG0GF54xxh
        NCbHyrsZavx7HzDcgXZyP8QvEc+4joZPis2CGuY2zYEy3pfpMOvC00HIXQfdNVerplMRAPeP7bY
        I0ZNqdLbf5Z/2SzkEEQ3/rxjnIqGydkenYLR0AotEls5iypxIOJDjG+sv3mFq5aLHrck=
X-Google-Smtp-Source: ABdhPJzi5wtD/9oQf+cS/3y6gfXtS/2UCdeJ9UiylpldkPk5qgepWuKzhjJHAlUHXHfa3t8+0uuxJQXfvw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a67:cc1b:: with SMTP id q27mr1154352vsl.67.1644535720255;
 Thu, 10 Feb 2022 15:28:40 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:28:08 +0000
In-Reply-To: <20220210232812.798387-1-nhuck@google.com>
Message-Id: <20220210232812.798387-4-nhuck@google.com>
Mime-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC PATCH v2 3/7] crypto: hctr2 - Add HCTR2 support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for HCTR2 as a template.  HCTR2 is a length-preserving
encryption mode that is efficient on processors with instructions to
accelerate AES and carryless multiplication, e.g. x86 processors with
AES-NI and CLMUL, and ARM processors with the ARMv8 Crypto Extensions.

As a length-preserving encryption mode, HCTR2 is suitable for
applications such as storage encryption where ciphertext expansion is
not possible, and thus authenticated encryption cannot be used.
Currently, such applications usually use XTS, or in some cases Adiantum.
XTS has the disadvantage that it is a narrow-block mode: a bitflip will
only change 16 bytes in the resulting ciphertext or plaintext.  This
reveals more information to an attacker than necessary.

HCTR2 is a wide-block mode, so it provides a stronger security property:
a bitflip will change the entire message.  HCTR2 is somewhat similar to
Adiantum, which is also a wide-block mode.  However, HCTR2 is designed
to take advantage of existing crypto instructions, while Adiantum
targets devices without such hardware support.  Adiantum is also
designed with longer messages in mind, while HCTR2 is designed to be
efficient even on short messages.

HCTR2 requires POLYVAL and XCTR as components.  More information on
HCTR2 can be found here: Length-preserving encryption with HCTR2:
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---

Changes since v1:
 * Rename streamcipher -> xctr
 * Rename hash -> polyval
 * Use __le64 instead of u64 for little-endian length
 * memzero_explicit in set_key
 * Use crypto request length instead of scatterlist length for polyval
 * Add comments referencing the paper's pseudocode
 * Derive blockcipher name from xctr name
 * Pass IV through request context
 * Use .generic_driver
 * Make tests more comprehensive

 crypto/Kconfig   |  11 +
 crypto/Makefile  |   1 +
 crypto/hctr2.c   | 532 +++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c  |   5 +
 crypto/testmgr.c |   8 +
 crypto/testmgr.h | 670 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1227 insertions(+)
 create mode 100644 crypto/hctr2.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0c61d03530a6..2a9029f51caf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -524,6 +524,17 @@ config CRYPTO_ADIANTUM
=20
 	  If unsure, say N.
=20
+config CRYPTO_HCTR2
+	tristate "HCTR2 support"
+	select CRYPTO_XCTR
+	select CRYPTO_POLYVAL
+	select CRYPTO_MANAGER
+	help
+	  HCTR2 is a length-preserving encryption mode for storage encryption tha=
t
+	  is efficient on processors with instructions to accelerate AES and
+	  carryless multiplication, e.g. x86 processors with AES-NI and CLMUL, an=
d
+	  ARM processors with the ARMv8 crypto extensions.
+
 config CRYPTO_ESSIV
 	tristate "ESSIV support for block encryption"
 	select CRYPTO_AUTHENC
diff --git a/crypto/Makefile b/crypto/Makefile
index 561f901a91d4..2dca9dbdede6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_CRYPTO_LRW) +=3D lrw.o
 obj-$(CONFIG_CRYPTO_XTS) +=3D xts.o
 obj-$(CONFIG_CRYPTO_CTR) +=3D ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) +=3D xctr.o
+obj-$(CONFIG_CRYPTO_HCTR2) +=3D hctr2.o
 obj-$(CONFIG_CRYPTO_KEYWRAP) +=3D keywrap.o
 obj-$(CONFIG_CRYPTO_ADIANTUM) +=3D adiantum.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305) +=3D nhpoly1305.o
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
new file mode 100644
index 000000000000..6ccc2a2f9038
--- /dev/null
+++ b/crypto/hctr2.c
@@ -0,0 +1,532 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * HCTR2 length-preserving encryption mode
+ *
+ * Copyright 2021 Google LLC
+ */
+
+
+/*
+ * HCTR2 is a length-preserving encryption mode that is efficient on
+ * processors with instructions to accelerate aes and carryless
+ * multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
+ * processors with the ARMv8 crypto extensions.
+ *
+ * For more details, see the paper: Length-preserving encryption with HCTR=
2
+ * (https://eprint.iacr.org/2021/1441.pdf)
+ */
+
+#include <crypto/internal/cipher.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/polyval.h>
+#include <crypto/scatterwalk.h>
+#include <linux/module.h>
+
+#define BLOCKCIPHER_BLOCK_SIZE		16
+
+/*
+ * The specification allows variable-length tweaks, but Linux's crypto API
+ * currently only allows algorithms to support a single length.  The "natu=
ral"
+ * tweak length for HCTR2 is 16, since that fits into one POLYVAL block fo=
r
+ * the best performance.  But longer tweaks are useful for fscrypt, to avo=
id
+ * needing to derive per-file keys.  So instead we use two blocks, or 32 b=
ytes.
+ */
+#define TWEAK_SIZE		32
+
+struct hctr2_instance_ctx {
+	struct crypto_cipher_spawn blockcipher_spawn;
+	struct crypto_skcipher_spawn xctr_spawn;
+	struct crypto_shash_spawn polyval_spawn;
+};
+
+struct hctr2_tfm_ctx {
+	struct crypto_cipher *blockcipher;
+	struct crypto_skcipher *xctr;
+	struct crypto_shash *polyval;
+	u8 L[BLOCKCIPHER_BLOCK_SIZE];
+};
+
+struct hctr2_request_ctx {
+	u8 first_block[BLOCKCIPHER_BLOCK_SIZE];
+	u8 xctr_iv[BLOCKCIPHER_BLOCK_SIZE];
+	struct scatterlist *bulk_part_dst;
+	struct scatterlist *bulk_part_src;
+	struct scatterlist sg_src[2];
+	struct scatterlist sg_dst[2];
+	/* Sub-requests, must be last */
+	union {
+		struct shash_desc hash_desc;
+		struct skcipher_request xctr_req;
+	} u;
+};
+
+static int hctr2_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	u8 hbar[BLOCKCIPHER_BLOCK_SIZE];
+	int err;
+
+	crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(tctx->blockcipher,
+				crypto_skcipher_get_flags(tfm) &
+				CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_cipher_setkey(tctx->blockcipher, key, keylen);
+	if (err)
+		return err;
+
+	crypto_skcipher_clear_flags(tctx->xctr, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(tctx->xctr,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_skcipher_setkey(tctx->xctr, key, keylen);
+	if (err)
+		return err;
+
+	memset(tctx->L, 0, sizeof(tctx->L));
+	memset(hbar, 0, sizeof(hbar));
+	tctx->L[0] =3D 0x01;
+	crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);
+	crypto_cipher_encrypt_one(tctx->blockcipher, hbar, hbar);
+
+	crypto_shash_clear_flags(tctx->polyval, CRYPTO_TFM_REQ_MASK);
+	crypto_shash_set_flags(tctx->polyval, crypto_skcipher_get_flags(tfm) &
+			       CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_shash_setkey(tctx->polyval, hbar, BLOCKCIPHER_BLOCK_SIZE);
+	memzero_explicit(hbar, sizeof(hbar));
+	return err;
+}
+
+static int hctr2_hash_tweak(struct skcipher_request *req)
+{
+	__le64 tweak_length_block[2];
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
+	const struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	struct shash_desc *hash_desc =3D &rctx->u.hash_desc;
+	int err;
+
+	memset(tweak_length_block, 0, sizeof(tweak_length_block));
+	if (req->cryptlen % POLYVAL_BLOCK_SIZE =3D=3D 0)
+		tweak_length_block[0] =3D cpu_to_le64(TWEAK_SIZE * 8 * 2 + 2);
+	else
+		tweak_length_block[0] =3D cpu_to_le64(TWEAK_SIZE * 8 * 2 + 3);
+
+	hash_desc->tfm =3D tctx->polyval;
+	err =3D crypto_shash_init(hash_desc);
+	if (err)
+		return err;
+
+	err =3D crypto_shash_update(hash_desc, (u8 *)tweak_length_block,
+				  sizeof(tweak_length_block));
+	if (err)
+		return err;
+	return crypto_shash_update(hash_desc, req->iv, TWEAK_SIZE);
+}
+
+static int hctr2_hash_message(struct skcipher_request *req,
+			      struct scatterlist *sgl,
+			      u8 digest[POLYVAL_DIGEST_SIZE])
+{
+	u8 padding[BLOCKCIPHER_BLOCK_SIZE];
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	struct shash_desc *hash_desc =3D &rctx->u.hash_desc;
+	const unsigned int bulk_len =3D req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	struct sg_mapping_iter miter;
+	unsigned int remainder =3D bulk_len % BLOCKCIPHER_BLOCK_SIZE;
+	int err, i;
+	int n =3D 0;
+
+	sg_miter_start(&miter, sgl, sg_nents(sgl),
+		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+	for (i =3D 0; i < bulk_len; i +=3D n) {
+		sg_miter_next(&miter);
+		n =3D min_t(unsigned int, miter.length, bulk_len - i);
+		err =3D crypto_shash_update(hash_desc, miter.addr, n);
+		if (err)
+			break;
+	}
+	sg_miter_stop(&miter);
+
+	if (err)
+		return err;
+
+	if (remainder) {
+		memset(padding, 0, BLOCKCIPHER_BLOCK_SIZE);
+		padding[0] =3D 0x01;
+		err =3D crypto_shash_update(hash_desc, padding,
+					  BLOCKCIPHER_BLOCK_SIZE - remainder);
+		if (err)
+			return err;
+	}
+	return crypto_shash_final(hash_desc, digest);
+}
+
+static int hctr2_finish(struct skcipher_request *req)
+{
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	u8 digest[POLYVAL_DIGEST_SIZE];
+	int err;
+
+	// U =3D UU ^ H(T || V)
+	err =3D hctr2_hash_tweak(req);
+	if (err)
+		return err;
+	err =3D hctr2_hash_message(req, rctx->bulk_part_dst, digest);
+	if (err)
+		return err;
+	crypto_xor(rctx->first_block, digest, BLOCKCIPHER_BLOCK_SIZE);
+
+	// Copy U into dst scatterlist
+	scatterwalk_map_and_copy(rctx->first_block, req->dst,
+				 0, BLOCKCIPHER_BLOCK_SIZE, 1);
+	return 0;
+}
+
+static void hctr2_xctr_done(struct crypto_async_request *areq,
+				    int err)
+{
+	struct skcipher_request *req =3D areq->data;
+
+	if (!err)
+		err =3D hctr2_finish(req);
+
+	skcipher_request_complete(req, err);
+}
+
+static int hctr2_crypt(struct skcipher_request *req, bool enc)
+{
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
+	const struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	u8 digest[POLYVAL_DIGEST_SIZE];
+	int bulk_len =3D req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	int err;
+
+	// Requests must be at least one block
+	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
+		return -EINVAL;
+
+	// Copy M into a temporary buffer
+	scatterwalk_map_and_copy(rctx->first_block, req->src,
+				 0, BLOCKCIPHER_BLOCK_SIZE, 0);
+
+	// Create scatterlists for N and V
+	rctx->bulk_part_src =3D scatterwalk_ffwd(rctx->sg_src, req->src,
+					       BLOCKCIPHER_BLOCK_SIZE);
+	rctx->bulk_part_dst =3D scatterwalk_ffwd(rctx->sg_dst, req->dst,
+					       BLOCKCIPHER_BLOCK_SIZE);
+
+	// MM =3D M ^ H(T || N)
+	err =3D hctr2_hash_tweak(req);
+	if (err)
+		return err;
+	err =3D hctr2_hash_message(req, rctx->bulk_part_src, digest);
+	if (err)
+		return err;
+	crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
+
+	// UU =3D E(MM)
+	if (enc)
+		crypto_cipher_encrypt_one(tctx->blockcipher, rctx->first_block,
+					  digest);
+	else
+		crypto_cipher_decrypt_one(tctx->blockcipher, rctx->first_block,
+					  digest);
+
+	// S =3D MM ^ UU ^ L
+	crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
+	crypto_xor_cpy(rctx->xctr_iv, digest, tctx->L, BLOCKCIPHER_BLOCK_SIZE);
+
+	// V =3D XCTR(S, N)
+	skcipher_request_set_tfm(&rctx->u.xctr_req, tctx->xctr);
+	skcipher_request_set_crypt(&rctx->u.xctr_req, rctx->bulk_part_src,
+				   rctx->bulk_part_dst, bulk_len,
+				   rctx->xctr_iv);
+	skcipher_request_set_callback(&rctx->u.xctr_req,
+				      req->base.flags,
+				      hctr2_xctr_done, req);
+	return crypto_skcipher_encrypt(&rctx->u.xctr_req) ?:
+		hctr2_finish(req);
+}
+
+static int hctr2_encrypt(struct skcipher_request *req)
+{
+	return hctr2_crypt(req, true);
+}
+
+static int hctr2_decrypt(struct skcipher_request *req)
+{
+	return hctr2_crypt(req, false);
+}
+
+static int hctr2_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst =3D skcipher_alg_instance(tfm);
+	struct hctr2_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
+	struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *xctr;
+	struct crypto_cipher *blockcipher;
+	struct crypto_shash *polyval;
+	unsigned int subreq_size;
+	int err;
+
+	xctr =3D crypto_spawn_skcipher(&ictx->xctr_spawn);
+	if (IS_ERR(xctr))
+		return PTR_ERR(xctr);
+
+	blockcipher =3D crypto_spawn_cipher(&ictx->blockcipher_spawn);
+	if (IS_ERR(blockcipher)) {
+		err =3D PTR_ERR(blockcipher);
+		goto err_free_xctr;
+	}
+
+	polyval =3D crypto_spawn_shash(&ictx->polyval_spawn);
+	if (IS_ERR(polyval)) {
+		err =3D PTR_ERR(polyval);
+		goto err_free_blockcipher;
+	}
+
+	tctx->xctr =3D xctr;
+	tctx->blockcipher =3D blockcipher;
+	tctx->polyval =3D polyval;
+
+	BUILD_BUG_ON(offsetofend(struct hctr2_request_ctx, u) !=3D
+				 sizeof(struct hctr2_request_ctx));
+	subreq_size =3D max(sizeof_field(struct hctr2_request_ctx, u.hash_desc) +
+			  crypto_shash_descsize(polyval), sizeof_field(struct
+			  hctr2_request_ctx, u.xctr_req) +
+			  crypto_skcipher_reqsize(xctr));
+
+	crypto_skcipher_set_reqsize(tfm, offsetof(struct hctr2_request_ctx, u) +
+				    subreq_size);
+	return 0;
+
+err_free_blockcipher:
+	crypto_free_cipher(blockcipher);
+err_free_xctr:
+	crypto_free_skcipher(xctr);
+	return err;
+}
+
+static void hctr2_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+
+	crypto_free_cipher(tctx->blockcipher);
+	crypto_free_skcipher(tctx->xctr);
+	crypto_free_shash(tctx->polyval);
+}
+
+static void hctr2_free_instance(struct skcipher_instance *inst)
+{
+	struct hctr2_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
+
+	crypto_drop_cipher(&ictx->blockcipher_spawn);
+	crypto_drop_skcipher(&ictx->xctr_spawn);
+	crypto_drop_shash(&ictx->polyval_spawn);
+	kfree(inst);
+}
+
+/*
+ * Check for a supported set of inner algorithms.
+ * See the comment at the beginning of this file.
+ */
+static bool hctr2_supported_algorithms(struct skcipher_alg *xctr_alg,
+				       struct crypto_alg *blockcipher_alg,
+				       struct shash_alg *polyval_alg)
+{
+	if (strncmp(xctr_alg->base.cra_name, "xctr(", 4) !=3D 0)
+		return false;
+
+	if (blockcipher_alg->cra_blocksize !=3D BLOCKCIPHER_BLOCK_SIZE)
+		return false;
+
+	if (strcmp(polyval_alg->base.cra_name, "polyval") !=3D 0)
+		return false;
+
+	return true;
+}
+
+static int hctr2_create_common(struct crypto_template *tmpl,
+			       struct rtattr **tb,
+			       const char *blockcipher_name,
+			       const char *xctr_name,
+			       const char *polyval_name)
+{
+	u32 mask;
+	struct skcipher_instance *inst;
+	struct hctr2_instance_ctx *ictx;
+	struct skcipher_alg *xctr_alg;
+	struct crypto_alg *blockcipher_alg;
+	struct shash_alg *polyval_alg;
+	int err;
+
+	err =3D crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
+
+	inst =3D kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	ictx =3D skcipher_instance_ctx(inst);
+
+	/* Stream cipher, xctr(block_cipher) */
+	err =3D crypto_grab_skcipher(&ictx->xctr_spawn,
+				   skcipher_crypto_instance(inst),
+				   xctr_name, 0, mask);
+	if (err)
+		goto err_free_inst;
+	xctr_alg =3D crypto_spawn_skcipher_alg(&ictx->xctr_spawn);
+
+	/* Block cipher, e.g. "aes" */
+	err =3D crypto_grab_cipher(&ictx->blockcipher_spawn,
+				 skcipher_crypto_instance(inst),
+				 blockcipher_name, 0, mask);
+	if (err)
+		goto err_free_inst;
+	blockcipher_alg =3D crypto_spawn_cipher_alg(&ictx->blockcipher_spawn);
+
+	/* Polyval =CE=B5-=E2=88=86U hash function */
+	err =3D crypto_grab_shash(&ictx->polyval_spawn,
+				skcipher_crypto_instance(inst),
+				polyval_name, 0, mask);
+	if (err)
+		goto err_free_inst;
+	polyval_alg =3D crypto_spawn_shash_alg(&ictx->polyval_spawn);
+
+	/* Check the set of algorithms */
+	if (!hctr2_supported_algorithms(xctr_alg, blockcipher_alg,
+					polyval_alg)) {
+		pr_warn("Unsupported HCTR2 instantiation: (%s,%s,%s)\n",
+			xctr_alg->base.cra_name, blockcipher_alg->cra_name,
+			polyval_alg->base.cra_name);
+		err =3D -EINVAL;
+		goto err_free_inst;
+	}
+
+	/* Instance fields */
+
+	err =3D -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "hctr2(%s)",
+		     blockcipher_alg->cra_name) >=3D CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "hctr2_base(%s,%s)",
+		     xctr_alg->base.cra_driver_name,
+		     polyval_alg->base.cra_driver_name) >=3D CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	inst->alg.base.cra_blocksize =3D BLOCKCIPHER_BLOCK_SIZE;
+	inst->alg.base.cra_ctxsize =3D sizeof(struct hctr2_tfm_ctx);
+	inst->alg.base.cra_alignmask =3D xctr_alg->base.cra_alignmask |
+				       polyval_alg->base.cra_alignmask;
+	/*
+	 * The hash function is called twice, so it is weighted higher than the
+	 * xctr and blockcipher.
+	 */
+	inst->alg.base.cra_priority =3D (2 * xctr_alg->base.cra_priority +
+				       4 * polyval_alg->base.cra_priority +
+				       blockcipher_alg->cra_priority) / 7;
+
+	inst->alg.setkey =3D hctr2_setkey;
+	inst->alg.encrypt =3D hctr2_encrypt;
+	inst->alg.decrypt =3D hctr2_decrypt;
+	inst->alg.init =3D hctr2_init_tfm;
+	inst->alg.exit =3D hctr2_exit_tfm;
+	inst->alg.min_keysize =3D crypto_skcipher_alg_min_keysize(xctr_alg);
+	inst->alg.max_keysize =3D crypto_skcipher_alg_max_keysize(xctr_alg);
+	inst->alg.ivsize =3D TWEAK_SIZE;
+
+	inst->free =3D hctr2_free_instance;
+
+	err =3D skcipher_register_instance(tmpl, inst);
+	if (err) {
+err_free_inst:
+		hctr2_free_instance(inst);
+	}
+	return err;
+}
+
+static int hctr2_create_base(struct crypto_template *tmpl, struct rtattr *=
*tb)
+{
+	const char *xctr_name;
+	const char *polyval_name;
+	char blockcipher_name[CRYPTO_MAX_ALG_NAME];
+	int len;
+
+	xctr_name =3D crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(xctr_name))
+		return PTR_ERR(xctr_name);
+
+	if (!strncmp(xctr_name, "xctr(", 5)) {
+		len =3D strscpy(blockcipher_name, xctr_name + 5,
+			    sizeof(blockcipher_name));
+
+		if (len < 1)
+			return -EINVAL;
+
+		if (blockcipher_name[len - 1] !=3D ')')
+			return -EINVAL;
+
+		blockcipher_name[len - 1] =3D 0;
+	} else
+		return -EINVAL;
+
+	polyval_name =3D crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(polyval_name))
+		return PTR_ERR(polyval_name);
+
+	return hctr2_create_common(tmpl, tb, blockcipher_name,
+				   xctr_name, polyval_name);
+}
+
+static int hctr2_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	const char *blockcipher_name;
+	char xctr_name[CRYPTO_MAX_ALG_NAME];
+
+	blockcipher_name =3D crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(blockcipher_name))
+		return PTR_ERR(blockcipher_name);
+
+	if (snprintf(xctr_name, CRYPTO_MAX_ALG_NAME, "xctr(%s)",
+		    blockcipher_name) >=3D CRYPTO_MAX_ALG_NAME)
+		return -ENAMETOOLONG;
+	return hctr2_create_common(tmpl, tb, blockcipher_name,
+				   xctr_name, "polyval");
+}
+
+/* hctr2(blockcipher_name) */
+/* hctr2_base(xctr_name, polyval_name) */
+static struct crypto_template hctr2_tmpls[] =3D {
+	{
+		.name =3D "hctr2_base",
+		.create =3D hctr2_create_base,
+		.module =3D THIS_MODULE,
+	}, {
+		.name =3D "hctr2",
+		.create =3D hctr2_create,
+		.module =3D THIS_MODULE,
+	}
+};
+
+static int __init hctr2_module_init(void)
+{
+	return crypto_register_templates(hctr2_tmpls, ARRAY_SIZE(hctr2_tmpls));
+}
+
+static void __exit hctr2_module_exit(void)
+{
+	return crypto_unregister_templates(hctr2_tmpls,
+					   ARRAY_SIZE(hctr2_tmpls));
+}
+
+subsys_initcall(hctr2_module_init);
+module_exit(hctr2_module_exit);
+
+MODULE_DESCRIPTION("HCTR2 length-preserving encryption mode");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("hctr2");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ced7467bb481..3a5cd6831e65 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2191,6 +2191,11 @@ static int do_test(const char *alg, u32 type, u32 ma=
sk, int m, u32 num_mb)
 				   16, 16, aead_speed_template_19, num_mb);
 		break;
=20
+	case 226:
+		test_cipher_speed("hctr2(aes)", ENCRYPT, sec, NULL,
+				  0, speed_template_32);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3e54d17fe644..2e92a4a89285 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4991,6 +4991,14 @@ static const struct alg_test_desc alg_test_descs[] =
=3D {
 		.suite =3D {
 			.hash =3D __VECS(ghash_tv_template)
 		}
+	}, {
+		.alg =3D "hctr2(aes)",
+		.generic_driver =3D
+		    "hctr2_base(xctr(aes-generic),polyval-generic)",
+		.test =3D alg_test_skcipher,
+		.suite =3D {
+			.cipher =3D __VECS(aes_hctr2_tv_template)
+		}
 	}, {
 		.alg =3D "hmac(md5)",
 		.test =3D alg_test_hash,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index da3736e51982..a16b631730e9 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -33630,4 +33630,674 @@ static const struct hash_testvec polyval_tv_templ=
ate[] =3D {
 	},
 };
=20
+/*
+ * Test vectors generated using https://github.com/google/hctr2
+ */
+static const struct cipher_testvec aes_hctr2_tv_template[] =3D {
+	{
+		.key	=3D "\xe1\x15\x66\x3c\x8d\xc6\x3a\xff"
+			  "\xef\x41\xd7\x47\xa2\xcc\x8a\xba",
+		.iv	=3D "\xc3\xbe\x2a\xcb\xb5\x39\x86\xf1"
+			  "\x91\xad\x6c\xf4\xde\x74\x45\x63"
+			  "\x5c\x7a\xd5\xcc\x8b\x76\xef\x0e"
+			  "\xcf\x2c\x60\x69\x37\xfd\x07\x96",
+		.ptext	=3D "\x65\x75\xae\xd3\xe2\xbc\x43\x5c"
+			  "\xb3\x1a\xd8\x05\xc3\xd0\x56\x29",
+		.ctext	=3D "\x11\x91\xea\x74\x58\xcc\xd5\xa2"
+			  "\xd0\x55\x9e\x3d\xfe\x7f\xc8\xfe",
+		.klen	=3D 16,
+		.len	=3D 16,
+	},
+	{
+		.key	=3D "\x50\xcc\x28\x5c\xaf\x62\xa2\x4e"
+			  "\x02\xf0\xc0\x5e\xc1\x29\x80\xca",
+		.iv	=3D "\x64\xa5\xd5\xf9\xf4\x68\x26\xea"
+			  "\xce\xbb\x6c\xdd\xa5\xef\x39\xb5"
+			  "\x5c\x93\xdf\x1b\x93\x21\xbe\x49"
+			  "\xff\x9e\x86\x4f\x7c\x4d\x51\x15",
+		.ptext	=3D "\x34\xc1\x08\x3e\x9c\x28\x0a\xcf"
+			  "\x33\xdb\x3f\x0d\x05\x27\xa4\xed",
+		.ctext	=3D "\x7c\xae\xbb\x37\x4a\x55\x94\x5b"
+			  "\xc6\x6f\x8f\x9f\x68\x5f\xc7\x62",
+		.klen	=3D 16,
+		.len	=3D 16,
+	},
+	{
+		.key	=3D "\xda\xce\x30\x85\xe7\x06\xe6\x02"
+			  "\x8f\x02\xbf\x9a\x82\x6e\x54\xde",
+		.iv	=3D "\xf6\x7a\x28\xce\xfb\x6c\xb3\xc5"
+			  "\x47\x81\x58\x69\x07\xe5\x22\xdb"
+			  "\x66\x93\xd7\xe9\xbd\x5c\x7f\xf0"
+			  "\x8a\x0b\x07\x09\xbb\xf1\x48\xc4",
+		.ptext	=3D "\x01\xcd\xa4\x47\x8e\x4e\xbc\x7d"
+			  "\xfd\xd8\xe9\xaa\xc7\x37\x25\x3d"
+			  "\x56",
+		.ctext	=3D "\xf3\xb2\x9e\xde\x96\x5d\xf0\xf6"
+			  "\xb6\x43\x57\xc5\x53\xe8\xf9\x05"
+			  "\x87",
+		.klen	=3D 16,
+		.len	=3D 17,
+	},
+	{
+		.key	=3D "\xe1\x22\xee\x5b\x3c\x92\x0e\x52"
+			  "\xd7\x95\x88\xa3\x79\x6c\xf8\xd9",
+		.iv	=3D "\xb8\xd1\xe7\x32\x36\x96\xd6\x44"
+			  "\x9c\x36\xad\x31\x5c\xaa\xf0\x17"
+			  "\x33\x2f\x29\x04\x31\xf5\x46\xc1"
+			  "\x2f\x1b\xfa\xa1\xbd\x86\xc4\xd3",
+		.ptext	=3D "\x87\xd7\xb8\x2d\x12\x62\xed\x41"
+			  "\x30\x7e\xd4\x0c\xfd\xb9\x6d\x8e"
+			  "\x30",
+		.ctext	=3D "\xb6\x6a\x0c\x71\x96\x22\xb9\x40"
+			  "\xa2\x04\x56\x14\x22\xae\xaa\x94"
+			  "\x26",
+		.klen	=3D 16,
+		.len	=3D 17,
+	},
+	{
+		.key	=3D "\xd8\x4f\xbc\x25\x8d\x3b\x30\xb9"
+			  "\x1a\xbc\x20\x6d\xae\xfd\xc8\x26"
+			  "\xcd\x23\xb4\x86\x28\x07\x4c\x3e",
+		.iv	=3D "\xeb\xd5\x97\xaf\x03\x85\x03\x83"
+			  "\x0c\x6b\xa3\xab\xe1\x00\x15\xf2"
+			  "\x4c\x7d\xfb\x98\x50\xcd\x19\x75"
+			  "\x28\x27\xe8\x18\x02\xbc\xe0\xdd",
+		.ptext	=3D "\x7e\x3a\x0e\x9c\xa8\x52\xa8\x3a"
+			  "\x15\x53\xed\x5c\x0b\x2a\x96\x5c"
+			  "\x71\x24\x82\xee\x53\xd4\xd5\xde"
+			  "\x27\xcd\x36\x18\xf7\x91\x4f",
+		.ctext	=3D "\xd0\x82\xa9\xdb\x77\x12\x3b\x90"
+			  "\xe6\xd5\xdd\x26\x6f\x31\xeb\xdf"
+			  "\xd4\x0c\x56\x2e\x84\x76\x77\x86"
+			  "\x35\xb4\x0f\xfb\x1d\x5a\x15",
+		.klen	=3D 24,
+		.len	=3D 31,
+	},
+	{
+		.key	=3D "\xba\xb1\x52\xa3\x76\x5e\x83\xee"
+			  "\x49\xe6\xcf\x01\xf6\x63\xa4\xba"
+			  "\xa1\x87\xbd\x58\xbb\x20\x96\xa5",
+		.iv	=3D "\x1d\x6a\x6d\x26\x40\x9c\xce\x76"
+			  "\x5e\xb8\x22\x1a\x10\xb6\x1d\xf2"
+			  "\x93\x1f\x87\x04\xb8\xb4\x6e\xf8"
+			  "\x35\x51\x96\x1b\xee\x7f\x8a\x60",
+		.ptext	=3D "\x67\xdf\x68\x07\xc0\xf9\x45\x4c"
+			  "\x1a\xfe\xd3\xc9\xb6\x7d\xe5\x18"
+			  "\x54\xf5\xb3\xae\xf6\xda\x52\x27"
+			  "\x3e\x52\xe8\xed\x04\xd7\x80",
+		.ctext	=3D "\x11\xa1\x00\x15\x7a\x46\x92\x82"
+			  "\x07\x5b\x64\xf1\x61\x27\x25\xc5"
+			  "\xc5\xaf\xa7\x2e\x61\x09\xb5\x5a"
+			  "\x9a\x1d\xc9\x20\xf0\xab\x1e",
+		.klen	=3D 24,
+		.len	=3D 31,
+	},
+	{
+		.key	=3D "\xbf\xaf\xd7\x67\x8c\x47\xcf\x21"
+			  "\x8a\xa5\xdd\x32\x25\x47\xbe\x4f"
+			  "\xf1\x3a\x0b\xa6\xaa\x2d\xcf\x09",
+		.iv	=3D "\xd9\xe8\xf0\x92\x4e\xfc\x1d\xf2"
+			  "\x81\x37\x7c\x8f\xf1\x59\x09\x20"
+			  "\xf4\x46\x51\x86\x4f\x54\x8b\x32"
+			  "\x58\xd1\x99\x8b\x8c\x03\xeb\x5d",
+		.ptext	=3D "\xcd\x64\x90\xf9\x7c\xe5\x0e\x5a"
+			  "\x75\xe7\x8e\x39\x86\xec\x20\x43"
+			  "\x8a\x49\x09\x15\x47\xf4\x3c\x89"
+			  "\x21\xeb\xcf\x4e\xcf\x91\xb5\x40"
+			  "\xcd\xe5\x4d\x5c\x6f\xf2\xd2\x80"
+			  "\xfa\xab\xb3\x76\x9f\x7f\x84\x0a",
+		.ctext	=3D "\x44\x98\x64\x15\xb7\x0b\x80\xa3"
+			  "\xb9\xca\x23\xff\x3b\x0b\x68\x74"
+			  "\xbb\x3e\x20\x19\x9f\x28\x71\x2a"
+			  "\x48\x3c\x7c\xe2\xef\xb5\x10\xac"
+			  "\x82\x9f\xcd\x08\x8f\x6b\x16\x6f"
+			  "\xc3\xbb\x07\xfb\x3c\xb0\x1b\x27",
+		.klen	=3D 24,
+		.len	=3D 48,
+	},
+	{
+		.key	=3D "\xbe\xbb\x77\x46\x06\x9c\xf4\x4d"
+			  "\x37\x9a\xe6\x3f\x27\xa7\x3b\x6e"
+			  "\x7a\x36\xb8\xb3\xff\xba\x51\xcc",
+		.iv	=3D "\x06\xbc\x8f\x66\x6a\xbe\xed\x5e"
+			  "\x51\xf2\x72\x11\x3a\x56\x85\x21"
+			  "\x44\xfe\xec\x47\x2b\x09\xb8\x6f"
+			  "\x08\x85\x2a\x93\xa3\xc3\xab\x5e",
+		.ptext	=3D "\xc7\x74\x42\xf1\xea\xc5\x37\x2d"
+			  "\xc2\xa0\xf6\xd5\x5a\x9a\xbb\xa0"
+			  "\xb2\xfd\x54\x8e\x98\xa0\xea\xc7"
+			  "\x79\x09\x65\x63\xa0\x2e\x82\x4e"
+			  "\x49\x9c\x39\x67\xd0\x0d\x80\x3e"
+			  "\x1a\x86\x84\x2b\x20\x23\xdf\xa7",
+		.ctext	=3D "\x5f\xa3\x11\xca\x93\xfa\x24\x3a"
+			  "\x24\xb6\xcf\x1e\x76\xbc\xab\xc4"
+			  "\xf3\x24\xa0\x27\xac\x90\xec\xe9"
+			  "\x73\x28\x7d\x35\x67\xfe\x2e\xa8"
+			  "\x89\x77\xac\xeb\xc3\x68\x36\xf4"
+			  "\x8f\x80\x2c\xf1\x80\xef\x49\x49",
+		.klen	=3D 24,
+		.len	=3D 48,
+	},
+	{
+		.key	=3D "\xa5\x28\x24\x34\x1a\x3c\xd8\xf7"
+			  "\x05\x91\x8f\xee\x85\x1f\x35\x7f"
+			  "\x80\x3d\xfc\x9b\x94\xf6\xfc\x9e"
+			  "\x19\x09\x00\xa9\x04\x31\x4f\x11",
+		.iv	=3D "\xa1\xba\x49\x95\xff\x34\x6d\xb8"
+			  "\xcd\x87\x5d\x5e\xfd\xea\x85\xdb"
+			  "\x8a\x7b\x5e\xb2\x5d\x57\xdd\x62"
+			  "\xac\xa9\x8c\x41\x42\x94\x75\xb7",
+		.ptext	=3D "\x69\xb4\xe8\x8c\x37\xe8\x67\x82"
+			  "\xf1\xec\x5d\x04\xe5\x14\x91\x13"
+			  "\xdf\xf2\x87\x1b\x69\x81\x1d\x71"
+			  "\x70\x9e\x9c\x3b\xde\x49\x70\x11"
+			  "\xa0\xa3\xdb\x0d\x54\x4f\x66\x69"
+			  "\xd7\xdb\x80\xa7\x70\x92\x68\xce"
+			  "\x81\x04\x2c\xc6\xab\xae\xe5\x60"
+			  "\x15\xe9\x6f\xef\xaa\x8f\xa7\xa7"
+			  "\x63\x8f\xf2\xf0\x77\xf1\xa8\xea"
+			  "\xe1\xb7\x1f\x9e\xab\x9e\x4b\x3f"
+			  "\x07\x87\x5b\x6f\xcd\xa8\xaf\xb9"
+			  "\xfa\x70\x0b\x52\xb8\xa8\xa7\x9e"
+			  "\x07\x5f\xa6\x0e\xb3\x9b\x79\x13"
+			  "\x79\xc3\x3e\x8d\x1c\x2c\x68\xc8"
+			  "\x51\x1d\x3c\x7b\x7d\x79\x77\x2a"
+			  "\x56\x65\xc5\x54\x23\x28\xb0\x03",
+		.ctext	=3D "\xeb\xf9\x98\x86\x3c\x40\x9f\x16"
+			  "\x84\x01\xf9\x06\x0f\xeb\x3c\xa9"
+			  "\x4c\xa4\x8e\x5d\xc3\x8d\xe5\xd3"
+			  "\xae\xa6\xe6\xcc\xd6\x2d\x37\x4f"
+			  "\x99\xc8\xa3\x21\x46\xb8\x69\xf2"
+			  "\xe3\x14\x89\xd7\xb9\xf5\x9e\x4e"
+			  "\x07\x93\x6f\x78\x8e\x6b\xea\x8f"
+			  "\xfb\x43\xb8\x3e\x9b\x4c\x1d\x7e"
+			  "\x20\x9a\xc5\x87\xee\xaf\xf6\xf9"
+			  "\x46\xc5\x18\x8a\xe8\x69\xe7\x96"
+			  "\x52\x55\x5f\x00\x1e\x1a\xdc\xcc"
+			  "\x13\xa5\xee\xff\x4b\x27\xca\xdc"
+			  "\x10\xa6\x48\x76\x98\x43\x94\xa3"
+			  "\xc7\xe2\xc9\x65\x9b\x08\x14\x26"
+			  "\x1d\x68\xfb\x15\x0a\x33\x49\x84"
+			  "\x84\x33\x5a\x1b\x24\x46\x31\x92",
+		.klen	=3D 32,
+		.len	=3D 128,
+	},
+	{
+		.key	=3D "\x91\x35\xf6\xba\x36\x94\x44\x6e"
+			  "\xf5\x7b\xaf\xe7\x56\x15\x0c\x8d"
+			  "\x98\x4b\x5d\xc0\x99\x39\xd9\x75"
+			  "\x71\xa6\x6b\x80\xa1\x92\xde\x6b",
+		.iv	=3D "\xda\xf3\x93\x88\x19\x70\xd2\x7a"
+			  "\x8f\xe5\x7a\xbc\xec\x74\xc0\xf1"
+			  "\x6b\x46\x37\x79\x92\x91\x1d\x15"
+			  "\x3b\xe4\x89\x2c\xf9\x50\x7f\x5c",
+		.ptext	=3D "\x66\xd2\xd9\xaa\x76\x91\x8d\x04"
+			  "\x78\xd3\x93\xeb\xe4\x9d\x88\xad"
+			  "\x14\x6b\x05\x96\x55\x60\x17\x04"
+			  "\x9d\x4d\xf0\x0d\x49\x78\xcc\xfc"
+			  "\xc7\x46\xf3\x3f\xf5\x21\x39\x51"
+			  "\xd1\x88\x84\x3e\x34\xde\x86\x19"
+			  "\xa4\x3b\x75\x18\x98\x89\x0a\x93"
+			  "\xe9\x6e\xbf\x52\xa1\x63\xf8\xa2"
+			  "\x77\xab\x57\xed\x5e\xc9\x64\xed"
+			  "\x5c\x1a\x1d\xb6\x14\xbc\x7b\x26"
+			  "\x27\xce\xf1\xfe\xc5\x74\xd0\x9d"
+			  "\x60\x77\x87\x36\xfd\x70\x54\x03"
+			  "\x8b\x9a\x36\x11\xf9\x0f\x7d\x1a"
+			  "\x66\xc5\xf0\x21\xbb\xfc\x84\xcd"
+			  "\x45\xbc\xdf\xc0\x81\xd3\xdf\x0f"
+			  "\x14\x20\xff\x20\x05\x0c\x47\x38",
+		.ctext	=3D "\xd4\x99\xdc\x4c\xba\xb9\x9c\xca"
+			  "\x5c\x85\x98\x3b\x11\x5e\xfb\xdc"
+			  "\xed\x49\x0f\x49\xf2\x45\x6c\x2c"
+			  "\x16\x4d\x75\xbf\x9b\x28\x20\x38"
+			  "\xea\xdf\xbe\x72\xea\xf8\x6e\x34"
+			  "\x7a\x97\x7c\xe8\xa9\x4f\x2f\xb0"
+			  "\x45\x48\x05\xcd\xd6\xc8\x59\xe5"
+			  "\x5f\x51\x42\xc4\x4e\x12\x64\xce"
+			  "\x99\xb1\xaf\x78\x13\x4d\x7e\x4a"
+			  "\xa5\x01\x0c\xd1\xad\xfe\x31\xbb"
+			  "\xbf\x1c\x02\x58\xa4\xd5\xd2\x70"
+			  "\x8a\xf8\x7d\x8f\x5d\xdf\xe7\x10"
+			  "\x09\xd6\xe1\x05\x50\xe8\x31\x7a"
+			  "\xa7\xfc\x4b\xf7\xad\xd5\x10\x29"
+			  "\x76\x60\x3e\x71\x99\x0a\x22\xe4"
+			  "\x29\xba\x63\xb7\x16\x56\xa2\x37",
+		.klen	=3D 32,
+		.len	=3D 128,
+	},
+	{
+		.key	=3D "\x36\x45\x11\xa2\x98\x5f\x96\x7c"
+			  "\xc6\xb4\x94\x31\x0a\x67\x09\x32"
+			  "\x6c\x6f\x6f\x00\xf0\x17\xcb\xac"
+			  "\xa5\xa9\x47\x9e\x2e\x85\x2f\xfa",
+		.iv	=3D "\x28\x88\xaa\x9b\x59\x3b\x1e\x97"
+			  "\x82\xe5\x5c\x9e\x6d\x14\x11\x19"
+			  "\x6e\x38\x8f\xd5\x40\x2b\xca\xf9"
+			  "\x7b\x4c\xe4\xa3\xd0\xd2\x8a\x13",
+		.ptext	=3D "\x95\xd2\xf7\x71\x1b\xca\xa5\x86"
+			  "\xd9\x48\x01\x93\x2f\x79\x55\x29"
+			  "\x71\x13\x15\x0e\xe6\x12\xbc\x4d"
+			  "\x8a\x31\xe3\x40\x2a\xc6\x5e\x0d"
+			  "\x68\xbb\x4a\x62\x8d\xc7\x45\x77"
+			  "\xd2\xb8\xc7\x1d\xf1\xd2\x5d\x97"
+			  "\xcf\xac\x52\xe5\x32\x77\xb6\xda"
+			  "\x30\x85\xcf\x2b\x98\xe9\xaa\x34"
+			  "\x62\xb5\x23\x9e\xb7\xa6\xd4\xe0"
+			  "\xb4\x58\x18\x8c\x4d\xde\x4d\x01"
+			  "\x83\x89\x24\xca\xfb\x11\xd4\x82"
+			  "\x30\x7a\x81\x35\xa0\xb4\xd4\xb6"
+			  "\x84\xea\x47\x91\x8c\x19\x86\x25"
+			  "\xa6\x06\x8d\x78\xe6\xed\x87\xeb"
+			  "\xda\xea\x73\x7c\xbf\x66\xb8\x72"
+			  "\xe3\x0a\xb8\x0c\xcb\x1a\x73\xf1"
+			  "\xa7\xca\x0a\xde\x57\x2b\xbd\x2b"
+			  "\xeb\x8b\x24\x38\x22\xd3\x0e\x1f"
+			  "\x17\xa0\x84\x98\x31\x77\xfd\x34"
+			  "\x6a\x4e\x3d\x84\x4c\x0e\xfb\xed"
+			  "\xc8\x2a\x51\xfa\xd8\x73\x21\x8a"
+			  "\xdb\xb5\xfe\x1f\xee\xc4\xe8\x65"
+			  "\x54\x84\xdd\x96\x6d\xfd\xd3\x31"
+			  "\x77\x36\x52\x6b\x80\x4f\x9e\xb4"
+			  "\xa2\x55\xbf\x66\x41\x49\x4e\x87"
+			  "\xa7\x0c\xca\xe7\xa5\xc5\xf6\x6f"
+			  "\x27\x56\xe2\x48\x22\xdd\x5f\x59"
+			  "\x3c\xf1\x9f\x83\xe5\x2d\xfb\x71"
+			  "\xad\xd1\xae\x1b\x20\x5c\x47\xb7"
+			  "\x3b\xd3\x14\xce\x81\x42\xb1\x0a"
+			  "\xf0\x49\xfa\xc2\xe7\x86\xbf\xcd"
+			  "\xb0\x95\x9f\x8f\x79\x41\x54",
+		.ctext	=3D "\xf6\x57\x51\xc4\x25\x61\x2d\xfa"
+			  "\xd6\xd9\x3f\x9a\x81\x51\xdd\x8e"
+			  "\x3d\xe7\xaa\x2d\xb1\xda\xc8\xa6"
+			  "\x9d\xaa\x3c\xab\x62\xf2\x80\xc3"
+			  "\x2c\xe7\x58\x72\x1d\x44\xc5\x28"
+			  "\x7f\xb4\xf9\xbc\x9c\xb2\xab\x8e"
+			  "\xfa\xd1\x4d\x72\xd9\x79\xf5\xa0"
+			  "\x24\x3e\x90\x25\x31\x14\x38\x45"
+			  "\x59\xc8\xf6\xe2\xc6\xf6\xc1\xa7"
+			  "\xb2\xf8\xa7\xa9\x2b\x6f\x12\x3a"
+			  "\xb0\x81\xa4\x08\x57\x59\xb1\x56"
+			  "\x4c\x8f\x18\x55\x33\x5f\xd6\x6a"
+			  "\xc6\xa0\x4b\xd6\x6b\x64\x3e\x9e"
+			  "\xfd\x66\x16\xe2\xdb\xeb\x5f\xb3"
+			  "\x50\x50\x3e\xde\x8d\x72\x76\x01"
+			  "\xbe\xcc\xc9\x52\x09\x2d\x8d\xe7"
+			  "\xd6\xc3\x66\xdb\x36\x08\xd1\x77"
+			  "\xc8\x73\x46\x26\x24\x29\xbf\x68"
+			  "\x2d\x2a\x99\x43\x56\x55\xe4\x93"
+			  "\xaf\xae\x4d\xe7\x55\x4a\xc0\x45"
+			  "\x26\xeb\x3b\x12\x90\x7c\xdc\xd1"
+			  "\xd5\x6f\x0a\xd0\xa9\xd7\x4b\x89"
+			  "\x0b\x07\xd8\x86\xad\xa1\xc4\x69"
+			  "\x1f\x5e\x8b\xc4\x9e\x91\x41\x25"
+			  "\x56\x98\x69\x78\x3a\x9e\xae\x91"
+			  "\xd8\xd9\xfa\xfb\xff\x81\x25\x09"
+			  "\xfc\xed\x2d\x87\xbc\x04\x62\x97"
+			  "\x35\xe1\x26\xc2\x46\x1c\xcf\xd7"
+			  "\x14\xed\x02\x09\xa5\xb2\xb6\xaa"
+			  "\x27\x4e\x61\xb3\x71\x6b\x47\x16"
+			  "\xb7\xe8\xd4\xaf\x52\xeb\x6a\x6b"
+			  "\xdb\x4c\x65\x21\x9e\x1c\x36",
+		.klen	=3D 32,
+		.len	=3D 255,
+	},
+	{
+		.key	=3D "\x56\x33\x37\x21\xc4\xea\x8b\x88"
+			  "\x67\x5e\xee\xb8\x0b\x6c\x04\x43"
+			  "\x17\xc5\x2b\x8a\x37\x17\x8b\x37"
+			  "\x60\x57\x3f\xa7\x82\xcd\xb9\x09",
+		.iv	=3D "\x88\xee\x9b\x35\x21\x2d\x41\xa1"
+			  "\x16\x0d\x7f\xdf\x57\xc9\xb9\xc3"
+			  "\xf6\x30\x53\xbf\x89\x46\xe6\x87"
+			  "\x60\xc8\x5e\x59\xdd\x8a\x7b\xfe",
+		.ptext	=3D "\x49\xe2\x0a\x4f\x7a\x60\x75\x9b"
+			  "\x95\x98\x2c\xe7\x4f\xb4\x58\xb9"
+			  "\x24\x54\x46\x34\xdf\x58\x31\xe7"
+			  "\x23\xc6\xa2\x60\x4a\xd2\x59\xb6"
+			  "\xeb\x3e\xc2\xf8\xe5\x14\x3c\x6d"
+			  "\x4b\x72\xcb\x5f\xcb\xa7\x47\xb9"
+			  "\x7a\x49\xfc\xf1\xad\x92\x76\x55"
+			  "\xac\x59\xdc\x3a\xc6\x8b\x7c\xdb"
+			  "\x06\xcd\xea\x6a\x34\x51\xb7\xb2"
+			  "\xe5\x39\x3c\x87\x00\x90\xc2\xbb"
+			  "\xb2\xa5\x2c\x58\xc2\x9b\xe3\x77"
+			  "\x95\x82\x50\xcb\x23\xdc\x18\xd8"
+			  "\x4e\xbb\x13\x5d\x35\x3d\x9a\xda"
+			  "\xe4\x75\xa1\x75\x17\x59\x8c\x6a"
+			  "\xb2\x76\x7e\xd4\x45\x31\x0a\x45"
+			  "\x2e\x60\x83\x3d\xdc\x8d\x43\x20"
+			  "\x58\x24\xb2\x9d\xd5\x59\x64\x32"
+			  "\x4e\x6f\xb9\x9c\xde\x77\x4d\x65"
+			  "\xdf\xc0\x7a\xeb\x40\x80\xe8\xe5"
+			  "\xc7\xc1\x77\x3b\xae\x2b\x85\xce"
+			  "\x56\xfa\x43\x41\x96\x23\x8e\xab"
+			  "\xd3\xc8\x65\xef\x0b\xfe\x42\x4c"
+			  "\x3a\x8a\x54\x55\xab\xa3\xf9\x62"
+			  "\x9f\x8e\xbe\x33\x9a\xfe\x6b\x52"
+			  "\xd4\x4c\x93\x84\x7c\x7e\xb1\x5e"
+			  "\x32\xaf\x6e\x21\x44\xd2\x6b\x56"
+			  "\xcd\x2c\x9d\x03\x3b\x50\x1f\x0a"
+			  "\xc3\x98\xff\x3a\x1d\x36\x7e\x6d"
+			  "\xcf\xbc\xe7\xe8\xfc\x24\x55\xfd"
+			  "\x72\x3d\xa7\x3f\x09\xa7\x38\xe6"
+			  "\x57\x8d\xc4\x74\x7f\xd3\x26\x75"
+			  "\xda\xfa\x29\x35\xc1\x31\x82",
+		.ctext	=3D "\x02\x23\x74\x02\x56\xf4\x7b\xc8"
+			  "\x55\x61\xa0\x6b\x68\xff\xde\x87"
+			  "\x9d\x66\x77\x86\x98\x63\xab\xd5"
+			  "\xd6\xf4\x7e\x3b\xf4\xae\x97\x13"
+			  "\x79\xc0\x96\x75\x87\x33\x2a\x0e"
+			  "\xc2\x1a\x13\x90\x5f\x6e\x93\xed"
+			  "\x54\xfe\xee\x05\x48\xae\x20\x2d"
+			  "\xa9\x2b\x98\xa3\xc8\xaf\x17\x6b"
+			  "\x82\x4a\x9a\x7f\xf0\xce\xd9\x26"
+			  "\x16\x28\xeb\xf4\x4b\xab\x7d\x6e"
+			  "\x96\x27\xd2\x90\xbb\x8d\x98\xdc"
+			  "\xb8\x6f\x7a\x98\x67\xef\x1c\xfb"
+			  "\xd0\x23\x1a\x2f\xc9\x58\x4e\xc6"
+			  "\x38\x03\x53\x61\x8e\xff\x55\x46"
+			  "\x47\xe8\x1f\x9d\x66\x95\x9b\x7f"
+			  "\x26\xac\xf2\x61\xa4\x05\x15\xcb"
+			  "\x62\xb6\x6b\x7c\x57\x95\x9d\x25"
+			  "\x9e\x83\xb1\x88\x50\x39\xb5\x34"
+			  "\x8a\x04\x2b\x76\x1b\xb8\x8c\x57"
+			  "\x26\x21\x99\x2e\x93\xc8\x9b\xb2"
+			  "\x31\xe1\xe3\x27\xde\xc8\xf2\xc5"
+			  "\x01\x7a\x45\x38\x6f\xe7\xa0\x9d"
+			  "\x8c\x41\x99\xec\x3d\xb6\xaf\x66"
+			  "\x76\xac\xc8\x78\xb0\xdf\xcf\xce"
+			  "\xa1\x29\x46\x6f\xe3\x35\x4a\x67"
+			  "\x59\x27\x14\xcc\x04\xdb\xb3\x03"
+			  "\xb7\x2d\x8d\xf9\x75\x9e\x59\x42"
+			  "\xe3\xa4\xf8\xf4\x82\x27\xa3\xa9"
+			  "\x79\xac\x6b\x8a\xd8\xdb\x29\x73"
+			  "\x02\xbb\x6f\x85\x00\x92\xea\x59"
+			  "\x30\x1b\x19\xf3\xab\x6e\x99\x9a"
+			  "\xf2\x23\x27\xc6\x59\x5a\x9c",
+		.klen	=3D 32,
+		.len	=3D 255,
+	},
+	{
+		.key	=3D "\xd3\x81\x72\x18\x23\xff\x6f\x4a"
+			  "\x25\x74\x29\x0d\x51\x8a\x0e\x13"
+			  "\xc1\x53\x5d\x30\x8d\xee\x75\x0d"
+			  "\x14\xd6\x69\xc9\x15\xa9\x0c\x60",
+		.iv	=3D "\x65\x9b\xd4\xa8\x7d\x29\x1d\xf4"
+			  "\xc4\xd6\x9b\x6a\x28\xab\x64\xe2"
+			  "\x62\x81\x97\xc5\x81\xaa\xf9\x44"
+			  "\xc1\x72\x59\x82\xaf\x16\xc8\x2c",
+		.ptext	=3D "\xc7\x6b\x52\x6a\x10\xf0\xcc\x09"
+			  "\xc1\x12\x1d\x6d\x21\xa6\x78\xf5"
+			  "\x05\xa3\x69\x60\x91\x36\x98\x57"
+			  "\xba\x0c\x14\xcc\xf3\x2d\x73\x03"
+			  "\xc6\xb2\x5f\xc8\x16\x27\x37\x5d"
+			  "\xd0\x0b\x87\xb2\x50\x94\x7b\x58"
+			  "\x04\xf4\xe0\x7f\x6e\x57\x8e\xc9"
+			  "\x41\x84\xc1\xb1\x7e\x4b\x91\x12"
+			  "\x3a\x8b\x5d\x50\x82\x7b\xcb\xd9"
+			  "\x9a\xd9\x4e\x18\x06\x23\x9e\xd4"
+			  "\xa5\x20\x98\xef\xb5\xda\xe5\xc0"
+			  "\x8a\x6a\x83\x77\x15\x84\x1e\xae"
+			  "\x78\x94\x9d\xdf\xb7\xd1\xea\x67"
+			  "\xaa\xb0\x14\x15\xfa\x67\x21\x84"
+			  "\xd3\x41\x2a\xce\xba\x4b\x4a\xe8"
+			  "\x95\x62\xa9\x55\xf0\x80\xad\xbd"
+			  "\xab\xaf\xdd\x4f\xa5\x7c\x13\x36"
+			  "\xed\x5e\x4f\x72\xad\x4b\xf1\xd0"
+			  "\x88\x4e\xec\x2c\x88\x10\x5e\xea"
+			  "\x12\xc0\x16\x01\x29\xa3\xa0\x55"
+			  "\xaa\x68\xf3\xe9\x9d\x3b\x0d\x3b"
+			  "\x6d\xec\xf8\xa0\x2d\xf0\x90\x8d"
+			  "\x1c\xe2\x88\xd4\x24\x71\xf9\xb3"
+			  "\xc1\x9f\xc5\xd6\x76\x70\xc5\x2e"
+			  "\x9c\xac\xdb\x90\xbd\x83\x72\xba"
+			  "\x6e\xb5\xa5\x53\x83\xa9\xa5\xbf"
+			  "\x7d\x06\x0e\x3c\x2a\xd2\x04\xb5"
+			  "\x1e\x19\x38\x09\x16\xd2\x82\x1f"
+			  "\x75\x18\x56\xb8\x96\x0b\xa6\xf9"
+			  "\xcf\x62\xd9\x32\x5d\xa9\xd7\x1d"
+			  "\xec\xe4\xdf\x1b\xbe\xf1\x36\xee"
+			  "\xe3\x7b\xb5\x2f\xee\xf8\x53\x3d"
+			  "\x6a\xb7\x70\xa9\xfc\x9c\x57\x25"
+			  "\xf2\x89\x10\xd3\xb8\xa8\x8c\x30"
+			  "\xae\x23\x4f\x0e\x13\x66\x4f\xe1"
+			  "\xb6\xc0\xe4\xf8\xef\x93\xbd\x6e"
+			  "\x15\x85\x6b\xe3\x60\x81\x1d\x68"
+			  "\xd7\x31\x87\x89\x09\xab\xd5\x96"
+			  "\x1d\xf3\x6d\x67\x80\xca\x07\x31"
+			  "\x5d\xa7\xe4\xfb\x3e\xf2\x9b\x33"
+			  "\x52\x18\xc8\x30\xfe\x2d\xca\x1e"
+			  "\x79\x92\x7a\x60\x5c\xb6\x58\x87"
+			  "\xa4\x36\xa2\x67\x92\x8b\xa4\xb7"
+			  "\xf1\x86\xdf\xdc\xc0\x7e\x8f\x63"
+			  "\xd2\xa2\xdc\x78\xeb\x4f\xd8\x96"
+			  "\x47\xca\xb8\x91\xf9\xf7\x94\x21"
+			  "\x5f\x9a\x9f\x5b\xb8\x40\x41\x4b"
+			  "\x66\x69\x6a\x72\xd0\xcb\x70\xb7"
+			  "\x93\xb5\x37\x96\x05\x37\x4f\xe5"
+			  "\x8c\xa7\x5a\x4e\x8b\xb7\x84\xea"
+			  "\xc7\xfc\x19\x6e\x1f\x5a\xa1\xac"
+			  "\x18\x7d\x52\x3b\xb3\x34\x62\x99"
+			  "\xe4\x9e\x31\x04\x3f\xc0\x8d\x84"
+			  "\x17\x7c\x25\x48\x52\x67\x11\x27"
+			  "\x67\xbb\x5a\x85\xca\x56\xb2\x5c"
+			  "\xe6\xec\xd5\x96\x3d\x15\xfc\xfb"
+			  "\x22\x25\xf4\x13\xe5\x93\x4b\x9a"
+			  "\x77\xf1\x52\x18\xfa\x16\x5e\x49"
+			  "\x03\x45\xa8\x08\xfa\xb3\x41\x92"
+			  "\x79\x50\x33\xca\xd0\xd7\x42\x55"
+			  "\xc3\x9a\x0c\x4e\xd9\xa4\x3c\x86"
+			  "\x80\x9f\x53\xd1\xa4\x2e\xd1\xbc"
+			  "\xf1\x54\x6e\x93\xa4\x65\x99\x8e"
+			  "\xdf\x29\xc0\x64\x63\x07\xbb\xea",
+		.ctext	=3D "\x9f\x72\x87\xc7\x17\xfb\x20\x15"
+			  "\x65\xb3\x55\xa8\x1c\x8e\x52\x32"
+			  "\xb1\x82\x8d\xbf\xb5\x9f\x10\x0a"
+			  "\xe8\x0c\x70\x62\xef\x89\xb6\x1f"
+			  "\x73\xcc\xe4\xcc\x7a\x3a\x75\x4a"
+			  "\x26\xe7\xf5\xd7\x7b\x17\x39\x2d"
+			  "\xd2\x27\x6e\xf9\x2f\x9e\xe2\xf6"
+			  "\xfa\x16\xc2\xf2\x49\x26\xa7\x5b"
+			  "\xe7\xca\x25\x0e\x45\xa0\x34\xc2"
+			  "\x9a\x37\x79\x7e\x7c\x58\x18\x94"
+			  "\x10\xa8\x7c\x48\xa9\xd7\x63\x89"
+			  "\x9e\x61\x4d\x26\x34\xd9\xf0\xb1"
+			  "\x2d\x17\x2c\x6f\x7c\x35\x0e\xbe"
+			  "\x77\x71\x7c\x17\x5b\xab\x70\xdb"
+			  "\x2f\x54\x0f\xa9\xc8\xf4\xf5\xab"
+			  "\x52\x04\x3a\xb8\x03\xa7\xfd\x57"
+			  "\x45\x5e\xbc\x77\xe1\xee\x79\x8c"
+			  "\x58\x7b\x1f\xf7\x75\xde\x68\x17"
+			  "\x98\x85\x8a\x18\x5c\xd2\x39\x78"
+			  "\x7a\x6f\x26\x6e\xe1\x13\x91\xdd"
+			  "\xdf\x0e\x6e\x67\xcc\x51\x53\xd8"
+			  "\x17\x5e\xce\xa7\xe4\xaf\xfa\xf3"
+			  "\x4f\x9f\x01\x9b\x04\xe7\xfc\xf9"
+			  "\x6a\xdc\x1d\x0c\x9a\xaa\x3a\x7a"
+			  "\x73\x03\xdf\xbf\x3b\x82\xbe\xb0"
+			  "\xb4\xa4\xcf\x07\xd7\xde\x71\x25"
+			  "\xc5\x10\xee\x0a\x15\x96\x8b\x4f"
+			  "\xfe\xb8\x28\xbd\x4a\xcd\xeb\x9f"
+			  "\x5d\x00\xc1\xee\xe8\x16\x44\xec"
+			  "\xe9\x7b\xd6\x85\x17\x29\xcf\x58"
+			  "\x20\xab\xf7\xce\x6b\xe7\x71\x7d"
+			  "\x4f\xa8\xb0\xe9\x7d\x70\xd6\x0b"
+			  "\x2e\x20\xb1\x1a\x63\x37\xaa\x2c"
+			  "\x94\xee\xd5\xf6\x58\x2a\xf4\x7a"
+			  "\x4c\xba\xf5\xe9\x3c\x6f\x95\x13"
+			  "\x5f\x96\x81\x5b\xb5\x62\xf2\xd7"
+			  "\x8d\xbe\xa1\x31\x51\xe6\xfe\xc9"
+			  "\x07\x7d\x0f\x00\x3a\x66\x8c\x4b"
+			  "\x94\xaa\xe5\x56\xde\xcd\x74\xa7"
+			  "\x48\x67\x6f\xed\xc9\x6a\xef\xaf"
+			  "\x9a\xb7\xae\x60\xfa\xc0\x37\x39"
+			  "\xa5\x25\xe5\x22\xea\x82\x55\x68"
+			  "\x3e\x30\xc3\x5a\xb6\x29\x73\x7a"
+			  "\xb6\xfb\x34\xee\x51\x7c\x54\xe5"
+			  "\x01\x4d\x72\x25\x32\x4a\xa3\x68"
+			  "\x80\x9a\x89\xc5\x11\x66\x4c\x8c"
+			  "\x44\x50\xbe\xd7\xa0\xee\xa6\xbb"
+			  "\x92\x0c\xe6\xd7\x83\x51\xb1\x69"
+			  "\x63\x40\xf3\xf4\x92\x84\xc4\x38"
+			  "\x29\xfb\xb4\x84\xa0\x19\x75\x16"
+			  "\x60\xbf\x0a\x9c\x89\xee\xad\xb4"
+			  "\x43\xf9\x71\x39\x45\x7c\x24\x83"
+			  "\x30\xbb\xee\x28\xb0\x86\x7b\xec"
+			  "\x93\xc1\xbf\xb9\x97\x1b\x96\xef"
+			  "\xee\x58\x35\x61\x12\x19\xda\x25"
+			  "\x77\xe5\x80\x1a\x31\x27\x9b\xe4"
+			  "\xda\x8b\x7e\x51\x4d\xcb\x01\x19"
+			  "\x4f\xdc\x92\x1a\x17\xd5\x6b\xf4"
+			  "\x50\xe3\x06\xe4\x76\x9f\x65\x00"
+			  "\xbd\x7a\xe2\x64\x26\xf2\xe4\x7e"
+			  "\x40\xf2\x80\xab\x62\xd5\xef\x23"
+			  "\x8b\xfb\x6f\x24\x6e\x9b\x66\x0e"
+			  "\xf4\x1c\x24\x1e\x1d\x26\x95\x09"
+			  "\x94\x3c\xb2\xb6\x02\xa7\xd9\x9a",
+		.klen	=3D 32,
+		.len	=3D 512,
+	},
+	{
+		.key	=3D "\x83\x8a\xa7\xd6\x31\x10\xb1\x67"
+			  "\xbf\xed\xf6\x93\x1d\x2e\xc9\x4c"
+			  "\x18\xab\x98\x2c\xed\x5a\x14\x30"
+			  "\xc9\xe0\x4b\x67\xb5\x0d\x6c\xb4",
+		.iv	=3D "\x79\x9a\xea\x92\x10\xd8\x0b\x6a"
+			  "\xb4\xcf\x49\x29\xdb\x50\xce\x54"
+			  "\xf2\x93\x09\x1d\xcc\xd6\x1a\xf7"
+			  "\x80\x49\x74\x83\x76\x50\xaf\x2c",
+		.ptext	=3D "\xce\x7a\x3c\xde\x95\x4b\x2f\x63"
+			  "\x39\x5f\x50\x87\x39\xfb\x5e\x42"
+			  "\x17\xcd\xff\x5e\x5c\x77\x67\x21"
+			  "\x9c\xae\xad\xa6\xbf\x89\xc2\x7e"
+			  "\x99\xfe\xec\x25\x3d\x94\x7f\xcf"
+			  "\x43\x52\xad\x87\x9d\x12\x54\x08"
+			  "\xc7\xb8\xe2\x5c\x4e\x4f\xc0\x6e"
+			  "\x1c\xff\xc1\x30\x66\xd4\x2e\x60"
+			  "\xe6\xc6\xfa\xf5\xc1\xc8\xb1\xd0"
+			  "\x89\x83\x13\x00\x35\x52\x3f\x08"
+			  "\xb7\x62\x77\xbd\x9b\x66\x35\xd3"
+			  "\x57\x24\x94\xe6\x2c\x2e\x9e\xda"
+			  "\x44\xf9\x6b\xae\x0b\xd7\x9f\x55"
+			  "\x86\x4e\x1b\x4b\xe2\x32\x20\x9c"
+			  "\x03\x15\xd1\x6e\x22\x56\xc7\x5c"
+			  "\xe4\x51\xbc\xd8\x21\xd0\xc4\x19"
+			  "\x18\xce\x62\x73\xad\x0c\x31\xa6"
+			  "\x66\xed\x1a\x7d\x54\xcb\xa4\x7c"
+			  "\xeb\xed\xdf\x80\x02\x8d\x26\x4b"
+			  "\xd4\x97\x13\x9d\xeb\xe7\x0b\x09"
+			  "\x99\x4d\xe6\xba\xb5\x38\x37\xff"
+			  "\x7d\xc5\xf2\xb9\x8a\xa8\x00\x4d"
+			  "\xff\x43\xb4\x22\xc0\x0b\x72\xea"
+			  "\x5b\x3e\xc3\xdb\xc8\xa7\xb0\x50"
+			  "\x48\x90\x6d\x8a\xf7\x30\x62\xd8"
+			  "\x3a\xcf\xf9\xcd\x6a\x67\xab\x55"
+			  "\x64\x70\x64\xda\x23\xed\x58\x26"
+			  "\xf6\x90\x2a\x6e\x5a\x98\xd4\x8e"
+			  "\x54\x6a\x9d\x1d\x29\xef\x84\xfa"
+			  "\x3c\xba\x2b\x5e\x34\x45\x7d\xfc"
+			  "\x45\x4f\x13\xb7\xdd\xd7\x2b\xb7"
+			  "\x1a\xb4\x86\x5e\xcf\x35\x54\xc3"
+			  "\xb6\x0d\xe7\xcd\x46\x44\xa4\xc4"
+			  "\x48\x2f\xd0\xfe\x72\xe1\xf0\x92"
+			  "\x1f\x53\xe4\x95\x45\x03\xb9\x9e"
+			  "\xc8\xe0\xcc\x04\x9c\xdd\x19\x19"
+			  "\xa3\xcf\x87\xec\xf1\x84\x0e\x65"
+			  "\xbc\xc9\xe7\x12\x26\x45\xe6\x2e"
+			  "\x9e\xe4\x79\x6c\xa0\x04\xdb\xca"
+			  "\x72\x97\x29\xfc\x20\x43\xd0\x37"
+			  "\x64\xf3\x33\x90\x14\xcf\x00\xa2"
+			  "\xf9\x1b\xa4\x9b\x30\x4b\xd0\x7a"
+			  "\x0d\x52\x2b\x1a\xd1\xea\xe8\x84"
+			  "\x8b\x44\x61\xb1\xfd\x4d\xdb\xf7"
+			  "\x0b\xd5\x55\x32\x83\xb2\x71\x42"
+			  "\x8a\x7f\x80\xc6\xff\x94\x16\xdf"
+			  "\xb5\xfe\x59\xe7\xb5\xa4\x58\x9c"
+			  "\x88\xd2\xb4\x63\x8b\xcb\x9b\x9f"
+			  "\xc6\x5c\x94\x1b\x41\x8b\xa2\x66"
+			  "\xda\x0d\xbc\x9d\x3a\x59\xd8\x66"
+			  "\xd0\x67\xfa\x50\x6f\xe6\xd0\x7a"
+			  "\xd1\x06\x23\x42\x0e\x14\x20\x65"
+			  "\x20\x73\xaa\x34\xac\xa7\x6d\xe5"
+			  "\x23\x28\xa0\xcf\x57\x3e\x19\x00"
+			  "\x3a\x85\x2f\x9d\x79\x15\x29\x4c"
+			  "\x9f\xf7\x3d\xa3\x24\x3c\xa0\x68"
+			  "\xc6\x4c\x44\x5a\x87\xe7\xbc\x0f"
+			  "\xbb\x19\xea\x3e\x37\xc4\x3b\xcc"
+			  "\x1e\xdd\xfa\xfa\x71\x0e\x37\xd5"
+			  "\x3a\xc5\x1e\x90\x5e\xf0\x13\x1f"
+			  "\x7a\x35\xb2\x63\x29\xb6\x27\xf2"
+			  "\x0a\x57\x5c\x43\xe2\xc7\x02\x4a"
+			  "\xc6\x56\xf0\xc1\xa7\xd8\xc6\x3c"
+			  "\x81\xd4\x5e\x16\x5e\x2a\x77\x77",
+		.ctext	=3D "\xd8\xb0\xf0\x69\xef\x35\x99\x52"
+			  "\xf1\x05\xd6\x07\x09\x8f\x2a\xd2"
+			  "\x69\xea\x3e\x3a\xc1\xa6\xbe\xdb"
+			  "\x9a\x13\xa2\x19\x59\x6d\xc9\x52"
+			  "\xf4\xf7\x3e\xed\xb2\xe2\xac\x2a"
+			  "\x75\xfa\x63\x29\x7a\x28\x97\x2b"
+			  "\xdb\xd2\xa4\xef\x5a\x92\x0a\xf0"
+			  "\xb5\x83\x60\x4c\x14\x20\x68\x19"
+			  "\x89\xee\xc6\x5b\xe9\x62\x58\x63"
+			  "\x41\x3e\xca\xa4\x5b\xdb\x49\x9b"
+			  "\xc0\x32\x10\x24\x19\xc2\xb1\x36"
+			  "\x7d\x04\xec\xc2\x1a\xfd\x74\xe5"
+			  "\x20\xe5\x2c\x0b\x9d\x70\x8b\x1a"
+			  "\xb5\xaf\x57\xad\x88\x8c\xe8\x51"
+			  "\x87\x0e\xca\x11\xfe\x93\x17\x6b"
+			  "\xa3\x03\x72\x66\x5e\x73\x2f\x15"
+			  "\xfd\xd3\xbb\x16\x44\x56\x73\x55"
+			  "\x0e\xfb\xfa\x71\x4e\x21\x40\xe4"
+			  "\xac\x77\x0a\x8a\x2a\x62\xd6\xcc"
+			  "\x30\x11\x75\xbb\x9c\x7f\x70\x31"
+			  "\x6d\xbc\x99\x33\xe6\x01\xfb\xb4"
+			  "\xd6\x5b\x93\xaf\x7e\xb5\x60\x11"
+			  "\x6c\x91\xa4\xd4\xa0\xeb\x9b\xa2"
+			  "\x33\x66\x68\x6b\xb8\xe4\x4f\xb6"
+			  "\x24\x89\x3e\xb7\xdc\xef\x6c\x6f"
+			  "\x80\x8e\x1d\xa0\xbe\xbe\x51\x49"
+			  "\xd7\x63\x62\x71\x37\x9e\x2d\x7f"
+			  "\xa6\x8f\xb8\xee\x9c\x64\x73\xd4"
+			  "\xd3\xe2\x3e\x42\x84\x31\xbb\x83"
+			  "\x19\x15\xdd\xdd\x56\x04\x22\x48"
+			  "\xd1\xb2\x0f\x65\x2f\x92\x56\x52"
+			  "\xb6\x96\x25\x93\x2b\xf1\x86\x9f"
+			  "\x30\x75\x23\xab\x48\x8e\x6c\x71"
+			  "\x1a\x46\x65\xe1\x3b\x8d\x09\xfb"
+			  "\xba\x9a\xb6\x08\xdc\xd6\x3e\x54"
+			  "\x74\xe7\xd2\xe7\x6b\xeb\x01\x46"
+			  "\x6b\xc9\x69\xc6\xaa\x3e\xd5\xe2"
+			  "\xd9\x45\x36\x2e\xf0\x46\x2f\x6f"
+			  "\xcb\x2b\xb7\xf0\xaf\x0a\xe7\x22"
+			  "\xc7\x15\x8d\x7f\x52\x63\x50\x88"
+			  "\x49\xbe\x52\xe7\x20\xf7\x65\x72"
+			  "\x32\xce\x50\x44\x1c\x8b\xe0\x34"
+			  "\x8c\x88\x0d\x2c\x7f\xde\xf9\xfd"
+			  "\xaf\x11\x03\x31\xf8\x86\xba\xe9"
+			  "\xc1\x61\x63\xeb\x64\x9f\x6c\x37"
+			  "\x8e\x20\x93\xdb\x6d\x05\xf3\x3c"
+			  "\x89\x3d\xbe\x8d\x3f\xee\x6d\xa0"
+			  "\xb4\x4b\xc2\xe5\x66\x6a\xa8\xcc"
+			  "\x8c\x06\xa6\xd2\xcd\x16\x73\xae"
+			  "\x28\xf1\x03\x2d\x38\x1a\x1c\x44"
+			  "\xb3\xf7\x35\x5f\xc8\xd1\xdb\xff"
+			  "\x3e\xc6\x65\x19\x06\xfc\x94\x80"
+			  "\x4f\xf5\xea\x33\x39\x02\x6a\x4d"
+			  "\x0e\xa6\x57\xe9\xf6\x38\x32\x0a"
+			  "\x9f\x97\x42\xb4\x23\x0e\xc8\x9d"
+			  "\x32\xdc\xb5\x5a\x94\x8d\x64\xd6"
+			  "\x4d\xcc\x42\xd0\xd8\xf6\x0b\x02"
+			  "\xb3\x51\x37\x46\x61\x59\x58\x00"
+			  "\x8c\x89\xa9\xbb\x00\x09\x4f\x1f"
+			  "\x57\xa1\xf5\x25\x14\x69\x4d\x22"
+			  "\x76\xa7\x5f\x7e\x12\xb5\x51\x5c"
+			  "\x1a\xc6\x54\x95\x7c\x7c\xa3\x6e"
+			  "\xba\xac\xa3\x2f\x13\xcb\x96\xd7"
+			  "\x4f\x45\xd4\xb4\x97\x73\xe4\x43",
+		.klen	=3D 32,
+		.len	=3D 512,
+	},
+};
+
 #endif	/* _CRYPTO_TESTMGR_H */
--=20
2.35.1.265.g69c8d7142f-goog

