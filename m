Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9165EC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 06:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63BE9217D7
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 06:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfBSGep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 01:34:45 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbfBSGep (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 01:34:45 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 341D99AE209194A88BEE;
        Tue, 19 Feb 2019 14:34:41 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Feb 2019
 14:34:34 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <sumit.garg@linaro.org>, <mpm@selenic.com>,
        <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] hwrng: Fix unsigned comparison with less than zero
Date:   Tue, 19 Feb 2019 14:33:02 +0800
Message-ID: <20190219063302.22888-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The return from the call to tee_client_invoke_func can be a
negative error code however this is being assigned to an
unsigned variable 'ret' hence the check is always false.
Fix this by making 'ret' an int.

Detected by Coccinelle ("Unsigned expression compared with zero:
ret < 0")

Fixes: 5fe8b1cc6a03 ("hwrng: add OP-TEE based rng driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/char/hw_random/optee-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 2b9fc8a..e9f4e10 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -73,7 +73,7 @@ struct optee_rng_private {
 static size_t get_optee_rng_data(struct optee_rng_private *pvt_data,
 				 void *buf, size_t req_size)
 {
-	u32 ret = 0;
+	int ret = 0;
 	u8 *rng_data = NULL;
 	size_t rng_size = 0;
 	struct tee_ioctl_invoke_arg inv_arg = {0};
@@ -172,7 +172,7 @@ static struct optee_rng_private pvt_data = {
 
 static int get_optee_rng_info(struct device *dev)
 {
-	u32 ret = 0;
+	int ret = 0;
 	struct tee_ioctl_invoke_arg inv_arg = {0};
 	struct tee_param param[4] = {0};
 
-- 
2.7.0


