From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH v2 2/7] crypto: omap-aes: Increase priority of hw accelerator
Date: Tue, 7 Jul 2015 21:01:44 +0530
Message-ID: <1436283109-13318-3-git-send-email-lokeshvutla@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36813 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbbGGPey (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 11:34:54 -0400
In-Reply-To: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Increasing the priority of omap-aes hw algos, in order to take
precedence over sw algos.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 4a0e808..54925d9 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -834,7 +834,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "ecb-aes-omap",
-	.cra_priority		= 100,
+	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC,
@@ -856,7 +856,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "cbc-aes-omap",
-	.cra_priority		= 100,
+	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC,
@@ -882,7 +882,7 @@ static struct crypto_alg algs_ctr[] = {
 {
 	.cra_name		= "ctr(aes)",
 	.cra_driver_name	= "ctr-aes-omap",
-	.cra_priority		= 100,
+	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC,
-- 
1.9.1
