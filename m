Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4405C2BB48
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 16:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84446238E8
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 16:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgLQQhW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:37:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:35874 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQQhW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 11:37:22 -0500
IronPort-SDR: CMjjrkU8Q5uO8ioh6jaT+dsr992VsEcVB6L8yWgNFKBnJVG5UZ3Dhk4/NqUXzTDoP8suwuMaDu
 jIsUTiPfL3Pw==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="154506900"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="154506900"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 08:35:35 -0800
IronPort-SDR: gjXuie8Nql8xWMq51v/jUopGSSFUDNoUVly27jMUhth5HInOMUuPIWsdD5n/6wJbqlqcdlDixw
 5J/axoGONmtQ==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="453166304"
Received: from cdonohoe-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.13.146])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 08:35:33 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: keembay-ocs-aes - Add dependency on HAS_IOMEM
Date:   Thu, 17 Dec 2020 16:35:10 +0000
Message-Id: <20201217163510.372558-1-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Add dependency for CRYPTO_DEV_KEEMBAY_OCS_AES_SM4 on HAS_IOMEM to
prevent build failures.

Fixes: 88574332451380f4 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 drivers/crypto/keembay/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/keembay/Kconfig b/drivers/crypto/keembay/Kconfig
index 3c16797b25b9..8eb5200d2f60 100644
--- a/drivers/crypto/keembay/Kconfig
+++ b/drivers/crypto/keembay/Kconfig
@@ -1,5 +1,6 @@
 config CRYPTO_DEV_KEEMBAY_OCS_AES_SM4
 	tristate "Support for Intel Keem Bay OCS AES/SM4 HW acceleration"
+	depends on HAS_IOMEM
 	depends on OF || COMPILE_TEST
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AEAD

base-commit: 90cc8cf2d1ab87d708ebc311ac104ccbbefad9fc
-- 
2.26.2

