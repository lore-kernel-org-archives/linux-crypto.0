Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290BDC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Mar 2022 09:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242175AbiCXJ4V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Mar 2022 05:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241065AbiCXJ4U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Mar 2022 05:56:20 -0400
X-Greylist: delayed 944 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Mar 2022 02:54:48 PDT
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 556BA5C863
        for <linux-crypto@vger.kernel.org>; Thu, 24 Mar 2022 02:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Fj18xbrLORt0+H0IrJ
        pnPpEvXa/QkSFc+cbAzNAcUnk=; b=Hw/rnSvsruhki0fAY1KK6s/rTCVy9vOK1T
        L0Za/aUCSwA8zzg0Ub6iPBVuurlyFZQlRiOoFxioOCDj+FF0LWe/DIaBmiU4YO/D
        APfqWpnyEIgyXL9y9vwXJLUWrviXUyI5Szcj0PRg7CoKzxXZgR356Z2OU2Fe78GG
        TaSuRctMw=
Received: from localhost (unknown [159.226.95.33])
        by smtp7 (Coremail) with SMTP id C8CowAAHBI4GPDxit6YIEA--.9600S2;
        Thu, 24 Mar 2022 17:38:14 +0800 (CST)
From:   QintaoShen <unSimple1993@163.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, QintaoShen <unSimple1993@163.com>
Subject: [PATCH v1] crypto: stm32: Check for NULL return of kmalloc_array()
Date:   Thu, 24 Mar 2022 17:38:12 +0800
Message-Id: <1648114692-11175-1-git-send-email-unSimple1993@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: C8CowAAHBI4GPDxit6YIEA--.9600S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw1rZry5tr1rZw1kJFyfCrg_yoWfZwc_CF
        18Wr97W34jv392yrsFq393XryYqr4fZ3s29a90yF13t345Z3yfW3WxWrZxAF43C3y8K3W8
        C3WxCry2yr17XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUUpRRPUUUUU==
X-Originating-IP: [159.226.95.33]
X-CM-SenderInfo: 5xqvxz5sohimizt6il2tof0z/1tbiNBvNH1aD-KvjPQABsg
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As the potential failure of memory allocation, kmalloc_array() may return
NULL and lead to NULL pointer dereference because of the usage of 'rctx->hw_context'.

Therefore, it is better to check the return value of kmalloc_array().

Signed-off-by: QintaoShen <unSimple1993@163.com>
---
 drivers/crypto/stm32/stm32-hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d33006d..f1a1a13 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -970,7 +970,8 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
 					 sizeof(u32),
 					 GFP_KERNEL);
-
+	if (!rctx->hw_context)
+		return -ENOMEM;
 	preg = rctx->hw_context;
 
 	*preg++ = stm32_hash_read(hdev, HASH_IMR);
-- 
2.7.4

