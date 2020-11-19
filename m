Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F830C64E7D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37006246F0
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MjOP4uTZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgKSPwh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbgKSPwg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 10:52:36 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18114C0613CF
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:36 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id f93so4631227qtb.10
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bvhfCLHTYs7l5lsgLwNrBMAcXk6yVVYBXG3jF5cS+kE=;
        b=MjOP4uTZ8G2drLy+R/RvDTmkhN1lqBygMFznKx7ziyTeTkXMBCOuGlBlydlYEhLWX7
         ngUt75ThmQcdsQuf23omAO99hc0OHT4DMkNHzyw35nmR0qg0s6at9GgiN+un8UB0ZKyt
         CN4stsYDR09rcHDLMSmGEJrVrd4zlDh1e4KeQIIWdH5+qDmKUYeCd//oeo/cqgs6nsdt
         j8qQee8N+1vo5OCO9WkAZ4udArOify2tn9Nx90pk4hRlDz5UHBL6bXfaCzizk8pLV5yO
         Hp4BsToydhApUMbA8R8RMc5zkYXqh6w6yNqGjPM5FdTUNrV2PYxa4yX/hHiDjNfprfqw
         Yggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bvhfCLHTYs7l5lsgLwNrBMAcXk6yVVYBXG3jF5cS+kE=;
        b=Piz1EKukdVLLLn3jKfPxsfCGy2duUU97XGpBErFAWtFyPRLaIkDvoU5YxQRMRhEW2V
         8peO3gOsQ+vWZMM7H9zXusVnSj5I0ZtgYpZWBijzKMRskcMtaP99mgUFxW75HFmHNXXX
         5Wxx5n9J6NBiGwuXT8M8PtRoy0EUkAUz1Ft8/J6RS0FOAh3VwMvuWDfscM8clsAbRk4u
         nwVdv5jZPeA8ohTWTeMrlZpg6zFcfeq+oxo3iCImiX6Fl5/0WOUJH5ZTihxpjvXbchb1
         rck3AHqWRuRQ6oK1iXoSLKCj1zB7+aEriG+wXNmTX8as5EWbZXI4tBg58vvNv6I2Mh1l
         oGuw==
X-Gm-Message-State: AOAM531Wv6hsrPx5X6NZxJTztUkQBZ8ARZIQFgi/5qE2bN0RMJ5wh21C
        Nb9jwL0fUQLq3wr7H7EPpP+Hcw==
X-Google-Smtp-Source: ABdhPJwnQTWrrSwIs3w5+5w6NPMKWMWsTkoh980avt1UnXUDjYSHhhrtOQyVDGTYO0PGKo4rz9f6pg==
X-Received: by 2002:aed:2084:: with SMTP id 4mr10469682qtb.81.1605801155263;
        Thu, 19 Nov 2020 07:52:35 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id g70sm127290qke.8.2020.11.19.07.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:52:34 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [Patch v2 0/6] Enable Qualcomm Crypto Engine on sdm845
Date:   Thu, 19 Nov 2020 10:52:27 -0500
Message-Id: <20201119155233.3974286-1-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Qualcomm crypto engine supports hardware accelerated algorithms for
encryption and authentication. Enable support for aes,des,3des encryption
algorithms and sha1,sha256, hmac(sha1),hmac(sha256) authentication
algorithms on sdm845.The patch series has been tested using the kernel
crypto testing module tcrypto.ko.

v1->v2:
- Rebased to linux-next v5.10-rc4.
- Fixed subject line format in all patches as per Bjorn's feedback.

Thara Gopinath (6):
  dt-binding:clock: Add entry for crypto engine RPMH clock resource
  clk:qcom:rpmh: Add CE clock on sdm845.
  drivers:crypto:qce: Enable support for crypto engine on sdm845.
  drivers:crypto:qce: Fix SHA result buffer corruption issues.
  dts:qcom:sdm845: Add dt entries to support crypto engine.
  devicetree:bindings:crypto: Extend qcom-qce binding to add support for
    crypto engine version 5.4

 .../devicetree/bindings/crypto/qcom-qce.txt   |  4 ++-
 arch/arm64/boot/dts/qcom/sdm845.dtsi          | 30 +++++++++++++++++++
 drivers/clk/qcom/clk-rpmh.c                   |  2 ++
 drivers/crypto/qce/core.c                     | 17 ++++++++++-
 drivers/crypto/qce/sha.c                      |  2 +-
 include/dt-bindings/clock/qcom,rpmh.h         |  1 +
 6 files changed, 53 insertions(+), 3 deletions(-)

-- 
2.25.1

