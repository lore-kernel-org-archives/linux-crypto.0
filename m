Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32B8C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 16:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5BA218D8
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 16:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfBKO2E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:28:04 -0500
Received: from foss.arm.com ([217.140.101.70]:49808 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729796AbfBKO2D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 09:28:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B623A78;
        Mon, 11 Feb 2019 06:28:03 -0800 (PST)
Received: from e110176-lin.benyossef.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B3EA3F575;
        Mon, 11 Feb 2019 06:28:01 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drag <ofir.drang@arm.com>, stable@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccree: add missing inline qualifier
Date:   Mon, 11 Feb 2019 16:27:58 +0200
Message-Id: <20190211142758.16718-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
was missing a "inline" qualifier for stub function used when CONFIG_PM
is not set causing a build warning.

Fixes: 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
Cc: stable@kernel.org # v4.20
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_pm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index f62624357020..907a6db4d6c0 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -30,7 +30,7 @@ static inline int cc_pm_init(struct cc_drvdata *drvdata)
 	return 0;
 }
 
-static void cc_pm_go(struct cc_drvdata *drvdata) {}
+static inline void cc_pm_go(struct cc_drvdata *drvdata) {}
 
 static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
 
-- 
2.20.1

