From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH][REPOST] crypto: caam - Fix missing init of '.type' in AEAD algos.
Date: Tue, 12 Mar 2013 14:09:24 +0530
Message-ID: <1363077564-25886-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:46568
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813Ab3CLI5y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Mar 2013 04:57:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Following AEAD algo templates are updated for '.type' initialization.
	(a) authenc(hmac(sha224),cbc(aes))
	(b) authenc(hmac(sha384),cbc(aes))
	(c) authenc(hmac(sha224),cbc(des3_ede))
	(d) authenc(hmac(sha384),cbc(des3_ede))
	(e) authenc(hmac(sha224),cbc(des))
	(f) authenc(hmac(sha384),cbc(des))

Signed-off-by: Vakul Garg <vakul@freescale.com>
Reviewed-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Andy Fleming <afleming@freescale.com>

---
 drivers/crypto/caam/caamalg.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b2a0a07..42420fb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1697,6 +1697,7 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha224),cbc(aes))",
 		.driver_name = "authenc-hmac-sha224-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
@@ -1736,6 +1737,7 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha384),cbc(aes))",
 		.driver_name = "authenc-hmac-sha384-cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
@@ -1814,6 +1816,7 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha224),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha224-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
@@ -1853,6 +1856,7 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha384),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha384-cbc-des3_ede-caam",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
@@ -1930,6 +1934,7 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha224),cbc(des))",
 		.driver_name = "authenc-hmac-sha224-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
@@ -1969,6 +1974,7 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "authenc(hmac(sha384),cbc(des))",
 		.driver_name = "authenc-hmac-sha384-cbc-des-caam",
 		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-- 
1.7.7.6
