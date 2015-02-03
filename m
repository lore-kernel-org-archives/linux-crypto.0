From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: tcrypt speed: fix filter for aead algorithms
Date: Tue, 3 Feb 2015 15:59:48 +0200
Message-ID: <1422971988-21517-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:64306
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964781AbbBCOA0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2015 09:00:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

test_aead_speed is written for sync algorithms without specifically
requiring them. The effect is that an async algorithm may be used without
setting up the request callback, this leading to a kernel panic.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/tcrypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 4b9e23f..5dc5a25 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -314,7 +314,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	asg = &sg[8];
 	sgout = &asg[8];
 
-	tfm = crypto_alloc_aead(algo, 0, 0);
+	/* This test is not for ASYNC algorithms */
+	tfm = crypto_alloc_aead(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
-- 
2.0.5
