Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CD8C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 15:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB612311F
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 15:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbhAFP3q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jan 2021 10:29:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:51394 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAFP3q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jan 2021 10:29:46 -0500
IronPort-SDR: bQkhJ3ThyMxzDKlwvKT7Z42O5NXfpYBmOTRmG6gz83+qZpsmCY8Ghy073qyE8jbNlfXgfZInVb
 py/XM1iW8SCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="164362339"
X-IronPort-AV: E=Sophos;i="5.78,480,1599548400"; 
   d="scan'208";a="164362339"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 07:28:00 -0800
IronPort-SDR: wu4yYJoRtsxtQMpoRC/THZ8RmCEfUFv0d/eDvxZM2UWOSa5Dg79Jb/6jH2lVCXmzLA2bzQWuqb
 BHAZE+I+7ymA==
X-IronPort-AV: E=Sophos;i="5.78,480,1599548400"; 
   d="scan'208";a="350884830"
Received: from tbrady-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.29.158])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 07:27:51 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, daniele.alessandrelli@lintel.com
Subject: [PATCH] crypto: keembay-ocs-hcu - Add dependency on HAS_IOMEM and ARCH_KEEMBAY
Date:   Wed,  6 Jan 2021 15:27:33 +0000
Message-Id: <20210106152733.572024-1-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Add the following additional dependencies for CRYPTO_DEV_KEEMBAY_OCS_HCU:

- HAS_IOMEM to prevent build failures

- ARCH_KEEMBAY to prevent asking the user about this driver when
  configuring a kernel without Intel Keem Bay platform support.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 drivers/crypto/keembay/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/keembay/Kconfig b/drivers/crypto/keembay/Kconfig
index e45f1b039380..00cf8f028cb9 100644
--- a/drivers/crypto/keembay/Kconfig
+++ b/drivers/crypto/keembay/Kconfig
@@ -43,6 +43,8 @@ config CRYPTO_DEV_KEEMBAY_OCS_HCU
 	tristate "Support for Intel Keem Bay OCS HCU HW acceleration"
 	select CRYPTO_HASH
 	select CRYPTO_ENGINE
+	depends on HAS_IOMEM
+	depends on ARCH_KEEMBAY || COMPILE_TEST
 	depends on OF || COMPILE_TEST
 	help
 	  Support for Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash
-- 
2.26.2

