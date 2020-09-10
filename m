Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE48C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 19:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D761421D81
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 19:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599766434;
	bh=orngRUhSl9l3X7hGv/CI9HzZMY8gLdIvlGNKvUcPMhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=s8T995MOVDJVaJU0s5jeyuBjaS+2SvUg6PunP79oTrsVCu152xDqjtpFi9wrygl8g
	 Bdyaf7pT/udu6m69D09pz4kgpirgJPYqodssLM+gXqud65qS4gF9NuApgNof1GAT2W
	 WBKzoRPHRCBaHskrJd4Q8kJe+OZUGAQ7GaOf4RTI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgIJTbg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgIJT3a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 15:29:30 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E598721D91;
        Thu, 10 Sep 2020 19:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599766169;
        bh=orngRUhSl9l3X7hGv/CI9HzZMY8gLdIvlGNKvUcPMhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LrVyziBD+ZKBtC0vuwxz/pdDe5ERb2/m4gWYDms2mSX8hRmJ+3MJAfN5QFCstv8H
         hkk2UB3HmE0mb2UD26y1W/ya0AzJHesj0eCsa/mFutb1UQTxteRQu9siO1vi+7GJXH
         6H1PWhOGfcpaCDOdcgX9+9QnXwl1zRM6Un+Zfe3o=
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
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v2 2/4] crypto: caam - Simplify with dev_err_probe()
Date:   Thu, 10 Sep 2020 21:29:17 +0200
Message-Id: <20200910192919.12503-2-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910192919.12503-1-krzk@kernel.org>
References: <20200910192919.12503-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Common pattern of handling deferred probe can be simplified with
dev_err_probe().  Less code and the error value gets printed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>

---

Changes since v1:
1. Add Reviewed-by
---
 drivers/crypto/caam/caamalg_qi2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 0441e4ff2df2..076c6b04bea9 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5115,8 +5115,7 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dpseci_dev)
 	/* DPIO */
 	err = dpaa2_dpseci_dpio_setup(priv);
 	if (err) {
-		if (err != -EPROBE_DEFER)
-			dev_err(dev, "dpaa2_dpseci_dpio_setup() failed\n");
+		dev_err_probe(dev, err, "dpaa2_dpseci_dpio_setup() failed\n");
 		goto err_dpio_setup;
 	}
 
-- 
2.17.1

