Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D191EC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 08:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B012020836
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 08:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgFZIEx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 04:04:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:37504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgFZIEx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 04:04:53 -0400
IronPort-SDR: cLNBLLzYtK3mXN/80FRSZP+5RShIAjKi37kVpFoKwtuLn6FdzOu80slEY7lzwEyu8oHCN/lHI7
 z5GilAoJHneg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="146739890"
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="146739890"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 01:04:53 -0700
IronPort-SDR: 9PEiwF8MKEZpXzojtXzG8JXDCz5v8rSboX54gJzXHscmAwaQpbGEa9fmRr9F5uZwcQa2lL/fmH
 SWQP1my5kuSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="479756356"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jun 2020 01:04:52 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 3/4] crypto: qat - remove unused field in skcipher ctx
Date:   Fri, 26 Jun 2020 09:04:28 +0100
Message-Id: <20200626080429.155450-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626080429.155450-1-giovanni.cabiddu@intel.com>
References: <20200626080429.155450-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove tfm field in qat_alg_skcipher_ctx structure.
This is not used.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 11f36eafda0c..77bdff0118f7 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -88,7 +88,6 @@ struct qat_alg_skcipher_ctx {
 	struct icp_qat_fw_la_bulk_req enc_fw_req;
 	struct icp_qat_fw_la_bulk_req dec_fw_req;
 	struct qat_crypto_instance *inst;
-	struct crypto_skcipher *tfm;
 };
 
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
@@ -1197,10 +1196,7 @@ static void qat_alg_aead_exit(struct crypto_aead *tfm)
 
 static int qat_alg_skcipher_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct qat_crypto_request));
-	ctx->tfm = tfm;
 	return 0;
 }
 
-- 
2.26.2

