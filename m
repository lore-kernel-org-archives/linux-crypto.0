Return-Path: <SRS0=1eZC=DR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BEFC433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Oct 2020 02:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25CB92225D
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Oct 2020 02:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgJJCXq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 22:23:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45188 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730056AbgJJCGu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 22:06:50 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 16E6E3CE7B6A12A113A0;
        Sat, 10 Oct 2020 10:05:59 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 10 Oct 2020
 10:05:50 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] crypto: testmgr - Fix format argument warning
Date:   Sat, 10 Oct 2020 10:16:37 +0800
Message-ID: <20201010021637.112091-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix follow warning:
[crypto/testmgr.c:2317]: (warning) %d in format string (no. 5) requires
'int' but the argument type is 'unsigned int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a64a639eddfa..aefa4b6b8d78 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2315,7 +2315,7 @@ static void generate_random_aead_testvec(struct aead_request *req,
 	if (vec->setkey_error == 0 && vec->setauthsize_error == 0)
 		generate_aead_message(req, suite, vec, prefer_inauthentic);
 	snprintf(name, max_namelen,
-		 "\"random: alen=%u plen=%u authsize=%u klen=%u novrfy=%d\"",
+		 "\"random: alen=%u plen=%u authsize=%u klen=%u novrfy=%u\"",
 		 vec->alen, vec->plen, authsize, vec->klen, vec->novrfy);
 }
 
-- 
2.16.2.dirty

