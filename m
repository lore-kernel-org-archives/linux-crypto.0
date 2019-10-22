Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FC4CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 06:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D06E2089E
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 06:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfJVGm2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 02:42:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53554 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729573AbfJVGm2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 02:42:28 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 79113D38A5E1D6BEEF27;
        Tue, 22 Oct 2019 14:42:26 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 22 Oct 2019
 14:42:20 +0800
To:     Herbert Xu <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Subject: [PATCH] crypto: arm64/aes-neonbs - remove redundant code in
 __xts_crypt()
Message-ID: <a33932c9-2975-4fcc-ba07-7c54df4eae27@huawei.com>
Date:   Tue, 22 Oct 2019 14:42:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A warning is found by the static code analysis tool:
  "Identical condition 'err', second condition is always false"

Fix this by removing the redundant condition @err.

Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index ea873b8904c4..7b342db428b0 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -387,7 +387,7 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 		skcipher_walk_done(&walk, nbytes);
 	}

-	if (err || likely(!tail))
+	if (likely(!tail))
 		return err;

 	/* handle ciphertext stealing */
-- 
2.7.4.3

