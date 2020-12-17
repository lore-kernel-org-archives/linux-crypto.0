Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59136C2BBCF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 320CC238EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgLQRXT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:23:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:47109 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgLQRXT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:23:19 -0500
IronPort-SDR: FRnS5eWIqSOMuNuSWwwg+ERU45LLIuo/M7kly4pywr1NZAR1wtPb90AYD97+iyFAHfY5b8hiKC
 Tl8kZg/xFYfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="260017886"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="260017886"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:33 -0800
IronPort-SDR: 3ktaQRjA2hM4aHVK5MIggWjDMziplyWZz+UONeXn4Qgzp8Lc8/6ZMumirnxUR+5FTQ8dSLjqTD
 6DOmP25GMYmw==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="369930940"
Received: from cdonohoe-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.13.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:30 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH 2/6] crypto: ecc - Move ecc.h to include/crypto/internal
Date:   Thu, 17 Dec 2020 17:20:57 +0000
Message-Id: <20201217172101.381772-3-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Move ecc.h header file to 'include/crypto/internal' so that it can be
easily imported from everywhere in the kernel tree.

This change is done to allow crypto device drivers to re-use the symbols
exported by 'crypto/ecc.c', thus avoiding code duplication.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 crypto/ecc.c                              | 2 +-
 crypto/ecdh.c                             | 2 +-
 crypto/ecrdsa.c                           | 2 +-
 crypto/ecrdsa_defs.h                      | 2 +-
 {crypto => include/crypto/internal}/ecc.h | 0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename {crypto => include/crypto/internal}/ecc.h (100%)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index c80aa25994a0..9aa801315a32 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -31,10 +31,10 @@
 #include <linux/fips.h>
 #include <crypto/ecdh.h>
 #include <crypto/rng.h>
+#include <crypto/internal/ecc.h>
 #include <asm/unaligned.h>
 #include <linux/ratelimit.h>
 
-#include "ecc.h"
 #include "ecc_curve_defs.h"
 
 typedef struct {
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index d56b8603dec9..edb06ce90d1d 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -6,11 +6,11 @@
  */
 
 #include <linux/module.h>
+#include <crypto/internal/ecc.h>
 #include <crypto/internal/kpp.h>
 #include <crypto/kpp.h>
 #include <crypto/ecdh.h>
 #include <linux/scatterlist.h>
-#include "ecc.h"
 
 struct ecdh_ctx {
 	unsigned int curve_id;
diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
index 6a3fd09057d0..b32ffcaad9ad 100644
--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -20,12 +20,12 @@
 #include <linux/crypto.h>
 #include <crypto/streebog.h>
 #include <crypto/internal/akcipher.h>
+#include <crypto/internal/ecc.h>
 #include <crypto/akcipher.h>
 #include <linux/oid_registry.h>
 #include <linux/scatterlist.h>
 #include "ecrdsa_params.asn1.h"
 #include "ecrdsa_pub_key.asn1.h"
-#include "ecc.h"
 #include "ecrdsa_defs.h"
 
 #define ECRDSA_MAX_SIG_SIZE (2 * 512 / 8)
diff --git a/crypto/ecrdsa_defs.h b/crypto/ecrdsa_defs.h
index 170baf039007..0056335b9d03 100644
--- a/crypto/ecrdsa_defs.h
+++ b/crypto/ecrdsa_defs.h
@@ -13,7 +13,7 @@
 #ifndef _CRYTO_ECRDSA_DEFS_H
 #define _CRYTO_ECRDSA_DEFS_H
 
-#include "ecc.h"
+#include <crypto/internal/ecc.h>
 
 #define ECRDSA_MAX_SIG_SIZE (2 * 512 / 8)
 #define ECRDSA_MAX_DIGITS (512 / 64)
diff --git a/crypto/ecc.h b/include/crypto/internal/ecc.h
similarity index 100%
rename from crypto/ecc.h
rename to include/crypto/internal/ecc.h
-- 
2.26.2

