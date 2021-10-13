Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C672C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D46160ED4
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhJMLCF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhJMLBf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 07:01:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A295EC0613A8
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:13 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so3486128pjq.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QbohWyUs/XEVgJ1sMzx5GgNA+CoHQz7FKaMhz+WvP7Q=;
        b=aWBDPo+XkPYlTM+uRegDzpoN/h679h+9ZFX3Yb9ikiuC3BwoIicwyXzxblfl25u0t3
         i5hZ37SfyfUxoCbkac0k50s5cSs+jzDSeCG1Bwom8E1qXnf7oRa/WW4UXuQJKHy9zOy5
         5vZ+mQlfFWydlI+nust7zAkVmD06HPzMi3IKNbqqaqjqwpRkSX6hnIuyx93XDMABUq9t
         NLcA5PhZSyybf5HxtP0nkCgOemXMKS/zVuXkIJWwjtgsj/EGXw/qfjU6ztOIFUxMU3WM
         q4DQ5WcKsw8MsEXV8uFB8pkhHcMU2nMiMrv8xOxmku5gk0KIWuF73+3c4DueG3kbPVnE
         G9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QbohWyUs/XEVgJ1sMzx5GgNA+CoHQz7FKaMhz+WvP7Q=;
        b=VBR4Eceww5yghaoMbYW7wGoRgqcuVoX4OtBHFSxY3MiMZXuc4S3/FOulfWMQn+zy3T
         UrKORmOK7fbIXmIYe8Fy5fVmD+4fAvOTk6vp9G2roPgW14zWDOBih4DQwikDCkVXA8MJ
         lRjGdtLrFYH3zYSf/BVh72CTHYuk1GnT6vehPNXhdjrvuwDMCXHsC5LGIU4AGi4fLLFy
         zOQyCiJfdWKPpCujqv763VxtEja6lEtLg31IHM1Md2ly4GRM16WZ1pfG21S/HbNF8CAi
         Na1WwzwzG8R/mlDHEt8Rn28HssCGRspgnVtkXtpR69hh+njlNMlgf2fp8OqXvwBupxWI
         pQ8Q==
X-Gm-Message-State: AOAM531sltMSzvrnW+DraeGXtERlaZcmAjXybPn0KimFb5CacNXxAiG7
        xwNnfTIvFxBurv56/X08cVBVng==
X-Google-Smtp-Source: ABdhPJwywYk4PJNAhFCjlu9JSdHG6UaMaytxyWqC5ooJQNf7ZtdtOTA3vvINGm9UW5P007G9L1NphA==
X-Received: by 2002:a17:902:6947:b0:13e:8e8d:cc34 with SMTP id k7-20020a170902694700b0013e8e8dcc34mr35131854plt.88.1634122633168;
        Wed, 13 Oct 2021 03:57:13 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:57:12 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v4 17/20] crypto: qce: Print a failure msg in case probe() fails
Date:   Wed, 13 Oct 2021 16:25:38 +0530
Message-Id: <20211013105541.68045-18-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Print a failure message (dev_err) in case the qcom qce crypto
driver probe() fails.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/crypto/qce/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 576c416461f9..cb8c77709e1e 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -281,6 +281,8 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	icc_set_bw(qce->mem_path, 0, 0);
 err_mem_path_put:
 	icc_put(qce->mem_path);
+
+	dev_err(dev, "%s failed : %d\n", __func__, ret);
 	return ret;
 }
 
-- 
2.31.1

