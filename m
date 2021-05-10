Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3B5C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3426112F
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEJJD7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 05:03:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2739 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhEJJD6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 05:03:58 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fdw3R1W9DzqV1B;
        Mon, 10 May 2021 16:59:31 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 17:02:45 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] crypto: hisilicon/hpre - extend 'cra_driver_name' with curve name
Date:   Mon, 10 May 2021 16:59:48 +0800
Message-ID: <1620637188-36988-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620637188-36988-1-git-send-email-tanghui20@huawei.com>
References: <1620637188-36988-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently,'cra_driver_name' cannot be used to specify ecdh algorithm
with a special curve, so extending it with curve name.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index a380087..c07a7f5 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1940,7 +1940,7 @@ static struct kpp_alg ecdh_nist_p192 = {
 		.cra_ctxsize = sizeof(struct hpre_ctx),
 		.cra_priority = HPRE_CRYPTO_ALG_PRI,
 		.cra_name = "ecdh-nist-p192",
-		.cra_driver_name = "hpre-ecdh",
+		.cra_driver_name = "hpre-ecdh-nist-p192",
 		.cra_module = THIS_MODULE,
 	},
 };
@@ -1957,7 +1957,7 @@ static struct kpp_alg ecdh_nist_p256 = {
 		.cra_ctxsize = sizeof(struct hpre_ctx),
 		.cra_priority = HPRE_CRYPTO_ALG_PRI,
 		.cra_name = "ecdh-nist-p256",
-		.cra_driver_name = "hpre-ecdh",
+		.cra_driver_name = "hpre-ecdh-nist-p256",
 		.cra_module = THIS_MODULE,
 	},
 };
-- 
2.8.1

