Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC20C6FD20
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjBHSi7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjBHSic (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:32 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAA12725
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id q19so21755359edd.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HoPGz5Pm+LZHpkjttTLTUflLBb3yC+wx886HJm99ZqA=;
        b=AhsSyyTofxroC3bJBIYXUw5pJHJDs4YkyO5xi+nRwRntn9OHsmG9YtNz3MGbLpUV1F
         DfFAuVtLQAa+hPgmwLaw/YscakI8uyVusFIVFjVraGqbHY+Yxj+K4yR1/Ky/pxUydYw7
         vSR+G8W0R9WxXr/ncC3DTrbMdO+rqi/PavVBX0wFNCjP5C1K2MsBLLKiD5xIaZWgtxQ+
         NNv2/fUxAnN+aOWaHz3DFkP/vWMQPhou6K2SfsEvYbIKmWGCIDixV1KccPaHV/iTJnI1
         WOUy2BZbEn0UgQUDEmPS6tvU7CpTIquysw9gWt9XJUjG005Eoly6L79oHwNAZ+fEs1eL
         ve9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HoPGz5Pm+LZHpkjttTLTUflLBb3yC+wx886HJm99ZqA=;
        b=ivh05Hiox4UOHLx1B3rOEJBF5p5QVaDO6m+Y/gWNPI6L88aVgUyTv2dJcfQ2b8Ay4X
         ITRWyDI2vJQuuZlP+kNpsKucH0R2YDrr7agVqJRTRMFJNxAoMsJsIR2CvtPNhMB1ckM9
         eiRfO91bJVcqJpEFr+RiFDJEDHG4TSY44O4OdWI3u5JGVRaXQJPF+zRIJPM7Jcfyxe4Y
         P9UUND1rqkNJ/Douj5ycEUmcrgpXCF+uj9+4rU7BePcVA3OCXwkcke9ECU0n3ShLpkNQ
         F7Z2kklmj/O6NrbDTKyaW0S37XLRQD7SEDP3I/rttkBdEoiw+Dk2GwU24ArWb7B6W7hz
         WgUw==
X-Gm-Message-State: AO0yUKVRY1EXNqzXnHsWLh1IRNHS5k/KN7iWTTn4plNsa4N3XS+0QIGH
        qpbMqYNVYcrh8BWBWtxApDLHTA==
X-Google-Smtp-Source: AK7set/hrIkfSh6wiF0q3Mlf8So3j2+LQ748LajKSEBH/yJrz8Ayf0IO+wdD3H+tyYM81FqgVad3tA==
X-Received: by 2002:a05:6402:278f:b0:4aa:aa5b:fcd0 with SMTP id b15-20020a056402278f00b004aaaa5bfcd0mr10466462ede.1.1675881510813;
        Wed, 08 Feb 2023 10:38:30 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:30 -0800 (PST)
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
Subject: [PATCH v9 14/14] crypto: qce: core: Add a compatible based on a SoC name
Date:   Wed,  8 Feb 2023 20:37:55 +0200
Message-Id: <20230208183755.2907771-15-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The added 'qcom,ipq4019-qce' and 'qcom,sm8150-qce' compatible values will
serve as QCE IP family compatibles, so that the crypto engine on added
platforms can derive from one of these two. Also the compatibles serve as
a fall-back for currently supported QCE IP variants on Qualcomm platforms.

At the moment there is no need to differentiate or add any other SoC
specific compatible values to the list, however it's known in advance
that the two QCE IP families are not fully compatible between each other.

The IP version based compatibles are left untouched to preserve backward
DTB ABI compatibility.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 drivers/crypto/qce/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 8e496fb2d5e2..627354e772e9 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -293,6 +293,8 @@ static int qce_crypto_remove(struct platform_device *pdev)
 static const struct of_device_id qce_crypto_of_match[] = {
 	{ .compatible = "qcom,crypto-v5.1", },
 	{ .compatible = "qcom,crypto-v5.4", },
+	{ .compatible = "qcom,ipq4019-qce", },
+	{ .compatible = "qcom,sm8150-qce", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
-- 
2.33.0

