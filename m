Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E67C3F6B0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 08:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiHYIlv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 04:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238113AbiHYIlo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 04:41:44 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C545C7EFD9;
        Thu, 25 Aug 2022 01:41:42 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MCxH31bMLzGpqc;
        Thu, 25 Aug 2022 16:39:59 +0800 (CST)
Received: from dggphis33418.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 25 Aug 2022 16:41:39 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <cuigaosheng1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next 2/2] crypto: crc32c - add missing Kconfig option select
Date:   Thu, 25 Aug 2022 16:41:38 +0800
Message-ID: <20220825084138.1881954-3-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220825084138.1881954-1-cuigaosheng1@huawei.com>
References: <20220825084138.1881954-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CRYPTO_CRC32C is using functions provided by CRYPTO_MANAGER,
otherwise the following error will occur:

    EXT4-fs (mmcblk0): Cannot load crc32c driver.

So select CRYPTO_MANAGER when enable CRYPTO_CRC32C.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b1ccf873779d..7f124604323b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -641,6 +641,7 @@ config CRYPTO_CRC32C
 	tristate "CRC32c CRC algorithm"
 	select CRYPTO_HASH
 	select CRC32
+	select CRYPTO_MANAGER
 	help
 	  Castagnoli, et al Cyclic Redundancy-Check Algorithm.  Used
 	  by iSCSI for header and data digests and by others.
-- 
2.25.1

