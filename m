Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16028C2BBCA
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBAC92399C
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgLQRYg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:24:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:47107 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgLQRYg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:24:36 -0500
IronPort-SDR: hD7dZJo1kNefeb9lOVJptgrMYKbTJGkVfgtpKWfGm7blJKW2n7fvJHRrpIruIbeKKfPtn8tI4H
 AMX+/uBkzvAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="260017909"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="260017909"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:38 -0800
IronPort-SDR: S8KsLpulYGAlE65UJ/zGDyizUtP/VzqcdXfrMwVezhQkQ4f58sHIgOQd1H2h+BecS9491kyhng
 sZYho1VZQ4uw==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="369930974"
Received: from cdonohoe-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.13.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:35 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH 4/6] crypto: ecdh - Add Curve ID for NIST P-384
Date:   Thu, 17 Dec 2020 17:20:59 +0000
Message-Id: <20201217172101.381772-5-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Prabhjot Khurana <prabhjot.khurana@intel.com>

Reserve ECC curve id for NIST P-384 curve.

This is done to prepare for future support of the P-384 curve by KPP
device drivers.

Signed-off-by: Prabhjot Khurana <prabhjot.khurana@intel.com>
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 include/crypto/ecdh.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index a5b805b5526d..e4ba1de961e4 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -25,6 +25,7 @@
 /* Curves IDs */
 #define ECC_CURVE_NIST_P192	0x0001
 #define ECC_CURVE_NIST_P256	0x0002
+#define ECC_CURVE_NIST_P384	0x0003
 
 /**
  * struct ecdh - define an ECDH private key
-- 
2.26.2

