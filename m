Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC75C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 03:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 103C721D91
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 03:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgINDzX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:55:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbgINDzV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Sep 2020 23:55:21 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 74C9DC398F6E1AE79224;
        Mon, 14 Sep 2020 11:55:17 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 14 Sep 2020
 11:55:06 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] crypto: atmel-aes - convert to use be32_add_cpu()
Date:   Mon, 14 Sep 2020 12:17:46 +0800
Message-ID: <20200914041746.3701896-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert cpu_to_be32(be32_to_cpu(E1) + E2) to use be32_add_cpu().

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index a6e14491e080..b1d286004295 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1539,7 +1539,7 @@ static int atmel_aes_gcm_length(struct atmel_aes_dev *dd)
 
 	/* Write incr32(J0) into IV. */
 	j0_lsw = j0[3];
-	j0[3] = cpu_to_be32(be32_to_cpu(j0[3]) + 1);
+	be32_add_cpu(&j0[3], 1);
 	atmel_aes_write_block(dd, AES_IVR(0), j0);
 	j0[3] = j0_lsw;
 
-- 
2.25.1

