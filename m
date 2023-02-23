Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5000C636D7
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 09:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjBWJA0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 04:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbjBWJAX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 04:00:23 -0500
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616BB4ECFD
        for <linux-crypto@vger.kernel.org>; Thu, 23 Feb 2023 01:00:15 -0800 (PST)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 31N8jWZW095530;
        Thu, 23 Feb 2023 16:45:32 +0800 (GMT-8)
        (envelope-from neal_liu@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.10) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Feb
 2023 16:58:34 +0800
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>,
        Neal Liu <neal_liu@aspeedtech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: aspeed: add error handling if dmam_alloc_coherent() failed
Date:   Thu, 23 Feb 2023 16:58:30 +0800
Message-ID: <20230223085830.605202-1-neal_liu@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.10.10]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 31N8jWZW095530
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since the acry_dev->buf_addr may be NULL, add error handling to
prevent any additional access to avoid potential issues.

Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
---
 drivers/crypto/aspeed/aspeed-acry.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 1f77ebd73489..85733e418c9e 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -782,6 +782,11 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 	acry_dev->buf_addr = dmam_alloc_coherent(dev, ASPEED_ACRY_BUFF_SIZE,
 						 &acry_dev->buf_dma_addr,
 						 GFP_KERNEL);
+	if (!acry_dev->buf_addr) {
+		rc = -ENOMEM;
+		goto err_engine_rsa_start;
+	}
+
 	memzero_explicit(acry_dev->buf_addr, ASPEED_ACRY_BUFF_SIZE);
 
 	aspeed_acry_register(acry_dev);
-- 
2.25.1

