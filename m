Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5168C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8378613E3
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhEEVjS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 17:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbhEEVjO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 17:39:14 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83562C061763
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 14:38:17 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y32so2786751pga.11
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 14:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mRrEkCTt84fVOsDtsgDP4oPLdjeOGHNGXk1uFFcE3+Y=;
        b=nJWgip7BvIqGFL1/DvcxAsopYjmE2vGuoCsexddbwV6zJuPKT2qkajFWtB/biaM3rI
         iB+OPJsGX9m6T4aJgvsvzC2T1QYtoHUKm0znNmgQeq1kCZ2wYVb21rUKgLLoJ5zVhNl7
         TvmDzFiohDSyZYKzRaZfbFPV/H7Rj1+SkIEMo6H+ZJ5lcGCe+x+RdTBIE3D50xUDRT+y
         Wokbvqgg9DDBxrp60in4ca0aQnZXei3SoOzOE1ioXnVZPPg2UnMPiTeevI40wFyXP/xx
         pSBe/ISvZ/tcLjFxwsy17OVr3YWuEnvIeAwbZnCwKNiWOWoTLnD9pPkmIny32TRf48c3
         zCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mRrEkCTt84fVOsDtsgDP4oPLdjeOGHNGXk1uFFcE3+Y=;
        b=HnsrE4UEE3Uvf0SGENhMnDai53J4+OaGSuD3g2q2gNrMFOvr0vkrly8Fa0assQ4CAb
         LWDqFuL5SQHaufkn3ZTP/6P4R5y5qaEfcr2Xxiox2Hz4AO3pU1XvBEUMNTgOcBaJdZb9
         ylRxrTaPM6PS0hhWiPyVriIj7evlIuPItjece2w5WpiBoKdPakCPTETNZlut5/XuH8Wm
         ZPz4M0O/14Iy9/sVeNoMqQJ2VlLhIfGq4UIMnb1xJWNJDMcXL4T2yIYdUoY3GxceW5bw
         qgJgIkJaDHAIjYYNp476r11xPcfYrxe5Kq387+NOpSmXukXYxBq+jYzPZhelE+hAziIE
         Sf8g==
X-Gm-Message-State: AOAM530K3Q+30qr+AdxSQA/126F+NExOSlTycSIOhSxIhsYL0T4Bu4x6
        9HOT8uYKIvWuCvr0SMYxZjAGzw==
X-Google-Smtp-Source: ABdhPJx536LRZ8fSBHRs4SnKnBCCiWPfmuFxvcaRuFCGwDSifKkxLv6sX1iId1QLl9QBcd9GOaR72w==
X-Received: by 2002:a63:5222:: with SMTP id g34mr919340pgb.309.1620250697112;
        Wed, 05 May 2021 14:38:17 -0700 (PDT)
Received: from localhost.localdomain.name ([223.235.141.68])
        by smtp.gmail.com with ESMTPSA id z26sm167031pfq.86.2021.05.05.14.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:38:16 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH v2 03/17] dt-bindings: qcom-qce: Add 'iommus' to required properties
Date:   Thu,  6 May 2021 03:07:17 +0530
Message-Id: <20210505213731.538612-4-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the missing required property - 'iommus' to the
device-tree binding documentation for qcom-qce crypto IP.

This property describes the phandle(s) to apps_smmu node with sid mask.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
index fdd53b184ba8..07ee1b12000b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.txt
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
@@ -11,6 +11,7 @@ Required properties:
 - dmas        : DMA specifiers for tx and rx dma channels. For more see
                 Documentation/devicetree/bindings/dma/dma.txt
 - dma-names   : DMA request names should be "rx" and "tx"
+- iommus      : phandle to apps_smmu node with sid mask
 
 Example:
 	crypto@fd45a000 {
-- 
2.30.2

