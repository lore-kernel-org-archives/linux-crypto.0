Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30026C47095
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 12:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D388B207EA
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 12:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgJGMo2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 08:44:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:25063 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728282AbgJGMo1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 08:44:27 -0400
IronPort-SDR: IKhMNDoevlS7FiiVSGZn/fvktilLZvktMB6wEhGsjMzSw++iJp4Sh+MazW1GXOz2Le1cuGYMDd
 XxOCrDOdOyPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="165055362"
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="165055362"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 05:44:27 -0700
IronPort-SDR: V1wi7HBPR+u0cZFmfVoK7f961FhCL0ysP/D6ft4jbtxrE7nwENGgww74WyrGC/JTMHBypQDd+F
 BKJ3LjJIzfmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="517791614"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga006.fm.intel.com with ESMTP; 07 Oct 2020 05:44:25 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH] crypto: qat - remove unused function
Date:   Wed,  7 Oct 2020 13:43:45 +0100
Message-Id: <20201007124345.39125-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unused function qat_dh_get_params().
This is to fix the following warning when compiling the driver with
CC=clang W=1

    drivers/crypto/qat/qat_common/qat_asym_algs.c:207:34: warning: unused function 'qat_dh_get_params' [-Wunused-function]

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 846569ec9066..f112078be868 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -204,11 +204,6 @@ static unsigned long qat_dh_fn_id(unsigned int len, bool g2)
 	};
 }
 
-static inline struct qat_dh_ctx *qat_dh_get_params(struct crypto_kpp *tfm)
-{
-	return kpp_tfm_ctx(tfm);
-}
-
 static int qat_dh_compute_value(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
-- 
2.26.2

