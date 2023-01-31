Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B0BC38142
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjAaIBu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAaIBt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:01:49 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C61340BF5
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:01:48 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlaL-005vdz-D5; Tue, 31 Jan 2023 16:01:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:01:45 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:01:45 +0800
Subject: [PATCH 1/32] crypto: api - Add scaffolding to change completion function signature
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com, Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Message-Id: <E1pMlaL-005vdz-D5@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto completion function currently takes a pointer to a
struct crypto_async_request object.  However, in reality the API
does not allow the use of any part of the object apart from the
data field.  For example, ahash/shash will create a fake object
on the stack to pass along a different data field.

This leads to potential bugs where the user may try to dereference
or otherwise use the crypto_async_request object.

This patch adds some temporary scaffolding so that the completion
function can take a void * instead.  Once affected users have been
converted this can be removed.

The helper crypto_request_complete will remain even after the
conversion is complete.  It should be used instead of calling
the completion functino directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/algapi.h |    7 +++++++
 include/linux/crypto.h  |    6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 61b327206b55..1fd81e74a174 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -302,4 +302,11 @@ enum {
 	CRYPTO_MSG_ALG_LOADED,
 };
 
+static inline void crypto_request_complete(struct crypto_async_request *req,
+					   int err)
+{
+	crypto_completion_t complete = req->complete;
+	complete(req, err);
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 5d1e961f810e..b18f6e669fb1 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -176,6 +176,7 @@ struct crypto_async_request;
 struct crypto_tfm;
 struct crypto_type;
 
+typedef struct crypto_async_request crypto_completion_data_t;
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
 
 /**
@@ -595,6 +596,11 @@ struct crypto_wait {
 /*
  * Async ops completion helper functioons
  */
+static inline void *crypto_get_completion_data(crypto_completion_data_t *req)
+{
+	return req->data;
+}
+
 void crypto_req_done(struct crypto_async_request *req, int err);
 
 static inline int crypto_wait_req(int err, struct crypto_wait *wait)
