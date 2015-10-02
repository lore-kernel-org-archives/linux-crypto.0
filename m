From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: atmel: Check for clk_prepare_enable() return value
Date: Fri,  2 Oct 2015 14:12:58 +0200
Message-ID: <1443787978-26624-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35134 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbbJBMNE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 08:13:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

clk_prepare_enable() can fail so add a check for this and
return the error code if it fails.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/atmel-aes.c  | 6 +++++-
 drivers/crypto/atmel-sha.c  | 6 +++++-
 drivers/crypto/atmel-tdes.c | 6 +++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 0f9a9dc..de8f5da 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -260,7 +260,11 @@ static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_ctx *ctx)
 
 static int atmel_aes_hw_init(struct atmel_aes_dev *dd)
 {
-	clk_prepare_enable(dd->iclk);
+	int err;
+
+	err = clk_prepare_enable(dd->iclk);
+	if (err)
+		return err;
 
 	if (!(dd->flags & AES_FLAGS_INIT)) {
 		atmel_aes_write(dd, AES_CR, AES_CR_SWRST);
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 5b35433..5e6cf08 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -794,7 +794,11 @@ static void atmel_sha_finish_req(struct ahash_request *req, int err)
 
 static int atmel_sha_hw_init(struct atmel_sha_dev *dd)
 {
-	clk_prepare_enable(dd->iclk);
+	int err;
+
+	err = clk_prepare_enable(dd->iclk);
+	if (err)
+		return err;
 
 	if (!(SHA_FLAGS_INIT & dd->flags)) {
 		atmel_sha_write(dd, SHA_CR, SHA_CR_SWRST);
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index ca29997..504e903 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -218,7 +218,11 @@ static struct atmel_tdes_dev *atmel_tdes_find_dev(struct atmel_tdes_ctx *ctx)
 
 static int atmel_tdes_hw_init(struct atmel_tdes_dev *dd)
 {
-	clk_prepare_enable(dd->iclk);
+	int err;
+
+	err = clk_prepare_enable(dd->iclk);
+	if (err)
+		return err;
 
 	if (!(dd->flags & TDES_FLAGS_INIT)) {
 		atmel_tdes_write(dd, TDES_CR, TDES_CR_SWRST);
-- 
2.4.9
