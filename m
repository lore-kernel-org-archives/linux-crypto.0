Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BC4C6FD1B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Feb 2023 17:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjBVRXS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbjBVRXH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2023 12:23:07 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7ABAD3D
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:23:03 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z5so8617770ljc.8
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Yd9lAcpRbHxF9RdOizjwYgJ/PMIKmYOw1xnRDHR/30=;
        b=XXW5OMHy/Ep3rE1cyCMMyjv41Cxcwe0bWk6m626Cvkdu/gigRgK3hrhr4wZLNRkzTb
         RUdpKqVumScTcWzJKenYZ7Z9M4Qb8AEpyXcLa1shTpiq1rK5F+3FZPepli7+JyiM//Ht
         3mIrKnSczUR/hRWn+MZuKPZGSAqqS2Cn/ZOAq1773Rm63F9Ysk4l7emUqIxmDflkgIOO
         tFYRAlq8CgIbsWjqwJBXwEmqdkThdAHX9GbpSKqUhRDUV87nCWigWEar2v2aFqM0eePc
         JEaythDhhcjkzzm3yebBJJ2jCkyThfTDE/MxilZaqx3xIFtiBpOUTpxUYnnvxBxyY4r5
         mB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Yd9lAcpRbHxF9RdOizjwYgJ/PMIKmYOw1xnRDHR/30=;
        b=vETNcvf2B9O63znEKOF4fP3b4cHqGpdRLIG+AjxSf4puwlw6y/aVUHgz6cuWT27m8G
         CRCrQyh8mjCMV68IlCXPk0fZzznaxf5zS1NnD2ZdtkcizvXCKkprmDNH9lWdBYB/GD3Y
         1rJwoJQnwlaYt/kPdplnfwbbLWSjnxkz6P/kNcGSpDjWFM6r8ODIqipk27ITjnAJ3F1D
         uAnhv0CMcuOE+T/gkSV8ZdCgNelDVuXgDyT2+/oTe0Tb2D02LQsCyHAicNNatm0rl9Ny
         dT9gUrPuznR+uMv1/OSsw8gfxQd3qf409PB1XFeJZV4S5mPOdxMzz2nt106JVB5gD0j7
         +RLA==
X-Gm-Message-State: AO0yUKW+DpTJ9sy+FB99KHxLocjE6DS1k8T2bS2sld0EoOGNBmCjLN+m
        wOY7YdmIECXXjclhjamKHeZ4aA==
X-Google-Smtp-Source: AK7set9+a35SyzaMThPps2maGPeQlYFoOjNpp1u5BGY+WfsSwIKGlEUp5XIadUP2Yt0ULp3kTp73Pg==
X-Received: by 2002:a05:651c:12c2:b0:295:8bea:99a2 with SMTP id 2-20020a05651c12c200b002958bea99a2mr2996064lje.1.1677086582964;
        Wed, 22 Feb 2023 09:23:02 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r3-20020a2e80c3000000b0029358afcc9esm805233ljg.34.2023.02.22.09.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:23:02 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v11 10/10] crypto: qce: core: Add a QCE IP family compatible 'qcom,qce'
Date:   Wed, 22 Feb 2023 19:22:40 +0200
Message-Id: <20230222172240.3235972-11-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
References: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The added 'qcom,qce' compatible value will serve as a sole QCE IP family
compatible, since a particular QCE IP version is discoverablem thus, if
it'd be needed to differentiate various IP versions, it can be obtained
in runtime.

Two IP version based compatibles are left untouched to preserve backward
DTB ABI compatibility.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 drivers/crypto/qce/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 5bb2128c95ca..fce49c0dee3e 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -293,6 +293,7 @@ static int qce_crypto_remove(struct platform_device *pdev)
 static const struct of_device_id qce_crypto_of_match[] = {
 	{ .compatible = "qcom,crypto-v5.1", },
 	{ .compatible = "qcom,crypto-v5.4", },
+	{ .compatible = "qcom,qce", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
-- 
2.33.0

