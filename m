Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E58C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A16561132
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEJJD6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 05:03:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2613 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhEJJD6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 05:03:58 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fdw4n640szmVWT;
        Mon, 10 May 2021 17:00:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 17:02:45 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] crypto: ecdh - extend 'cra_driver_name' with curve name
Date:   Mon, 10 May 2021 16:59:47 +0800
Message-ID: <1620637188-36988-2-git-send-email-tanghui20@huawei.com>
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

Currently, 'cra_driver_name' cannot be used to specify ecdh algorithm
with a special curve, so extending it with curve name.

Although using 'cra_name' can also specify a special curve, but ecdh
generic driver cannot be specified when vendor hardware accelerator
has registered.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 crypto/ecdh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 04a427b..07eb34f 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -141,7 +141,7 @@ static struct kpp_alg ecdh_nist_p192 = {
 	.init = ecdh_nist_p192_init_tfm,
 	.base = {
 		.cra_name = "ecdh-nist-p192",
-		.cra_driver_name = "ecdh-generic",
+		.cra_driver_name = "ecdh-nist-p192-generic",
 		.cra_priority = 100,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct ecdh_ctx),
@@ -166,7 +166,7 @@ static struct kpp_alg ecdh_nist_p256 = {
 	.init = ecdh_nist_p256_init_tfm,
 	.base = {
 		.cra_name = "ecdh-nist-p256",
-		.cra_driver_name = "ecdh-generic",
+		.cra_driver_name = "ecdh-nist-p256-generic",
 		.cra_priority = 100,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct ecdh_ctx),
-- 
2.8.1

