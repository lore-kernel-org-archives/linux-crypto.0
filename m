Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E45C10F00
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 15:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C67C20830
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 15:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfCUPMY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:12:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44602 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727857AbfCUPMY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 11:12:24 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CAEFBCD6B454FC9748A3;
        Thu, 21 Mar 2019 23:12:18 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Thu, 21 Mar 2019
 23:12:11 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <leitao@debian.org>, <nayna@linux.ibm.com>, <pfsmorigo@gmail.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <mpe@ellerman.id.au>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-crypto@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: vmx - Make p8_init and p8_exit static
Date:   Thu, 21 Mar 2019 23:11:48 +0800
Message-ID: <20190321151148.19128-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warnings:

drivers/crypto/vmx/vmx.c:44:12: warning:
 symbol 'p8_init' was not declared. Should it be static?
drivers/crypto/vmx/vmx.c:70:13: warning:
 symbol 'p8_exit' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index 31a98dc..a9f5198 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -41,7 +41,7 @@ static struct crypto_alg *algs[] = {
 	NULL,
 };
 
-int __init p8_init(void)
+static int __init p8_init(void)
 {
 	int ret = 0;
 	struct crypto_alg **alg_it;
@@ -67,7 +67,7 @@ int __init p8_init(void)
 	return ret;
 }
 
-void __exit p8_exit(void)
+static void __exit p8_exit(void)
 {
 	struct crypto_alg **alg_it;
 
-- 
2.7.0


