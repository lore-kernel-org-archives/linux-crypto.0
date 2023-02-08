Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A6CC6FD18
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjBHSi4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjBHSi1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:27 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD8BD500
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:25 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id fi26so21725733edb.7
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGwN38UyWUPf0Ti04py3ZiYx4eNGqgCxHn2UnAKcmFI=;
        b=caUTdNfnCpo99+HJGaHCW3+wrxfWOBK4hpmxA3rgejdGanpjoN+dRRRHY57YjwaOOl
         Xv3P74fxnxdp7nZhKc6ykQHgre5O39Cjr99Wgu7uUZYP5v7OC40OKejBJc0FozL20HTD
         0ncwa96iejP3tBoxWgJtzVBtgixag2eUKWlw1ltdVzKCxJeZLu5Xuxfq0pVAeTls7B3P
         1PgrN26Tu+izVCz3WZ9r7m0j8Y0glIe1YqErduXNSbivplb69ZojQKx3wLUg+ueuvXJC
         EgCLUhxCDLqozFwWxo5WebtDCe7mXFpHSZ527b9BkUxV1NQStZdU15zwCNhdhQZGUgCz
         biUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGwN38UyWUPf0Ti04py3ZiYx4eNGqgCxHn2UnAKcmFI=;
        b=uofVlJl0SVQYu3DKMXZRkM+sDQ38B/WxBvj5AqEhCKV/ziXC1RzEHWGbDmUUpYfWmA
         ciIVMLYrL7dc9X5rQV0VLDI0oDsVEoyHBkB/7LBkHr2ub4Zl9TUV4KAwIFy8vxYeRA/O
         jYyBiZSfPjJY7w7gQz8AaCH7YZX3LXQdVd+JK1FLv6JlsD9n1/URun5lDDzmEre8dSgT
         p7ANiJjhnquNuGOJn48NeSirStElcstudFvpIac7Y2gpTjt/xNAFAJT7X15L4Ur8+N0O
         G9I/RlpzcNX302FwMdtC/adGzp9kbwMp9AyeCDkDHX3u0ZEdgsxfYJBgLybBCTHIZjSh
         xlIg==
X-Gm-Message-State: AO0yUKXqobGz6tM4i9aIK5TJBPrCeAi4bwiMLEgMq/CIHXCz8JusLLH9
        uxJ4HEQ2nUug7hJr1TSLCJAWcg==
X-Google-Smtp-Source: AK7set/54VH2VwWs1RTVWYKuvMVa9NVklUfTAccygFgbdjhM/Pdb+a0+0VpSWKwP2kwS9d2TLAHvMg==
X-Received: by 2002:a05:6402:1d49:b0:4aa:b0e9:84dd with SMTP id dz9-20020a0564021d4900b004aab0e984ddmr10707578edb.3.1675881504680;
        Wed, 08 Feb 2023 10:38:24 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:24 -0800 (PST)
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
Subject: [PATCH v9 10/14] arm64: dts: qcom: sm8550: add a family compatible for QCE IP
Date:   Wed,  8 Feb 2023 20:37:51 +0200
Message-Id: <20230208183755.2907771-11-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a family compatible for QCE IP on SM8550 SoC, which is equal to
QCE IP found on SM8150 SoC and described in the device tree bindings
documentation.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 1dea055a6815..7da89c478936 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1865,7 +1865,7 @@ cryptobam: dma-controller@1dc4000 {
 		};
 
 		crypto: crypto@1de0000 {
-			compatible = "qcom,sm8550-qce";
+			compatible = "qcom,sm8550-qce", "qcom,sm8150-qce";
 			reg = <0x0 0x01dfa000 0x0 0x6000>;
 			dmas = <&cryptobam 4>, <&cryptobam 5>;
 			dma-names = "rx", "tx";
-- 
2.33.0

