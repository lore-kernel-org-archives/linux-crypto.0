Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FBAC77B62
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Mar 2023 13:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjC0Nr7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbjC0Nrv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Mar 2023 09:47:51 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C50944B0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 06:47:49 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b20so36553725edd.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 06:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679924867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvQae14K8HmSyxC8LyADsvwI9KRuBTXgHDMXuVFN2bU=;
        b=MzulBE5SiYfdTZ61fqF+IaniovqFBPJ6tTUnxMHuwD6NuRjsUzQpZeEaajViKmA8TW
         r27LxrU8JrYiJfsTyoeygzacaqQVJiNMTJj6sTyDhGMD47LHjJdfCuVIQ7+bU/QbE8/q
         eoO0ulY+p3rFfNxiAzGL93DNnYmO89DxADfQfgle4BcEDbo5Q77pFOXn6zf52eC0AB0O
         +2cHcT5oJak5BezmV8rfc7t+79Ez2+mCIQKe9aTHBz1VVdQqRJ3MUJ4GzpnT8k1nHyEQ
         KPDQ+oaJhFM38RWliPWdxLd85948T/ZyGLtS/97PVrYprMDQ/vyokqZ0pd1tJTOyMEFW
         AHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679924867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AvQae14K8HmSyxC8LyADsvwI9KRuBTXgHDMXuVFN2bU=;
        b=niFlXXFZ/HtNmr2PEBl9Vk3VhwdHpAiVuw3x/pob10TqxNhd7Q5eleeZtWEH8qy4pQ
         lS9PuyDQZhd9+UCF7lYjH6pL0evHRfr4lkgx7KbVg5BKEtluRtAl/Y50+/pU6hpVg2Dg
         /3HamH1eCgJPeDo/6mmxv8WxRwXEXtiaosP5kKE4h2bKCr/yia+1WIN8jvi8vB1ojkDR
         08pBCkhxVm9I01ZXOECYLZi+cjBXFQHTUZploeG0xDsdERs56MdQl3M86twjLJMT3rnw
         RasLeHoYqQHjFNzwlC/FgOVWZ7gebY2xB/Bt29QjAX4lmdK0jLjk5oLR9jCrjkd56Sdi
         fO+w==
X-Gm-Message-State: AAQBX9dJushtLkNytu1+fdBq/qgDKSkaQbLhjOfGLkaIdCuyKp6jdXkz
        fu9AOnT+d1Tr+zHRWh4YlRnXnA==
X-Google-Smtp-Source: AKy350byAi10P6eCjlQna6nzLLxxVjsMRG0OdF1RQUXVJ0fvxylOQt4cceUc+Zrt+tn5U03ea21wfw==
X-Received: by 2002:a17:906:448e:b0:933:3cd8:a16f with SMTP id y14-20020a170906448e00b009333cd8a16fmr13846020ejo.75.1679924867744;
        Mon, 27 Mar 2023 06:47:47 -0700 (PDT)
Received: from localhost.localdomain ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id n7-20020a509347000000b005023ddb37eesm2394303eda.8.2023.03.27.06.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:47:47 -0700 (PDT)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v4 2/7] dt-bindings: mmc: sdhci-msm: Add ICE phandle
Date:   Mon, 27 Mar 2023 16:47:29 +0300
Message-Id: <20230327134734.3256974-3-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327134734.3256974-1-abel.vesa@linaro.org>
References: <20230327134734.3256974-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Starting with SM8550, the ICE will have its own devicetree node
so add the qcom,ice property to reference it.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---

The v3 (RFC) is here:
https://lore.kernel.org/all/20230313115202.3960700-3-abel.vesa@linaro.org/

Changes since v3:
 * dropped the "and drop core clock" part from subject line

Changes since v2:
 * dropped all changes except the qcom,ice property

 Documentation/devicetree/bindings/mmc/sdhci-msm.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
index 64df6919abaf..0ad14d5b722e 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
@@ -120,6 +120,10 @@ properties:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: platform specific settings for DLL_CONFIG reg.
 
+  qcom,ice:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the Inline Crypto Engine node
+
   iommus:
     minItems: 1
     maxItems: 8
-- 
2.34.1

