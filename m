Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1909AC433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Mar 2021 14:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C7A61A0A
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Mar 2021 14:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhCXOdW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:33:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14861 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbhCXOdA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Mar 2021 10:33:00 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F59dW2Q1Kz8ywv;
        Wed, 24 Mar 2021 22:30:55 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 24 Mar 2021 22:32:45 +0800
From:   'Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Zaibo Xu" <xuzaibo@huawei.com>, Weili Qian <qianweili@huawei.com>,
        Meng Yu <yumeng18@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shukun Tan <tanshukun1@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC:     <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH -next] crypto: hisilicon/hpre - fix build error without CONFIG_CRYPTO_ECDH
Date:   Wed, 24 Mar 2021 14:42:39 +0000
Message-ID: <20210324144239.997757-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

GCC reports build error as following:

x86_64-linux-gnu-ld: drivers/crypto/hisilicon/hpre/hpre_crypto.o: in function `hpre_ecdh_set_secret':
hpre_crypto.c:(.text+0x269c): undefined reference to `crypto_ecdh_decode_key'

Fix it by selecting CRYPTO_ECDH.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index c45adb15ce8d..bb327d6e365a 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -69,6 +69,7 @@ config CRYPTO_DEV_HISI_HPRE
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_DH
 	select CRYPTO_RSA
+	select CRYPTO_ECDH
 	help
 	  Support for HiSilicon HPRE(High Performance RSA Engine)
 	  accelerator, which can accelerate RSA and DH algorithms.

