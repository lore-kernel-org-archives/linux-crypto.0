Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128DA2E2F1B
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 09:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843408; cv=none; b=gIzS7XDPHtQz8JqHTBN5ijRxOJZdV3V/aPnuzJ2sT7D57uHhYOdfUInwcCGK5cMPCey7JddGr8yFunwuGcEVPDUY86DD9DLAv71s7j6wh7omYCCOAoWd767gq13NYagSYM2WC6ehu2AJvtHtwPWaLi4qIQykL8nOUIkmKfJYOWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843408; c=relaxed/simple;
	bh=jj4FXpnaY2L8qRW5W5/06pfPaCeBVQY5CbMDnnBtNOA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fxmQQsj6PRwYKRpPX0S7LoeDT7bL0rrs3rrlFXGnCG8LRRi23G2ZJuWqHTOjL40A0ji6sh1HL8XyG+SpMyUm9VmoVjXxtitdYdbsEphc57Kxa2xueM/2rMAzq3fmOkgVZzxuBinZ6KHRbM2HzrBbeVU5wE7OaX3atxdqmtUarZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=TYWShlci; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="TYWShlci"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so11109055a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 02:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1750843400; x=1751448200; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PueVIxrY0Lhx5OoYalpVzj7TJ+cyHwt+DTi/ni2FBMg=;
        b=TYWShlci2W5Vwl3f0oDuA0g1jKsPVsnAaplQ6wJo0q1upNo7DmpauwIWLYQWJybV1e
         MP3HQsU4RR+e+fV2MeWLKo14TBHoNVcCqw6nypUZJ9Cd4OyvYuRjV6hg046cDcCoOTNJ
         Q/Leh3Sx7qGqljcXbzOmTAWIhkUAe0vkzORj58R3RuK0OoAMVJ+97djUq9NiiVtvnfa7
         3Ecc8Em4E4DW7vERFkRl5Etwnovx12CB9z2pF3Q2JgoVTyuc9U50fcRBiS1rjFHk30F8
         otXqmlPtDZ4HqfC5rupSp75N7Oc9Npz5fAeW16UBNxeWoIMv1lWfnm8j0A9hrWE1QtTw
         zfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750843400; x=1751448200;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PueVIxrY0Lhx5OoYalpVzj7TJ+cyHwt+DTi/ni2FBMg=;
        b=wJZd4frV/ukKa9t30xz3DDo8Ss3K8cqceXgeL7YA27XQq2Z6LzP1fy+nRvjY7iacrt
         ++eacUl5Crvbk4Fbc8VI3lD2FghffcnsOn0zy8jOO0B+eigo2EcCOue23G1NsgsYe+e8
         Z6LdElqcsyMe+k7TcQ8oYaSeWwl1UXHTxXbu/KOqyDEr3xt4WuaT94Stc7BJg0fZokxy
         oaTia0M1JXhTNfGF4xv6tsWXLEDFOnrHl7pf4+bYzONH40zIgLAC/rtJpnC3TRTi6XDL
         z/32hdacdiXfkTraZ2x2l4sP34tYVqnaC7mQTMmL2jFnSOtAopMpk5Kt+Ukfq/FL269f
         g+1w==
X-Forwarded-Encrypted: i=1; AJvYcCXHLdnG40Dwr85eiwq0wxut6Hp6lLaRovFU59nyIzQUY1mU5qcT8GsprpIJaE52bALklft2W5te3xEzMow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVgDMLZK6DR+XLDoHHhuXLbrJbBtg03WhO8+jpAGm9XGhNAFcq
	L2S5sKHon79/qvd94luGHEyUAMVTGSJRISTMnZp8k66Sd/UnvRSaq3V4GtbGDeAPr+s=
X-Gm-Gg: ASbGncvUSz9u2ZgKzp9UkMiddgR/bR+Vgapp8yQHFl106GOCO5KwnmxGtZx5EB0ZEmq
	vRGfuC7MGocgGiIiW/3rYh+HFxgeBHKqU7J97njKHxnQh83jGEUNd3ebaYBdhi0do202XpzxM7Q
	82mtARGQODaPZ4c2sY1c8xMjrZPqojjyc+IMIkm+vZuNookhBKObYb3hZQ5fA25xdpYAvOtDDt5
	1gYS+nrpU3vsHlTIHM1ve3TSx66CCDOwt741uDLXKsoyLB1mF6SOO5w9e1Kl8ld8PXLT4GiIRDF
	bL2EsPJ6WXT7wJrZKU8ynwuh8sJwMvLykg/hrwFGgr+Cq3J6GWp2HTjCjcLprImWaH09mc1re7c
	vepT7xwZRNtNPUXO7WZXJvDV1dJNoPiWC
X-Google-Smtp-Source: AGHT+IFufR/i6s8bQEjNP+fAneYyap2WFk8eT5JzaxB2nRH9U0X06huQYHvxc1UIF4P5JtCVtPmAUw==
X-Received: by 2002:a17:906:6a12:b0:ad8:8529:4f77 with SMTP id a640c23a62f3a-ae0bea790d5mr233626966b.38.1750843400340;
        Wed, 25 Jun 2025 02:23:20 -0700 (PDT)
Received: from otso.local (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0aaa0a854sm270277766b.68.2025.06.25.02.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 02:23:19 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 25 Jun 2025 11:23:06 +0200
Subject: [PATCH 11/14] dt-bindings: soc: qcom: qcom,pmic-glink: document
 SM7635 compatible
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250625-sm7635-fp6-initial-v1-11-d9cd322eac1b@fairphone.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750843387; l=920;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=jj4FXpnaY2L8qRW5W5/06pfPaCeBVQY5CbMDnnBtNOA=;
 b=QKOjYfcAGy5ZXnCmFyoCw5qgS3UKBJcYTNOrXIfiYw6DV7itFoCGZHGaadZiBNtQHiCfzjhFV
 Na8qSuO8OQ1DyaQjIxXMBvzPUgOVhYUCHVfApprHUM0Cz5utU9EaZ19
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the SM7635 compatible used to describe the pmic glink on this
platform.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/soc/qcom/qcom,pmic-glink.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,pmic-glink.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,pmic-glink.yaml
index 4c9e78f29523e3d77aacb4299f64ab96f9b1a831..2b77021b278dd9dca604cf31e39d9eca98f2aa7d 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,pmic-glink.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,pmic-glink.yaml
@@ -37,6 +37,7 @@ properties:
           - const: qcom,pmic-glink
       - items:
           - enum:
+              - qcom,sm7635-pmic-glink
               - qcom,sm8650-pmic-glink
               - qcom,sm8750-pmic-glink
               - qcom,x1e80100-pmic-glink

-- 
2.50.0

