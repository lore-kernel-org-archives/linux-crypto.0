Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2B8C07E9D
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Sep 2022 10:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiIXKhi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Sep 2022 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiIXKhg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Sep 2022 06:37:36 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221C9124178;
        Sat, 24 Sep 2022 03:37:35 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MZQN14kF6z1P6rM;
        Sat, 24 Sep 2022 18:33:21 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 18:37:32 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 18:37:31 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/sec - enabling clock gating of the address prefetch module
Date:   Sat, 24 Sep 2022 18:34:45 +0800
Message-ID: <20220924103445.64422-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the value of clock gating register to 0x7fff to enable
clock gating of the address prefetch module. When the device is
idle, the clock is turned off to save power.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 3705412bac5f..6eb8a16ba0a7 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -55,7 +55,7 @@
 #define SEC_CONTROL_REG		0x301200
 #define SEC_DYNAMIC_GATE_REG		0x30121c
 #define SEC_CORE_AUTO_GATE		0x30212c
-#define SEC_DYNAMIC_GATE_EN		0x7bff
+#define SEC_DYNAMIC_GATE_EN		0x7fff
 #define SEC_CORE_AUTO_GATE_EN		GENMASK(3, 0)
 #define SEC_CLK_GATE_ENABLE		BIT(3)
 #define SEC_CLK_GATE_DISABLE		(~BIT(3))
-- 
2.33.0

