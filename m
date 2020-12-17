Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E715C2BBCD
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F013A238EC
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgLQRXP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:23:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:47107 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgLQRXP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:23:15 -0500
IronPort-SDR: QkaGJ+QZ3jp4mihmuBb1tuOjgDhdro1c2pZHcAB49b95bZnJgYlfzEB8soUzXWz0YVPv7KVXBD
 MI1QBONMsCUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="260017877"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="260017877"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:30 -0800
IronPort-SDR: /4prLWMLITawgE77iGyrNvkbP9yTtJ3JW6ZAhzheOKVMuI/I5dW3tsI3+gQngD0TREH6qjWVFp
 AsLovDE0edwA==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="369930927"
Received: from cdonohoe-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.13.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:27 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH 1/6] crypto: engine - Add KPP Support to Crypto Engine
Date:   Thu, 17 Dec 2020 17:20:56 +0000
Message-Id: <20201217172101.381772-2-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
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
 crypto/crypto_engine.c                 | 27 ++++++++++++++++++++++++++
 include/crypto/engine.h                |  5 +++++
 3 files changed, 36 insertions(+)

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
index cff21f4e03e3..fb1c50cdb8e4 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -340,6 +340,19 @@ int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
 }
 EXPORT_SYMBOL_GPL(crypto_transfer_skcipher_request_to_engine);
 
+/**
+ * crypto_transfer_kpp_request_to_engine - transfer one kpp_request
+ * to list into the engine queue
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
  * crypto_finalize_aead_request - finalize one aead_request if
  * the request is done
@@ -396,6 +409,20 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_skcipher_request);
 
+/**
+ * crypto_finalize_kpp_request - finalize one kpp_request if
+ * the request is done
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
  * crypto_engine_start - start the hardware engine
  * @engine: the hardware engine need to be started
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 3f06e40d063a..0525fb0133cb 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -16,6 +16,7 @@
 #include <crypto/akcipher.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
+#include <crypto/kpp.h>
 
 #define ENGINE_NAME_LEN	30
 /*
@@ -98,6 +99,8 @@ int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
 					       struct ahash_request *req);
 int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
 					       struct skcipher_request *req);
+int crypto_transfer_kpp_request_to_engine(struct crypto_engine *engine,
+					  struct kpp_request *req);
 void crypto_finalize_aead_request(struct crypto_engine *engine,
 				  struct aead_request *req, int err);
 void crypto_finalize_akcipher_request(struct crypto_engine *engine,
@@ -106,6 +109,8 @@ void crypto_finalize_hash_request(struct crypto_engine *engine,
 				  struct ahash_request *req, int err);
 void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 				      struct skcipher_request *req, int err);
+void crypto_finalize_kpp_request(struct crypto_engine *engine,
+				 struct kpp_request *req, int err);
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
-- 
2.26.2

