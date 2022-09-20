Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEE5C6FA8B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 11:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiITLmx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 07:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiITLmJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 07:42:09 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27517436A
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w2so2539320pfb.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=f1jyoMzYrt7oW3ZWE+v01VrggZfcgZodlLjAeFXHMeI=;
        b=fs7gdTeOnh6ajT0yIBSWXYT4L2N3b4oPI9fdr6NeMuRnaU2VkFM0XPnXpJIdeR8O+e
         kZu6hYqU/o9vRacABqPnwhkoUpbz0jMgf1ALcVRubrxJj2jsydG8IWxizoMCO+EtXdC2
         trvFye6XTiVanq/1aBOn/53bG1OHC8bjNkhYsHOc5sQzNTyuoKsCbUz0fFXct3R8e+45
         0GUjjXp0x4kTuOrIsmBslPQxt3KgCEIPDUUpgEnd4HQ8TP+rPOKplxljq+cdJY2BhhnR
         umjKU0ViLgSz5GKHAqv+/4HjHg66/OpU9SpwDoeCdTauhrpVXfCh8PNj9X04jBBfiEAV
         V+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=f1jyoMzYrt7oW3ZWE+v01VrggZfcgZodlLjAeFXHMeI=;
        b=H4irKgVcRsgpq7+x4G4jOmikU1xopXeeQudNpkrpaVTAli7lOGd3sW+CYi2XaE5Ga4
         dhFF7TKuUzEJxwOl/MILUEGEOVKIMMetPQiRNHiaP7S8kEt3GMfpDnMYMDa+gOu4Ng0O
         xWXdibPGo7k5LxetPimdu+OiPN0BWLnoBUFfS8N6g2xwKDdz6M6rz81KujVRCJRECh1S
         DleEGYXkG5y10c02/yXOnPrgBN27c7enFPH3TCxGLS8HnbmKGD/BxEEZS+wyKnFHCQKg
         31Nc59QNdCgLuQeInHjr00s89xzxvBYWCJGHGy47Rxj5zo7dIPyOZimASUhNZkfbXUaj
         Er4g==
X-Gm-Message-State: ACrzQf28QKrKpSzY5AI40KiFf362Q1HFrQPRoxm8sNGNFX/hnm7fi34G
        +TEzGmuw2o9+H3L7nQ7Lnw/pZ/PEeMJncA==
X-Google-Smtp-Source: AMsMyM5ZD2aJk5iuQA6y0NmBUSdwRh7Wc1Io0QWIX9d73pd6IVTCE1fZfBRd+zTbW5U4KgT11NenvA==
X-Received: by 2002:a63:4c50:0:b0:429:983d:22f1 with SMTP id m16-20020a634c50000000b00429983d22f1mr20123611pgl.213.1663674110301;
        Tue, 20 Sep 2022 04:41:50 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:6535:ca5f:67d1:670d:e188])
        by smtp.gmail.com with ESMTPSA id p30-20020a63741e000000b00434e57bfc6csm1348793pgc.56.2022.09.20.04.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 04:41:49 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        robh@kernel.org, krzysztof.kozlowski@linaro.org,
        andersson@kernel.org, bhupesh.sharma@linaro.org,
        bhupesh.linux@gmail.com, davem@davemloft.net
Subject: [PATCH v7 9/9] MAINTAINERS: Add myself as a co-maintainer for Qualcomm Crypto Drivers
Date:   Tue, 20 Sep 2022 17:10:51 +0530
Message-Id: <20220920114051.1116441-10-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
References: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add myself as a co-maintainer of Qualcomm Crypto drivers.
As I will be working on enabling crypto block on newer
Qualcomm SoCs, I will also help review and co-maintain
the same.

Cc: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0556cd21f86..df5724cf608c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16945,6 +16945,7 @@ F:	drivers/cpufreq/qcom-cpufreq-nvmem.c
 
 QUALCOMM CRYPTO DRIVERS
 M:	Thara Gopinath <thara.gopinath@gmail.com>
+M:	Bhupesh Sharma <bhupesh.sharma@linaro.org>
 L:	linux-crypto@vger.kernel.org
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
-- 
2.37.1

