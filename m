Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6CDC43334
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jun 2022 02:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356079AbiFVCDZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356009AbiFVCDY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jun 2022 22:03:24 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C21B30543;
        Tue, 21 Jun 2022 19:03:23 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 9C70D1E80CD1;
        Wed, 22 Jun 2022 10:03:15 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B_IKXUawNFvw; Wed, 22 Jun 2022 10:03:13 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 5DBFA1E80C7D;
        Wed, 22 Jun 2022 10:03:12 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yuzhe@nfschina.com, renyu@nfschina.com,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH] crypto: stm32 - Handle failure of kmalloc_array()
Date:   Wed, 22 Jun 2022 10:02:08 +0800
Message-Id: <20220622020208.25776-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As the possible failure of the kmalloc_array(), therefore it
should be better to check it and return '-ENOMEM' on error.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 drivers/crypto/stm32/stm32-hash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d33006d43f76..fc03e32e364f 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -970,6 +970,8 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
 					 sizeof(u32),
 					 GFP_KERNEL);
+	if (!rctx->hw_context)
+		return -ENOMEM;
 
 	preg = rctx->hw_context;
 
-- 
2.11.0

