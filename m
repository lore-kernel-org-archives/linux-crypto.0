Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532F8C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 09:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2595B24655
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 09:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAVJRl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 04:17:41 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgAVJRl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 04:17:41 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AEB42BAE94895711F33B;
        Wed, 22 Jan 2020 17:17:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 22 Jan 2020 17:17:32 +0800
From:   Hongbo Yao <yaohongbo@huawei.com>
To:     <jens.wiklander@linaro.org>, <Rijo-john.Thomas@amd.com>
CC:     <yaohongbo@huawei.com>, <chenzhou10@huawei.com>,
        <tee-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>,
        <Devaraj.Rangasamy@amd.com>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCH RESEND -next] tee: amdtee: amdtee depends on CRYPTO_DEV_CCP_DD
Date:   Wed, 22 Jan 2020 17:12:38 +0800
Message-ID: <20200122091238.65484-1-yaohongbo@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CRYPTO_DEV_CCP_DD=m and AMDTEE=y, the following error is seen
while building call.c or core.c

drivers/tee/amdtee/call.o: In function `handle_unload_ta':
call.c:(.text+0x35f): undefined reference to `psp_tee_process_cmd'
drivers/tee/amdtee/core.o: In function `amdtee_driver_init':
core.c:(.init.text+0xf): undefined reference to `psp_check_tee_status

Fix the config dependency for AMDTEE here.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 757cc3e9ff ("tee: add AMD-TEE driver")
Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
Reviewed-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/tee/amdtee/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/amdtee/Kconfig b/drivers/tee/amdtee/Kconfig
index 4e32b6413b41..191f9715fa9a 100644
--- a/drivers/tee/amdtee/Kconfig
+++ b/drivers/tee/amdtee/Kconfig
@@ -3,6 +3,6 @@
 config AMDTEE
 	tristate "AMD-TEE"
 	default m
-	depends on CRYPTO_DEV_SP_PSP
+	depends on CRYPTO_DEV_SP_PSP && CRYPTO_DEV_CCP_DD
 	help
 	  This implements AMD's Trusted Execution Environment (TEE) driver.
-- 
2.20.1

