Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6952E1731
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 09:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843401; cv=none; b=rSJdv4kGOJx4/GNKr+YLcs0y9AHXq2J2bzXA3gZNc2mQK3d/QvM8GjjiET+SneY0yz1y0uDOJAoGW7OzFCupdvQPPRZey5UVYsu3Z2bg3MMBiN3R0r8o9HgnX/K8cAffJe2KmhQRHxGbXCBHeuWndo1ld4JasZEzA8jxFXe1ywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843401; c=relaxed/simple;
	bh=QF6zOzPisaNRx6UkDEnfUjzHboUeRh3pRf3riJuZ07g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OujbAeL5impAdyWX9Ns66qwBh4GB3GbK8pLqDvx9ZhyiwrPzUm1S3FqVKD084MoJvjG4YMP0FhpYycFQAsLekkMOHaYPU0H9jf4G/+fTBpc4cA3nRyb9bwP86ba2E+zCbhp21UJdeHRSZVB2Wmrisl6vHXcF6ZEnQp2HmbyhYCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=QVvl/9li; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="QVvl/9li"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad93ff9f714so249867766b.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 02:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1750843396; x=1751448196; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TKX5DuiO7AzJ1dwZVvAVxWI3Xdt99v9P0wOhJICwjbk=;
        b=QVvl/9libTo5/a2GI0EJQbZpa2KCIvFYnDJqJU6G8gbDGzXg7f4Pdk+YkaMaHcXCAn
         Dj6l/mHZdMaMwic5f+ybWQS2qaOi0xLsKoZunJFNua7C6PREekpvnoFbLy4uoQ1x1yGm
         vbJB0WvFKXecgNYS8IsQCyPuT0CCWS3mkHs967Y30nfdiMFsV+w4gNkDCFSVZ7o9AddO
         mflARtdkg34SE8aNqu//ITfDRKJ7JZWibDXNFyvltw3yDDFDOljWHnauWLlPngd6v8QW
         BHPkErTQBFL4WrwnTjZ9D62AO3DvDR4pblHMwO1qiTzqL20mHx/yPrDKynfYErrzz5f0
         hvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750843396; x=1751448196;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TKX5DuiO7AzJ1dwZVvAVxWI3Xdt99v9P0wOhJICwjbk=;
        b=Daan7kuvtChDvZz9bKKx25lbS1T7tX2mKbsNpImACvmeT+hbrOCUMdQ7HESvNwHCPN
         BiYYtv3X5rs5Xko9vKkjo/XDDpso3/bP+vWKb7cClvbKv2QFxnLDwpWmbsnJyW/AIIQ7
         mlEouNwYxtxviJDTBfGa9r/JtCn+Cmb/5NxD715+PP2iOJK5fxeTWcT/Ms8LJG6rJ5VO
         ieltvqDXo1sz9fVg85kuUsfz8dIueuD7h3+RwbS5RLm451vTo8DkwbbeV1cpvpKmw+mR
         xvRDPVJFn/pA28EHJK8Jy76HvtS400M1gcgTq/JC0DitGyXdp81t7pqJ6fQRiNkFhmyT
         jaXA==
X-Forwarded-Encrypted: i=1; AJvYcCULBIvRW2wOYhrTzb5spwq4w4z3jlFjgh4nNEiaxcQIxg9QPqM8IJtCoqj8gF8lF7Syh7kVJ6J6tj/JOaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGo9EIIjFY+StGEu9uDxGoPf76EgdQH5W2EI776L8DYKolbT+c
	UfMtbrvUZ2rFNjfcTlyXnOwaG3UGN7guXT1u4bL0YqEpcsPigQFYXaOn2dRP0jKoYhI=
X-Gm-Gg: ASbGncsvpvtlkwi9NheZwJPYTId8WT+Rnn42scRsAr9jV1eFOOWdBN0OHVSrYihH0Q3
	EpPCQv7qecaIJNyRySGP6Xt1Ni+uXaqZTo/M+BgQAqjpieZPXC1eBgntiNEtCaMjlKJFRIgseLY
	KWo3oh9qXDJMouPABrIlnUEesTGliq5zcSP4Dj9oqtB6KAz3xQA5Job2tguC1oOk0GdtAdWVkQb
	Osn/au6SSYs1FU5MKOAAfTtEbJ5gaQww6q8bFtE06f4YWrwXW/qtGXV7gZwSD7UgFkFD45xGb5x
	WRqaTsngEMn7kAk7q2LgYMjmHKjDm7yFLaieeyR3yFJfogCDC5pMz7C7eS470ZxH5V5LcJeNS8q
	GPVVOe33ZSfpY314QOhkJcUaOtImtS3D/C+dHZ1PdhB8=
X-Google-Smtp-Source: AGHT+IGiDFBoDucTPjUqqaMImeHSSI/9lZCbdCTgquH7Z0S3KEgQQwP7r3gJyT916kpPzaeBdGItbw==
X-Received: by 2002:a17:907:9808:b0:ae0:bf55:5c48 with SMTP id a640c23a62f3a-ae0bf55634bmr217592466b.7.1750843396185;
        Wed, 25 Jun 2025 02:23:16 -0700 (PDT)
Received: from otso.local (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0aaa0a854sm270277766b.68.2025.06.25.02.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 02:23:15 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 25 Jun 2025 11:23:03 +0200
Subject: [PATCH 08/14] dt-bindings: thermal: qcom-tsens: document the
 SM7635 Temperature Sensor
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250625-sm7635-fp6-initial-v1-8-d9cd322eac1b@fairphone.com>
References: <20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com>
In-Reply-To: <20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750843387; l=884;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=QF6zOzPisaNRx6UkDEnfUjzHboUeRh3pRf3riJuZ07g=;
 b=u4p3k6p/2j42YHb4XwcyOL+Rq/CqQjib4+cSu01z968A3xXWkhEPGtNDUd9b2G12MuzVho+Uv
 4c01+k5CLJPAHJpvg+Bz4qlPQ4Hme44CNKKgFxwQ8y5DARbiLPoZmDF
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Temperature Sensor (TSENS) on the SM7635 Platform.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index 0e653bbe9884953b58c4d8569b8d096db47fd54f..76b3d4ab5a793a9bd675e52a348ca2d62077cf58 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -65,6 +65,7 @@ properties:
               - qcom,sm6115-tsens
               - qcom,sm6350-tsens
               - qcom,sm6375-tsens
+              - qcom,sm7635-tsens
               - qcom,sm8150-tsens
               - qcom,sm8250-tsens
               - qcom,sm8350-tsens

-- 
2.50.0

