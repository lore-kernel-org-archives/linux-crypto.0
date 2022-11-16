Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D608CC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Nov 2022 09:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiKPJYe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Nov 2022 04:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiKPJYb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2022 04:24:31 -0500
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 76C5CB52;
        Wed, 16 Nov 2022 01:24:28 -0800 (PST)
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
        by hzbj-icmmx-1 (Coremail) with SMTP id AQAAfwD3D_WUq3Rj1VTfAA--.22866S2;
        Wed, 16 Nov 2022 17:21:24 +0800 (CST)
Received: from phytium.com.cn (unknown [111.160.237.26])
        by mail (Coremail) with SMTP id AQAAfwBHUJBErHRjMH0JAA--.7835S3;
        Wed, 16 Nov 2022 17:24:21 +0800 (CST)
From:   Zhang Yiqun <zhangyiqun@phytium.com.cn>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yiqun <zhangyiqun@phytium.com.cn>
Subject: [PATCH] crypto: tcrypt - Fix multibuffer skcipher speed test mem leak
Date:   Wed, 16 Nov 2022 17:24:11 +0800
Message-Id: <20221116092411.2432-1-zhangyiqun@phytium.com.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: AQAAfwBHUJBErHRjMH0JAA--.7835S3
X-CM-SenderInfo: x2kd0wp1lt30o6sk53xlxphulrpou0/
Authentication-Results: hzbj-icmmx-1; spf=neutral smtp.mail=zhangyiqun
        @phytium.com.cn;
X-Coremail-Antispam: 1Uk129KBjvdXoW7JFW8trWUAF17try8ArWfAFb_yoWfArc_Wa
        90qr98ur4jvas7Gws8Aw48Jr1093W3tr18WFnrJw4UtFy7W3ykCanFkr43Zr1xu3y7Zr17
        Wa1kXr1DAw1UujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrnU
        Uv73VFW2AGmfu7jjvjm3AaLaJ3UjIYCTnIWjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRUUUUU
        UUUU=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the past, the data for mb-skcipher test has been allocated
twice, that means the first allcated memory area is without
free, which may cause a potential memory leakage. So this
patch is to remove one allocation to fix this error.

Signed-off-by: Zhang Yiqun <zhangyiqun@phytium.com.cn>
---
 crypto/tcrypt.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a82679b576bb..4c018d8d06c8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1090,15 +1090,6 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 			goto out_free_tfm;
 		}
 
-
-	for (i = 0; i < num_mb; ++i)
-		if (testmgr_alloc_buf(data[i].xbuf)) {
-			while (i--)
-				testmgr_free_buf(data[i].xbuf);
-			goto out_free_tfm;
-		}
-
-
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = skcipher_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-- 
2.17.1

