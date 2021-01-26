Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE23C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jan 2021 06:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3DE722B3F
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jan 2021 06:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388495AbhAZGkd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jan 2021 01:40:33 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:50948 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387736AbhAZGio (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jan 2021 01:38:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=5Qzhy
        HkOIhzhyDKQmARRKm/yKJdbh50BiqAFk60dd7M=; b=HQv1XYRkgJvVvwKz2p6MX
        m2HfOT5CjTGyT18MnKmQfxiqV85u7AWSyu03/iTYhPwWaUy8m+qf3d7XBCgq8gwJ
        wedBfvtUsKhEoKCxBE6gVoWq26FjRfP5V6atMD4vOTgGSX7CmCfjfIuq8TY+ZUhm
        WeGj6Nymf10UjaozghbmMA=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp5 (Coremail) with SMTP id HdxpCgD3_4FpkA9gI1qZAA--.101S2;
        Tue, 26 Jan 2021 11:45:52 +0800 (CST)
From:   dingsenjie@163.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] crypto/ccree: fix spelling typo of allocated
Date:   Tue, 26 Jan 2021 11:45:53 +0800
Message-Id: <20210126034553.44496-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgD3_4FpkA9gI1qZAA--.101S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw4xWrWDurW5tr43AF1DJrb_yoW3Awb_u3
        yxWay7Xryj9wn3tr4UJw48ZrWF9343uFs2gr4jqrW5XFy3Zrs5uFy7ur13Ar17JrWrXryk
        uws2g3Wayw43ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5cNVDUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiThEmyFUDHcZbaAAAsP
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

allocted -> allocated

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/crypto/ccree/cc_cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index cdfee50..78833491 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -921,7 +921,7 @@ static int cc_cipher_process(struct skcipher_request *req,
 			return crypto_skcipher_decrypt(subreq);
 	}
 
-	/* The IV we are handed may be allocted from the stack so
+	/* The IV we are handed may be allocated from the stack so
 	 * we must copy it to a DMAable buffer before use.
 	 */
 	req_ctx->iv = kmemdup(iv, ivsize, flags);
-- 
1.9.1

