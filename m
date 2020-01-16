Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3401EC33CB3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15085207E0
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbgAPKPF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 05:15:05 -0500
Received: from foss.arm.com ([217.140.110.172]:47454 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgAPKPE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 05:15:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6649F31B;
        Thu, 16 Jan 2020 02:15:04 -0800 (PST)
Received: from e110176-lin.arm.com (unknown [10.50.4.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D24F3F534;
        Thu, 16 Jan 2020 02:15:02 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] crypto: ccree: fix typo in comment
Date:   Thu, 16 Jan 2020 12:14:37 +0200
Message-Id: <20200116101447.20374-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116101447.20374-1-gilad@benyossef.com>
References: <20200116101447.20374-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hadar Gat <hadar.gat@arm.com>

Fixed a typo in a commnet.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
---
 drivers/crypto/ccree/cc_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index c1066f433a28..4de25c85d127 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -48,7 +48,7 @@ int cc_pm_resume(struct device *dev)
 		dev_err(dev, "failed getting clock back on. We're toast.\n");
 		return rc;
 	}
-	/* wait for Crytpcell reset completion */
+	/* wait for Cryptocell reset completion */
 	if (!cc_wait_for_reset_completion(drvdata)) {
 		dev_err(dev, "Cryptocell reset not completed");
 		return -EBUSY;
-- 
2.23.0

