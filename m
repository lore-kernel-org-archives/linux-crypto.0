Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555FFC48BE5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 15:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31C7561289
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jun 2021 15:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhFVPSg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jun 2021 11:18:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57269 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhFVPSe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jun 2021 11:18:34 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lvi8H-00019K-1t; Tue, 22 Jun 2021 15:16:09 +0000
From:   Colin King <colin.king@canonical.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Qinglang Miao <miaoqinglang@huawei.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qat: ratelimit invalid ioctl message and print the invalid cmd
Date:   Tue, 22 Jun 2021 16:16:08 +0100
Message-Id: <20210622151608.23741-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently incorrect QAT ioctls can spam the kernel log with error messages
of the form "QAT: Invalid ioctl" if a userspace program uses the wrong
ioctl command. Quench the messages by ratelimiting them and also print
the invalid command being used as that is useful to know.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 96b437bfe3de..6f64aa693146 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -406,7 +406,7 @@ static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		ret = adf_ctl_ioctl_get_status(fp, cmd, arg);
 		break;
 	default:
-		pr_err("QAT: Invalid ioctl\n");
+		pr_err_ratelimited("QAT: Invalid ioctl %d\n", cmd);
 		ret = -EFAULT;
 		break;
 	}
-- 
2.31.1

