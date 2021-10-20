Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDE3C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3078E61260
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJTKiD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:38:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:7388 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhJTKiB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 06:38:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="228622895"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="228622895"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:47 -0700
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="527005550"
Received: from dhicke3x-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.29.200])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:44 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 1/5] crypto: engine - Add KPP Support to Crypto Engine
Date:   Wed, 20 Oct 2021 11:35:34 +0100
Message-Id: <20211020103538.360614-2-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
References: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Prabhjot Khurana <prabhjot.khurana@intel.com>

Add KPP support to the crypto engine queue manager, so that it can be
used to simplify the logic of KPP device drivers as done for other
crypto drivers.

Signed-off-by: Prabhjot Khurana <prabhjot.khurana@intel.com>
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 Documentation/crypto/crypto_engine.rst |  4 ++++
 crypto/crypto_engine.c                 | 26 ++++++++++++++++++++++++++
 include/crypto/engine.h                |  5 +++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/crypto_engine.rst
index 25cf9836c336..d562ea17d994 100644
--- a/Documentation/crypto/crypto_engine.rst
+++ b/Documentation/crypto/crypto_engine.rst
@@ -69,6 +69,8 @@ the crypto engine via one of:
 
 * crypto_transfer_hash_request_to_engine()
 
+* crypto_transfer_kpp_request_to_engine()
+
 * crypto_transfer_skcipher_request_to_engine()
 
 At the end of the request process, a call to one of the following functions is needed:
@@ -79,4 +81,6 @@ At the end of the request process, a call to one of the following functions is n
 
 * crypto_finalize_hash_request()
 
+* crypto_finalize_kpp_request()
+
 * crypto_finalize_skcipher_request()
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index cff21f4e03e3..fb07da9920ee 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -327,6 +327,19 @@ int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
 }
 EXPORT_SYMBOL_GPL(crypto_transfer_hash_request_to_engine);
 
+/**
+ * crypto_transfer_kpp_request_to_engine - transfer one kpp_request to list
+ * into the engine queue
+ * @engine: the hardware engine
+ * @req: the request need to be listed into the engine queue
+ */
+int crypto_transfer_kpp_request_to_engine(struct crypto_engine *engine,
+					  struct kpp_request *req)
+{
+	return crypto_transfer_request_to_engine(engine, &req->base);
+}
+EXPORT_SYMBOL_GPL(crypto_transfer_kpp_request_to_engine);
+
 /**
  * crypto_transfer_skcipher_request_to_engine - transfer one skcipher_request
  * to list into the engine queue
@@ -382,6 +395,19 @@ void crypto_finalize_hash_request(struct crypto_engine *engine,
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_hash_request);
 
+/**
+ * crypto_finalize_kpp_request - finalize one kpp_request if the request is done
+ * @engine: the hardware engine
+ * @req: the request need to be finalized
+ * @err: error number
+ */
+void crypto_finalize_kpp_request(struct crypto_engine *engine,
+				 struct kpp_request *req, int err)
+{
+	return crypto_finalize_request(engine, &req->base, err);
+}
+EXPORT_SYMBOL_GPL(crypto_finalize_kpp_request);
+
 /**
  * crypto_finalize_skcipher_request - finalize one skcipher_request if
  * the request is done
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 26cac19b0f46..fd4f2fa23f51 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -16,6 +16,7 @@
 #include <crypto/akcipher.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
+#include <crypto/kpp.h>
 
 #define ENGINE_NAME_LEN	30
 /*
@@ -96,6 +97,8 @@ int crypto_transfer_akcipher_request_to_engine(struct crypto_engine *engine,
 					       struct akcipher_request *req);
 int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
 					       struct ahash_request *req);
+int crypto_transfer_kpp_request_to_engine(struct crypto_engine *engine,
+					  struct kpp_request *req);
 int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
 					       struct skcipher_request *req);
 void crypto_finalize_aead_request(struct crypto_engine *engine,
@@ -104,6 +107,8 @@ void crypto_finalize_akcipher_request(struct crypto_engine *engine,
 				      struct akcipher_request *req, int err);
 void crypto_finalize_hash_request(struct crypto_engine *engine,
 				  struct ahash_request *req, int err);
+void crypto_finalize_kpp_request(struct crypto_engine *engine,
+				 struct kpp_request *req, int err);
 void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 				      struct skcipher_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
-- 
2.31.1

