Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1819FC10F19
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Aug 2023 10:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbjHNKOn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Aug 2023 06:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbjHNKO1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2023 06:14:27 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D040A10EA
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2023 03:14:24 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-99c1f6f3884so566589266b.0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2023 03:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1692008063; x=1692612863;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmievXtIctu/+ybkBLI3TuLZaNyu3VYe3/9M8wY7rGY=;
        b=YEXYiLN4MiXDAN+PnkgwHu8fM1V089UultUVA2sft6OfrcEoVvSU6iQOTMMuRdLWWk
         jxhzqsTOqFQ8iJNJjeDQDPBRExjAjh1cXfe/J8vfU0eXXAITmoWd/tugvBsLeKj83h04
         llWWlAkm7rZPZOyuhf/C2EARYxNxLuVIF6d4UZPwXeRfVcT/VuUb0uUkvHHNP6at35BR
         3d/85SsUbBO+gkVzNlpYcWpk99bs9lXe3+TFKeDyd4/esEZGOmfe4pHpqGzquGBscg0q
         h1lRRz8T4j4hDNHcN4yLjgZgrojotQ/Y+nNhNlY8L/+1qyfi16bkuSKdZfkugkeRYLVw
         YpXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692008063; x=1692612863;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmievXtIctu/+ybkBLI3TuLZaNyu3VYe3/9M8wY7rGY=;
        b=eWURwjhmnAjz9IbogSr4WDm+tlHY03sthOpB1hN/5kxtAzaPfwoW+XLrT07VnPnrd6
         wDHNB+NEqKW64KdtALBVbFN/dXON0H6Re3p3bLmcnvq6M5M+88Kr/0gnrCVXCEs27VsS
         5msDqrY1C3w2EvJViJPXlDMYUWqJ1rK9YroWklI/ZJogIEA3rRwLajUYdC10uPcL6XB7
         SgyjQmvjO2Kg4yyfp5tQZiK7E6yHMm+mcsrTvu8sADgdm/6c9JyjN5ES69F7DfoMdn69
         pDvifRzhxxWFzf1XudnYpIMK4+23NigZjSI0QgFBrkXzJYtUm6ZjlAo6YgGYoRL8ppH5
         L//A==
X-Gm-Message-State: AOJu0YzUMrbaw93jWPWOSFjoBjVPwOjxDne4ftWEcj6AJdBg70rrty1B
        /9mHJQ8B6nYYnMrbFkagmPl7Ww==
X-Google-Smtp-Source: AGHT+IEVgwvO/dKriPsv+vdgRRyCY4UXV0TtWrF8Ahp+OdMvoW2pra4Vy6xR+oHZ0p68/sWIkeVa6A==
X-Received: by 2002:a17:906:5a4b:b0:99c:8906:4b25 with SMTP id my11-20020a1709065a4b00b0099c89064b25mr7412624ejc.74.1692008063479;
        Mon, 14 Aug 2023 03:14:23 -0700 (PDT)
Received: from otso.luca.vpn.lucaweiss.eu (212095005216.public.telering.at. [212.95.5.216])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b00993a37aebc5sm5472870ejb.50.2023.08.14.03.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 03:14:23 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Mon, 14 Aug 2023 12:14:15 +0200
Subject: [PATCH v6 3/4] dt-bindings: ufs: qcom: Add ICE to sm8450 example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230814-dt-binding-ufs-v6-3-fd94845adeda@fairphone.com>
References: <20230814-dt-binding-ufs-v6-0-fd94845adeda@fairphone.com>
In-Reply-To: <20230814-dt-binding-ufs-v6-0-fd94845adeda@fairphone.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>,
        Rob Herring <robh@kernel.org>
X-Mailer: b4 0.12.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SM8450 actually supports ICE (Inline Crypto Engine) so adjust the
example to match.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 2b0831622cf0..462ead5a1cec 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -317,5 +317,6 @@ examples:
                             <0 0>,
                             <0 0>,
                             <0 0>;
+            qcom,ice = <&ice>;
         };
     };

-- 
2.41.0

