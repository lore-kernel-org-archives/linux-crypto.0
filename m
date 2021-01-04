Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1040AC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF86A221E5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbhADPOS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:14:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:6415 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbhADPOR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 10:14:17 -0500
IronPort-SDR: JhG/bGqMXBtunMu8XdFf6raeHpbPr8/5iEuyop2/fnYkKfQsvqD6ykBLi8VFPA6adMAzlO5tqL
 v5Nfzvx99rnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="174388163"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="174388163"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 07:13:37 -0800
IronPort-SDR: 4plFRtioCSGJr0K4kKWnGZ4SqCu/hujzvtc5hFnMsqDyqdhhisiTjmSWZxCze6OOOsO6FNYUCu
 6mVPf9wMY+og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="349972512"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 07:13:36 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: qat - replace CRYPTO_AES with CRYPTO_LIB_AES in Kconfig
Date:   Mon,  4 Jan 2021 15:35:15 +0000
Message-Id: <20210104153515.749496-1-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201223205755.GA19858@gondor.apana.org.au>
References: <20201223205755.GA19858@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use CRYPTO_LIB_AES in place of CRYPTO_AES in the dependences for the QAT
common code.

Fixes: c0e583ab2016 ("crypto: qat - add CRYPTO_AES to Kconfig dependencies")
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 846a3d90b41a..77783feb62b2 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -11,7 +11,7 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select FW_LOADER
 
 config CRYPTO_DEV_QAT_DH895xCC
-- 
2.26.2

