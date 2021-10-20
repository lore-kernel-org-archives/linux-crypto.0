Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52A2C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C85A660F8F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhJTKiF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:38:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:7393 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhJTKiF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 06:38:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="228622899"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="228622899"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:51 -0700
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="527005560"
Received: from dhicke3x-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.29.200])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:48 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/5] crypto: ecc - Move ecc.h to include/crypto/internal
Date:   Wed, 20 Oct 2021 11:35:35 +0100
Message-Id: <20211020103538.360614-3-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
References: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
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
 crypto/ecdsa.c                            | 2 +-
 crypto/ecrdsa.c                           | 2 +-
 crypto/ecrdsa_defs.h                      | 2 +-
 {crypto => include/crypto/internal}/ecc.h | 0
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename {crypto => include/crypto/internal}/ecc.h (100%)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index afc6cefdc1d9..80efc9b4eb69 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -32,10 +32,10 @@
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
index c6f61c2211dc..e4857d534344 100644
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
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index 1e7b15009bf6..b3a8a6b572ba 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -5,12 +5,12 @@
 
 #include <linux/module.h>
 #include <crypto/internal/akcipher.h>
+#include <crypto/internal/ecc.h>
 #include <crypto/akcipher.h>
 #include <crypto/ecdh.h>
 #include <linux/asn1_decoder.h>
 #include <linux/scatterlist.h>
 
-#include "ecc.h"
 #include "ecdsasignature.asn1.h"
 
 struct ecc_ctx {
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
2.31.1

