Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5F0C04FF3
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F211C61177
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhEVCZ5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 22:25:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5659 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhEVCZy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 22:25:54 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fn6fq22Q8z1BPn2;
        Sat, 22 May 2021 10:21:39 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 10:24:27 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 10:24:27 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] crypto: ecdh - fix 'ecdh_init'
Date:   Sat, 22 May 2021 10:21:22 +0800
Message-ID: <1621650084-25505-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621650084-25505-1-git-send-email-tanghui20@huawei.com>
References: <1621650084-25505-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST P192 is not unregistered if failed to register NIST P256,
actually it need to unregister the algorithms already registered.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 crypto/ecdh.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 4227d35..e2c4808 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -183,7 +183,16 @@ static int ecdh_init(void)
 	ret = crypto_register_kpp(&ecdh_nist_p192);
 	ecdh_nist_p192_registered = ret == 0;
 
-	return crypto_register_kpp(&ecdh_nist_p256);
+	ret = crypto_register_kpp(&ecdh_nist_p256);
+	if (ret)
+		goto nist_p256_error;
+
+	return 0;
+
+nist_p256_error:
+	if (ecdh_nist_p192_registered)
+		crypto_unregister_kpp(&ecdh_nist_p192);
+	return ret;
 }
 
 static void ecdh_exit(void)
-- 
2.8.1

