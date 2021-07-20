Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481E4C07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F97D6121E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhGTIRL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:11 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41167 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbhGTIPZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771363; x=1658307363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xHDP9R1cWsgZiXIzdqzaDMHHbipFi9sp5dcaOBn5n0o=;
  b=11ejAgNJezyRv1EhFFCw0Al3NRt38i604JW2fratfyNL3hcQFCmlP4XZ
   hidU9ggpdrpdPDGRGXehi5We1IOz6I9ZGwAlFHQbBf69ZmUPp8KIME0iH
   WZs0BFP7jptnLHpDKzpdapQ7ePi4qkhDRcwce9LWQ79zxx94yzSvWd3DK
   O/8f1+uXuOzv0p4DRpHSOMUTvrS22n7DYjihTkbZSO+luZaKa44ho1Th5
   nhx/ngAaxXjz/IkHD3/B+IB3RnudtLWwsu+R0H10Cs+/5a/iZ5RLXS98J
   2eUgdfO6MIyAMnQjoGjFALMGXezdCvu17Mfoo9VEQje9OjsESff6ohHn3
   A==;
IronPort-SDR: lQhwY62eWH1AlEOO9o2bVJgXPUY1yJuABOrHqL4FaIjkAYr2dTcZZ0hws1sbUwzbMWegScQPwV
 YqVlO5U5zu+ZefWqirqgoMvZDLq8ruliIgDCbhxQqYTDqfL9EEA0a9Qe3k7MXReU7HO7J5yAcu
 blh5yaEc4JBBXMy5V67JRxeuF0lZW8ACFXW3O/84jRpyIxLFqMQL4qLUuioFjG7816yruo8a/S
 TO0+LE8/MZ9MZEBwRFBCUOT8mM6h0rxW3jX/rrcaMD92B6c3WM4EmZABZiFfXi5+QEjdJ+cRZl
 0lwasilV2puE3lX/cwN1nPfY
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="122687363"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:56:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:56 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:54 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 7/9] crypto: atmel-{aes, tdes}: Set OFB's blocksize to 1
Date:   Tue, 20 Jul 2021 11:55:33 +0300
Message-ID: <20210720085535.141486-8-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set cra_blocksize to 1 to indicate OFB is a stream cipher.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 2 +-
 drivers/crypto/atmel-tdes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 8ea873bf6b86..9ec007b4f8fc 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1305,7 +1305,7 @@ static struct skcipher_alg aes_algs[] = {
 {
 	.base.cra_name		= "ofb(aes)",
 	.base.cra_driver_name	= "atmel-ofb-aes",
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct atmel_aes_ctx),
 
 	.init			= atmel_aes_init_tfm,
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 8380e0ab149a..e30786ec9f2d 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -991,7 +991,7 @@ static struct skcipher_alg tdes_algs[] = {
 {
 	.base.cra_name		= "ofb(des)",
 	.base.cra_driver_name	= "atmel-ofb-des",
-	.base.cra_blocksize	= DES_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_alignmask	= 0x7,
 
 	.min_keysize		= DES_KEY_SIZE,
-- 
2.25.1

