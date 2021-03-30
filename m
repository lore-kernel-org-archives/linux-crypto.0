Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F887C433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 11:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F14866195C
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 11:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhC3Lhe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 07:37:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15823 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhC3LhY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 07:37:24 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F8nS304hpz9tNM;
        Tue, 30 Mar 2021 19:35:15 +0800 (CST)
Received: from ubuntu.huawei.com (10.67.174.117) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 19:37:12 +0800
From:   Ruiqi Gong <gongruiqi1@huawei.com>
To:     Zaibo Xu <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Wang Weiyang" <wangweiyang2@huawei.com>,
        Ruiqi GONG <gongruiqi1@huawei.com>
Subject: [PATCH -next] crypto: hisilicon/hpre - fix a typo in hpre_crypto.c
Date:   Tue, 30 Mar 2021 07:51:24 -0400
Message-ID: <20210330115124.15508-1-gongruiqi1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Do a trivial typo fix.
s/discribed/described

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ruiqi Gong <gongruiqi1@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index d743c540d602..9fbb573fdb1e 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1758,7 +1758,7 @@ static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
 
 	/*
 	 * Src_data(gx) is in little-endian order, MSB in the final byte should
-	 * be masked as discribed in RFC7748, then transform it to big-endian
+	 * be masked as described in RFC7748, then transform it to big-endian
 	 * form, then hisi_hpre can use the data.
 	 */
 	ptr[31] &= 0x7f;
-- 
2.17.1

