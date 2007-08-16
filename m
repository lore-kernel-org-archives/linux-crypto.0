From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 01/10] t add cast to regain ablkcipher_request from private ctx
Date: Thu, 16 Aug 2007 22:01:06 +0200
Message-ID: <20070816200134.680838000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60599 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbXHPUFw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:52 -0400
Content-Disposition: inline; filename=crypto_add_casts.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This cast allows to regain the struct ablkcipher_request for a request 
from private data.

Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -580,6 +580,12 @@ static inline struct ablkcipher_request 
 	return container_of(req, struct ablkcipher_request, base);
 }
 
+static inline struct ablkcipher_request *ablkcipher_ctx_cast(
+		void *ctx)
+{
+	return container_of(ctx, struct ablkcipher_request, __ctx);
+}
+
 static inline struct ablkcipher_request *ablkcipher_request_alloc(
 	struct crypto_ablkcipher *tfm, gfp_t gfp)
 {

-- 
