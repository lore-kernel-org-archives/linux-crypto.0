From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: akcipher - fix spelling cihper -> cipher
Date: Tue, 23 Jun 2015 10:18:53 -0700
Message-ID: <20150623171853.15642.88750.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbbFWRTE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 13:19:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/akcipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index d798641..528ae6a 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -114,4 +114,4 @@ void crypto_unregister_akcipher(struct akcipher_alg *alg)
 EXPORT_SYMBOL_GPL(crypto_unregister_akcipher);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Generic public key cihper type");
+MODULE_DESCRIPTION("Generic public key cipher type");
