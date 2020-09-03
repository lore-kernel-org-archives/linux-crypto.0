Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FA6C2BBDB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 18:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE97B208C7
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599156261;
	bh=M/bUGa4+5MJQO1H2/94D6MztczIs+L3ZMGG4rxczDRY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zfEubA1epfT5300v5SsVgJCOEWyy0X4jDIXg6Xci+Tom7jOP82R7OexvJrfsGnYgX
	 Z8DGybZfybOEXKSOX/lDv6W10X7EAfyjBgRtdvFdSuEIny8w6Cyzrcm7NJay+fQvAf
	 yPJVWv9qvQG8x4mLDj2/BxIPX31Crc/OCZ9BbX9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgICSEU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 14:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgICSEQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 14:04:16 -0400
Received: from localhost.localdomain (unknown [194.230.155.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1537D20716;
        Thu,  3 Sep 2020 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599156255;
        bh=M/bUGa4+5MJQO1H2/94D6MztczIs+L3ZMGG4rxczDRY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dSuth1Xcu2mR6W60CDiFo6xBHvTnYdE2RuZ1UBFjiYVLyAtnwajOCWKR2YiBnIl1B
         OT4qYsIBRuzbqwpXwMFZt/JPHehgzo+i2aPQJZgVQ8a2LhvtynqZf5qdu+2kja09Vn
         q3YnNkvC9Xh1ns5aMLRflQvbavAtAw7cae6zzRFk=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] crypto: s5p-sss - Pass error from clk_get and reduce verbosity on deferral
Date:   Thu,  3 Sep 2020 20:04:00 +0200
Message-Id: <20200903180400.2865-3-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903180400.2865-1-krzk@kernel.org>
References: <20200903180400.2865-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pass the error directly from devm_clk_get() to describe the real reason,
instead of fixed ENOENT.  Do not print error messages on deferred probe.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index f67f1e22ecd1..e83145c43b18 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2201,11 +2201,10 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	pdata->clk = devm_clk_get(dev, variant->clk_names[0]);
-	if (IS_ERR(pdata->clk)) {
-		dev_err(dev, "failed to find secss clock %s\n",
-			variant->clk_names[0]);
-		return -ENOENT;
-	}
+	if (IS_ERR(pdata->clk))
+		return dev_err_probe(dev, PTR_ERR(pdata->clk),
+				     "failed to find secss clock %s\n",
+				     variant->clk_names[0]);
 
 	err = clk_prepare_enable(pdata->clk);
 	if (err < 0) {
@@ -2217,9 +2216,9 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	if (variant->clk_names[1]) {
 		pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
 		if (IS_ERR(pdata->pclk)) {
-			dev_err(dev, "failed to find clock %s\n",
-				variant->clk_names[1]);
-			err = -ENOENT;
+			err = dev_err_probe(dev, PTR_ERR(pdata->pclk),
+					    "failed to find clock %s\n",
+					    variant->clk_names[1]);
 			goto err_clk;
 		}
 
-- 
2.17.1

