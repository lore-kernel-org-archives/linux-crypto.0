From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] crypto: nx - Convert GCM to new AEAD interface
Date: Mon, 15 Jun 2015 16:09:42 +0800
Message-ID: <E1Z4PSg-00083y-RJ@gondolin.me.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51462 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbbFOIJr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 04:09:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the nx GCM implementations to the new AEAD
interface.  This is compile-tested only.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/nx/nx-aes-gcm.c |  107 ++++++++++++++++++-----------------------
 drivers/crypto/nx/nx.c         |   26 ++++++---
 drivers/crypto/nx/nx.h         |    7 +-
 3 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index e4e64f6..08ac6d4 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -93,14 +93,6 @@ out:
 	return rc;
 }
 
-static int gcm_aes_nx_setauthsize(struct crypto_aead *tfm,
-				  unsigned int authsize)
-{
-	crypto_aead_crt(tfm)->authsize = authsize;
-
-	return 0;
-}
-
 static int gcm4106_aes_nx_setauthsize(struct crypto_aead *tfm,
 				      unsigned int authsize)
 {
@@ -113,8 +105,6 @@ static int gcm4106_aes_nx_setauthsize(struct crypto_aead *tfm,
 		return -EINVAL;
 	}
 
-	crypto_aead_crt(tfm)->authsize = authsize;
-
 	return 0;
 }
 
@@ -131,7 +121,7 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 	unsigned int max_sg_len;
 
 	if (nbytes <= AES_BLOCK_SIZE) {
-		scatterwalk_start(&walk, req->assoc);
+		scatterwalk_start(&walk, req->src);
 		scatterwalk_copychunks(out, &walk, nbytes, SCATTERWALK_FROM_SG);
 		scatterwalk_done(&walk, SCATTERWALK_FROM_SG, 0);
 		return 0;
@@ -156,7 +146,7 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
 		nx_sg = nx_walk_and_build(nx_ctx->in_sg, max_sg_len,
-					  req->assoc, processed, &to_process);
+					  req->src, processed, &to_process);
 
 		if ((to_process + processed) < nbytes)
 			NX_CPB_FDM(csbcpb_aead) |= NX_FDM_INTERMEDIATE;
@@ -222,7 +212,7 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 				   NX_PAGE_SIZE * (max_sg_len - 1));
 
 		nx_sg = nx_walk_and_build(nx_ctx->in_sg, max_sg_len,
-					  req->assoc, processed, &to_process);
+					  req->src, processed, &to_process);
 
 		if ((to_process + processed) < nbytes)
 			NX_CPB_FDM(csbcpb) |= NX_FDM_INTERMEDIATE;
@@ -374,7 +364,8 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 		csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
 		desc.tfm = (struct crypto_blkcipher *) req->base.tfm;
 		rc = nx_build_sg_lists(nx_ctx, &desc, req->dst,
-				       req->src, &to_process, processed,
+				       req->src, &to_process,
+				       processed + req->assoclen,
 				       csbcpb->cpb.aes_gcm.iv_or_cnt);
 
 		if (rc)
@@ -409,17 +400,19 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 mac:
 	if (enc) {
 		/* copy out the auth tag */
-		scatterwalk_map_and_copy(csbcpb->cpb.aes_gcm.out_pat_or_mac,
-				 req->dst, nbytes,
-				 crypto_aead_authsize(crypto_aead_reqtfm(req)),
-				 SCATTERWALK_TO_SG);
+		scatterwalk_map_and_copy(
+			csbcpb->cpb.aes_gcm.out_pat_or_mac,
+			req->dst, req->assoclen + nbytes,
+			crypto_aead_authsize(crypto_aead_reqtfm(req)),
+			SCATTERWALK_TO_SG);
 	} else {
 		u8 *itag = nx_ctx->priv.gcm.iauth_tag;
 		u8 *otag = csbcpb->cpb.aes_gcm.out_pat_or_mac;
 
-		scatterwalk_map_and_copy(itag, req->src, nbytes,
-				 crypto_aead_authsize(crypto_aead_reqtfm(req)),
-				 SCATTERWALK_FROM_SG);
+		scatterwalk_map_and_copy(
+			itag, req->src, req->assoclen + nbytes,
+			crypto_aead_authsize(crypto_aead_reqtfm(req)),
+			SCATTERWALK_FROM_SG);
 		rc = memcmp(itag, otag,
 			    crypto_aead_authsize(crypto_aead_reqtfm(req))) ?
 		     -EBADMSG : 0;
@@ -478,45 +471,39 @@ static int gcm4106_aes_nx_decrypt(struct aead_request *req)
  * during encrypt/decrypt doesn't solve this problem, because it calls
  * blkcipher_walk_done under the covers, which doesn't use walk->blocksize,
  * but instead uses this tfm->blocksize. */
-struct crypto_alg nx_gcm_aes_alg = {
-	.cra_name        = "gcm(aes)",
-	.cra_driver_name = "gcm-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_AEAD,
-	.cra_blocksize   = 1,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_aead_type,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_gcm_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_aead = {
-		.ivsize      = AES_BLOCK_SIZE,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.setkey      = gcm_aes_nx_set_key,
-		.setauthsize = gcm_aes_nx_setauthsize,
-		.encrypt     = gcm_aes_nx_encrypt,
-		.decrypt     = gcm_aes_nx_decrypt,
-	}
+struct aead_alg nx_gcm_aes_alg = {
+	.base = {
+		.cra_name        = "gcm(aes)",
+		.cra_driver_name = "gcm-aes-nx",
+		.cra_priority    = 300,
+		.cra_blocksize   = 1,
+		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+		.cra_module      = THIS_MODULE,
+	},
+	.init        = nx_crypto_ctx_aes_gcm_init,
+	.exit        = nx_crypto_ctx_aead_exit,
+	.ivsize      = 12,
+	.maxauthsize = AES_BLOCK_SIZE,
+	.setkey      = gcm_aes_nx_set_key,
+	.encrypt     = gcm_aes_nx_encrypt,
+	.decrypt     = gcm_aes_nx_decrypt,
 };
 
-struct crypto_alg nx_gcm4106_aes_alg = {
-	.cra_name        = "rfc4106(gcm(aes))",
-	.cra_driver_name = "rfc4106-gcm-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_AEAD,
-	.cra_blocksize   = 1,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_nivaead_type,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_gcm_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_aead = {
-		.ivsize      = 8,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.geniv       = "seqiv",
-		.setkey      = gcm4106_aes_nx_set_key,
-		.setauthsize = gcm4106_aes_nx_setauthsize,
-		.encrypt     = gcm4106_aes_nx_encrypt,
-		.decrypt     = gcm4106_aes_nx_decrypt,
-	}
+struct aead_alg nx_gcm4106_aes_alg = {
+	.base = {
+		.cra_name        = "rfc4106(gcm(aes))",
+		.cra_driver_name = "rfc4106-gcm-aes-nx",
+		.cra_priority    = 300,
+		.cra_blocksize   = 1,
+		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+		.cra_module      = THIS_MODULE,
+	},
+	.init        = nx_crypto_ctx_aes_gcm_init,
+	.exit        = nx_crypto_ctx_aead_exit,
+	.ivsize      = 8,
+	.maxauthsize = AES_BLOCK_SIZE,
+	.setkey      = gcm4106_aes_nx_set_key,
+	.setauthsize = gcm4106_aes_nx_setauthsize,
+	.encrypt     = gcm4106_aes_nx_encrypt,
+	.decrypt     = gcm4106_aes_nx_decrypt,
 };
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 2e2529c..8473505 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -19,8 +19,8 @@
  * Author: Kent Yoder <yoder1@us.ibm.com>
  */
 
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
-#include <crypto/hash.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/algapi.h>
@@ -29,7 +29,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <linux/device.h>
 #include <linux/of.h>
@@ -531,11 +530,11 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out_unreg_ctr;
 
-	rc = crypto_register_alg(&nx_gcm_aes_alg);
+	rc = crypto_register_aead(&nx_gcm_aes_alg);
 	if (rc)
 		goto out_unreg_ctr3686;
 
-	rc = crypto_register_alg(&nx_gcm4106_aes_alg);
+	rc = crypto_register_aead(&nx_gcm4106_aes_alg);
 	if (rc)
 		goto out_unreg_gcm;
 
@@ -570,9 +569,9 @@ out_unreg_ccm4309:
 out_unreg_ccm:
 	crypto_unregister_alg(&nx_ccm_aes_alg);
 out_unreg_gcm4106:
-	crypto_unregister_alg(&nx_gcm4106_aes_alg);
+	crypto_unregister_aead(&nx_gcm4106_aes_alg);
 out_unreg_gcm:
-	crypto_unregister_alg(&nx_gcm_aes_alg);
+	crypto_unregister_aead(&nx_gcm_aes_alg);
 out_unreg_ctr3686:
 	crypto_unregister_alg(&nx_ctr3686_aes_alg);
 out_unreg_ctr:
@@ -639,9 +638,9 @@ int nx_crypto_ctx_aes_ccm_init(struct crypto_tfm *tfm)
 				  NX_MODE_AES_CCM);
 }
 
-int nx_crypto_ctx_aes_gcm_init(struct crypto_tfm *tfm)
+int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm)
 {
-	return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_AES,
+	return nx_crypto_ctx_init(crypto_aead_ctx(tfm), NX_FC_AES,
 				  NX_MODE_AES_GCM);
 }
 
@@ -693,6 +692,13 @@ void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
 	nx_ctx->out_sg = NULL;
 }
 
+void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_aead_ctx(tfm);
+
+	kzfree(nx_ctx->kmem);
+}
+
 static int nx_probe(struct vio_dev *viodev, const struct vio_device_id *id)
 {
 	dev_dbg(&viodev->dev, "driver probed: %s resource id: 0x%x\n",
@@ -721,8 +727,8 @@ static int nx_remove(struct vio_dev *viodev)
 
 		crypto_unregister_alg(&nx_ccm_aes_alg);
 		crypto_unregister_alg(&nx_ccm4309_aes_alg);
-		crypto_unregister_alg(&nx_gcm_aes_alg);
-		crypto_unregister_alg(&nx_gcm4106_aes_alg);
+		crypto_unregister_aead(&nx_gcm_aes_alg);
+		crypto_unregister_aead(&nx_gcm4106_aes_alg);
 		crypto_unregister_alg(&nx_ctr_aes_alg);
 		crypto_unregister_alg(&nx_ctr3686_aes_alg);
 		crypto_unregister_alg(&nx_cbc_aes_alg);
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 41b87ee..de3ea87 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -143,13 +143,14 @@ struct nx_crypto_ctx {
 
 /* prototypes */
 int nx_crypto_ctx_aes_ccm_init(struct crypto_tfm *tfm);
-int nx_crypto_ctx_aes_gcm_init(struct crypto_tfm *tfm);
+int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_aes_cbc_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_aes_ecb_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_sha_init(struct crypto_tfm *tfm);
 void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
+void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm);
 void nx_ctx_init(struct nx_crypto_ctx *nx_ctx, unsigned int function);
 int nx_hcall_sync(struct nx_crypto_ctx *ctx, struct vio_pfo_op *op,
 		  u32 may_sleep);
@@ -176,8 +177,8 @@ void nx_debugfs_fini(struct nx_crypto_driver *);
 
 extern struct crypto_alg nx_cbc_aes_alg;
 extern struct crypto_alg nx_ecb_aes_alg;
-extern struct crypto_alg nx_gcm_aes_alg;
-extern struct crypto_alg nx_gcm4106_aes_alg;
+extern struct aead_alg nx_gcm_aes_alg;
+extern struct aead_alg nx_gcm4106_aes_alg;
 extern struct crypto_alg nx_ctr_aes_alg;
 extern struct crypto_alg nx_ctr3686_aes_alg;
 extern struct crypto_alg nx_ccm_aes_alg;
