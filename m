Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB2F1F582E
	for <linux-crypto@vger.kernel.org>; Sun, 13 Jul 2025 08:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752394039; cv=none; b=AcXAX4F3l45/EPGqs3cAMwwSRSXcGUe7FZAouBowQeatONnen2i5Lo+/+LkxSDr3vJz1hvDSgjB4CGwSEqrna1wzoMHPpQiwOL3ov3wzToDd7Z1IEtSUn1s0ibnuP2Z/q2KTDAlazJBcp9v8pjPHJmavhT3ximM2ZmD9khVKT68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752394039; c=relaxed/simple;
	bh=ZPOAK3xFvDZxKtMubUGBzI+X0LzZj/ehseUCLqV9308=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z7SER5AVGI8OepfGkODOPUxceBBsIp98xNjYA0B7RJr+4lgqwdqxLCsAG0iyddD9nlIQLFWz0mTP1065qaahHaQhz6IoykEoE9Dg0v0XpykGvmSw6QsK8LED6Mc1096yG/vQpvrUkrO17t+NHNk0GiSuDbGZzUUeR0+coyv8plg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=TG7RkjQO; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="TG7RkjQO"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so2930193f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jul 2025 01:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1752394035; x=1752998835; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJyl6Itr2J8CcBOnf8YZMhnDEgMz2YqGF17cfLG0u0w=;
        b=TG7RkjQOt1q81yyyKBTbe1QUYdoIKhdpCxzaOTjGMogHOwNKL6Egi3VqxzvthquTke
         TeaOLBI24wSWILWT7/7wJkFK0oilg/7rZY+pPtU6m+EcgQqQuFsC5+Q6Z4P0Tyn3Lt3Y
         967nN9RiFvhWO7cPiojPW60sDOF5D9SiuJ4cv/AByYCqxnC0Yvd8RVirluvsG1R9YeUS
         2bmhun+vzkTjSE2xvcQnaUuIOrqEh+ub4UVi+CfZms6IGl209PTWVITiezNPFNkTlci2
         6bXqW+7tlU+Xu5+p+TENSe+syb3cczNXZZHgm7PZa6DRQLax9ODPMF8yXRi0mwtSaqFi
         NZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752394035; x=1752998835;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJyl6Itr2J8CcBOnf8YZMhnDEgMz2YqGF17cfLG0u0w=;
        b=fx44lPDvsf58TeY6NSPOROW8qfgygoEm1RCNDwlP1GnGFtWrUptQ91XmJZ5LcWdC3v
         WVPzC+42exyXFT98E2ebkDCxDsbF7M9RdCsp6SMC6jpJbc6Wx9VLPZTzndHkWZ1Au5Zf
         9+8RbNBKlnKckLzx/0W9I8skaqUJ8aEneCLc071A0nXjqN96dzeC7AJO++MkTfUI2HFn
         HL5dH10Djv1A4aK2VqVr37M1x3LBRefnBRGiZOh7kdeH3V0Si48ZeERiCWONqb1GTx88
         D1jd3zIRQrpH2TnJwJehxJJ571qMQWTMAYCnig6fmWuUiDFYpuBsaStGwsEa9h17Ggc3
         2Big==
X-Forwarded-Encrypted: i=1; AJvYcCV5e8/H5Ue3Xg5aecPBPE0H5LZkP/IBzC3cSzU94opBFA0FeQ/9gMZsJGy7Vu8b6gaXpi3AzGOY1AxMyEA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx57SvxyZ2o1WksItqkCsFFoLhOVbSH++3n9qlstjQTinO8U2Pk
	K5/Vsi8o1JZ3xB9Z5H5VsPIg139eAjKLZk4DMwD4pJRKmE/durOKbyAuJuuEFyBPXAQ=
X-Gm-Gg: ASbGncunSjbmZRMTgQH8q3kDaP7ZeBN+w+Hclt+600WunE8ZmHg4WAs/0x2ou8Tpq0+
	/c7ILAfjtaG6RT/TmwPUSKfgDI0KJAN+N2Qb+gogZBxNT7d8SyqIu+6h6OlYSHd3Hn7b3q07vW7
	UmhfSy6sN+G9SxBohnIdKxhMKalgy7iYoCrGKRyeSlL+NrRriKSBm55d2BV2aN58Spfek0wBY1M
	E9VsFIT97VH226gCgNW7HEE8zMpp6/Q0zLnIcaJ49cgFHCn74k9crdj/1mF+YxXrIYn1+vX7kQ8
	gaLtS1eOZGHGT+PgNIPJ89JT23tnHB9aSB8cMALRSwzI2MmcIUPZMbrDH1O5glVXV6dOjcK9iDi
	vWEaW7oEQ8+dqEUR7dutQf+IlO740cPndeCdj
X-Google-Smtp-Source: AGHT+IFDkaJX0TEdwthvnMnibkv7x2m1KVCrimnEeDmcfRvTFWioaF6EXSVrFnCJ2KS+deMt9VV08Q==
X-Received: by 2002:adf:ae4a:0:b0:3a4:f787:9b58 with SMTP id ffacd0b85a97d-3b5f18abc86mr5290060f8f.58.1752394035324;
        Sun, 13 Jul 2025 01:07:15 -0700 (PDT)
Received: from [192.168.224.50] ([213.208.155.167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8dc22a8sm9386608f8f.34.2025.07.13.01.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jul 2025 01:07:14 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Sun, 13 Jul 2025 10:05:30 +0200
Subject: [PATCH v2 08/15] dt-bindings: thermal: qcom-tsens: document the
 Milos Temperature Sensor
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250713-sm7635-fp6-initial-v2-8-e8f9a789505b@fairphone.com>
References: <20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com>
In-Reply-To: <20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 Joerg Roedel <joro@8bytes.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Das Srinagesh <quic_gurus@quicinc.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Jassi Brar <jassisinghbrar@gmail.com>, 
 Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
 linux-mmc@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1752393945; l=844;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=ZPOAK3xFvDZxKtMubUGBzI+X0LzZj/ehseUCLqV9308=;
 b=g6khw9Eoj3k7qdE6HzUK3LwUa3ARHqiUtNifgmAtPNMijChPBfhsPG+M6zDWw7Jp/LdMvpqx0
 G/ABS6yAzifCr1yjRWLDxYJ5Q3VDCx3clJN4ZacevbE60KKq1Tn9u0D
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Temperature Sensor (TSENS) on the Milos SoC.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index 0e653bbe9884953b58c4d8569b8d096db47fd54f..94311ebd7652d42eb6f3ae0dba792872c90b623f 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -49,6 +49,7 @@ properties:
       - description: v2 of TSENS
         items:
           - enum:
+              - qcom,milos-tsens
               - qcom,msm8953-tsens
               - qcom,msm8996-tsens
               - qcom,msm8998-tsens

-- 
2.50.1

