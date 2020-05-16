Return-Path: <SRS0=7V1w=66=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530DFC433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 May 2020 04:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B7A206D4
	for <linux-crypto@archiver.kernel.org>; Sat, 16 May 2020 04:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pQwc7OQZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgEPEXO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 May 2020 00:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgEPEXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 May 2020 00:23:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9A0C061A0C;
        Fri, 15 May 2020 21:23:12 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so1752047plo.7;
        Fri, 15 May 2020 21:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OEbwsoaIcCQ4y8nX9CNRFLXSvzUNmbajCyzAAZz+JCQ=;
        b=pQwc7OQZ3rtpfftGLFLVGY4y3q033b7NvjPTHqTWGp38v5/q+pSlYTxQ+94qxbdP5b
         Zd70wtp902/pB3pzBoWRiPty2nvL7PCf8tiLh4pUhdav2+ELgKksaRc5v3dr8GggRrsj
         1RF3XFvOhQfAiCvyydbYIbqv+gJBwpL7YspXlUirnbR3gQ/qSA801ZBE78iXr6MDqMqY
         6nRJSUqFJm7iVGEz7geJmTmYpZuWfpQIIUaqiH4HK9a8LLX/F4jNBb1zmbV0Ctq+Ip1D
         zdnFxprUWamkRp/43Aof9bRkdeyiWtsb5NfjcHywsNH1diI+rt6GSwQEtIzKBsMveh0O
         QFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OEbwsoaIcCQ4y8nX9CNRFLXSvzUNmbajCyzAAZz+JCQ=;
        b=ktBECvp/740AQNl+aeWKMHXU0tg7ltcWFaZ+uG4L3vVGe7bxHaIpCbPfrx56pTc3qN
         kgOz1rzub4Bt4ELAalV4PBuugiK6aGyoMjyGdsW0sN09Jd821Asb7wX/C9FAkLTZdJ3T
         vCT4/26jX06MBnffMpwilOS2NuowaN3HRFcDeTyTiLEKDtzyPPkF+dB0JhkA4aQ6mFM5
         Q6wnXJZ/zra5/Ea2Bel/sFC4pNi43zJ6kGYmfN+BwB/OZhyk+2ZNLuHd0LpLPYHvS0PB
         kkWTeKJe6YoEb3zknEQoUI+OnrnwDpcidei/R4ziFDW7l+Ss3njCk2TMwAYHpffX3Y2g
         FXxg==
X-Gm-Message-State: AOAM533v4wjFyEbf4Rpu8Bly8ixs6f2OGCafuL87W+5MVeWnVaSvR00N
        xLEBa4VF8tpEddOaxsdkZblTfmA3
X-Google-Smtp-Source: ABdhPJzPzhcBZlRBUKU1oBCmskE7TfbETcrLnUkLn/PjCMvGULNr+qVI6ZvaXshdd/gkV10B9Fp9Vw==
X-Received: by 2002:a17:902:bd87:: with SMTP id q7mr6582092pls.92.1589602991273;
        Fri, 15 May 2020 21:23:11 -0700 (PDT)
Received: from squirtle.lan (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id 196sm2862590pfx.105.2020.05.15.21.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 21:23:10 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam - make soc match data optional
Date:   Fri, 15 May 2020 21:23:03 -0700
Message-Id: <20200516042303.6070-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Vyrbrid devices don't have any clock that need to be taken care of, so
make clock data optional on i.MX.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 4fcdd262e581..6aba430793cc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -630,12 +630,7 @@ static int caam_probe(struct platform_device *pdev)
 	imx_soc_match = soc_device_match(caam_imx_soc_table);
 	caam_imx = (bool)imx_soc_match;

-	if (imx_soc_match) {
-		if (!imx_soc_match->data) {
-			dev_err(dev, "No clock data provided for i.MX SoC");
-			return -EINVAL;
-		}
-
+	if (imx_soc_match && imx_soc_match->data) {
 		ret = init_clocks(dev, imx_soc_match->data);
 		if (ret)
 			return ret;
--
2.21.3
