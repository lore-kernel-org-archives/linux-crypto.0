Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6839CC07E96
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Jul 2021 06:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F8E861289
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Jul 2021 06:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhGKGQh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Jul 2021 02:16:37 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:38015 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhGKGQh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Jul 2021 02:16:37 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d42 with ME
        id TiDq2500121Fzsu03iDqnV; Sun, 11 Jul 2021 08:13:50 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 11 Jul 2021 08:13:50 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, tomaszx.kowalik@intel.com,
        marco.chiappero@intel.com, andriy.shevchenko@linux.intel.com,
        fiona.trahe@intel.com, wojciech.ziemba@intel.com,
        ztong0001@gmail.com, qat-linux@intel.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 3/3] crypto: qat - Fix a typo in a comment
Date:   Sun, 11 Jul 2021 08:13:45 +0200
Message-Id: <7f6a70b57bf4da88027e9b64ce4c89336a4ebf27.1625983602.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1625983602.git.christophe.jaillet@wanadoo.fr>
References: <cover.1625983602.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

s/Enable/Disable/ when describing 'adf_disable_aer()'

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index d2ae293d0df6..ed3e40bc56eb 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -194,7 +194,7 @@ int adf_enable_aer(struct adf_accel_dev *accel_dev)
 EXPORT_SYMBOL_GPL(adf_enable_aer);
 
 /**
- * adf_disable_aer() - Enable Advance Error Reporting for acceleration device
+ * adf_disable_aer() - Disable Advance Error Reporting for acceleration device
  * @accel_dev:  Pointer to acceleration device.
  *
  * Function disables PCI Advance Error Reporting for the
-- 
2.30.2

