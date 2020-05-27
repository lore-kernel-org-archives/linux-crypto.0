Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE80AC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 22:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B5E207D8
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 22:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgE0WTN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 18:19:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:46044 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgE0WTM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 18:19:12 -0400
IronPort-SDR: j2q3Qs80feiizNk9aheku5nncnGUlayOAb0EHUAv08gw+9Tl8hfpowAGmZk8M1W85b9JsXLTfN
 0vR9PbQ4fu8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 15:19:12 -0700
IronPort-SDR: kkvQe6/BRtWrrUfNXpNvWwtU2TKP/4KqHaDz1To2TRLP679m/WdepqX/N9IuBRIqZOPOPtzQ+p
 Ln76wYrwdrXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="468903693"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2020 15:19:11 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix parameter check in aead encryption
Date:   Wed, 27 May 2020 23:18:52 +0100
Message-Id: <20200527221852.4942-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Return -EINVAL if the input digest size and/or cipher
length is zero or the cipher length is not multiple of a block.
These additional parameter checks prevent an undefined device behaviour.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 9df4aebf37ca..00e10a4d578a 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -825,8 +825,15 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
+	u32 cipher_length = areq->cryptlen - digst_size;
 	int ret, ctr = 0;
 
+	if (!digst_size || !areq->cryptlen || !cipher_length)
+		return -EINVAL;
+
+	if (cipher_length % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
@@ -840,7 +847,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
-	cipher_param->cipher_length = areq->cryptlen - digst_size;
+	cipher_param->cipher_length = cipher_length;
 	cipher_param->cipher_offset = areq->assoclen;
 	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
 	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
@@ -869,6 +876,12 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	uint8_t *iv = areq->iv;
 	int ret, ctr = 0;
 
+	if (!areq->cryptlen)
+		return -EINVAL;
+
+	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
-- 
2.26.2

