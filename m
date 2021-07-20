Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2BDC07E9B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CC366120F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhGTIRO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:14 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58869 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbhGTIPO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771352; x=1658307352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vcvACObpRITMXDzDHLitiZnMlmUTJastzPuxvVsqhm0=;
  b=DAWENFlHg0cxVLGivqGCcXKF9zctlUK7o27q6Thluzmw/OWYzqemiApp
   ExbORxXyiOrY+TtKxOpbKxCBcDx/K0N4fO2zd4ZtF6Wn41iyVHuTkREnI
   8Fxcd416TYvv1RWJcros/DFMe8EgISukAL/fcvZs+xVx46PCrHhIZ5X3h
   emBYgkRBBUujO3CQ/Vu1EkK8mbBgTCN9hCdB7pb8lopu8QQluYKv781YU
   XPubRQtIHAoZ6wkml7J2s9RNL6KVpIplSOyjxyFJ5j6o1jzDoe/2glmFt
   nTqeyo3InMWUNgas8Qv5rgfokp4Bz1ddXMVVSNOtIfVrtdaS1Jk1TV3mB
   g==;
IronPort-SDR: bDCKq+Uxxp+ORoo7I6MyAx8+kB3nGCL4yyy58aljvKBIC6FEjsv5MG23o+xcOlYXhfx65FpfWo
 oLNzhry+Pdn5zuGFO0jesGCuCEVP/iocJIc0U8oEV2+3+uJmjAG2pnvZW1soIfQ4tOvWMwl4Ng
 YS1Xd7M1faJ8+oH9k4vMXNqMgNTI5clSgZHal+d+0CbM0XSGwPhzotLDhf1CHfzUpXJu/0jlHj
 7lAVIQI8CXqlj3r16sGuV2Kl1kQZK+5wpEWVufTp0a5EIypmRqvDYArJcEnMG4oWjW/n+7Z6qU
 fnjJ6oTf1C/0X6iEHM81nCad
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="125187431"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:55:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:51 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:49 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 5/9] crypto: atmel-aes: Add NIST 800-38A's zero length cryptlen constraint
Date:   Tue, 20 Jul 2021 11:55:31 +0300
Message-ID: <20210720085535.141486-6-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST 800-38A requires for the ECB, CBC, CFB, OFB and CTR modes that
the plaintext and ciphertext to have a positive integer length.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 4e9515e8dd25..8ea873bf6b86 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1094,6 +1094,13 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	if (opmode == AES_FLAGS_XTS && req->cryptlen < XTS_BLOCK_SIZE)
 		return -EINVAL;
 
+	/*
+	 * ECB, CBC, CFB, OFB or CTR mode require the plaintext and ciphertext
+	 * to have a positve integer length.
+	 */
+	if (!req->cryptlen && opmode != AES_FLAGS_XTS)
+		return 0;
+
 	if ((opmode == AES_FLAGS_ECB || opmode == AES_FLAGS_CBC) &&
 	    !IS_ALIGNED(req->cryptlen, crypto_skcipher_blocksize(skcipher)))
 		return -EINVAL;
-- 
2.25.1

