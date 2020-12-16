Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1EFC2BBCA
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0E8233A2
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLPLuW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 06:50:22 -0500
Received: from mga05.intel.com ([192.55.52.43]:25423 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgLPLuW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 06:50:22 -0500
IronPort-SDR: c1EyMwC952AaRK9QclMnYaWxmxcJzTLCYR/ACv9dOQspxqtc3wtqWyzq9eVHolUdlWHQA9qZ8x
 AMtFSVxPkXig==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="259775339"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="259775339"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:23 -0800
IronPort-SDR: bauHvpLAFjLQ6tLsp5wi9gXrQtuU9cpTex3y8XWIB8fYQNSgHmauDermPMeNi+8jw7j+mwbgp3
 zqfHzzGomEig==
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="368985196"
Received: from johnlyon-mobl.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.90.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:20 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v4 5/5] MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver
Date:   Wed, 16 Dec 2020 11:46:39 +0000
Message-Id: <20201216114639.3451399-6-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
References: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Add maintainers for the Intel Keem Bay Offload Crypto Subsystem (OCS)
Hash Control Unit (HCU) crypto driver.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Acked-by: Declan Murphy <declan.murphy@intel.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c9e221929961..a610b78fc4a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9068,6 +9068,17 @@ F:	drivers/crypto/keembay/keembay-ocs-aes-core.c
 F:	drivers/crypto/keembay/ocs-aes.c
 F:	drivers/crypto/keembay/ocs-aes.h
 
+INTEL KEEM BAY OCS HCU CRYPTO DRIVER
+M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
+M:	Declan Murphy <declan.murphy@intel.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
+F:	drivers/crypto/keembay/Kconfig
+F:	drivers/crypto/keembay/Makefile
+F:	drivers/crypto/keembay/keembay-ocs-hcu-core.c
+F:	drivers/crypto/keembay/ocs-hcu.c
+F:	drivers/crypto/keembay/ocs-hcu.h
+
 INTEL MANAGEMENT ENGINE (mei)
 M:	Tomas Winkler <tomas.winkler@intel.com>
 L:	linux-kernel@vger.kernel.org
-- 
2.26.2

