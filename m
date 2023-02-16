Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA70C6FA9D
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjBPNPL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjBPNO4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:56 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C01D53554
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:48 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u27so1863166ljo.12
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676553287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Yd9lAcpRbHxF9RdOizjwYgJ/PMIKmYOw1xnRDHR/30=;
        b=l8znhmby9Ou/ayAkmoZRFWINUtrj5JOzTE+qO0v5ncxadXQX+sRPJZrSwlx3b9U5LQ
         JGD2YxEHCWY+a0/6/phBWXfrkWKf0XbXbw4h29RYUa4t4IdwHYfGLpyeTJA7CR47BslD
         cxLmBpcfUz9asR25xyvhwK6VnwQBtE0Ok6Yt4LImw2GJ4/SyihNAphmibYOApmhEtRyP
         I2Ch19kzlsNWNOQI3RtkzC5dBxIzV7h8EOAdkYVzdB6uMIFSg+7QGPc1aP2AO2kgHP4C
         wdqkUeuwRINLInCO8XvY3HH9l4NCTnS/Jx+nu0L/xcUgB1OoRod5bB8EyJc4dzQY7wD7
         YK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676553287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Yd9lAcpRbHxF9RdOizjwYgJ/PMIKmYOw1xnRDHR/30=;
        b=yQPvtYzVd5mA7bAYgTJXg8eN0VroG4qSCyL4SNqF5nZvGJyViQJ5UbSyrYh87ta1W7
         TFTV/5mwG8ANoqlpTD8RwoKcwyf8nUTfd7nN8PhJDKM6V6nqNo6bKkEfbHqMNd92WRDS
         63/2bBk16PJeQaynnqqwpT4hfdHo0g/QJ9hXUU8HJNB2uaxhEJs29pfjd6SV7wuQY7J6
         ph36d4TnRMT56WTqQqh3NClGS+9CFVUAQ25Cx+4rJvDKQbi2XX0SM06sfm9C8JSLwB0X
         ARNdKD210/L+Ig1DGVpu8okesYo3eatQWatwHWgYHeuqXR7tTLZTfVBXgvv33c+kgv87
         CJNg==
X-Gm-Message-State: AO0yUKXQvbQ00P5ZPxnglXlJHtQ/12dhEU4Abt+51LFwHtWqk+4XNTEv
        pPVNoOlpon0fxKbCVP+VFY8glQ==
X-Google-Smtp-Source: AK7set8AC3akpCxImrycnKhop5QhurFRa136ZAhMWjejhNcYZ5p0qpTdFdN7gvG0ODXMGfP1qhBIoQ==
X-Received: by 2002:a2e:9913:0:b0:293:4eac:734a with SMTP id v19-20020a2e9913000000b002934eac734amr1593461lji.0.1676553286845;
        Thu, 16 Feb 2023 05:14:46 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:46 -0800 (PST)
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
Subject: [PATCH v10 10/10] crypto: qce: core: Add a QCE IP family compatible 'qcom,qce'
Date:   Thu, 16 Feb 2023 15:14:30 +0200
Message-Id: <20230216131430.3107308-11-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
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

