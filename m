Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFBFC433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 15:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7CD208DB
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599059212;
	bh=Kf4AGkwBeCGoHHALVeorzcgycX+eJy9K4IemTaY2rug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CJwL1fDd5x/O6bEJz4POycMc+ZMcgM8bLKxxRS1RhRjKD+oQpP8KTh/9S4q+5/YeF
	 mi/dN8dI6WNupR6XnGdXkCVXWwVa5+OTqCXWdZHJwTWjJUJuQ8vfnr5LJB5k52f4DE
	 XBK7JZANV7jdRSApYkMu4r8s08X9tGRCHXpbXHWU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgIBPGr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbgIBPFl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 11:05:41 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33E06208DB;
        Wed,  2 Sep 2020 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599059141;
        bh=Kf4AGkwBeCGoHHALVeorzcgycX+eJy9K4IemTaY2rug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSgk85zVnJwt/VLg6KrgcafVnr5qa9RP9MooVdCpAlnwQtnqKIbPFJrhmtrv38w4y
         jXfAlVoqW4GNgLiLrc23muvJZTjKhoGoiR3RyIEUbnXfgbCEpTFdbU+BmwPVNcNLxr
         EDn8X09KLElHzjuCD5vsFq83sVfcZ3idPyRGI1GU=
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
Subject: [PATCH 2/4] crypto: caam - Simplify with dev_err_probe()
Date:   Wed,  2 Sep 2020 17:05:28 +0200
Message-Id: <20200902150530.14640-2-krzk@kernel.org>
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

