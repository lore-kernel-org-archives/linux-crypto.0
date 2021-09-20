Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC4CC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 18:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF5B600D4
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 18:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378965AbhITScL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 14:32:11 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:37174
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352646AbhITSaH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 14:30:07 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 54A813F328;
        Mon, 20 Sep 2021 18:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632162518;
        bh=RZrZe46PibOc6VV+U13ENsWARYzoTyYCxHt8wFyjnVY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=HutSIyPrh96ZCXYSLHh5fbc4BXZoKkqxTxEyn0XgHY9+qdmgTxjcNgTdN1ytrlRXO
         t/IoT45as39vaoJ7si2Sjwt++gU1RbHsGIDmgSn4SzBVGlyect26dM9p9RuQwz9rR5
         aYMbiZaCIDoYLZeY1ct3s0gI+z+TxJ+S3vdAKL/Q/mJp0oUCMEZ1Iq1PcnQcn8Hntr
         LzJOq9XXWI6w2IzKfr0ft4G6DbiCbSIYdL8A9DtkJbNnmns0MCSEILKWR/kLUrMdLk
         tZgT8HHxDHAXos/RzC4Dd5fjmjFU/VyyXy13u36adcVDsN8qKbXjUaY5F0DBqgOH0T
         l2TRfIGnJweQQ==
From:   Colin King <colin.king@canonical.com>
To:     Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon: Fix spelling mistake "COMSUMED" -> "CONSUMED"
Date:   Mon, 20 Sep 2021 19:28:38 +0100
Message-Id: <20210920182838.17218-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a literal string. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 7148201ce76e..873971ef9aee 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -218,7 +218,7 @@ static const struct debugfs_reg32 hzip_dfx_regs[] = {
 	{"HZIP_AVG_DELAY                 ",  0x28ull},
 	{"HZIP_MEM_VISIBLE_DATA          ",  0x30ull},
 	{"HZIP_MEM_VISIBLE_ADDR          ",  0x34ull},
-	{"HZIP_COMSUMED_BYTE             ",  0x38ull},
+	{"HZIP_CONSUMED_BYTE             ",  0x38ull},
 	{"HZIP_PRODUCED_BYTE             ",  0x40ull},
 	{"HZIP_COMP_INF                  ",  0x70ull},
 	{"HZIP_PRE_OUT                   ",  0x78ull},
-- 
2.32.0

