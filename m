Return-Path: <SRS0=0OXc=4P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72F6C4BA06
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Feb 2020 07:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D692072D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Feb 2020 07:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgB0HQs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Feb 2020 02:16:48 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:34912 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727336AbgB0HQs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Feb 2020 02:16:48 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8F06A889ABED8BB0365F;
        Thu, 27 Feb 2020 15:16:39 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 27 Feb 2020 15:16:29 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Hongbo Yao <yaohongbo@huawei.com>,
        "Zhou Wang" <wangzhou1@hisilicon.com>
Subject: [PATCH v2] crypto: hisilicon - qm depends on UACCE
Date:   Thu, 27 Feb 2020 15:12:28 +0800
Message-ID: <1582787548-28201-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hongbo Yao <yaohongbo@huawei.com>

If UACCE=m and CRYPTO_DEV_HISI_QM=y, the following error
is seen while building qm.o:

drivers/crypto/hisilicon/qm.o: In function `hisi_qm_init':
(.text+0x23c6): undefined reference to `uacce_alloc'
(.text+0x2474): undefined reference to `uacce_remove'
(.text+0x286b): undefined reference to `uacce_remove'
drivers/crypto/hisilicon/qm.o: In function `hisi_qm_uninit':
(.text+0x2918): undefined reference to `uacce_remove'
make[1]: *** [vmlinux] Error 1
make: *** [autoksyms_recursive] Error 2

This patch fixes the config dependency for QM and ZIP.

reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 8851161..095850d 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -40,6 +40,7 @@ config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 || COMPILE_TEST
 	depends on PCI && PCI_MSI
+	depends on UACCE || UACCE=n
 	help
 	  HiSilicon accelerator engines use a common queue management
 	  interface. Specific engine driver may use this module.
@@ -49,6 +50,7 @@ config CRYPTO_DEV_HISI_ZIP
 	depends on PCI && PCI_MSI
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	depends on !CPU_BIG_ENDIAN || COMPILE_TEST
+	depends on UACCE || UACCE=n
 	select CRYPTO_DEV_HISI_QM
 	help
 	  Support for HiSilicon ZIP Driver
-- 
2.8.1

