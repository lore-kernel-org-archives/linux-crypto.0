From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH] crypto: caam - Fix missing init of '.type' in AEAD algos.
Date: Mon, 7 Jan 2013 16:58:19 +0530
Message-ID: <1357558099-4603-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:14654
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680Ab3AGLaj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jan 2013 06:30:39 -0500
Received: from mail50-co1 (localhost [127.0.0.1])	by mail50-co1-R.bigfish.com
 (Postfix) with ESMTP id 92F0F500058	for <linux-crypto@vger.kernel.org>; Mon,
  7 Jan 2013 11:30:38 +0000 (UTC)
Received: from CO1EHSMHS015.bigfish.com (unknown [10.243.78.217])	by
 mail50-co1.bigfish.com (Postfix) with ESMTP id 3E3618C00EC	for
 <linux-crypto@vger.kernel.org>; Mon,  7 Jan 2013 11:30:36 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r07BUXCY027603	for
 <linux-crypto@vger.kernel.org>; Mon, 7 Jan 2013 04:30:34 -0700
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
