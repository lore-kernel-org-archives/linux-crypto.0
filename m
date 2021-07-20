Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF998C07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A70456120F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhGTIQz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:16:55 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41197 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbhGTIPW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771360; x=1658307360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BvECuVH1S6mHb7Y7yYH9mswdt55NYUYyII8/lZa041E=;
  b=usK8sDqnyEHhpaFKYyOEfjTmEqtKimJDJmaSw7wc3W3WuAHucHIy4c9W
   jfktzuI9p21K6vHjlccj45hki2/zukHAAQLB3fJ1O1o2pJw1n9LwbTU8Z
   EWOxKyV/UkrxOHxufxqtQ+YkopHGFv1jlPUibJ05mrurpPFfV7ZVVNUdu
   DLruFqOikrkZdc8NQ0xaqFLPvxB3qQUIH4BvvN8346SQq7/bPsOEDWTYe
   xUfcfu1Z4ypDgpm/LwCH4qwgNaXFeNmJ7jPYPmlw3V3oxQLLaFcRSsAtM
   lo9o3ImqHwKfS2r6puOUP8AfKJQVTdPfF1dn1v4tSd9JYY18/G+6N46mE
   g==;
IronPort-SDR: 8HrygmC+GMzUNr9H5XSw0CcQemSNAtSniSVFEhLaCJ9XhykYNjLDHr4mZLCRYkJhThV/LmTJZq
 Nczcz9ZpC3U8u91byBu74+MlhRmhFB75tOGV3qBS326gm1uwwCEBC4kBUwch5HT91Wevyn13jJ
 py4dcS80bUzgWrW3Q0iXQu0lHl5OC2ln1TxFzxsrW4kbqqfbudh5n7hGneqiu6PQlNo2x1shBh
 Ya3McoMA7Sj7axSt4o1fKrnPpr2/YyxNR8SBKumQ14Umc7JNksXiQvNKPsi8TbJ9+gKZp5xd7i
 aFWvdYGuM3gAD0581eSxX716
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="122687332"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:55:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:46 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:44 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 3/9] crypto: atmel-aes: Add blocksize constraint for ECB and CBC modes
Date:   Tue, 20 Jul 2021 11:55:29 +0300
Message-ID: <20210720085535.141486-4-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST 800-38A requires for the ECB and CBC modes that the total number
of bits in the plaintext to be a multiple of the block cipher.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index b1d286004295..9c6d80d1d7a0 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1089,6 +1089,11 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct atmel_aes_base_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct atmel_aes_reqctx *rctx;
 	struct atmel_aes_dev *dd;
+	u32 opmode = mode & AES_FLAGS_OPMODE_MASK;
+
+	if ((opmode == AES_FLAGS_ECB || opmode == AES_FLAGS_CBC) &&
+	    !IS_ALIGNED(req->cryptlen, crypto_skcipher_blocksize(skcipher)))
+		return -EINVAL;
 
 	switch (mode & AES_FLAGS_OPMODE_MASK) {
 	case AES_FLAGS_CFB8:
@@ -1120,7 +1125,7 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	rctx = skcipher_request_ctx(req);
 	rctx->mode = mode;
 
-	if ((mode & AES_FLAGS_OPMODE_MASK) != AES_FLAGS_ECB &&
+	if (opmode != AES_FLAGS_ECB &&
 	    !(mode & AES_FLAGS_ENCRYPT) && req->src == req->dst) {
 		unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 
-- 
2.25.1

