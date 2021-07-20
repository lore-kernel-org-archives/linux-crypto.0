Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF08C636C8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAD1F6120F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhGTIQq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:16:46 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24883 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbhGTIPO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771353; x=1658307353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4K8bV3JW1qimCrMpXoHJsQZL134CQa/zIp1gnXlYhGc=;
  b=mmfMubMHmg0PHSf8kkH2lTsesccCzutpCkZRz6FSH/JyUG5JYF1nZJBa
   3ecJbLf27VoPKmn2QCgJcpWVtWlXBTWCUKtGaSKUsu2D2OIR75M4cAt60
   XFFR1MXIvSYIVt4i+XkxPpvHeAjTgQkMMgC0+evoYUTvWwazvPewvHPhE
   q8MU9bqZCahayiLL684hfq3GWN/G7+uA5nxYqdChh0LHIVpX5qabLaDq+
   B1116tk8oQ0qIDcqIwY80ovzKnWqFJuMeXM9tO1jWtY+yE0ikdAx9MvO8
   u/uRsYHyKKwso9z3h9wAdGBGMDX2EkfhPH8H9MHJipRbjMSJCSVWBqtc8
   g==;
IronPort-SDR: I4q7+Z6fn3oYhuvcx0Dx4rbfidh3/JIABjGawph2ZZgTmLayyT5c1+DMaR4X5hzvz4bRuOUMp7
 nOKDdGCKzwFsSstHvKBpmVvMHGRVQKugJvFtVwWLpHgpd6CZlTJW1QBj2b1Ju/i4hO0fvEcc9g
 d3i/F9gO8exC60K19JVbvXPjLXsXrgVvn5cNfqiqRgRhdcjD8b8X95Zu9Q+Y4PHPvcss49zIKH
 oSlCo/TwDBjr8f5+I8onQZpyN9Lbopo2RbyrJ9WN/++cuuwBcVVLYX46k4vYFGV2jZLXo/G20d
 aXgb4u/tl7qeQrUKQVWZ9ub/
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="128973603"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:55:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:41 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:39 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 1/9] crypto: atmel-tdes: Clarify how tdes dev gets allocated to the tfm
Date:   Tue, 20 Jul 2021 11:55:27 +0300
Message-ID: <20210720085535.141486-2-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The tdes dev gets allocated to the tfm at alg->init time, there's no
need to overwrite the pointer to tdes_dd afterwards.
There's a single IP per SoC anyway, the first entry from the
atmel_tdes.dev_list is chosen without counting for tfms for example,
in case one thinks of an even distribution of tfms across the TDES
IPs: there's only one. At alg->init time the ctx->dd should already
be NULL, there's no need to check its value before requesting for a
tdes dev.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-tdes.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 6f01c51e3c37..dda70dbe0838 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -196,23 +196,15 @@ static void atmel_tdes_write_n(struct atmel_tdes_dev *dd, u32 offset,
 		atmel_tdes_write(dd, offset, *value);
 }
 
-static struct atmel_tdes_dev *atmel_tdes_find_dev(struct atmel_tdes_ctx *ctx)
+static struct atmel_tdes_dev *atmel_tdes_dev_alloc(void)
 {
-	struct atmel_tdes_dev *tdes_dd = NULL;
-	struct atmel_tdes_dev *tmp;
+	struct atmel_tdes_dev *tdes_dd;
 
 	spin_lock_bh(&atmel_tdes.lock);
-	if (!ctx->dd) {
-		list_for_each_entry(tmp, &atmel_tdes.dev_list, list) {
-			tdes_dd = tmp;
-			break;
-		}
-		ctx->dd = tdes_dd;
-	} else {
-		tdes_dd = ctx->dd;
-	}
+	/* One TDES IP per SoC. */
+	tdes_dd = list_first_entry_or_null(&atmel_tdes.dev_list,
+					   struct atmel_tdes_dev, list);
 	spin_unlock_bh(&atmel_tdes.lock);
-
 	return tdes_dd;
 }
 
@@ -646,7 +638,6 @@ static int atmel_tdes_handle_queue(struct atmel_tdes_dev *dd,
 	rctx->mode &= TDES_FLAGS_MODE_MASK;
 	dd->flags = (dd->flags & ~TDES_FLAGS_MODE_MASK) | rctx->mode;
 	dd->ctx = ctx;
-	ctx->dd = dd;
 
 	err = atmel_tdes_write_ctrl(dd);
 	if (!err)
@@ -897,14 +888,13 @@ static int atmel_tdes_ofb_decrypt(struct skcipher_request *req)
 static int atmel_tdes_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct atmel_tdes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct atmel_tdes_dev *dd;
-
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_tdes_reqctx));
 
-	dd = atmel_tdes_find_dev(ctx);
-	if (!dd)
+	ctx->dd = atmel_tdes_dev_alloc();
+	if (!ctx->dd)
 		return -ENODEV;
 
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_tdes_reqctx));
+
 	return 0;
 }
 
-- 
2.25.1

