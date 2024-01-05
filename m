Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051F52E85C
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jan 2024 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="U0SY9mNR"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a27cd5850d6so186400766b.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jan 2024 08:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1704471348; x=1705076148; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2EkrLPpfX68IA8d/5CPpZuMAmVCLu73Yzxl8t1E6w2M=;
        b=U0SY9mNRzOHLg2oAJuki4XzHlnHxFPPVkogg4Bsg9gAjcixsZ7XWE9nydc3ZOuiHsT
         Wl9VlAwNnK/OWl7qMZjd+yvuhS2ocl+0uMDZNcEUzlpXGhJqIXLqeyKlO2HHJFxH3Jvz
         77AacKA9ADY95/ZLd/pWxo6ykcbUfYNIcs4aoRfNLXlQ6RLfYH0K6QSMP7GHRGac2F3R
         zfL5LlJoZvzwwzSTDfsW9ZH5UPidQ1miL0/CKzbsLHItD4HBf6+ztuMFZBGpd2HaNXbG
         ZFGykocPpCUUM4yo+esWqko0/GuA+BGj3SJpgSEbFWRtAXryW6aVv2bC3g/bQRDhfCcp
         rnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704471348; x=1705076148;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2EkrLPpfX68IA8d/5CPpZuMAmVCLu73Yzxl8t1E6w2M=;
        b=P+Jyu+pZSVHgZ9ZrmoQF6IDTvf3fJgv4ey4zK0uFVOyClxFf2FXqShz8VwQPEpSuKY
         fEbWg4Fq2NJy2JO+HQdDDmQisA5MUg3v1U0IN57aN8jFQlkFoPv7oiv+kqz443QDv8s5
         IJKrXYaJkw4CeWMFqyLSiqZ7axLM0ypJf6/MS1+tviXq+0ZoKCQ76sjh6Om92qsfHNNB
         6KMuLKc8Sct57ZB7GshJZxuRBUQvmC+xXHt5mrsyTjD+MqKuxOveKWVKzfxpbUxrPC2i
         2WYFb5D2mWY9mgThZA8DoDnC7QywppvKS72x8ZXRnkq08hYXXtfEnXXAxUebVJ1ysbhD
         6l1w==
X-Gm-Message-State: AOJu0YxPOmq2m3hHqb1wlW/q30/ElcMPihAygENYrO392SBU6PSR66fD
	ih0DFyfC63CS02asMJvosD8uwrcba0cGnw==
X-Google-Smtp-Source: AGHT+IF0F4kBNIMfJY2WeUh31uZD8/I9CGX4aE/9HYT9YMdxaniTBXNbap7APj6H4vgi4j2E/4Gi1w==
X-Received: by 2002:a17:906:261a:b0:a26:d20e:35a7 with SMTP id h26-20020a170906261a00b00a26d20e35a7mr1259647ejc.127.1704471348452;
        Fri, 05 Jan 2024 08:15:48 -0800 (PST)
Received: from otso.luca.vpn.lucaweiss.eu (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id ft33-20020a170907802100b00a26a5632d8fsm1031726ejc.13.2024.01.05.08.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 08:15:47 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Fri, 05 Jan 2024 17:15:44 +0100
Subject: [PATCH 2/2] arm64: dts: qcom: sm6350: Add Crypto Engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240105-sm6350-qce-v1-2-416e5c7319ac@fairphone.com>
References: <20240105-sm6350-qce-v1-0-416e5c7319ac@fairphone.com>
In-Reply-To: <20240105-sm6350-qce-v1-0-416e5c7319ac@fairphone.com>
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.4

Add crypto engine (CE) and CE BAM related nodes and definitions for this
SoC.

For reference:

  [    2.297419] qcrypto 1dfa000.crypto: Crypto device found, version 5.5.1

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 8fd6f4d03490..516aadbb16bb 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1212,6 +1212,37 @@ ufs_mem_phy_lanes: phy@1d87400 {
 			};
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			num-channels = <16>;
+			qcom,num-ees = <4>;
+			iommus = <&apps_smmu 0x432 0x0000>,
+				 <&apps_smmu 0x438 0x0001>,
+				 <&apps_smmu 0x43f 0x0000>,
+				 <&apps_smmu 0x426 0x0011>,
+				 <&apps_smmu 0x436 0x0011>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm6350-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x432 0x0000>,
+				 <&apps_smmu 0x438 0x0001>,
+				 <&apps_smmu 0x43f 0x0000>,
+				 <&apps_smmu 0x426 0x0011>,
+				 <&apps_smmu 0x436 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 QCOM_ICC_TAG_ALWAYS
+					 &clk_virt SLAVE_EBI_CH0 QCOM_ICC_TAG_ALWAYS>;
+			interconnect-names = "memory";
+		};
+
 		ipa: ipa@1e40000 {
 			compatible = "qcom,sm6350-ipa";
 

-- 
2.43.0

