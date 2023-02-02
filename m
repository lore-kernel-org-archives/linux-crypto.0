Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0666C05027
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjBBNvP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjBBNvG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:51:06 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169688F262
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:50:54 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id eq11so2049106edb.6
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBem2NaL280LHTVogyWEkwH1nm5H/eL2ckWJlZxEMdU=;
        b=waAO7eaGLH9YW7nyuYw9i0PZ4GBokzdDGaHtmj5eS6oVRzJwgJ5oPHMFiFInriZNBR
         Pr8PfSVGjSmtmTtF8jxbAoySOTkhNjTLuiALLFnEn8KqnrQJJPDfHpi2ITLWLEm+yQuW
         mnBYjcewSZN+MdH3ebEdpSwKdOIS9APxmWWntD84YPBuYJajuaem/d4/llMselDS+VoR
         3K+tvuWqqcIJmMTu4I9pbfhc2BVLKsUqvsKjvq/VL3gc1gTso197JtxZAXF9HO/4EZjk
         cBR7EPqBc8RLD+YzuNgWWDhgmwPayvpsrM2dHN1T3EXpyCxN7bHxVFRyKiTy5i9JfO5o
         8qxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBem2NaL280LHTVogyWEkwH1nm5H/eL2ckWJlZxEMdU=;
        b=f/ohpiGKxP+vlkWpkVxOngfo1gBGUtWUhuCP5PmYiGHkJa1dUUg+2w3Y3M8EF6UEJf
         rfUw42QdCUHf0cjOtZb/F84PcvViGxGGULXNR5eR4HpY7yr2q6QsDLWhPFkbXJ17s9Da
         /EyEbd6ochz0xb2dUMRgiuKWr+3o9ug6mkTaxVAnK3TGgWE4Ncoz/bpAZyg/paQXCSvg
         eWez8qHE4L/97gSWctYd1GCjRFcdOIqHNoD4JSGx8msMpACIABYr8pOGsLmGwxM8v+zl
         dGh/tMsZRjcTmaBA+3bSKLzAFbRgmBluXH0UmgKITz8AjQ8nhozQbSVpf9MxZSwAK+dG
         pQ1w==
X-Gm-Message-State: AO0yUKVGvUR3AbQpEfqZsI8DOqkKZZUQec2+TmJzoV5VSDsI6zY3v4L/
        EzsWzLWmUBHDR7M+AkfFEvHOTA==
X-Google-Smtp-Source: AK7set80HZ1RwZVRBTxF1gSeizwJ0UtCiFFwG86Zvs8f04+P40LFmAJW6dymStwZ42bbc9fGCio3mQ==
X-Received: by 2002:a05:6402:34cc:b0:491:6ea2:e88a with SMTP id w12-20020a05640234cc00b004916ea2e88amr7470846edc.2.1675345852595;
        Thu, 02 Feb 2023 05:50:52 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7c157000000b0049e1f167956sm7596332edp.9.2023.02.02.05.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:50:52 -0800 (PST)
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
        linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v8 7/9] crypto: qce: core: Add support to initialize interconnect path
Date:   Thu,  2 Feb 2023 15:50:34 +0200
Message-Id: <20230202135036.2635376-8-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Thara Gopinath <thara.gopinath@gmail.com>

Crypto engine on certain Snapdragon processors like sm8150, sm8250, sm8350
etc. requires interconnect path between the engine and memory to be
explicitly enabled and bandwidth set prior to any operations. Add support
in the qce core to enable the interconnect path appropriately.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: herbert@gondor.apana.org.au
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Thara Gopinath <thara.gopinath@gmail.com>
[Bhupesh: Make header file inclusion alphabetical and use devm_of_icc_get()]
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[vladimir: moved icc bandwidth setup closer to its acquisition]
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 drivers/crypto/qce/core.c | 16 +++++++++++++++-
 drivers/crypto/qce/core.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index d3780be44a76..336edba2513e 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -5,6 +5,7 @@
 
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
+#include <linux/interconnect.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -22,6 +23,8 @@
 #define QCE_MAJOR_VERSION5	0x05
 #define QCE_QUEUE_LENGTH	1
 
+#define QCE_DEFAULT_MEM_BANDWIDTH	393600
+
 static const struct qce_algo_ops *qce_ops[] = {
 #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 	&skcipher_ops,
@@ -218,10 +221,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-	ret = clk_prepare_enable(qce->core);
+	qce->mem_path = devm_of_icc_get(qce->dev, "memory");
+	if (IS_ERR(qce->mem_path))
+		return PTR_ERR(qce->mem_path);
+
+	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH, QCE_DEFAULT_MEM_BANDWIDTH);
 	if (ret)
 		return ret;
 
+	ret = clk_prepare_enable(qce->core);
+	if (ret)
+		goto err_mem_path_disable;
+
 	ret = clk_prepare_enable(qce->iface);
 	if (ret)
 		goto err_clks_core;
@@ -260,6 +271,9 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	clk_disable_unprepare(qce->iface);
 err_clks_core:
 	clk_disable_unprepare(qce->core);
+err_mem_path_disable:
+	icc_set_bw(qce->mem_path, 0, 0);
+
 	return ret;
 }
 
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index 085774cdf641..228fcd69ec51 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -35,6 +35,7 @@ struct qce_device {
 	void __iomem *base;
 	struct device *dev;
 	struct clk *core, *iface, *bus;
+	struct icc_path *mem_path;
 	struct qce_dma_data dma;
 	int burst_size;
 	unsigned int pipe_pair_id;
-- 
2.33.0

