Return-Path: <SRS0=pGAR=XD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CCCC433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Sep 2019 08:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE84620854
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Sep 2019 08:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfIHIEe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:04:34 -0400
Received: from foss.arm.com ([217.140.110.172]:40234 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfIHIEe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Sep 2019 04:04:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0F8B337;
        Sun,  8 Sep 2019 01:04:33 -0700 (PDT)
Received: from ssg-dev-vb.kfn.arm.com (E110178.Arm.com [10.50.4.168])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C80E73F67D;
        Sun,  8 Sep 2019 01:04:32 -0700 (PDT)
From:   Uri Shir <uri.shir@arm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Gilad <gilad@benyossef.com>
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ccree - enable CTS support in AES-XTS
Date:   Sun,  8 Sep 2019 11:04:26 +0300
Message-Id: <1567929866-7089-1-git-send-email-uri.shir@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In XTS encryption/decryption the plaintext byte size
can be >= AES_BLOCK_SIZE. This patch enable the AES-XTS ciphertext
stealing implementation in ccree driver.

Signed-off-by: Uri Shir <uri.shir@arm.com>
---
 drivers/crypto/ccree/cc_cipher.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 5b58226..a95d3bd 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -116,10 +116,6 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 	case S_DIN_to_AES:
 		switch (ctx_p->cipher_mode) {
 		case DRV_CIPHER_XTS:
-			if (size >= AES_BLOCK_SIZE &&
-			    IS_ALIGNED(size, AES_BLOCK_SIZE))
-				return 0;
-			break;
 		case DRV_CIPHER_CBC_CTS:
 			if (size >= AES_BLOCK_SIZE)
 				return 0;
@@ -945,7 +941,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "xts(paes)",
 		.driver_name = "xts-paes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -963,7 +959,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "xts512(paes)",
 		.driver_name = "xts-paes-du512-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -982,7 +978,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "xts4096(paes)",
 		.driver_name = "xts-paes-du4096-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1203,7 +1199,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "xts(aes)",
 		.driver_name = "xts-aes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1220,7 +1216,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "xts512(aes)",
 		.driver_name = "xts-aes-du512-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1238,7 +1234,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "xts4096(aes)",
 		.driver_name = "xts-aes-du4096-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
-- 
2.7.4

