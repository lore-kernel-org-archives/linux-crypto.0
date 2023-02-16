Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A53FC6FD18
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjBPNPK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjBPNOv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:51 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30835454D
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:45 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id b30so1910121ljf.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676553285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drQma7nNWgYIegGN8xjgb6Jv9bqzaE0wjeikGVtXijQ=;
        b=FDyBsCyO20brAo9mArK9sLpKTcfWTBO6lkQ3Yhr3vKaFRh7X8VpRii5YD/dln9157Z
         oZwUTwCwWZ9SKKDfU2ny6zyEXZSUSyKQZwOJAm9/jheDgWsZvJLBgxNoKVOMZMv1VPus
         F6a1RhDwbG23H7cN6ToOHVb+k/18K3OjlTHDDEvbY3eaDd2U7nZy3jpGav5FHc3fG2WD
         uozmLlxxkCshEfDabs7uth+OvXysjEXFOQC9RZ96fKIwb9bNSwAGrc206vr2ME8ENGIX
         BfjQ3PffZFduWDryHO4nGax/gDezfYGiG50J+jYLda+5pvysXUjZZCh5AfY9+CjrXKYU
         iH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676553285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=drQma7nNWgYIegGN8xjgb6Jv9bqzaE0wjeikGVtXijQ=;
        b=oI4O7IP/s1OV1FyNtv2n2au6s8ceE3fBDz7Jc0LcAaAU2RPnZfBGrAMJeRPjIglT8Y
         K/ubtLXE3XczdkbtMAnotecaWVwg/dnMbf+v5pBHhV4OHVKUDAjjL0h8Qxpd8qnrTwTK
         Zk0Zoet6A4DcK3PI7tBh3n2cuGJ8wJsbjNWxMakO1k2Vs+oUx7bOoKYaBM1/FdK3xhQs
         ki7cUinQIJ8rDjIw+5T3AyRZlDC+UPb0lukc5yGqZ0BCD6jBOvO4zC8V5r6UvAocxjWJ
         2hEYCfgsnSkpCbD/Jd9Zft909eFt+sAxU474w/IJOeImTA3+NQOWmaD9Nw3oFp/vQHKu
         uD4g==
X-Gm-Message-State: AO0yUKVzXlQrikUV6AgJLwC8CN+vG5xrJCQrPhidLtUirVvwAgngbVRY
        98784NLDMt+RmSmqwC8/qe18+Q==
X-Google-Smtp-Source: AK7set/KKe9iXZAkK+yWzAUyqQqZOENyMPekg2hCaKYdm3gVnxuJhHxy5l5i0oL15TDFFzOk8pBsvA==
X-Received: by 2002:a2e:9913:0:b0:293:4eac:734a with SMTP id v19-20020a2e9913000000b002934eac734amr1593442lji.0.1676553285510;
        Thu, 16 Feb 2023 05:14:45 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:44 -0800 (PST)
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
        linux-crypto@vger.kernel.org, Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v10 09/10] crypto: qce: core: Make clocks optional
Date:   Thu, 16 Feb 2023 15:14:29 +0200
Message-Id: <20230216131430.3107308-10-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Thara Gopinath <thara.gopinath@gmail.com>

On certain Snapdragon processors, the crypto engine clocks are enabled by
default by security firmware and the driver should not handle the clocks.
Make acquiring of all the clocks optional in crypto engine driver, so that
the driver initializes properly even if no clocks are specified in the dt.

Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Thara Gopinath <thara.gopinath@gmail.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[Bhupesh: Massage the commit log]
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 drivers/crypto/qce/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 0654b94cfb95..5bb2128c95ca 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -209,15 +209,15 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	qce->core = devm_clk_get(qce->dev, "core");
+	qce->core = devm_clk_get_optional(qce->dev, "core");
 	if (IS_ERR(qce->core))
 		return PTR_ERR(qce->core);
 
-	qce->iface = devm_clk_get(qce->dev, "iface");
+	qce->iface = devm_clk_get_optional(qce->dev, "iface");
 	if (IS_ERR(qce->iface))
 		return PTR_ERR(qce->iface);
 
-	qce->bus = devm_clk_get(qce->dev, "bus");
+	qce->bus = devm_clk_get_optional(qce->dev, "bus");
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-- 
2.33.0

