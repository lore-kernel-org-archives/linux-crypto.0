Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753A5C05052
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Aug 2023 10:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjHNKOl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Aug 2023 06:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbjHNKOW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2023 06:14:22 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB4110CE
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2023 03:14:21 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-99bf8e5ab39so566356166b.2
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2023 03:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1692008060; x=1692612860;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkXTYbxi8WsuAx3brFiN3d9aFfnzOfLnWqXE8pepV8E=;
        b=SW3PgpkMGdRLpwTKiD2cGqxzUT4MRFRGhPbqlmmV1bg9hpAqQ4GiQUFDoj8Ipv2XSA
         U2xu2X4WEY/spbe5GWKQ5tpSOawfizR9yldqvPWA0ZqihXwA6jAP2CF6kukIgDabu6nr
         DJgc6y4Bg05Giv+k3zOOUTbWDQofSs07j181Tykuy8fW/R79mQPdWMoMi9+EjYntMwJz
         /pnRimwEp2P1W4xq3Dp53k/nw9tN24SL2oJ1q/0rZEO/RZWQCW/8KtKsgEzUYiHTTmv7
         T5f8x8+ouQrK1r74zKdFQrVqTWitMrq1tL0x6bzxVtPfDthWyMQMURnmaQqYbQX1szHM
         POqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692008060; x=1692612860;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkXTYbxi8WsuAx3brFiN3d9aFfnzOfLnWqXE8pepV8E=;
        b=j47RoUHs0++cCDd0com7BmeF23+2Scu3haKaQkDKEJ1smu3XoskcNEpZkSTKsEys3H
         W0F/kyXOnbdQaVgJxwSzjqozonS0Ci3SAfe62EHkB5yu2KFBuz1XIONFZZp3V7A6cfeq
         BpNvs4hlAqNcDfb1baxTFyTOf6kQjUEA64VxWxrSnPhKowRGCZYmAdGftRj8m4qB6q42
         5IZIBkEkOd8TepHPfr4Y5G4vszof1hUoIyVGszhssfvLhz8cnL9sM73skBNJAtQES2Go
         2Z1JXRViv6OMsq44kMo38E8oW/EO2fSzKswRHGEkzxN2que5dWRLsIUTWW6Fuxj0AuCJ
         jApw==
X-Gm-Message-State: AOJu0Yw0AzkspccveqqYog8fCNx7J7aSzyOpZg7oYpPFWGy1Mg7hry+M
        qMghWfaenRDLKXoY4bHPe6X/Uw==
X-Google-Smtp-Source: AGHT+IFoHxMBCJ6ihiQY7oKhpRGwHadxLpkZDfkgnb07niT0v85Ddz8JnmeAUkKxzzzYDvSl1egqGA==
X-Received: by 2002:a17:906:30cf:b0:99c:bb4d:f59e with SMTP id b15-20020a17090630cf00b0099cbb4df59emr7476010ejb.63.1692008060084;
        Mon, 14 Aug 2023 03:14:20 -0700 (PDT)
Received: from otso.luca.vpn.lucaweiss.eu (212095005216.public.telering.at. [212.95.5.216])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b00993a37aebc5sm5472870ejb.50.2023.08.14.03.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 03:14:19 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Mon, 14 Aug 2023 12:14:13 +0200
Subject: [PATCH v6 1/4] dt-bindings: ufs: qcom: Add reg-names property for
 ICE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230814-dt-binding-ufs-v6-1-fd94845adeda@fairphone.com>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.12.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add this
in the bindings so the existing dts can validate successfully.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index bdfa86a0cc98..4cc3f8f03b33 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -79,6 +79,11 @@ properties:
     minItems: 1
     maxItems: 2
 
+  reg-names:
+    items:
+      - const: std
+      - const: ice
+
   required-opps:
     maxItems: 1
 
@@ -134,6 +139,8 @@ allOf:
         reg:
           minItems: 1
           maxItems: 1
+        reg-names:
+          maxItems: 1
 
   - if:
       properties:
@@ -162,6 +169,10 @@ allOf:
         reg:
           minItems: 2
           maxItems: 2
+        reg-names:
+          minItems: 2
+      required:
+        - reg-names
 
   - if:
       properties:
@@ -190,6 +201,8 @@ allOf:
         reg:
           minItems: 1
           maxItems: 1
+        reg-names:
+          maxItems: 1
 
     # TODO: define clock bindings for qcom,msm8994-ufshc
 

-- 
2.41.0

