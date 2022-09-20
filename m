Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB4DC54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 11:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiITLmB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 07:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiITLlq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 07:41:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2266EF3E
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso1081846pjq.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=S/VY5MZwOkPVf4gf0OmaE3pHGUVQux0NVg5TTa4NfT8=;
        b=NqTOe3iiUQICAXunR2DJaV/3zsHDSJpEw+TwFpamvurkELyWckCG2t6an2YRvKW5Sl
         ZbICfqeSBGkudUhvJYL9b0BY0f9rtGW7n0MMPfzhNs6iqdeNf7jqmfp+i014B6ZUFzIm
         RyYbE7NkqBfcSUToaKyItyfaoVcB4mpTJramTrh5QecNsmNvdtI77NUUKrhX204KBAa1
         ugeLYqZdu0hEk9/+bEWA1UBK0IFPPj9uiX+rXS6IVXE2xPcS20DG2uNf2zFdtMGsIHwi
         DJsqUlDSoJ8itYLNrYjO8uDq/SmAPIoOXxzXqe9/TT/M1hcX4UOdZSIqyr0S8yPPWNaA
         UDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=S/VY5MZwOkPVf4gf0OmaE3pHGUVQux0NVg5TTa4NfT8=;
        b=l3xPFK33MUmXW1rJ3II1h3NCBBu5nz4vowGDtBSySHTbJ8j5d/fXlQNYRKfNBW8SKz
         N5oOhtdTaAjnNuavRFDjoniJ17mCynYVvbqEkUtMwDMkedCwAEsDqH8v1oiFiomsgm5/
         VDur+Iayv4OzYF6Oi4K+fd6qvawoW92orhe1uVtf6zEckUfgIeQT2g6fXfFbiftB54V4
         zuYbxfdDzxf6BdrIFQpcFJZOPBV5AOPbW1+kjpgRZraqMthmztzEC+4+awj/ctk5aJwa
         fO5a8l5RKnOn+gWmHfuBMnOBvJVEMQMJ2+JvjbRfHH3qJqKxQuQYCBcT2eqvsQJZk4jF
         CvJA==
X-Gm-Message-State: ACrzQf14U+msnyOnT4XoUIZvvgnxmknhqnN9MNNQct0lyYfK6TpBgup9
        NGpwm2mFiqx86FImYPXham9Wp2Z2Y9WDZQ==
X-Google-Smtp-Source: AMsMyM5DsNX3RgjSRPJweeS5J16q4ACPjJjDNmXrM1xncre90UD6HKG2UPAJycXK3zCZiHWC4cM0UA==
X-Received: by 2002:a17:902:eb90:b0:178:25ab:b3ee with SMTP id q16-20020a170902eb9000b0017825abb3eemr4360076plg.23.1663674088867;
        Tue, 20 Sep 2022 04:41:28 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:6535:ca5f:67d1:670d:e188])
        by smtp.gmail.com with ESMTPSA id p30-20020a63741e000000b00434e57bfc6csm1348793pgc.56.2022.09.20.04.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 04:41:28 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        robh@kernel.org, krzysztof.kozlowski@linaro.org,
        andersson@kernel.org, bhupesh.sharma@linaro.org,
        bhupesh.linux@gmail.com, davem@davemloft.net,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v7 5/9] crypto: qce: core: Add support to initialize interconnect path
Date:   Tue, 20 Sep 2022 17:10:47 +0530
Message-Id: <20220920114051.1116441-6-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
References: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
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
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[Bhupesh: Make header file inclusion alphabetical and use devm_of_icc_get()]
---
 drivers/crypto/qce/core.c | 16 +++++++++++++++-
 drivers/crypto/qce/core.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index d3780be44a76..63be06df5519 100644
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
@@ -206,6 +209,10 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
+	qce->mem_path = devm_of_icc_get(qce->dev, "memory");
+	if (IS_ERR(qce->mem_path))
+		return PTR_ERR(qce->mem_path);
+
 	qce->core = devm_clk_get(qce->dev, "core");
 	if (IS_ERR(qce->core))
 		return PTR_ERR(qce->core);
@@ -218,10 +225,14 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-	ret = clk_prepare_enable(qce->core);
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
2.37.1

