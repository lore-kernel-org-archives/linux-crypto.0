Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D5DC3F2C6
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 15:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC7D20863
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 15:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgCCPsd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 10:48:33 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:60421 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728291AbgCCPsd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 10:48:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TrZE6tq_1583250489;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TrZE6tq_1583250489)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Mar 2020 23:48:10 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, ebiggers@kernel.org, pvanleeuwen@rambus.com,
        zohar@linux.ibm.com
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qat - simplify the qat_crypto function
Date:   Tue,  3 Mar 2020 23:48:09 +0800
Message-Id: <20200303154809.81817-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

simplify code to remove unnecessary constant string copies.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 3852d31ce0a4..fb504cee0305 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -250,8 +250,7 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
-	strlcpy(key, ADF_NUM_CY, sizeof(key));
-	if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+	if (adf_cfg_get_param_value(accel_dev, SEC, ADF_NUM_CY, val))
 		return -EFAULT;
 
 	if (kstrtoul(val, 0, &num_inst))
-- 
2.17.1

