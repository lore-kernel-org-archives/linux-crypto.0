Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E055BCA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 08:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE53621872
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 08:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbfJVILb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 04:11:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387614AbfJVILb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 04:11:31 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CA90B8E4C52B6E750235;
        Tue, 22 Oct 2019 16:11:28 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Tue, 22 Oct 2019
 16:11:23 +0800
To:     Herbert Xu <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <ard.biesheuvel@linaro.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Subject: [PATCH v3] crypto: arm64/aes-neonbs - add return value of
 skcipher_walk_done() in __xts_crypt()
Message-ID: <aaf0f585-3a06-8af1-e2f1-ab301e560d49@huawei.com>
Date:   Tue, 22 Oct 2019 16:11:18 +0800
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

Fix this by adding return value of skcipher_walk_done().

Fixes: 67cfa5d3b721 ("crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2 -> v3:
 - add "Acked-by:"

v1 -> v2:
 - update the subject and comment
 - add return value of skcipher_walk_done()

 arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index ea873b8904c4..e3e27349a9fe 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -384,7 +384,7 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 			goto xts_tail;

 		kernel_neon_end();
-		skcipher_walk_done(&walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}

 	if (err || likely(!tail))
-- 
2.7.4.3

