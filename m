Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F850C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C3D6610D0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhJMLCV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhJMLBu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 07:01:50 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C969FC0613B6
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:22 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d23so1941317pgh.8
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KIeSWkawFiY3EKsKgOHORiHIHpztrgHhtcjht+dbDL8=;
        b=F8EQQVS8lD2AmJe6NmVXJvx1DuV+9AXwJi6WVNUKBOPFyc9z+oQ+SEWtsm7ZAbsZUG
         Vwhju67oKN6l9EQAAWSlvo+EAWzpahGrZInHXAygLxRvfSlcnlIFpbNXndQzn2F58tre
         0Z9V7MJzPNy10twHrMiheNKA7QRd8SbMMYIPKRLbbRvZan/otoGnY7cnMkfnopgWHf7S
         wwKDQ8Sk32bAYfuT7vF6wOmnRFdVOty610dWcCc4SBGXg3pIw1p0ppJCrLdsHDidOc9c
         UOYhylRG9EsOEss1bmwScqx13yJRKQueS3OvylNWOfLQpWmTRvsSprH/eQHZM4tCGIFX
         7AaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KIeSWkawFiY3EKsKgOHORiHIHpztrgHhtcjht+dbDL8=;
        b=VmmTLWpxZl5JVKQoYaAOv6RNQgKUxHze7eraLURiJZSmyPW0urDDzFGk3/Ldcfh43O
         ADbToG8bt4rXfCL8vrM+Vkhg8dUUeKzLIIJg7lmxP9oaZ4hNb9OGk5EzpDuFvWDff1QW
         tto2TGx7SEh5l73NE7ngqdOGfsvwEpQ2kbl7MH5AYpjGL08i7Zp5uroSo9KOBCJTTwyX
         o5p07iTF4xWQSMLc3tfWR8WoU083yy/fe1IXAPSOGa2aMXjXlZlxNsNzMmEwc8JsqhAH
         CyuVGNcjB+mMgCZABkejIio/tQ1iVoN2kJKEElc9UGelo3v1geVYYLW5fw/PzDANnYaR
         xztw==
X-Gm-Message-State: AOAM530VhueBirINopxznbVNHp1W1SuYL/gNwNZ7NhiEQ7qL0B3sv4+6
        RttCsfxJ/cgCIlbOVwB2QW01Gw==
X-Google-Smtp-Source: ABdhPJyn/6vHcY71500LqC+ZB4kTKev7QGx8YUDta7MQFz8PtPTUQEw7o/zGmliHgnQWK4XYVdpXQg==
X-Received: by 2002:a63:392:: with SMTP id 140mr27804274pgd.189.1634122642326;
        Wed, 13 Oct 2021 03:57:22 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:57:22 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v4 19/20] crypto: qce: Add 'sm8250-qce' compatible string check
Date:   Wed, 13 Oct 2021 16:25:40 +0530
Message-Id: <20211013105541.68045-20-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add 'sm8250-qce' compatible string check in qce crypto
driver as we add support for sm8250 crypto device in the
device-tree in the subsequent patch.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/crypto/qce/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index c6f686126fc9..4c55eceb4e7f 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -306,6 +306,7 @@ static int qce_crypto_remove(struct platform_device *pdev)
 static const struct of_device_id qce_crypto_of_match[] = {
 	{ .compatible = "qcom,ipq6018-qce", },
 	{ .compatible = "qcom,sdm845-qce", },
+	{ .compatible = "qcom,sm8250-qce", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
-- 
2.31.1

