Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F88C00A89
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 08:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EA7222228
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 08:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgJ3ISc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:18:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6671 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgJ3ISc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 04:18:32 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CMwDg1xlHz15PTM;
        Fri, 30 Oct 2020 16:18:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 30 Oct 2020 16:18:23 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: arm64 - move const after static
Date:   Fri, 30 Oct 2020 16:19:00 +0800
Message-ID: <1604045940-33684-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed the WARNING: Move const after static - use 'static const u8'

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 arch/arm64/crypto/aes-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-ce-glue.c b/arch/arm64/crypto/aes-ce-glue.c
index 56a5f6f..8ba6f04 100644
--- a/arch/arm64/crypto/aes-ce-glue.c
+++ b/arch/arm64/crypto/aes-ce-glue.c
@@ -77,7 +77,7 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 	/*
 	 * The AES key schedule round constants
 	 */
-	static u8 const rcon[] = {
+	static const u8 rcon[] = {
 		0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36,
 	};
 
-- 
2.7.4

