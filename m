Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5380C636C8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 901CA61209
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhGTIR0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24894 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhGTIPO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771353; x=1658307353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bwI9gxWGdNp9j8lflPn0ecNSwTANdGc33doeihFdZBM=;
  b=aFILqc88OHeIn5EoeRnv3odvf7ddKm8x2eOlmU8HxlPkh9+28XwmKdOO
   hh7CIKobqgKGq6zbqdhEuos6fnNTGuOV9rQCaURs1KbkYdTDlDQ47iElF
   42re+ZKm/+KAZxyuplXYarQGLxsw+OENNxkKHMderScGJhymRB596QBrc
   sTCotYZvZuuTLkF3qyjGsWcYE7r6emt4WQ+hxihZhmXsiqGdIEdda1Yzh
   2n5rLVAtGyPn3XRPPVhZKb5x9Eyt2SG3Ewe7NTdWKRBzBpwuc+HpHCemf
   F9BqInF9X16J/DDBcboEpG8V7B0kDGAeBlJoBkbMQPA1X7nhfQE3ZQejR
   A==;
IronPort-SDR: AsQ9+fN3cEW94XouGCgB6FtnzgJB6gnbcpyPSJXngBjjJnc/p5Q1/brJHQe5Av3RttOKMWiA4X
 12ygX0KneBZJ+vxZ6nWRqIfPOSjOP/LsLJ8mWytfAhigl09WGJxqgZ5rLrJNN3291Ddv3nUDDI
 GB0tQ0iOwzXtEEaOUY4ihvmDWRP8LWhM62uhEtzcmPvN9q1vKdG9XzloiWYkO8D6VEqPbS91nT
 zV3WWl4gvxZNp7KD36MwVWIa6EZMLbP/CFbdwzzgmUyoBTubtfhl0BQfDqJ4Rvq16qZRrs+73P
 ae5mULGi1pT0nVdn1ImFmndI
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="128973620"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:55:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:49 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:47 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 4/9] crypto: atmel-aes: Add XTS input length constraint
Date:   Tue, 20 Jul 2021 11:55:30 +0300
Message-ID: <20210720085535.141486-5-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Input length smaller than block size does not make sense for XTS.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9c6d80d1d7a0..4e9515e8dd25 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1091,6 +1091,9 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct atmel_aes_dev *dd;
 	u32 opmode = mode & AES_FLAGS_OPMODE_MASK;
 
+	if (opmode == AES_FLAGS_XTS && req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
 	if ((opmode == AES_FLAGS_ECB || opmode == AES_FLAGS_CBC) &&
 	    !IS_ALIGNED(req->cryptlen, crypto_skcipher_blocksize(skcipher)))
 		return -EINVAL;
-- 
2.25.1

