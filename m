Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17448C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 11:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D69208CA
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 11:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgHaLAR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 07:00:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:18006 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgHaLAP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 07:00:15 -0400
IronPort-SDR: KdhkDEHcgKtYwmt3t/07sAxeckfRDiRageVFisNFIJ/kFEhQdKaZ9a+7BwxqGjm36+Gxt1y2ZV
 Om41LWOvU6Jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9729"; a="157955515"
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="scan'208";a="157955515"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 04:00:13 -0700
IronPort-SDR: +HwZLV74qXcrPgeV6UDegDL2kcPyYoHLnxU/A1eUahZ6GJRhutM0FoajlobHwHuIbHn9F2qzcw
 jLuxbZJHPh2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="scan'208";a="314313068"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2020 04:00:11 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Dominik Przychodni <dominik.przychodni@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2] crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA
Date:   Mon, 31 Aug 2020 11:59:59 +0100
Message-Id: <20200831105959.107261-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Dominik Przychodni <dominik.przychodni@intel.com>

Return -EINVAL for authenc(hmac(sha1),cbc(aes)),
authenc(hmac(sha256),cbc(aes)) and authenc(hmac(sha512),cbc(aes))
if the cipher length is not multiple of the AES block.
This is to prevent an undefined device behaviour.

Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
Signed-off-by: Dominik Przychodni <dominik.przychodni@intel.com>
[giovanni.cabiddu@intel.com: reworded commit message]
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 72753b84dc95..d552dbcfe0a0 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -828,6 +828,11 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
 	int ret, ctr = 0;
+	u32 cipher_len;
+
+	cipher_len = areq->cryptlen - digst_size;
+	if (cipher_len % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
@@ -842,7 +847,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
-	cipher_param->cipher_length = areq->cryptlen - digst_size;
+	cipher_param->cipher_length = cipher_len;
 	cipher_param->cipher_offset = areq->assoclen;
 	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
 	auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
@@ -871,6 +876,9 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	u8 *iv = areq->iv;
 	int ret, ctr = 0;
 
+	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
-- 
2.26.2

