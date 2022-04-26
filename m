Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830FCC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Apr 2022 11:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242042AbiDZMDA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 08:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239509AbiDZMDA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 08:03:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B566339E;
        Tue, 26 Apr 2022 04:59:52 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KngNV48MVzGpRr;
        Tue, 26 Apr 2022 19:57:14 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 19:59:50 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 26 Apr
 2022 19:59:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/sec - add sm4 generic selection
Date:   Tue, 26 Apr 2022 19:53:58 +0800
Message-ID: <20220426115358.52392-1-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add sm4 generic selection for fallback tfm in the Kconfig.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index e572f9982d4e..27e1fa912063 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -26,6 +26,7 @@ config CRYPTO_DEV_HISI_SEC2
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_SM4
 	depends on PCI && PCI_MSI
 	depends on UACCE || UACCE=n
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
-- 
2.33.0

