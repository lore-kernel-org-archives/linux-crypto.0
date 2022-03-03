Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD07C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 18:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiCCSO0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 13:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiCCSOZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 13:14:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904ECEF7AF
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 10:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646331219; x=1677867219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YvFtguEdVtYSvc/8BUWq1lfFeWQ9inpeeCp0rT5BQ+M=;
  b=UGIIrBE8QdnGO3150RnXXCGYOqi/jim7bsIsf0uHxwLbqeDVrGssx61F
   fvKj2wcWQA8zQsQmyolR7tlP30KfKkAph7LDRVEWJ5qcCf8vL+NTBd8BJ
   NxXWoSo9ZVL1KS+wd8xvFXF1NxEz8SG12JVTl4lX7SrA4G0YEMW5cNkoa
   CYNIxvUvVgjtPehebmvRiXAAI1q+GK9iJ/ywGmSvhc69DF6m9thMVxCfP
   d48B3VF029BjdaSXmj/pZApnoAhWduYFClBYAzUm4XqUV858838SaRPAw
   KTRx8BMujCoaK/Q+7FkhpHy+m4DIJgU9KsqadOaG6sFu1DaIbkWnsYxp7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="278447794"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="278447794"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 10:00:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="640279734"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 10:00:55 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Kyle Sanderson <kyle.leet@gmail.com>,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [RFC 3/3] crypto: qat - remove CRYPTO_ALG_ALLOCATES_MEMORY flag
Date:   Thu,  3 Mar 2022 18:00:36 +0000
Message-Id: <20220303180036.13475-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303180036.13475-1-giovanni.cabiddu@intel.com>
References: <20220303180036.13475-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the CRYPTO_ALG_ALLOCATES_MEMORY flag from the aead and skcipher
alg structures.

This allows the QAT driver to be used by dm-crypt after it has been
changed to (1) use pre-allocated buffers in the datapath and (2) to
handle skcipher and aead requests with the CRYPTO_TFM_REQ_MAY_BACKLOG
flag set.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 765377cebcca..38ccb20c507e 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1588,7 +1588,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1605,7 +1605,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1622,7 +1622,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1640,7 +1640,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "qat_aes_cbc",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1658,7 +1658,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "ctr(aes)",
 	.base.cra_driver_name = "qat_aes_ctr",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1676,8 +1676,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "qat_aes_xts",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
-			  CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
-- 
2.35.1

