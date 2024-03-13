Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355783E487
	for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2024 12:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710334416; cv=none; b=D9DPsdln/EP6gwa/KDm7FM+moeG89fhXCWsHb0mMiNZBU+3fizzs7TKimp3ZpDYuuQZbWx9uEC0mZJ2qi7Xda12MyM88BszYL3Qh/kw3u+obR+EYOyU+cvk43A5veFort0xvT98fw6Hlfk71cft6HWHZSp1oVUVOaYgNywCX0QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710334416; c=relaxed/simple;
	bh=t9ETQhsMi3JCo6L9lAIlwLKX3YACOoMJvy5t+4f3Db8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bYiLvkZqsFYwnSht6ehGT61yXCQhbsEZGCQ3ZiqGgLToxVFvjDjzHEq28Guiy9a+PCBcW4/8C5+fbe8BITcaQMZnsFa7RYJha5xy++NDPGR5atvNLsH7a0xIRXTGLTDK7HJc4buY6485JHpfKRjTN658BJj/bJ66l5+j2g1B38M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=YoTCUFbT; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="YoTCUFbT"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a3122b70439so844602066b.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2024 05:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1710334413; x=1710939213; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxb/4unMwiiw34slo/Lxt3H8AqpbzUye2nUxDtdgTWI=;
        b=YoTCUFbTX79y4w2cya5MbDUdpBP5YG6Ec9fKbJK24RprL5dC/dG67c9GrNNw0/VhKA
         2Lg4GwvGSFt1ORNwHCGkO6M1Pm/Jc1L0kVUe49xlIazzitv1p+Sm2sJsYC4Rf+nS9Wvi
         MxB7mwGZXsLQPjwH3RJ4+loKY1hlUsXwoskwBhZ6KpGEtPdWb+NMtKBwC61RFZdLOuoD
         uqwn5ffC9C+1nY8Ns06j/vPkLL5d5LNLIzOHV3ksrIRMXTf7EaL3x+xOkHmJTt5LqyRe
         IxwZF6sB3ci+NbCwM9jYYofP46fO/tga0AKcMrvu/fns0cAuKrXPIHYOzex9WX59+8Qt
         i+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710334413; x=1710939213;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxb/4unMwiiw34slo/Lxt3H8AqpbzUye2nUxDtdgTWI=;
        b=d90slVm1heYJ9JdCgUKrUkhdk0lqCtKnWVEacTjABe3esNRZtg1w8d/erMNhpKe9mi
         tKSSTG68UAyp63e91vj6vVQ3cB/CR4LR2QxTx0wBIIEelY3CEH467NCTCH7LeHdP8zAC
         SGyc0a0XdRi7r6+R0CXUOSwXqZroCeR0qmaphh3JojFh6H0YqYao4QUQutHdPHTfn13e
         kA0Q0rSBYdvQLGR5VYU60J4wIRcZe4rpZ5eb1KOMAWozmNGvJFjQYqPkTWFQjy3NRHr0
         XKHkjvE2rqzA5pvdh1inWr0IPAVDFZUy/Y0/LYAbJiehFbL5y/UzIx1u5v1PmcDJqMje
         mTQg==
X-Forwarded-Encrypted: i=1; AJvYcCVnl5s9Jriw95IaubMsnoGc9YtXRvpscoGTrJNRg6WC9o4llxl9Man9U3zkgKfF/W2wDSlOz95vEMoNJaUIJ11N7B91NTprbhYs1Jtr
X-Gm-Message-State: AOJu0YwNT4BSADCTAcsKxc+2cycM9ro/juAnjQwyiqP2FYykmBWMvXlF
	rqTcYgYGHlDdi9ctA80nhkFqJMp0dpTFtnLFpWaXHp+a+7EMpBA4Kk6Cx0Wm2G8=
X-Google-Smtp-Source: AGHT+IGZBy38RA1kd28N7FqIYB5/MHvNN1GPfLWolHWY4kG6L/symPCXVuU4L002dy3ms9tGKZ3beA==
X-Received: by 2002:a17:907:cbc4:b0:a46:4e73:9c67 with SMTP id vk4-20020a170907cbc400b00a464e739c67mr2151230ejc.68.1710334413569;
        Wed, 13 Mar 2024 05:53:33 -0700 (PDT)
Received: from otso.luca.vpn.lucaweiss.eu (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id jw22-20020a170906e95600b00a4623030893sm3249098ejb.126.2024.03.13.05.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 05:53:32 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 13 Mar 2024 13:53:15 +0100
Subject: [PATCH 2/2] arm64: dts: qcom: sc7280: Add inline crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240313-sc7280-ice-v1-2-3fa089fb7a27@fairphone.com>
References: <20240313-sc7280-ice-v1-0-3fa089fb7a27@fairphone.com>
In-Reply-To: <20240313-sc7280-ice-v1-0-3fa089fb7a27@fairphone.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, cros-qcom-dts-watchers@chromium.org
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.13.0

Add the ICE found on sc7280 and link it to the UFS node.

For reference:

  [    0.261424] qcom-ice 1d88000.crypto: Found QC Inline Crypto Engine (ICE) v3.2.0

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 83b5b76ba179..3ea5f9cf040e 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2314,6 +2314,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 				<0 0>,
 				<0 0>,
 				<0 0>;
+			qcom,ice = <&ice>;
+
 			status = "disabled";
 		};
 
@@ -2336,6 +2338,13 @@ ufs_mem_phy: phy@1d87000 {
 			status = "disabled";
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,sc7280-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d88000 0 0x8000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;

-- 
2.44.0

