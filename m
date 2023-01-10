Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FABBC54EBC
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 13:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjAJNvV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 08:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238347AbjAJNu6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 08:50:58 -0500
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A159A13D3B;
        Tue, 10 Jan 2023 05:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1673358657;
  x=1704894657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bw++1q/WpttUTFptagdBASo7vbIKLpApNOLAXVx9xOg=;
  b=i8SZIszvcwraT16On8nD778GL02WCVhXiFQ49kbURaOw90e75UyindVf
   t3OWdq+6LrVdmk12WTpOfKzBqPz3SYLYYKo/fDnNbOwYFjaIanTReVrtC
   MvILVSDs9Xaooj5cbfczWgWo6jDdVpWDiea9QNFgukDo8Q/7ICQKu4Fiz
   GRGG/ajjCHeI844TnK4NnAlHHKG0/2sYMW6of6PSug6Qyz4aFIikmBPkZ
   P+FM7FDu0bj2sL0rna+D4FKPpqHrCsI3UptB7H24jMA1oFLz3tXcvJFnK
   +qPRYFXePB6l/wJeMj14AbU5iLVkpYMBUDRUpAPQvpzFckRappEMyQ7B7
   g==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <jesper.nilsson@axis.com>, <lars.persson@axis.com>
CC:     <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/12] crypto: axis - validate AEAD authsize
Date:   Tue, 10 Jan 2023 14:50:35 +0100
Message-ID: <20230110135042.2940847-6-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230110135042.2940847-1-vincent.whitchurch@axis.com>
References: <20230110135042.2940847-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Validate the AEAD authsize to fix errors like this with
CRYPTO_MANAGER_EXTRA_TESTS:

 alg: aead: artpec-gcm-aes setauthsize unexpectedly succeeded on test
 vector "random: alen=0 plen=60 authsize=6 klen=17 novrfy=0";
 expected_error=-22

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 87f82c314e48..0ffe6e0045aa 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1274,6 +1274,12 @@ static int artpec6_crypto_aead_set_key(struct crypto_aead *tfm, const u8 *key,
 	return 0;
 }
 
+static int artpec6_crypto_aead_setauthsize(struct crypto_aead *tfm,
+					   unsigned int authsize)
+{
+	return crypto_gcm_check_authsize(authsize);
+}
+
 static int artpec6_crypto_aead_encrypt(struct aead_request *req)
 {
 	int ret;
@@ -2829,6 +2835,7 @@ static struct aead_alg aead_algos[] = {
 	{
 		.init   = artpec6_crypto_aead_init,
 		.setkey = artpec6_crypto_aead_set_key,
+		.setauthsize = artpec6_crypto_aead_setauthsize,
 		.encrypt = artpec6_crypto_aead_encrypt,
 		.decrypt = artpec6_crypto_aead_decrypt,
 		.ivsize = GCM_AES_IV_SIZE,
-- 
2.34.1

