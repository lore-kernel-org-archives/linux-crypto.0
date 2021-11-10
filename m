Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101D3C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB08A61078
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhKJLDU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbhKJLC7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:02:59 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BCDC06120B
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r5so2730074pls.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cMr0eE8FXgPe+QXcGVoNpVzyu/9rj5/pkeXUEo39aLo=;
        b=WvLNS+ggr7y59JU7GQNkZ16qg2QM7b5NhBYESPwK0gzPRVg7QE8HFXrALmBXcytmqJ
         JjD3zTTk78kldYjj4SIyaXQjdJPFu8UES1W3iJx9bsvMucETp5FdWsloIHj+9nub+FlI
         T+eaEOFxN6Xf9NZFdgGlOwZtyfh4eplPJqV4UIT8p1CZRVzVHTkOsPssRf0AvMm93tke
         i3gJVZbq7MLHYfM8M93NbWLGqIGh9tRTBOGoDek6pV6VYHfLXFZzMAcExWXw0zQ/aI+Q
         iYGn78bkkTPMbyfBdutcQO1JzhwFNwe+EZ2MS3nhPBb/R8pjpUxvTfQhBupkmPkdfYwu
         o5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMr0eE8FXgPe+QXcGVoNpVzyu/9rj5/pkeXUEo39aLo=;
        b=Fg2VaESbae6ZvVMgAFR7/Ui4eqAPguP30gAyCMWHNzx0OXhRIOZHohUm6IsUDV5SqH
         u9Ygb+lf6s3hYVlBBX9AOYdo9i6msgB3AnsKMXb7LvOAK1smZzz5sU7IO3np7PtsuI0n
         9fPceXHi1OWcvt9+w4lfp1GdJdPHtRdoyD3G4pkebs14aeD6hswivHR+q+RohXGKf6kW
         1R1XWoJHIonMAAv6BgbrcfLtyrlz5HeUU1H2wAAk89FtVttmWsqI258sInJKJacWgior
         03gjxvWrSMfpGqhL0R82lJ3Ri+Jb/tcUSB9RPGw0Sh78B8lD7STP6mRr4nGlwlRCuA2e
         Ukcw==
X-Gm-Message-State: AOAM531vnpD+u9dSptj8jORoYut6PRCc/27FzJlsODMN41tA+EpTbSyf
        /RnbDY2koeb1SWO34laK9YvTO4Z0lDqk8w==
X-Google-Smtp-Source: ABdhPJzvVpgiH2PlMxXWAmipSkGsWQhyKhW8YmToX7VhyCW0Zali00uwZ+BsJuQ7Wd8QuR87/F3Fpg==
X-Received: by 2002:a17:902:e851:b0:142:19fe:982a with SMTP id t17-20020a170902e85100b0014219fe982amr14573280plg.13.1636542011471;
        Wed, 10 Nov 2021 03:00:11 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:00:11 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 06/22] dt-bindings: qcom-bam: Add "powered remotely" mode
Date:   Wed, 10 Nov 2021 16:29:06 +0530
Message-Id: <20211110105922.217895-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In some configurations, the BAM DMA controller is set up by a remote
processor and the local processor can simply start making use of it
without setting up the BAM. This is already supported using the
"qcom,controlled-remotely" property.

However, for some reason another possible configuration is that the
remote processor is responsible for powering up the BAM, but we are
still responsible for initializing it (e.g. resetting it etc). Add
a "qcom,powered-remotely" property to describe that configuration.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[moved Stephan's change to the YAML dt-binding format]
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
 Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml b/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
index cfff3a2286fb..bf0a59e8a2bf 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
@@ -73,6 +73,12 @@ properties:
       Indicates that the bam is controlled by remote proccessor i.e.
       execution environment.
 
+  qcom,powered-remotely:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Indicates that the bam is powered up by a remote processor
+      but must be initialized by the local processor.
+
   qcom,num-ees:
     $ref: /schemas/types.yaml#/definitions/uint32
     minimum: 0
-- 
2.31.1

