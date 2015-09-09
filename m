From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/8] crypto: rsa - check status returned from
 crypto_unregister_akcipher
Date: Wed, 09 Sep 2015 09:15:07 -0700
Message-ID: <20150909161507.2828.40751.stgit@tstruk-mobl1>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33535 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbbIIQRG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:17:06 -0400
In-Reply-To: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add status check returned from crypto_unregister_akcipher function.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/rsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 466003e..93feae2 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -329,7 +329,7 @@ static int rsa_init(void)
 
 static void rsa_exit(void)
 {
-	crypto_unregister_akcipher(&rsa);
+	WARN_ON(crypto_unregister_akcipher(&rsa));
 }
 
 module_init(rsa_init);
