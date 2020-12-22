Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC2DC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 12:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E232E2312E
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 12:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgLVMjf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Dec 2020 07:39:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:20066 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgLVMje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Dec 2020 07:39:34 -0500
IronPort-SDR: jg5VWo76BfITIRp3HqFvRvdHc7ukedQgtMe3li3ez+PRbgPyJ74yYWe8dsFCIN9vUqj7k/GK/4
 Lu8/OGlBr9aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9842"; a="155074622"
X-IronPort-AV: E=Sophos;i="5.78,438,1599548400"; 
   d="scan'208";a="155074622"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 04:38:52 -0800
IronPort-SDR: aDg3AiOxxyVdhcQX2R7reX4lnTR6lrwvXvcbqXNh2kFCPY46QIk1H0K6CjSNJvBPs/OJZinTPl
 ZyzRNyCwwOaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,438,1599548400"; 
   d="scan'208";a="341572116"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga003.jf.intel.com with ESMTP; 22 Dec 2020 04:38:50 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] crypto: qat - add CRYPTO_AES to Kconfig dependencies
Date:   Tue, 22 Dec 2020 13:00:24 +0000
Message-Id: <20201222130024.694558-1-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch includes a missing dependency (CRYPTO_AES) which may
lead to an "undefined reference to `aes_expandkey'" linking error.

Fixes: 5106dfeaeabe ("crypto: qat - add AES-XTS support for QAT GEN4 devices")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index beb379b23dc3..846a3d90b41a 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -11,6 +11,7 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_AES
 	select FW_LOADER
 
 config CRYPTO_DEV_QAT_DH895xCC
-- 
2.26.2

