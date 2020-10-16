Return-Path: <SRS0=63hd=DX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB6EC4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC67C21527
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390689AbgJPR2e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Oct 2020 13:28:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:5405 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390238AbgJPR2d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Oct 2020 13:28:33 -0400
IronPort-SDR: vhk2KrNxrR9qRZ+0qaoh7uaGhYc9qYSYycXcxy9N/OqhcYZcPKNcCKDNSAcaRHO7l0z46ETTOw
 q8YR1DTU4lyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="153570114"
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="153570114"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:28:33 -0700
IronPort-SDR: rFp/wyngmAesjUtGBR+3gnnagkbvPewdv9yjmWZa+dVI2QXvpLCJIY55YFK1j4JvenFxkniess
 OACH8QK/U59Q==
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="464750867"
Received: from apurdea-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.84.178])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:28:30 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH 3/3] MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver
Date:   Fri, 16 Oct 2020 18:27:59 +0100
Message-Id: <20201016172759.1260407-4-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016172759.1260407-1-daniele.alessandrelli@linux.intel.com>
References: <20201016172759.1260407-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Add maintainers for the Intel Keem Bay Offload Crypto Subsystem (OCS)
Hash Control Unit (HCU) crypto driver.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 606f9d7ef19a..1a0d7368c468 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8863,6 +8863,17 @@ M:	Deepak Saxena <dsaxena@plexity.net>
 S:	Maintained
 F:	drivers/char/hw_random/ixp4xx-rng.c
 
+INTEL KEEM BAY OCS HCU CRYPTO DRIVER
+M:	Declan Murphy <declan.murphy@intel.com>
+M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
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

