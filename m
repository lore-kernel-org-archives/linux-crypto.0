Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124CBC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 12:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65852082E
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 12:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfLQMHM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 07:07:12 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:37218 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727806AbfLQMHJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 07:07:09 -0500
X-Greylist: delayed 2162 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 07:07:09 EST
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ihB3Z-0004pv-Lh; Tue, 17 Dec 2019 11:30:25 +0000
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1ihB3Y-008qmJ-V6; Tue, 17 Dec 2019 11:30:24 +0000
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     ben.dooks@codethink.co.uk
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        YueHaibing <yuehaibing@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] crypto: sun4i-ss: make unexported sun4i_ss_pm_ops static
Date:   Tue, 17 Dec 2019 11:30:24 +0000
Message-Id: <20191217113024.2109457-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The sun4i_ss_pm_ops is not referenced outside the driver
except via a pointer, so make it static to avoid the following
warning:

drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c:276:25: warning: symbol 'sun4i_ss_pm_ops' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Allison Randal <allison@lohutok.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 814cd12149a9..52c8b7f680a7 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -273,7 +273,7 @@ static int sun4i_ss_pm_resume(struct device *dev)
 	return err;
 }
 
-const struct dev_pm_ops sun4i_ss_pm_ops = {
+static const struct dev_pm_ops sun4i_ss_pm_ops = {
 	SET_RUNTIME_PM_OPS(sun4i_ss_pm_suspend, sun4i_ss_pm_resume, NULL)
 };
 
-- 
2.24.0

