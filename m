Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC09C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB0B61038
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245075AbhIXJa1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:30:27 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:16294 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244920AbhIXJaZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Sep 2021 05:30:25 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HG6C82gYNz8tQf;
        Fri, 24 Sep 2021 17:28:04 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 17:28:48 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 24 Sep
 2021 17:28:48 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 6/6] crypto: hisilicon/sec - add sm3/md5 generic selection for ahash
Date:   Fri, 24 Sep 2021 17:27:16 +0800
Message-ID: <20210924092716.12848-7-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924092716.12848-1-yekai13@huawei.com>
References: <20210924092716.12848-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add sm3/md5 generic selection for ahash in the Kconfig.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index e572f9982d4e..300398665fc5 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -23,6 +23,8 @@ config CRYPTO_DEV_HISI_SEC2
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_HMAC
+	select CRYPTO_MD5
+	select CRYPTO_SM3
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-- 
2.33.0

