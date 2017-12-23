From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH v1] crypto: crypto4xx - perform aead icv check in the driver
Date: Sat, 23 Dec 2017 19:45:46 +0100
Message-ID: <7d26eb8de324eb17d99d2e4b0aa271b6c75ef889.1514054717.git.chunkeey@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40588 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752902AbdLWSpu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Dec 2017 13:45:50 -0500
Received: by mail-wm0-f66.google.com with SMTP id f206so26678051wmf.5
        for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2017 10:45:50 -0800 (PST)
Received: from debian64.daheim (p5B0D7224.dip0.t-ipconnect.de. [91.13.114.36])
        by smtp.gmail.com with ESMTPSA id d71sm14574629wma.7.2017.12.23.10.45.47
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Dec 2017 10:45:47 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.90_RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1eSonq-00046p-Se
        for linux-crypto@vger.kernel.org; Sat, 23 Dec 2017 19:45:46 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ccm-aes-ppc4xx now fails one of testmgr's expected
failure test cases as such:

|decryption failed on test 10 for ccm-aes-ppc4xx:
|ret was 0, |expected -EBADMSG

It doesn't look like the hardware sets the authentication failure
flag. The original vendor source from which this was ported does
not have any special code or notes about why this would happen or
if there are any WAs.

Hence, this patch converts the aead_done callback handler to
perform the icv check in the driver. And this fixes the false
negative and the ccm-aes-ppc4xx passes the selftests once again.

|name         : ccm(aes)
|driver       : ccm-aes-ppc4xx
|module       : crypto4xx
|priority     : 300
|refcnt       : 1
|selftest     : passed
|internal     : no
|type         : aead
|async        : yes
|blocksize    : 1
|ivsize       : 16
|maxauthsize  : 16
|geniv        : <none>

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c  |  6 +---
 drivers/crypto/amcc/crypto4xx_core.c | 54 ++++++++++++++++++------------------
 2 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index eeaf27859d80..ea83d0bff0e9 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -256,10 +256,6 @@ static inline bool crypto4xx_aead_need_fallback(struct aead_request *req,
 	if (is_ccm && !(req->iv[0] == 1 || req->iv[0] == 3))
 		return true;
 
-	/* CCM - fix CBC MAC mismatch in special case */
-	if (is_ccm && decrypt && !req->assoclen)
-		return true;
-
 	return false;
 }
 
@@ -330,7 +326,7 @@ int crypto4xx_setkey_aes_ccm(struct crypto_aead *cipher, const u8 *key,
 	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
 	sa->sa_contents.w = SA_AES_CCM_CONTENTS | (keylen << 2);
 
-	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
+	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
 				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
 				 SA_NO_HEADER_PROC, SA_HASH_ALG_CBC_MAC,
 				 SA_CIPHER_ALG_AES,
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index f148627e925c..ad19aa806931 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -577,15 +577,14 @@ static void crypto4xx_aead_done(struct crypto4xx_device *dev,
 				struct pd_uinfo *pd_uinfo,
 				struct ce_pd *pd)
 {
-	struct aead_request *aead_req;
-	struct crypto4xx_ctx *ctx;
+	struct aead_request *aead_req = container_of(pd_uinfo->async_req,
+		struct aead_request, base);
 	struct scatterlist *dst = pd_uinfo->dest_va;
+	size_t cp_len = crypto_aead_authsize(
+		crypto_aead_reqtfm(aead_req));
+	u32 icv[cp_len];
 	int err = 0;
 
-	aead_req = container_of(pd_uinfo->async_req, struct aead_request,
-				base);
-	ctx  = crypto_tfm_ctx(aead_req->base.tfm);
-
 	if (pd_uinfo->using_sd) {
 		crypto4xx_copy_pkt_to_dst(dev, pd, pd_uinfo,
 					  pd->pd_ctl_len.bf.pkt_len,
@@ -597,38 +596,39 @@ static void crypto4xx_aead_done(struct crypto4xx_device *dev,
 
 	if (pd_uinfo->sa_va->sa_command_0.bf.dir == DIR_OUTBOUND) {
 		/* append icv at the end */
-		size_t cp_len = crypto_aead_authsize(
-			crypto_aead_reqtfm(aead_req));
-		u32 icv[cp_len];
-
 		crypto4xx_memcpy_from_le32(icv, pd_uinfo->sr_va->save_digest,
 					   cp_len);
 
 		scatterwalk_map_and_copy(icv, dst, aead_req->cryptlen,
 					 cp_len, 1);
+	} else {
+		/* check icv at the end */
+		scatterwalk_map_and_copy(icv, aead_req->src,
+			aead_req->assoclen + aead_req->cryptlen -
+			cp_len, cp_len, 0);
+
+		crypto4xx_memcpy_from_le32(icv, icv, cp_len);
+
+		if (crypto_memneq(icv, pd_uinfo->sr_va->save_digest, cp_len))
+			err = -EBADMSG;
 	}
 
 	crypto4xx_ret_sg_desc(dev, pd_uinfo);
 
 	if (pd->pd_ctl.bf.status & 0xff) {
-		if (pd->pd_ctl.bf.status & 0x1) {
-			/* authentication error */
-			err = -EBADMSG;
-		} else {
-			if (!__ratelimit(&dev->aead_ratelimit)) {
-				if (pd->pd_ctl.bf.status & 2)
-					pr_err("pad fail error\n");
-				if (pd->pd_ctl.bf.status & 4)
-					pr_err("seqnum fail\n");
-				if (pd->pd_ctl.bf.status & 8)
-					pr_err("error _notify\n");
-				pr_err("aead return err status = 0x%02x\n",
-					pd->pd_ctl.bf.status & 0xff);
-				pr_err("pd pad_ctl = 0x%08x\n",
-					pd->pd_ctl.bf.pd_pad_ctl);
-			}
-			err = -EINVAL;
+		if (!__ratelimit(&dev->aead_ratelimit)) {
+			if (pd->pd_ctl.bf.status & 2)
+				pr_err("pad fail error\n");
+			if (pd->pd_ctl.bf.status & 4)
+				pr_err("seqnum fail\n");
+			if (pd->pd_ctl.bf.status & 8)
+				pr_err("error _notify\n");
+			pr_err("aead return err status = 0x%02x\n",
+				pd->pd_ctl.bf.status & 0xff);
+			pr_err("pd pad_ctl = 0x%08x\n",
+				pd->pd_ctl.bf.pd_pad_ctl);
 		}
+		err = -EINVAL;
 	}
 
 	if (pd_uinfo->state & PD_ENTRY_BUSY)
-- 
2.15.1
