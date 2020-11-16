Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419E2C4742C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 19:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08B9122263
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 19:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgKPS7R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:59:17 -0500
Received: from mga05.intel.com ([192.55.52.43]:4423 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbgKPS7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 13:59:17 -0500
IronPort-SDR: u/i8KgLeJmJQCJvxeyIJ8FhekXvgQCjSrk4Dw+xM7bnI8vLgpvz66zshtvzof458EUuP7AubMl
 9SfI1wc2lBzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="255508862"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="255508862"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:59:17 -0800
IronPort-SDR: 4/xnP9wBn5mz2scHV/nllFuERvDam3Dpo7+VFCYJPsYFFGN12retQhFr4JHi0t1wXS8ezwIZkU
 R0b/aHDtAhrA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="543710031"
Received: from abarnicl-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.19.98])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:59:14 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v3 3/3] MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver
Date:   Mon, 16 Nov 2020 18:58:46 +0000
Message-Id: <20201116185846.773464-4-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201116185846.773464-1-daniele.alessandrelli@linux.intel.com>
References: <20201116185846.773464-1-daniele.alessandrelli@linux.intel.com>
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

