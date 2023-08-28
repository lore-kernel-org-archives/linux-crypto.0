Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACC6C83F25
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Aug 2023 08:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjH1IF7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Aug 2023 04:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjH1IF1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Aug 2023 04:05:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168011A1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fed963273cso23417435e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693209917; x=1693814717;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUqK3D/qBAScvsv5jxc6WIoboJn9RkK2Rd/aqGsaGBc=;
        b=a0E796ED/JpDfX/oftzY0J0gcqVa9ih6OIeQ8Ajj5zfv3iAiTfbFSQCtq8WXxuKUEY
         0zWZPm76VfvJIyziPoTKfoXzb+Yvc0hmRhiS/Ro5ntydB2QXghR2hJWTP3a1rb++JxZ1
         5SYBW37ngfmznyxfdJ1KGOGVA9/Ed3wO+qwi1mASfhR0nM5G8zJjD36s+zgJDqZEIU5U
         Z29B8CUft1fIeaeJki+36wil3m2agci93XPJATughN/3wfQ5bTk+wlMXgJMQBS9ynwN5
         12+I04cVE6htPTFDT5FiB1Zju6JHfvW1yt0WHTDnqH4mOeR1pU/5p9gIW8jgOpApGv0E
         7YeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693209917; x=1693814717;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUqK3D/qBAScvsv5jxc6WIoboJn9RkK2Rd/aqGsaGBc=;
        b=diaVrgL9YCynOR1H6Ylj1+LqEGgaL8lQhzNkb2TiE1ayBAlH8Zaq8j+cp7WfM8BSRt
         XvYaaE3XRk1CiD4yhZkD9Hhsuf2y6lAsMdVL9RqxykrQ69XIcuKh+Nm7aJigepSrQlss
         ot+k5LFRdQ0Cw6uy4HVtSLLQXf1pK/dIVvVXDj/1DRjxrAddY/ORA3WuB2s4l6Swl14C
         1JO7C+zRrVzNL3BFCnYWgO/v7Jlt6mnVHtcQswWB21SGEWjFV1pzRVem2QQqkrLP4w7x
         VVAuaPPaEyZL7bYKmHXxjD3BBraab5+ZRBNKcBLuNzyPcikkKbwfzv7vADTDHCu7x1On
         eMzg==
X-Gm-Message-State: AOJu0Ywq6U1IqEIcPjDG7c4efEtLNDEZ+DDYHGfxOgGqigMiT2qC919r
        S4GCIlLqgNAVkf5Uce52yMzOjw==
X-Google-Smtp-Source: AGHT+IGc9USV6c1+FYLDF4ACIByFoCpuMg0iJJBzGTUyCCyraVLSXN9QIEBqZtJ4bfnMza+1Db4Itw==
X-Received: by 2002:a05:600c:2491:b0:3fe:da37:d59 with SMTP id 17-20020a05600c249100b003feda370d59mr9859347wms.4.1693209917652;
        Mon, 28 Aug 2023 01:05:17 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id z16-20020a1c4c10000000b003fa96fe2bd9sm13067035wmf.22.2023.08.28.01.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 01:05:17 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 28 Aug 2023 10:04:38 +0200
Subject: [PATCH v3 3/6] crypto: qcom-rng - Add support for trng
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230828-topic-sm8550-rng-v3-3-7a0678ca7988@linaro.org>
References: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
In-Reply-To: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Om Prakash Singh <quic_omprsing@quicinc.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=881;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=4EfZ57+G5h9yWi4TQIKUUrIhvzgsYdg1XurWyJSWa80=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk7FU35qVfbGnf776KF2wzKGgyFO++U7yVJ/CF+7yt
 i+ez1fqJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOxVNwAKCRB33NvayMhJ0eo0EA
 CybMyj1BeXvy+AD+wDJ9e2irxmiIT5ukqD+8cQ/jELy6fDqToFGhBtnu5T3BcPusp5pe2cfF6eR8zW
 ljUXOBiVpzsTwi/uoKU2pIskZMo1akvgUvqt7J5dc4EBUCwXQl+/VQMYMjZOo/mXrFeYi5NAEki5hO
 jAVCyOiYSad4ARuz7Vxs9ZG3VlZxYeUrmQQtTkNjOvs77pvQ/y/l05Ubs4JHe2mOvav01/EJqOMi4m
 loWLbjY52BCzHIj62fzQJF2E72XU20qXxLT8cICEGuWKR1wZTAhsnWDQJfq1jv7/w4XBMXQTwPGImo
 qrIKjjZMwOV35nZvC3xl2oa0v7Zi850aqtTWUPi1pz092LRratRVIxYN0Va7/6PuuDF026Qss8t1hE
 Noyi/IF5lzphQW7G+ulCy2nauo1psfKD8Xj6bOy2VbsdBt3lYIreKGKYz3iwPTneCVqBVkcmJT90St
 cc8KzUeANG2+8006NIg68u6pU7uqcdOiQkGz6PMWS7kWi30ivMkhi3pVi4Q3sKXreLxI0VmUzKUnif
 GRRJB/+HWAxzsXAAr/loiQLBprk2EtA703afNzDC665nJUbTrg7t/WiQypBD1VZsyGnxR1w238CXs+
 Ap96mEXb3hEUaaeTO2SRdosKAwe8cxQJBnY82/miIQL4ATNtXTxDdYOe5O8A==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SM8450 & later SoCs RNG HW is now a True Random Number Generator
and a new compatible has been introduced to handle the difference.

Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/qcom-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 825a729f205e..fb54b8cfc35f 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -207,6 +207,7 @@ MODULE_DEVICE_TABLE(acpi, qcom_rng_acpi_match);
 static const struct of_device_id __maybe_unused qcom_rng_of_match[] = {
 	{ .compatible = "qcom,prng", .data = (void *)0},
 	{ .compatible = "qcom,prng-ee", .data = (void *)1},
+	{ .compatible = "qcom,trng", .data = (void *)1},
 	{}
 };
 MODULE_DEVICE_TABLE(of, qcom_rng_of_match);

-- 
2.34.1

