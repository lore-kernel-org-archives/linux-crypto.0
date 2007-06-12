From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [patch 1/1] add cast to regain ablkcipher_request from private ctx
Date: Tue, 12 Jun 2007 18:20:23 +0200
Message-ID: <20070612162023.GA25764@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47463 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbXFLQUY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2007 12:20:24 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1Hy96V-00070C-Bk
	for linux-crypto@vger.kernel.org; Tue, 12 Jun 2007 18:20:23 +0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This cast allows to regain the struct ablkcipher_request for a request 
from private data.

Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Index: b/include/linux/crypto.h
===================================================================
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -600,6 +600,12 @@ static inline struct ablkcipher_request 
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
