Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728415AbeLNLUW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Dec 2018 06:20:22 -0500
From: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srikanth Jampala" <jsrikanth@marvell.com>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Added AEAD cipher support
Date: Fri, 14 Dec 2018 11:19:51 +0000
Message-ID: <20181214111856.32030-1-rnagadheeraj@marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Added support to offload AEAD ciphers to NITROX. Currently supported
AEAD cipher is 'gcm(aes)'.

Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/Makefile          |   4 +-
 drivers/crypto/cavium/nitrox/nitrox_aead.c     | 364 ++++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_algs.c     | 559 +--------------------=
----
 drivers/crypto/cavium/nitrox/nitrox_common.h   |   6 +-
 drivers/crypto/cavium/nitrox/nitrox_req.h      | 239 +++++++++--
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c   |  38 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 498 +++++++++++++++++++++=
+
 7 files changed, 1103 insertions(+), 605 deletions(-)
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_aead.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_skcipher.c

diff --git a/drivers/crypto/cavium/nitrox/Makefile b/drivers/crypto/cavium/=
nitrox/Makefile
index ad0546630ad8..f83991aaf820 100644
--- a/drivers/crypto/cavium/nitrox/Makefile
+++ b/drivers/crypto/cavium/nitrox/Makefile
@@ -7,7 +7,9 @@ n5pf-objs :=3D nitrox_main.o \
 	nitrox_hal.o \
 	nitrox_reqmgr.o \
 	nitrox_algs.o	\
-	nitrox_mbx.o
+	nitrox_mbx.o	\
+	nitrox_skcipher.o \
+	nitrox_aead.o
=20
 n5pf-$(CONFIG_PCI_IOV) +=3D nitrox_sriov.o
 n5pf-$(CONFIG_DEBUG_FS) +=3D nitrox_debugfs.o
diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/ca=
vium/nitrox/nitrox_aead.c
new file mode 100644
index 000000000000..4f43eacd2557
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -0,0 +1,364 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/crypto.h>
+#include <linux/rtnetlink.h>
+
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/des.h>
+#include <crypto/sha.h>
+#include <crypto/internal/aead.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/gcm.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_common.h"
+#include "nitrox_req.h"
+
+#define GCM_AES_SALT_SIZE	4
+
+/**
+ * struct nitrox_crypt_params - Params to set nitrox crypto request.
+ * @cryptlen: Encryption/Decryption data length
+ * @authlen: Assoc data length + Cryptlen
+ * @srclen: Input buffer length
+ * @dstlen: Output buffer length
+ * @iv: IV data
+ * @ivsize: IV data length
+ * @ctrl_arg: Identifies the request type (ENCRYPT/DECRYPT)
+ */
+struct nitrox_crypt_params {
+	unsigned int cryptlen;
+	unsigned int authlen;
+	unsigned int srclen;
+	unsigned int dstlen;
+	u8 *iv;
+	int ivsize;
+	u8 ctrl_arg;
+};
+
+union gph_p3 {
+	struct {
+#ifdef __BIG_ENDIAN_BITFIELD
+		u16 iv_offset : 8;
+		u16 auth_offset	: 8;
+#else
+		u16 auth_offset	: 8;
+		u16 iv_offset : 8;
+#endif
+	};
+	u16 param;
+};
+
+static int nitrox_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
+				 unsigned int keylen)
+{
+	int aes_keylen;
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct flexi_crypto_context *fctx;
+	union fc_ctx_flags flags;
+
+	aes_keylen =3D flexi_aes_keylen(keylen);
+	if (aes_keylen < 0) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	/* fill crypto context */
+	fctx =3D nctx->u.fctx;
+	flags.f =3D be64_to_cpu(fctx->flags.f);
+	flags.w0.aes_keylen =3D aes_keylen;
+	fctx->flags.f =3D cpu_to_be64(flags.f);
+
+	/* copy enc key to context */
+	memset(&fctx->crypto, 0, sizeof(fctx->crypto));
+	memcpy(fctx->crypto.u.key, key, keylen);
+
+	return 0;
+}
+
+static int nitrox_aead_setauthsize(struct crypto_aead *aead,
+				   unsigned int authsize)
+{
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
+	union fc_ctx_flags flags;
+
+	flags.f =3D be64_to_cpu(fctx->flags.f);
+	flags.w0.mac_len =3D authsize;
+	fctx->flags.f =3D cpu_to_be64(flags.f);
+
+	aead->authsize =3D authsize;
+
+	return 0;
+}
+
+static int alloc_src_sglist(struct aead_request *areq, char *iv, int ivsiz=
e,
+			    int buflen)
+{
+	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
+	int nents =3D sg_nents_for_len(areq->src, buflen) + 1;
+	int ret;
+
+	if (nents < 0)
+		return nents;
+
+	/* Allocate buffer to hold IV and input scatterlist array */
+	ret =3D alloc_src_req_buf(nkreq, nents, ivsize);
+	if (ret)
+		return ret;
+
+	nitrox_creq_copy_iv(nkreq->src, iv, ivsize);
+	nitrox_creq_set_src_sg(nkreq, nents, ivsize, areq->src, buflen);
+
+	return 0;
+}
+
+static int alloc_dst_sglist(struct aead_request *areq, int ivsize, int buf=
len)
+{
+	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
+	int nents =3D sg_nents_for_len(areq->dst, buflen) + 3;
+	int ret;
+
+	if (nents < 0)
+		return nents;
+
+	/* Allocate buffer to hold ORH, COMPLETION and output scatterlist
+	 * array
+	 */
+	ret =3D alloc_dst_req_buf(nkreq, nents);
+	if (ret)
+		return ret;
+
+	nitrox_creq_set_orh(nkreq);
+	nitrox_creq_set_comp(nkreq);
+	nitrox_creq_set_dst_sg(nkreq, nents, ivsize, areq->dst, buflen);
+
+	return 0;
+}
+
+static void free_src_sglist(struct aead_request *areq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
+
+	kfree(nkreq->src);
+}
+
+static void free_dst_sglist(struct aead_request *areq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
+
+	kfree(nkreq->dst);
+}
+
+static int nitrox_set_creq(struct aead_request *areq,
+			   struct nitrox_crypt_params *params)
+{
+	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
+	struct se_crypto_request *creq =3D &nkreq->creq;
+	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
+	union gph_p3 param3;
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	int ret;
+
+	creq->flags =3D areq->base.flags;
+	creq->gfp =3D (areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		GFP_KERNEL : GFP_ATOMIC;
+
+	creq->ctrl.value =3D 0;
+	creq->opcode =3D FLEXI_CRYPTO_ENCRYPT_HMAC;
+	creq->ctrl.s.arg =3D params->ctrl_arg;
+
+	creq->gph.param0 =3D cpu_to_be16(params->cryptlen);
+	creq->gph.param1 =3D cpu_to_be16(params->authlen);
+	creq->gph.param2 =3D cpu_to_be16(params->ivsize + areq->assoclen);
+	param3.iv_offset =3D 0;
+	param3.auth_offset =3D params->ivsize;
+	creq->gph.param3 =3D cpu_to_be16(param3.param);
+
+	creq->ctx_handle =3D nctx->u.ctx_handle;
+	creq->ctrl.s.ctxl =3D sizeof(struct flexi_crypto_context);
+
+	ret =3D alloc_src_sglist(areq, params->iv, params->ivsize,
+			       params->srclen);
+	if (ret)
+		return ret;
+
+	ret =3D alloc_dst_sglist(areq, params->ivsize, params->dstlen);
+	if (ret) {
+		free_src_sglist(areq);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void nitrox_aead_callback(void *arg, int err)
+{
+	struct aead_request *areq =3D arg;
+
+	free_src_sglist(areq);
+	free_dst_sglist(areq);
+	if (err) {
+		pr_err_ratelimited("request failed status 0x%0x\n", err);
+		err =3D -EINVAL;
+	}
+
+	areq->base.complete(&areq->base, err);
+}
+
+static int nitrox_aes_gcm_enc(struct aead_request *areq)
+{
+	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
+	struct se_crypto_request *creq =3D &nkreq->creq;
+	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
+	struct nitrox_crypt_params params;
+	int ret;
+
+	memcpy(fctx->crypto.iv, areq->iv, GCM_AES_SALT_SIZE);
+
+	memset(&params, 0, sizeof(params));
+	params.cryptlen =3D areq->cryptlen;
+	params.authlen =3D areq->assoclen + params.cryptlen;
+	params.srclen =3D params.authlen;
+	params.dstlen =3D params.srclen + aead->authsize;
+	params.iv =3D &areq->iv[GCM_AES_SALT_SIZE];
+	params.ivsize =3D GCM_AES_IV_SIZE - GCM_AES_SALT_SIZE;
+	params.ctrl_arg =3D ENCRYPT;
+	ret =3D nitrox_set_creq(areq, &params);
+	if (ret)
+		return ret;
+
+	/* send the crypto request */
+	return nitrox_process_se_request(nctx->ndev, creq, nitrox_aead_callback,
+					 areq);
+}
+
+static int nitrox_aes_gcm_dec(struct aead_request *areq)
+{
+	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
+	struct se_crypto_request *creq =3D &nkreq->creq;
+	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
+	struct nitrox_crypt_params params;
+	int ret;
+
+	memcpy(fctx->crypto.iv, areq->iv, GCM_AES_SALT_SIZE);
+
+	memset(&params, 0, sizeof(params));
+	params.cryptlen =3D areq->cryptlen - aead->authsize;
+	params.authlen =3D areq->assoclen + params.cryptlen;
+	params.srclen =3D areq->cryptlen + areq->assoclen;
+	params.dstlen =3D params.srclen - aead->authsize;
+	params.iv =3D &areq->iv[GCM_AES_SALT_SIZE];
+	params.ivsize =3D GCM_AES_IV_SIZE - GCM_AES_SALT_SIZE;
+	params.ctrl_arg =3D DECRYPT;
+	ret =3D nitrox_set_creq(areq, &params);
+	if (ret)
+		return ret;
+
+	/* send the crypto request */
+	return nitrox_process_se_request(nctx->ndev, creq, nitrox_aead_callback,
+					 areq);
+}
+
+static int nitrox_aead_init(struct crypto_aead *aead)
+{
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct crypto_ctx_hdr *chdr;
+
+	/* get the first device */
+	nctx->ndev =3D nitrox_get_first_device();
+	if (!nctx->ndev)
+		return -ENODEV;
+
+	/* allocate nitrox crypto context */
+	chdr =3D crypto_alloc_context(nctx->ndev);
+	if (!chdr) {
+		nitrox_put_device(nctx->ndev);
+		return -ENOMEM;
+	}
+	nctx->chdr =3D chdr;
+	nctx->u.ctx_handle =3D (uintptr_t)((u8 *)chdr->vaddr +
+					 sizeof(struct ctx_hdr));
+	nctx->u.fctx->flags.f =3D 0;
+
+	return 0;
+}
+
+static int nitrox_aes_gcm_init(struct crypto_aead *aead)
+{
+	int ret;
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	union fc_ctx_flags *flags;
+
+	ret =3D nitrox_aead_init(aead);
+	if (ret)
+		return ret;
+
+	flags =3D &nctx->u.fctx->flags;
+	flags->w0.cipher_type =3D CIPHER_AES_GCM;
+	flags->w0.hash_type =3D AUTH_NULL;
+	flags->w0.iv_source =3D IV_FROM_DPTR;
+	/* ask microcode to calculate ipad/opad */
+	flags->w0.auth_input_type =3D 1;
+	flags->f =3D be64_to_cpu(flags->f);
+
+	crypto_aead_set_reqsize(aead, sizeof(struct aead_request) +
+				sizeof(struct nitrox_kcrypt_request));
+
+	return 0;
+}
+
+static void nitrox_aead_exit(struct crypto_aead *aead)
+{
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+
+	/* free the nitrox crypto context */
+	if (nctx->u.ctx_handle) {
+		struct flexi_crypto_context *fctx =3D nctx->u.fctx;
+
+		memzero_explicit(&fctx->crypto, sizeof(struct crypto_keys));
+		memzero_explicit(&fctx->auth, sizeof(struct auth_keys));
+		crypto_free_context((void *)nctx->chdr);
+	}
+	nitrox_put_device(nctx->ndev);
+
+	nctx->u.ctx_handle =3D 0;
+	nctx->ndev =3D NULL;
+}
+
+static struct aead_alg nitrox_aeads[] =3D { {
+	.base =3D {
+		.cra_name =3D "gcm(aes)",
+		.cra_driver_name =3D "n5_aes_gcm",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.setkey =3D nitrox_aes_gcm_setkey,
+	.setauthsize =3D nitrox_aead_setauthsize,
+	.encrypt =3D nitrox_aes_gcm_enc,
+	.decrypt =3D nitrox_aes_gcm_dec,
+	.init =3D nitrox_aes_gcm_init,
+	.exit =3D nitrox_aead_exit,
+	.ivsize =3D GCM_AES_IV_SIZE,
+	.maxauthsize =3D AES_BLOCK_SIZE,
+} };
+
+int nitrox_register_aeads(void)
+{
+	return crypto_register_aeads(nitrox_aeads, ARRAY_SIZE(nitrox_aeads));
+}
+
+void nitrox_unregister_aeads(void)
+{
+	crypto_unregister_aeads(nitrox_aeads, ARRAY_SIZE(nitrox_aeads));
+}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_algs.c b/drivers/crypto/ca=
vium/nitrox/nitrox_algs.c
index 10075a97ff0d..d646ae5f29b0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_algs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_algs.c
@@ -1,561 +1,24 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/crypto.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/printk.h>
-
-#include <crypto/aes.h>
-#include <crypto/skcipher.h>
-#include <crypto/ctr.h>
-#include <crypto/des.h>
-#include <crypto/xts.h>
-
-#include "nitrox_dev.h"
 #include "nitrox_common.h"
-#include "nitrox_req.h"
-
-#define PRIO 4001
-
-struct nitrox_cipher {
-	const char *name;
-	enum flexi_cipher value;
-};
-
-/**
- * supported cipher list
- */
-static const struct nitrox_cipher flexi_cipher_table[] =3D {
-	{ "null",		CIPHER_NULL },
-	{ "cbc(des3_ede)",	CIPHER_3DES_CBC },
-	{ "ecb(des3_ede)",	CIPHER_3DES_ECB },
-	{ "cbc(aes)",		CIPHER_AES_CBC },
-	{ "ecb(aes)",		CIPHER_AES_ECB },
-	{ "cfb(aes)",		CIPHER_AES_CFB },
-	{ "rfc3686(ctr(aes))",	CIPHER_AES_CTR },
-	{ "xts(aes)",		CIPHER_AES_XTS },
-	{ "cts(cbc(aes))",	CIPHER_AES_CBC_CTS },
-	{ NULL,			CIPHER_INVALID }
-};
-
-static enum flexi_cipher flexi_cipher_type(const char *name)
-{
-	const struct nitrox_cipher *cipher =3D flexi_cipher_table;
-
-	while (cipher->name) {
-		if (!strcmp(cipher->name, name))
-			break;
-		cipher++;
-	}
-	return cipher->value;
-}
-
-static int flexi_aes_keylen(int keylen)
-{
-	int aes_keylen;
-
-	switch (keylen) {
-	case AES_KEYSIZE_128:
-		aes_keylen =3D 1;
-		break;
-	case AES_KEYSIZE_192:
-		aes_keylen =3D 2;
-		break;
-	case AES_KEYSIZE_256:
-		aes_keylen =3D 3;
-		break;
-	default:
-		aes_keylen =3D -EINVAL;
-		break;
-	}
-	return aes_keylen;
-}
-
-static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
-{
-	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
-	struct crypto_ctx_hdr *chdr;
-
-	/* get the first device */
-	nctx->ndev =3D nitrox_get_first_device();
-	if (!nctx->ndev)
-		return -ENODEV;
-
-	/* allocate nitrox crypto context */
-	chdr =3D crypto_alloc_context(nctx->ndev);
-	if (!chdr) {
-		nitrox_put_device(nctx->ndev);
-		return -ENOMEM;
-	}
-	nctx->chdr =3D chdr;
-	nctx->u.ctx_handle =3D (uintptr_t)((u8 *)chdr->vaddr +
-					 sizeof(struct ctx_hdr));
-	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(tfm) +
-				    sizeof(struct nitrox_kcrypt_request));
-	return 0;
-}
-
-static void nitrox_skcipher_exit(struct crypto_skcipher *tfm)
-{
-	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
-
-	/* free the nitrox crypto context */
-	if (nctx->u.ctx_handle) {
-		struct flexi_crypto_context *fctx =3D nctx->u.fctx;
-
-		memset(&fctx->crypto, 0, sizeof(struct crypto_keys));
-		memset(&fctx->auth, 0, sizeof(struct auth_keys));
-		crypto_free_context((void *)nctx->chdr);
-	}
-	nitrox_put_device(nctx->ndev);
-
-	nctx->u.ctx_handle =3D 0;
-	nctx->ndev =3D NULL;
-}
-
-static inline int nitrox_skcipher_setkey(struct crypto_skcipher *cipher,
-					 int aes_keylen, const u8 *key,
-					 unsigned int keylen)
-{
-	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(cipher);
-	struct nitrox_crypto_ctx *nctx =3D crypto_tfm_ctx(tfm);
-	struct flexi_crypto_context *fctx;
-	enum flexi_cipher cipher_type;
-	const char *name;
-
-	name =3D crypto_tfm_alg_name(tfm);
-	cipher_type =3D flexi_cipher_type(name);
-	if (unlikely(cipher_type =3D=3D CIPHER_INVALID)) {
-		pr_err("unsupported cipher: %s\n", name);
-		return -EINVAL;
-	}
-
-	/* fill crypto context */
-	fctx =3D nctx->u.fctx;
-	fctx->flags =3D 0;
-	fctx->w0.cipher_type =3D cipher_type;
-	fctx->w0.aes_keylen =3D aes_keylen;
-	fctx->w0.iv_source =3D IV_FROM_DPTR;
-	fctx->flags =3D cpu_to_be64(*(u64 *)&fctx->w0);
-	/* copy the key to context */
-	memcpy(fctx->crypto.u.key, key, keylen);
-
-	return 0;
-}
-
-static int nitrox_aes_setkey(struct crypto_skcipher *cipher, const u8 *key=
,
-			     unsigned int keylen)
-{
-	int aes_keylen;
-
-	aes_keylen =3D flexi_aes_keylen(keylen);
-	if (aes_keylen < 0) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
-}
-
-static int alloc_src_sglist(struct skcipher_request *skreq, int ivsize)
-{
-	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
-	int nents =3D sg_nents(skreq->src) + 1;
-	struct se_crypto_request *creq =3D &nkreq->creq;
-	char *iv;
-	struct scatterlist *sg;
-
-	/* Allocate buffer to hold IV and input scatterlist array */
-	nkreq->src =3D alloc_req_buf(nents, ivsize, creq->gfp);
-	if (!nkreq->src)
-		return -ENOMEM;
-
-	/* copy iv */
-	iv =3D nkreq->src;
-	memcpy(iv, skreq->iv, ivsize);
-
-	sg =3D (struct scatterlist *)(iv + ivsize);
-	creq->src =3D sg;
-	sg_init_table(sg, nents);
-
-	/* Input format:
-	 * +----+----------------+
-	 * | IV | SRC sg entries |
-	 * +----+----------------+
-	 */
-
-	/* IV */
-	sg =3D create_single_sg(sg, iv, ivsize);
-	/* SRC entries */
-	create_multi_sg(sg, skreq->src);
-
-	return 0;
-}
-
-static int alloc_dst_sglist(struct skcipher_request *skreq, int ivsize)
-{
-	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
-	int nents =3D sg_nents(skreq->dst) + 3;
-	int extralen =3D ORH_HLEN + COMP_HLEN;
-	struct se_crypto_request *creq =3D &nkreq->creq;
-	struct scatterlist *sg;
-	char *iv =3D nkreq->src;
-
-	/* Allocate buffer to hold ORH, COMPLETION and output scatterlist
-	 * array
-	 */
-	nkreq->dst =3D alloc_req_buf(nents, extralen, creq->gfp);
-	if (!nkreq->dst)
-		return -ENOMEM;
-
-	creq->orh =3D (u64 *)(nkreq->dst);
-	set_orh_value(creq->orh);
-
-	creq->comp =3D (u64 *)(nkreq->dst + ORH_HLEN);
-	set_comp_value(creq->comp);
-
-	sg =3D (struct scatterlist *)(nkreq->dst + ORH_HLEN + COMP_HLEN);
-	creq->dst =3D sg;
-	sg_init_table(sg, nents);
-
-	/* Output format:
-	 * +-----+----+----------------+-----------------+
-	 * | ORH | IV | DST sg entries | COMPLETION Bytes|
-	 * +-----+----+----------------+-----------------+
-	 */
-
-	/* ORH */
-	sg =3D create_single_sg(sg, creq->orh, ORH_HLEN);
-	/* IV */
-	sg =3D create_single_sg(sg, iv, ivsize);
-	/* DST entries */
-	sg =3D create_multi_sg(sg, skreq->dst);
-	/* COMPLETION Bytes */
-	create_single_sg(sg, creq->comp, COMP_HLEN);
-
-	return 0;
-}
-
-static void free_src_sglist(struct skcipher_request *skreq)
-{
-	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
-
-	kfree(nkreq->src);
-}
=20
-static void free_dst_sglist(struct skcipher_request *skreq)
+int nitrox_crypto_register(void)
 {
-	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	int err;
=20
-	kfree(nkreq->dst);
-}
+	err =3D nitrox_register_skciphers();
+	if (err)
+		return err;
=20
-static void nitrox_skcipher_callback(struct skcipher_request *skreq,
-				     int err)
-{
-	free_src_sglist(skreq);
-	free_dst_sglist(skreq);
+	err =3D nitrox_register_aeads();
 	if (err) {
-		pr_err_ratelimited("request failed status 0x%0x\n", err);
-		err =3D -EINVAL;
-	}
-
-	skcipher_request_complete(skreq, err);
-}
-
-static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
-{
-	struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(skreq);
-	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(cipher);
-	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
-	int ivsize =3D crypto_skcipher_ivsize(cipher);
-	struct se_crypto_request *creq;
-	int ret;
-
-	creq =3D &nkreq->creq;
-	creq->flags =3D skreq->base.flags;
-	creq->gfp =3D (skreq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		     GFP_KERNEL : GFP_ATOMIC;
-
-	/* fill the request */
-	creq->ctrl.value =3D 0;
-	creq->opcode =3D FLEXI_CRYPTO_ENCRYPT_HMAC;
-	creq->ctrl.s.arg =3D (enc ? ENCRYPT : DECRYPT);
-	/* param0: length of the data to be encrypted */
-	creq->gph.param0 =3D cpu_to_be16(skreq->cryptlen);
-	creq->gph.param1 =3D 0;
-	/* param2: encryption data offset */
-	creq->gph.param2 =3D cpu_to_be16(ivsize);
-	creq->gph.param3 =3D 0;
-
-	creq->ctx_handle =3D nctx->u.ctx_handle;
-	creq->ctrl.s.ctxl =3D sizeof(struct flexi_crypto_context);
-
-	ret =3D alloc_src_sglist(skreq, ivsize);
-	if (ret)
-		return ret;
-
-	ret =3D alloc_dst_sglist(skreq, ivsize);
-	if (ret) {
-		free_src_sglist(skreq);
-		return ret;
-	}
-
-	nkreq->nctx =3D nctx;
-	nkreq->skreq =3D skreq;
-
-	/* send the crypto request */
-	return nitrox_process_se_request(nctx->ndev, creq,
-					 nitrox_skcipher_callback, skreq);
-}
-
-static int nitrox_aes_encrypt(struct skcipher_request *skreq)
-{
-	return nitrox_skcipher_crypt(skreq, true);
-}
-
-static int nitrox_aes_decrypt(struct skcipher_request *skreq)
-{
-	return nitrox_skcipher_crypt(skreq, false);
-}
-
-static int nitrox_3des_setkey(struct crypto_skcipher *cipher,
-			      const u8 *key, unsigned int keylen)
-{
-	if (keylen !=3D DES3_EDE_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	return nitrox_skcipher_setkey(cipher, 0, key, keylen);
-}
-
-static int nitrox_3des_encrypt(struct skcipher_request *skreq)
-{
-	return nitrox_skcipher_crypt(skreq, true);
-}
-
-static int nitrox_3des_decrypt(struct skcipher_request *skreq)
-{
-	return nitrox_skcipher_crypt(skreq, false);
-}
-
-static int nitrox_aes_xts_setkey(struct crypto_skcipher *cipher,
-				 const u8 *key, unsigned int keylen)
-{
-	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(cipher);
-	struct nitrox_crypto_ctx *nctx =3D crypto_tfm_ctx(tfm);
-	struct flexi_crypto_context *fctx;
-	int aes_keylen, ret;
-
-	ret =3D xts_check_key(tfm, key, keylen);
-	if (ret)
-		return ret;
-
-	keylen /=3D 2;
-
-	aes_keylen =3D flexi_aes_keylen(keylen);
-	if (aes_keylen < 0) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
+		nitrox_unregister_skciphers();
+		return err;
 	}
=20
-	fctx =3D nctx->u.fctx;
-	/* copy KEY2 */
-	memcpy(fctx->auth.u.key2, (key + keylen), keylen);
-
-	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
-}
-
-static int nitrox_aes_ctr_rfc3686_setkey(struct crypto_skcipher *cipher,
-					 const u8 *key, unsigned int keylen)
-{
-	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(cipher);
-	struct nitrox_crypto_ctx *nctx =3D crypto_tfm_ctx(tfm);
-	struct flexi_crypto_context *fctx;
-	int aes_keylen;
-
-	if (keylen < CTR_RFC3686_NONCE_SIZE)
-		return -EINVAL;
-
-	fctx =3D nctx->u.fctx;
-
-	memcpy(fctx->crypto.iv, key + (keylen - CTR_RFC3686_NONCE_SIZE),
-	       CTR_RFC3686_NONCE_SIZE);
-
-	keylen -=3D CTR_RFC3686_NONCE_SIZE;
-
-	aes_keylen =3D flexi_aes_keylen(keylen);
-	if (aes_keylen < 0) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
-}
-
-static struct skcipher_alg nitrox_skciphers[] =3D { {
-	.base =3D {
-		.cra_name =3D "cbc(aes)",
-		.cra_driver_name =3D "n5_cbc(aes)",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D AES_BLOCK_SIZE,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D AES_MIN_KEY_SIZE,
-	.max_keysize =3D AES_MAX_KEY_SIZE,
-	.ivsize =3D AES_BLOCK_SIZE,
-	.setkey =3D nitrox_aes_setkey,
-	.encrypt =3D nitrox_aes_encrypt,
-	.decrypt =3D nitrox_aes_decrypt,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-}, {
-	.base =3D {
-		.cra_name =3D "ecb(aes)",
-		.cra_driver_name =3D "n5_ecb(aes)",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D AES_BLOCK_SIZE,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D AES_MIN_KEY_SIZE,
-	.max_keysize =3D AES_MAX_KEY_SIZE,
-	.ivsize =3D AES_BLOCK_SIZE,
-	.setkey =3D nitrox_aes_setkey,
-	.encrypt =3D nitrox_aes_encrypt,
-	.decrypt =3D nitrox_aes_decrypt,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-}, {
-	.base =3D {
-		.cra_name =3D "cfb(aes)",
-		.cra_driver_name =3D "n5_cfb(aes)",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D AES_BLOCK_SIZE,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D AES_MIN_KEY_SIZE,
-	.max_keysize =3D AES_MAX_KEY_SIZE,
-	.ivsize =3D AES_BLOCK_SIZE,
-	.setkey =3D nitrox_aes_setkey,
-	.encrypt =3D nitrox_aes_encrypt,
-	.decrypt =3D nitrox_aes_decrypt,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-}, {
-	.base =3D {
-		.cra_name =3D "xts(aes)",
-		.cra_driver_name =3D "n5_xts(aes)",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D AES_BLOCK_SIZE,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D 2 * AES_MIN_KEY_SIZE,
-	.max_keysize =3D 2 * AES_MAX_KEY_SIZE,
-	.ivsize =3D AES_BLOCK_SIZE,
-	.setkey =3D nitrox_aes_xts_setkey,
-	.encrypt =3D nitrox_aes_encrypt,
-	.decrypt =3D nitrox_aes_decrypt,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-}, {
-	.base =3D {
-		.cra_name =3D "rfc3686(ctr(aes))",
-		.cra_driver_name =3D "n5_rfc3686(ctr(aes))",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D 1,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-	.max_keysize =3D AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-	.ivsize =3D CTR_RFC3686_IV_SIZE,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-	.setkey =3D nitrox_aes_ctr_rfc3686_setkey,
-	.encrypt =3D nitrox_aes_encrypt,
-	.decrypt =3D nitrox_aes_decrypt,
-}, {
-	.base =3D {
-		.cra_name =3D "cts(cbc(aes))",
-		.cra_driver_name =3D "n5_cts(cbc(aes))",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D AES_BLOCK_SIZE,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_type =3D &crypto_ablkcipher_type,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D AES_MIN_KEY_SIZE,
-	.max_keysize =3D AES_MAX_KEY_SIZE,
-	.ivsize =3D AES_BLOCK_SIZE,
-	.setkey =3D nitrox_aes_setkey,
-	.encrypt =3D nitrox_aes_encrypt,
-	.decrypt =3D nitrox_aes_decrypt,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-}, {
-	.base =3D {
-		.cra_name =3D "cbc(des3_ede)",
-		.cra_driver_name =3D "n5_cbc(des3_ede)",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D DES3_EDE_KEY_SIZE,
-	.max_keysize =3D DES3_EDE_KEY_SIZE,
-	.ivsize =3D DES3_EDE_BLOCK_SIZE,
-	.setkey =3D nitrox_3des_setkey,
-	.encrypt =3D nitrox_3des_encrypt,
-	.decrypt =3D nitrox_3des_decrypt,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-}, {
-	.base =3D {
-		.cra_name =3D "ecb(des3_ede)",
-		.cra_driver_name =3D "n5_ecb(des3_ede)",
-		.cra_priority =3D PRIO,
-		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
-		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask =3D 0,
-		.cra_module =3D THIS_MODULE,
-	},
-	.min_keysize =3D DES3_EDE_KEY_SIZE,
-	.max_keysize =3D DES3_EDE_KEY_SIZE,
-	.ivsize =3D DES3_EDE_BLOCK_SIZE,
-	.setkey =3D nitrox_3des_setkey,
-	.encrypt =3D nitrox_3des_encrypt,
-	.decrypt =3D nitrox_3des_decrypt,
-	.init =3D nitrox_skcipher_init,
-	.exit =3D nitrox_skcipher_exit,
-}
-
-};
-
-int nitrox_crypto_register(void)
-{
-	return crypto_register_skciphers(nitrox_skciphers,
-					 ARRAY_SIZE(nitrox_skciphers));
+	return 0;
 }
=20
 void nitrox_crypto_unregister(void)
 {
-	crypto_unregister_skciphers(nitrox_skciphers,
-				    ARRAY_SIZE(nitrox_skciphers));
+	nitrox_unregister_aeads();
+	nitrox_unregister_skciphers();
 }
diff --git a/drivers/crypto/cavium/nitrox/nitrox_common.h b/drivers/crypto/=
cavium/nitrox/nitrox_common.h
index 863143a8336b..e4be69d7e6e5 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_common.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_common.h
@@ -7,6 +7,10 @@
=20
 int nitrox_crypto_register(void);
 void nitrox_crypto_unregister(void);
+int nitrox_register_aeads(void);
+void nitrox_unregister_aeads(void);
+int nitrox_register_skciphers(void);
+void nitrox_unregister_skciphers(void);
 void *crypto_alloc_context(struct nitrox_device *ndev);
 void crypto_free_context(void *ctx);
 struct nitrox_device *nitrox_get_first_device(void);
@@ -19,7 +23,7 @@ void pkt_slc_resp_tasklet(unsigned long data);
 int nitrox_process_se_request(struct nitrox_device *ndev,
 			      struct se_crypto_request *req,
 			      completion_t cb,
-			      struct skcipher_request *skreq);
+			      void *cb_arg);
 void backlog_qflush_work(struct work_struct *work);
=20
=20
diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cav=
ium/nitrox/nitrox_req.h
index d45ff91c19a9..76c0f0be7233 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -8,6 +8,7 @@
 #include "nitrox_dev.h"
=20
 #define PENDING_SIG	0xFFFFFFFFFFFFFFFFUL
+#define PRIO 4001
=20
 /**
  * struct gphdr - General purpose Header
@@ -106,6 +107,18 @@ enum flexi_cipher {
 	CIPHER_INVALID
 };
=20
+enum flexi_auth {
+	AUTH_NULL =3D 0,
+	AUTH_MD5,
+	AUTH_SHA1,
+	AUTH_SHA2_SHA224,
+	AUTH_SHA2_SHA256,
+	AUTH_SHA2_SHA384,
+	AUTH_SHA2_SHA512,
+	AUTH_GMAC,
+	AUTH_INVALID
+};
+
 /**
  * struct crypto_keys - Crypto keys
  * @key: Encryption key or KEY1 for AES-XTS
@@ -132,6 +145,32 @@ struct auth_keys {
 	u8 opad[64];
 };
=20
+union fc_ctx_flags {
+	__be64 f;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 cipher_type	: 4;
+		u64 reserved_59	: 1;
+		u64 aes_keylen : 2;
+		u64 iv_source : 1;
+		u64 hash_type : 4;
+		u64 reserved_49_51 : 3;
+		u64 auth_input_type: 1;
+		u64 mac_len : 8;
+		u64 reserved_0_39 : 40;
+#else
+		u64 reserved_0_39 : 40;
+		u64 mac_len : 8;
+		u64 auth_input_type: 1;
+		u64 reserved_49_51 : 3;
+		u64 hash_type : 4;
+		u64 iv_source : 1;
+		u64 aes_keylen : 2;
+		u64 reserved_59	: 1;
+		u64 cipher_type	: 4;
+#endif
+	} w0;
+};
 /**
  * struct flexi_crypto_context - Crypto context
  * @cipher_type: Encryption cipher type
@@ -146,33 +185,7 @@ struct auth_keys {
  * @auth: Authentication keys
  */
 struct flexi_crypto_context {
-	union {
-		__be64 flags;
-		struct {
-#if defined(__BIG_ENDIAN_BITFIELD)
-			u64 cipher_type	: 4;
-			u64 reserved_59	: 1;
-			u64 aes_keylen : 2;
-			u64 iv_source : 1;
-			u64 hash_type : 4;
-			u64 reserved_49_51 : 3;
-			u64 auth_input_type: 1;
-			u64 mac_len : 8;
-			u64 reserved_0_39 : 40;
-#else
-			u64 reserved_0_39 : 40;
-			u64 mac_len : 8;
-			u64 auth_input_type: 1;
-			u64 reserved_49_51 : 3;
-			u64 hash_type : 4;
-			u64 iv_source : 1;
-			u64 aes_keylen : 2;
-			u64 reserved_59	: 1;
-			u64 cipher_type	: 4;
-#endif
-		} w0;
-	};
-
+	union fc_ctx_flags flags;
 	struct crypto_keys crypto;
 	struct auth_keys auth;
 };
@@ -194,8 +207,6 @@ struct nitrox_crypto_ctx {
=20
 struct nitrox_kcrypt_request {
 	struct se_crypto_request creq;
-	struct nitrox_crypto_ctx *nctx;
-	struct skcipher_request *skreq;
 	u8 *src;
 	u8 *dst;
 };
@@ -400,7 +411,7 @@ struct resp_hdr {
 	u64 *completion;
 };
=20
-typedef void (*completion_t)(struct skcipher_request *skreq, int err);
+typedef void (*completion_t)(void *arg, int err);
=20
 /**
  * struct nitrox_softreq - Represents the NIROX Request.
@@ -435,9 +446,30 @@ struct nitrox_softreq {
 	unsigned long tstamp;
=20
 	completion_t callback;
-	struct skcipher_request *skreq;
+	void *cb_arg;
 };
=20
+static inline int flexi_aes_keylen(int keylen)
+{
+	int aes_keylen;
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		aes_keylen =3D 1;
+		break;
+	case AES_KEYSIZE_192:
+		aes_keylen =3D 2;
+		break;
+	case AES_KEYSIZE_256:
+		aes_keylen =3D 3;
+		break;
+	default:
+		aes_keylen =3D -EINVAL;
+		break;
+	}
+	return aes_keylen;
+}
+
 static inline void *alloc_req_buf(int nents, int extralen, gfp_t gfp)
 {
 	size_t size;
@@ -448,6 +480,14 @@ static inline void *alloc_req_buf(int nents, int extra=
len, gfp_t gfp)
 	return kzalloc(size, gfp);
 }
=20
+/**
+ * create_single_sg - Point SG entry to the data
+ * @sg:		Destination SG list
+ * @buf:	Data
+ * @buflen:	Data length
+ *
+ * Returns next free entry in the destination SG list
+ **/
 static inline struct scatterlist *create_single_sg(struct scatterlist *sg,
 						   void *buf, int buflen)
 {
@@ -456,18 +496,33 @@ static inline struct scatterlist *create_single_sg(st=
ruct scatterlist *sg,
 	return sg;
 }
=20
+/**
+ * create_multi_sg - Create multiple sg entries with buflen data length fr=
om
+ *		     source sglist
+ * @to_sg:	Destination SG list
+ * @from_sg:	Source SG list
+ * @buflen:	Data length
+ *
+ * Returns next free entry in the destination SG list
+ **/
 static inline struct scatterlist *create_multi_sg(struct scatterlist *to_s=
g,
-						  struct scatterlist *from_sg)
+						  struct scatterlist *from_sg,
+						  int buflen)
 {
-	struct scatterlist *sg;
-	int i;
+	struct scatterlist *sg =3D to_sg;
+	unsigned int sglen;
+
+	for (; buflen; buflen -=3D sglen) {
+		sglen =3D from_sg->length;
+		if (sglen > buflen)
+			sglen =3D buflen;
=20
-	for_each_sg(from_sg, sg, sg_nents(from_sg), i) {
-		sg_set_buf(to_sg, sg_virt(sg), sg->length);
-		to_sg++;
+		sg_set_buf(sg, sg_virt(from_sg), sglen);
+		from_sg =3D sg_next(from_sg);
+		sg++;
 	}
=20
-	return to_sg;
+	return sg;
 }
=20
 static inline void set_orh_value(u64 *orh)
@@ -480,4 +535,112 @@ static inline void set_comp_value(u64 *comp)
 	WRITE_ONCE(*comp, PENDING_SIG);
 }
=20
+static inline int alloc_src_req_buf(struct nitrox_kcrypt_request *nkreq,
+				    int nents, int ivsize)
+{
+	struct se_crypto_request *creq =3D &nkreq->creq;
+
+	nkreq->src =3D alloc_req_buf(nents, ivsize, creq->gfp);
+	if (!nkreq->src)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline void nitrox_creq_copy_iv(char *dst, char *src, int size)
+{
+	memcpy(dst, src, size);
+}
+
+static inline struct scatterlist *nitrox_creq_src_sg(char *iv, int ivsize)
+{
+	return (struct scatterlist *)(iv + ivsize);
+}
+
+static inline void nitrox_creq_set_src_sg(struct nitrox_kcrypt_request *nk=
req,
+					  int nents, int ivsize,
+					  struct scatterlist *src, int buflen)
+{
+	char *iv =3D nkreq->src;
+	struct scatterlist *sg;
+	struct se_crypto_request *creq =3D &nkreq->creq;
+
+	creq->src =3D nitrox_creq_src_sg(iv, ivsize);
+	sg =3D creq->src;
+	sg_init_table(sg, nents);
+
+	/* Input format:
+	 * +----+----------------+
+	 * | IV | SRC sg entries |
+	 * +----+----------------+
+	 */
+
+	/* IV */
+	sg =3D create_single_sg(sg, iv, ivsize);
+	/* SRC entries */
+	create_multi_sg(sg, src, buflen);
+}
+
+static inline int alloc_dst_req_buf(struct nitrox_kcrypt_request *nkreq,
+				    int nents)
+{
+	int extralen =3D ORH_HLEN + COMP_HLEN;
+	struct se_crypto_request *creq =3D &nkreq->creq;
+
+	nkreq->dst =3D alloc_req_buf(nents, extralen, creq->gfp);
+	if (!nkreq->dst)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline void nitrox_creq_set_orh(struct nitrox_kcrypt_request *nkreq=
)
+{
+	struct se_crypto_request *creq =3D &nkreq->creq;
+
+	creq->orh =3D (u64 *)(nkreq->dst);
+	set_orh_value(creq->orh);
+}
+
+static inline void nitrox_creq_set_comp(struct nitrox_kcrypt_request *nkre=
q)
+{
+	struct se_crypto_request *creq =3D &nkreq->creq;
+
+	creq->comp =3D (u64 *)(nkreq->dst + ORH_HLEN);
+	set_comp_value(creq->comp);
+}
+
+static inline struct scatterlist *nitrox_creq_dst_sg(char *dst)
+{
+	return (struct scatterlist *)(dst + ORH_HLEN + COMP_HLEN);
+}
+
+static inline void nitrox_creq_set_dst_sg(struct nitrox_kcrypt_request *nk=
req,
+					  int nents, int ivsize,
+					  struct scatterlist *dst, int buflen)
+{
+	struct se_crypto_request *creq =3D &nkreq->creq;
+	struct scatterlist *sg;
+	char *iv =3D nkreq->src;
+
+	creq->dst =3D nitrox_creq_dst_sg(nkreq->dst);
+	sg =3D creq->dst;
+	sg_init_table(sg, nents);
+
+	/* Output format:
+	 * +-----+----+----------------+-----------------+
+	 * | ORH | IV | DST sg entries | COMPLETION Bytes|
+	 * +-----+----+----------------+-----------------+
+	 */
+
+	/* ORH */
+	sg =3D create_single_sg(sg, creq->orh, ORH_HLEN);
+	/* IV */
+	sg =3D create_single_sg(sg, iv, ivsize);
+	/* DST entries */
+	sg =3D create_multi_sg(sg, dst, buflen);
+	/* COMPLETION Bytes */
+	create_single_sg(sg, creq->comp, COMP_HLEN);
+}
+
 #endif /* __NITROX_REQ_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/=
cavium/nitrox/nitrox_reqmgr.c
index d566bb904ec2..e34e4df8fd24 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -269,6 +269,8 @@ static inline bool cmdq_full(struct nitrox_cmdq *cmdq, =
int qlen)
 		smp_mb__after_atomic();
 		return true;
 	}
+	/* sync with other cpus */
+	smp_mb__after_atomic();
 	return false;
 }
=20
@@ -324,8 +326,6 @@ static int post_backlog_cmds(struct nitrox_cmdq *cmdq)
 	spin_lock_bh(&cmdq->backlog_qlock);
=20
 	list_for_each_entry_safe(sr, tmp, &cmdq->backlog_head, backlog) {
-		struct skcipher_request *skreq;
-
 		/* submit until space available */
 		if (unlikely(cmdq_full(cmdq, ndev->qlen))) {
 			ret =3D -ENOSPC;
@@ -337,12 +337,8 @@ static int post_backlog_cmds(struct nitrox_cmdq *cmdq)
 		/* sync with other cpus */
 		smp_mb__after_atomic();
=20
-		skreq =3D sr->skreq;
 		/* post the command */
 		post_se_instr(sr, cmdq);
-
-		/* backlog requests are posted, wakeup with -EINPROGRESS */
-		skcipher_request_complete(skreq, -EINPROGRESS);
 	}
 	spin_unlock_bh(&cmdq->backlog_qlock);
=20
@@ -365,7 +361,7 @@ static int nitrox_enqueue_request(struct nitrox_softreq=
 *sr)
 		}
 		/* add to backlog list */
 		backlog_list_add(sr, cmdq);
-		return -EBUSY;
+		return -EINPROGRESS;
 	}
 	post_se_instr(sr, cmdq);
=20
@@ -382,7 +378,7 @@ static int nitrox_enqueue_request(struct nitrox_softreq=
 *sr)
 int nitrox_process_se_request(struct nitrox_device *ndev,
 			      struct se_crypto_request *req,
 			      completion_t callback,
-			      struct skcipher_request *skreq)
+			      void *cb_arg)
 {
 	struct nitrox_softreq *sr;
 	dma_addr_t ctx_handle =3D 0;
@@ -399,7 +395,7 @@ int nitrox_process_se_request(struct nitrox_device *nde=
v,
 	sr->flags =3D req->flags;
 	sr->gfp =3D req->gfp;
 	sr->callback =3D callback;
-	sr->skreq =3D skreq;
+	sr->cb_arg =3D cb_arg;
=20
 	atomic_set(&sr->status, REQ_NOT_POSTED);
=20
@@ -513,7 +509,20 @@ void backlog_qflush_work(struct work_struct *work)
=20
 static bool sr_completed(struct nitrox_softreq *sr)
 {
-	return (READ_ONCE(*sr->resp.orh) !=3D READ_ONCE(*sr->resp.completion));
+	u64 orh =3D READ_ONCE(*sr->resp.orh);
+	unsigned long timeout =3D jiffies + msecs_to_jiffies(1);
+
+	if ((orh !=3D PENDING_SIG) && (orh & 0xff))
+		return true;
+
+	while (READ_ONCE(*sr->resp.completion) =3D=3D PENDING_SIG) {
+		if (time_after(jiffies, timeout)) {
+			pr_err("comp not done\n");
+			return false;
+		}
+	}
+
+	return true;
 }
=20
 /**
@@ -527,8 +536,6 @@ static void process_response_list(struct nitrox_cmdq *c=
mdq)
 {
 	struct nitrox_device *ndev =3D cmdq->ndev;
 	struct nitrox_softreq *sr;
-	struct skcipher_request *skreq;
-	completion_t callback;
 	int req_completed =3D 0, err =3D 0, budget;
=20
 	/* check all pending requests */
@@ -558,15 +565,12 @@ static void process_response_list(struct nitrox_cmdq =
*cmdq)
 		/* remove from response list */
 		response_list_del(sr, cmdq);
=20
-		callback =3D sr->callback;
-		skreq =3D sr->skreq;
-
 		/* ORH error code */
 		err =3D READ_ONCE(*sr->resp.orh) & 0xff;
 		softreq_destroy(sr);
=20
-		if (callback)
-			callback(skreq, err);
+		if (sr->callback)
+			sr->callback(sr->cb_arg, err);
=20
 		req_completed++;
 	}
diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypt=
o/cavium/nitrox/nitrox_skcipher.c
new file mode 100644
index 000000000000..d4935d6cefdd
--- /dev/null
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -0,0 +1,498 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+#include <crypto/aes.h>
+#include <crypto/skcipher.h>
+#include <crypto/ctr.h>
+#include <crypto/des.h>
+#include <crypto/xts.h>
+
+#include "nitrox_dev.h"
+#include "nitrox_common.h"
+#include "nitrox_req.h"
+
+struct nitrox_cipher {
+	const char *name;
+	enum flexi_cipher value;
+};
+
+/**
+ * supported cipher list
+ */
+static const struct nitrox_cipher flexi_cipher_table[] =3D {
+	{ "null",		CIPHER_NULL },
+	{ "cbc(des3_ede)",	CIPHER_3DES_CBC },
+	{ "ecb(des3_ede)",	CIPHER_3DES_ECB },
+	{ "cbc(aes)",		CIPHER_AES_CBC },
+	{ "ecb(aes)",		CIPHER_AES_ECB },
+	{ "cfb(aes)",		CIPHER_AES_CFB },
+	{ "rfc3686(ctr(aes))",	CIPHER_AES_CTR },
+	{ "xts(aes)",		CIPHER_AES_XTS },
+	{ "cts(cbc(aes))",	CIPHER_AES_CBC_CTS },
+	{ NULL,			CIPHER_INVALID }
+};
+
+static enum flexi_cipher flexi_cipher_type(const char *name)
+{
+	const struct nitrox_cipher *cipher =3D flexi_cipher_table;
+
+	while (cipher->name) {
+		if (!strcmp(cipher->name, name))
+			break;
+		cipher++;
+	}
+	return cipher->value;
+}
+
+static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
+{
+	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
+	struct crypto_ctx_hdr *chdr;
+
+	/* get the first device */
+	nctx->ndev =3D nitrox_get_first_device();
+	if (!nctx->ndev)
+		return -ENODEV;
+
+	/* allocate nitrox crypto context */
+	chdr =3D crypto_alloc_context(nctx->ndev);
+	if (!chdr) {
+		nitrox_put_device(nctx->ndev);
+		return -ENOMEM;
+	}
+	nctx->chdr =3D chdr;
+	nctx->u.ctx_handle =3D (uintptr_t)((u8 *)chdr->vaddr +
+					 sizeof(struct ctx_hdr));
+	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(tfm) +
+				    sizeof(struct nitrox_kcrypt_request));
+	return 0;
+}
+
+static void nitrox_skcipher_exit(struct crypto_skcipher *tfm)
+{
+	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
+
+	/* free the nitrox crypto context */
+	if (nctx->u.ctx_handle) {
+		struct flexi_crypto_context *fctx =3D nctx->u.fctx;
+
+		memzero_explicit(&fctx->crypto, sizeof(struct crypto_keys));
+		memzero_explicit(&fctx->auth, sizeof(struct auth_keys));
+		crypto_free_context((void *)nctx->chdr);
+	}
+	nitrox_put_device(nctx->ndev);
+
+	nctx->u.ctx_handle =3D 0;
+	nctx->ndev =3D NULL;
+}
+
+static inline int nitrox_skcipher_setkey(struct crypto_skcipher *cipher,
+					 int aes_keylen, const u8 *key,
+					 unsigned int keylen)
+{
+	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(cipher);
+	struct nitrox_crypto_ctx *nctx =3D crypto_tfm_ctx(tfm);
+	struct flexi_crypto_context *fctx;
+	union fc_ctx_flags *flags;
+	enum flexi_cipher cipher_type;
+	const char *name;
+
+	name =3D crypto_tfm_alg_name(tfm);
+	cipher_type =3D flexi_cipher_type(name);
+	if (unlikely(cipher_type =3D=3D CIPHER_INVALID)) {
+		pr_err("unsupported cipher: %s\n", name);
+		return -EINVAL;
+	}
+
+	/* fill crypto context */
+	fctx =3D nctx->u.fctx;
+	flags =3D &fctx->flags;
+	flags->f =3D 0;
+	flags->w0.cipher_type =3D cipher_type;
+	flags->w0.aes_keylen =3D aes_keylen;
+	flags->w0.iv_source =3D IV_FROM_DPTR;
+	flags->f =3D cpu_to_be64(*(u64 *)&flags->w0);
+	/* copy the key to context */
+	memcpy(fctx->crypto.u.key, key, keylen);
+
+	return 0;
+}
+
+static int nitrox_aes_setkey(struct crypto_skcipher *cipher, const u8 *key=
,
+			     unsigned int keylen)
+{
+	int aes_keylen;
+
+	aes_keylen =3D flexi_aes_keylen(keylen);
+	if (aes_keylen < 0) {
+		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
+}
+
+static int alloc_src_sglist(struct skcipher_request *skreq, int ivsize)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	int nents =3D sg_nents(skreq->src) + 1;
+	int ret;
+
+	/* Allocate buffer to hold IV and input scatterlist array */
+	ret =3D alloc_src_req_buf(nkreq, nents, ivsize);
+	if (ret)
+		return ret;
+
+	nitrox_creq_copy_iv(nkreq->src, skreq->iv, ivsize);
+	nitrox_creq_set_src_sg(nkreq, nents, ivsize, skreq->src,
+			       skreq->cryptlen);
+
+	return 0;
+}
+
+static int alloc_dst_sglist(struct skcipher_request *skreq, int ivsize)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	int nents =3D sg_nents(skreq->dst) + 3;
+	int ret;
+
+	/* Allocate buffer to hold ORH, COMPLETION and output scatterlist
+	 * array
+	 */
+	ret =3D alloc_dst_req_buf(nkreq, nents);
+	if (ret)
+		return ret;
+
+	nitrox_creq_set_orh(nkreq);
+	nitrox_creq_set_comp(nkreq);
+	nitrox_creq_set_dst_sg(nkreq, nents, ivsize, skreq->dst,
+			       skreq->cryptlen);
+
+	return 0;
+}
+
+static void free_src_sglist(struct skcipher_request *skreq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+
+	kfree(nkreq->src);
+}
+
+static void free_dst_sglist(struct skcipher_request *skreq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+
+	kfree(nkreq->dst);
+}
+
+static void nitrox_skcipher_callback(void *arg, int err)
+{
+	struct skcipher_request *skreq =3D arg;
+
+	free_src_sglist(skreq);
+	free_dst_sglist(skreq);
+	if (err) {
+		pr_err_ratelimited("request failed status 0x%0x\n", err);
+		err =3D -EINVAL;
+	}
+
+	skcipher_request_complete(skreq, err);
+}
+
+static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
+{
+	struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(skreq);
+	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(cipher);
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	int ivsize =3D crypto_skcipher_ivsize(cipher);
+	struct se_crypto_request *creq;
+	int ret;
+
+	creq =3D &nkreq->creq;
+	creq->flags =3D skreq->base.flags;
+	creq->gfp =3D (skreq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		     GFP_KERNEL : GFP_ATOMIC;
+
+	/* fill the request */
+	creq->ctrl.value =3D 0;
+	creq->opcode =3D FLEXI_CRYPTO_ENCRYPT_HMAC;
+	creq->ctrl.s.arg =3D (enc ? ENCRYPT : DECRYPT);
+	/* param0: length of the data to be encrypted */
+	creq->gph.param0 =3D cpu_to_be16(skreq->cryptlen);
+	creq->gph.param1 =3D 0;
+	/* param2: encryption data offset */
+	creq->gph.param2 =3D cpu_to_be16(ivsize);
+	creq->gph.param3 =3D 0;
+
+	creq->ctx_handle =3D nctx->u.ctx_handle;
+	creq->ctrl.s.ctxl =3D sizeof(struct flexi_crypto_context);
+
+	ret =3D alloc_src_sglist(skreq, ivsize);
+	if (ret)
+		return ret;
+
+	ret =3D alloc_dst_sglist(skreq, ivsize);
+	if (ret) {
+		free_src_sglist(skreq);
+		return ret;
+	}
+
+	/* send the crypto request */
+	return nitrox_process_se_request(nctx->ndev, creq,
+					 nitrox_skcipher_callback, skreq);
+}
+
+static int nitrox_aes_encrypt(struct skcipher_request *skreq)
+{
+	return nitrox_skcipher_crypt(skreq, true);
+}
+
+static int nitrox_aes_decrypt(struct skcipher_request *skreq)
+{
+	return nitrox_skcipher_crypt(skreq, false);
+}
+
+static int nitrox_3des_setkey(struct crypto_skcipher *cipher,
+			      const u8 *key, unsigned int keylen)
+{
+	if (keylen !=3D DES3_EDE_KEY_SIZE) {
+		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	return nitrox_skcipher_setkey(cipher, 0, key, keylen);
+}
+
+static int nitrox_3des_encrypt(struct skcipher_request *skreq)
+{
+	return nitrox_skcipher_crypt(skreq, true);
+}
+
+static int nitrox_3des_decrypt(struct skcipher_request *skreq)
+{
+	return nitrox_skcipher_crypt(skreq, false);
+}
+
+static int nitrox_aes_xts_setkey(struct crypto_skcipher *cipher,
+				 const u8 *key, unsigned int keylen)
+{
+	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(cipher);
+	struct nitrox_crypto_ctx *nctx =3D crypto_tfm_ctx(tfm);
+	struct flexi_crypto_context *fctx;
+	int aes_keylen, ret;
+
+	ret =3D xts_check_key(tfm, key, keylen);
+	if (ret)
+		return ret;
+
+	keylen /=3D 2;
+
+	aes_keylen =3D flexi_aes_keylen(keylen);
+	if (aes_keylen < 0) {
+		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	fctx =3D nctx->u.fctx;
+	/* copy KEY2 */
+	memcpy(fctx->auth.u.key2, (key + keylen), keylen);
+
+	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
+}
+
+static int nitrox_aes_ctr_rfc3686_setkey(struct crypto_skcipher *cipher,
+					 const u8 *key, unsigned int keylen)
+{
+	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(cipher);
+	struct nitrox_crypto_ctx *nctx =3D crypto_tfm_ctx(tfm);
+	struct flexi_crypto_context *fctx;
+	int aes_keylen;
+
+	if (keylen < CTR_RFC3686_NONCE_SIZE)
+		return -EINVAL;
+
+	fctx =3D nctx->u.fctx;
+
+	memcpy(fctx->crypto.iv, key + (keylen - CTR_RFC3686_NONCE_SIZE),
+	       CTR_RFC3686_NONCE_SIZE);
+
+	keylen -=3D CTR_RFC3686_NONCE_SIZE;
+
+	aes_keylen =3D flexi_aes_keylen(keylen);
+	if (aes_keylen < 0) {
+		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
+}
+
+static struct skcipher_alg nitrox_skciphers[] =3D { {
+	.base =3D {
+		.cra_name =3D "cbc(aes)",
+		.cra_driver_name =3D "n5_cbc(aes)",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D AES_MIN_KEY_SIZE,
+	.max_keysize =3D AES_MAX_KEY_SIZE,
+	.ivsize =3D AES_BLOCK_SIZE,
+	.setkey =3D nitrox_aes_setkey,
+	.encrypt =3D nitrox_aes_encrypt,
+	.decrypt =3D nitrox_aes_decrypt,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+}, {
+	.base =3D {
+		.cra_name =3D "ecb(aes)",
+		.cra_driver_name =3D "n5_ecb(aes)",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D AES_MIN_KEY_SIZE,
+	.max_keysize =3D AES_MAX_KEY_SIZE,
+	.ivsize =3D AES_BLOCK_SIZE,
+	.setkey =3D nitrox_aes_setkey,
+	.encrypt =3D nitrox_aes_encrypt,
+	.decrypt =3D nitrox_aes_decrypt,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+}, {
+	.base =3D {
+		.cra_name =3D "cfb(aes)",
+		.cra_driver_name =3D "n5_cfb(aes)",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D AES_MIN_KEY_SIZE,
+	.max_keysize =3D AES_MAX_KEY_SIZE,
+	.ivsize =3D AES_BLOCK_SIZE,
+	.setkey =3D nitrox_aes_setkey,
+	.encrypt =3D nitrox_aes_encrypt,
+	.decrypt =3D nitrox_aes_decrypt,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+}, {
+	.base =3D {
+		.cra_name =3D "xts(aes)",
+		.cra_driver_name =3D "n5_xts(aes)",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D 2 * AES_MIN_KEY_SIZE,
+	.max_keysize =3D 2 * AES_MAX_KEY_SIZE,
+	.ivsize =3D AES_BLOCK_SIZE,
+	.setkey =3D nitrox_aes_xts_setkey,
+	.encrypt =3D nitrox_aes_encrypt,
+	.decrypt =3D nitrox_aes_decrypt,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+}, {
+	.base =3D {
+		.cra_name =3D "rfc3686(ctr(aes))",
+		.cra_driver_name =3D "n5_rfc3686(ctr(aes))",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D 1,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+	.max_keysize =3D AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+	.ivsize =3D CTR_RFC3686_IV_SIZE,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+	.setkey =3D nitrox_aes_ctr_rfc3686_setkey,
+	.encrypt =3D nitrox_aes_encrypt,
+	.decrypt =3D nitrox_aes_decrypt,
+}, {
+	.base =3D {
+		.cra_name =3D "cts(cbc(aes))",
+		.cra_driver_name =3D "n5_cts(cbc(aes))",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_type =3D &crypto_ablkcipher_type,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D AES_MIN_KEY_SIZE,
+	.max_keysize =3D AES_MAX_KEY_SIZE,
+	.ivsize =3D AES_BLOCK_SIZE,
+	.setkey =3D nitrox_aes_setkey,
+	.encrypt =3D nitrox_aes_encrypt,
+	.decrypt =3D nitrox_aes_decrypt,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+}, {
+	.base =3D {
+		.cra_name =3D "cbc(des3_ede)",
+		.cra_driver_name =3D "n5_cbc(des3_ede)",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D DES3_EDE_KEY_SIZE,
+	.max_keysize =3D DES3_EDE_KEY_SIZE,
+	.ivsize =3D DES3_EDE_BLOCK_SIZE,
+	.setkey =3D nitrox_3des_setkey,
+	.encrypt =3D nitrox_3des_encrypt,
+	.decrypt =3D nitrox_3des_decrypt,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+}, {
+	.base =3D {
+		.cra_name =3D "ecb(des3_ede)",
+		.cra_driver_name =3D "n5_ecb(des3_ede)",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.min_keysize =3D DES3_EDE_KEY_SIZE,
+	.max_keysize =3D DES3_EDE_KEY_SIZE,
+	.ivsize =3D DES3_EDE_BLOCK_SIZE,
+	.setkey =3D nitrox_3des_setkey,
+	.encrypt =3D nitrox_3des_encrypt,
+	.decrypt =3D nitrox_3des_decrypt,
+	.init =3D nitrox_skcipher_init,
+	.exit =3D nitrox_skcipher_exit,
+}
+
+};
+
+int nitrox_register_skciphers(void)
+{
+	return crypto_register_skciphers(nitrox_skciphers,
+					 ARRAY_SIZE(nitrox_skciphers));
+}
+
+void nitrox_unregister_skciphers(void)
+{
+	crypto_unregister_skciphers(nitrox_skciphers,
+				    ARRAY_SIZE(nitrox_skciphers));
+}
--=20
2.13.6
