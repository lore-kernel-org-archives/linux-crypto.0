Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE14C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 15:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5994B2087D
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599059209;
	bh=R9eOfQhQb+/XeZ5M4+bYUU5e3t9TRQD0NsZttudCC+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eN0REoWWrwPnMZNzBke8lED5f2bhiWA4zxTF2IbppaiSDpIrLpuYCJiNVCNJANvtZ
	 QByXASReXF5bVRB0fA+YejJMStQGQAYqQHJwau2u/gBxHiM8gVqp/WhR5FDXZL5Jhz
	 pmhzZoJzU7J5MCiZ8WoLUGwh3i6a7DAuULL3+xp0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgIBPGi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgIBPFp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 11:05:45 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DACC020BED;
        Wed,  2 Sep 2020 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599059145;
        bh=R9eOfQhQb+/XeZ5M4+bYUU5e3t9TRQD0NsZttudCC+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmZAi40hKptfBUA/mVShlTC34b3ps+FNOyGPnDSwMzL1Alnl5ayCHzkLjaaqNv+39
         TQ9Z9m4CdmPGBqjarBXZQcViBHC54orEyfCaQ76S+jdKRwWZh4o05CWCmkiH/I7390
         go5OlD4b8vx13jhs1LXU3gIox4l3a3f4lde1Jmbw=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/4] crypto: stm32-hash - Simplify with dev_err_probe()
Date:   Wed,  2 Sep 2020 17:05:29 +0200
Message-Id: <20200902150530.14640-3-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200902150530.14640-1-krzk@kernel.org>
References: <20200902150530.14640-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Common pattern of handling deferred probe can be simplified with
dev_err_probe().  Less code and the error value gets printed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/stm32/stm32-hash.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 092eaabda238..3524130cf6ee 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1464,14 +1464,9 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	}
 
 	hdev->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(hdev->clk)) {
-		if (PTR_ERR(hdev->clk) != -EPROBE_DEFER) {
-			dev_err(dev, "failed to get clock for hash (%lu)\n",
-				PTR_ERR(hdev->clk));
-		}
-
-		return PTR_ERR(hdev->clk);
-	}
+	if (IS_ERR(hdev->clk))
+		return dev_err_probe(dev, PTR_ERR(hdev->clk),
+				     "failed to get clock for hash\n");
 
 	ret = clk_prepare_enable(hdev->clk);
 	if (ret) {
-- 
2.17.1

