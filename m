Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7605222B8CB
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331042; cv=none; b=ne3avRTFnTLLkGUnjvdnYvIxOFa5GSX334cHOF8yNdpCYzgX+3HYz4aWKsaS5H9VdbAtMneYi7K18PBAkoStoi823/BeGu4+gvwTMBLN8wGRyydU6YbU6kis17O0BnuiA3Xh5AwFL+u9oAdT+vrykjj3stkJ1LlDLjAQLZjDoY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331042; c=relaxed/simple;
	bh=Oj83634LuR0Sk6h6LV1CwwmH8/xA1oyqe0fNzBAzWv0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GhtV2vbx9yPdmEbpKW8aR1uMcca9j6oANzwzhcZqy+o5Lln43zzsI4i9K2y7wbntJbTU2xXWF55olFhGHIjc/FQsiuDgJWUy8vs+O/lGcT7PJR2ZACcUDDPnYJE6mVh+njGUiVLzus2oiUQhriY7DRn+oBODI+PvFlaaMi8lF9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=hKS6oCp8; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="hKS6oCp8"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47774d3536dso3717665e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765331038; x=1765935838; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=umLdQ4Z0Oa1qrbBohYzZ1X9EBV4iKWUTwztaRyY6xyM=;
        b=hKS6oCp8m1f9thEctqo4PCFwr4b3BrEWMEXs0p/fhB4bGOQDmlNs9sTlQ1kx5zz9Bn
         VJV/1/UTftbaziYT/CEAJQcAnWPffAHfeFgomvOYOVrmf/G+uAbRmhbJRl6Pg2A4wR1/
         tGltNQtpBosKvd0TaRvGDp8lkrSMSj9W1lk/AprGgG3OL22EAj7SS8OVPPWX1i6AaI2B
         N5yZtKUMq9bcFmP1vJ43yQLAFXnZg6ZeAXc2OSanNQ01Ub2FK5a1yuhBliwPuJ7A7nTQ
         p6LritUo0UCZhkD17DCubEnPST4Em1834/cAKpvQFqYrcptuCPAAph476NjNLN8jR/8t
         ZJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331038; x=1765935838;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=umLdQ4Z0Oa1qrbBohYzZ1X9EBV4iKWUTwztaRyY6xyM=;
        b=fxFzccz56t2j9H4J5MaqvKhDTmOAD+W6DzCcynUhnscOBfcg1zyIVm0Z5Tp888fe+h
         J/FLkh777Wx69hBeQy0EDjhspML/Tiw1/446amwTZ8rHuKSYXBv4uHb2nqJ/vgfd/z8N
         ljojAclFsZDrWbBvOgO0jx4MMRVMnPwJvJmkD5gufv82D3Jr7iboGsyjDdrNKB/HCoYa
         Q18+B3EEsYX+7y4zeR5mcB26atlzzQes3+IYuqszQdTiwqvS5Nwc6mCZxBbR8YbI32Gq
         8/p8WOjJ77b0Y2fJvgP9l+tbsIZSxweVhfvVU5KgIEIh5bYbYREiUIwPfwYRPPlap/ZD
         OIkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUD6b7AqFq04nuDGsqlGGPD74SUg9wcgAg5HMDeLrr7YrZ4N5iGWb4xl5hkzARVAsBPPPelO8WIJMVSWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGAAiwSgG2SQczMqb4zUm05aNmbjphuxYX23hk4wMZTmk1l8ML
	58JZHwZfqRmBb4WQ5tcXkk+z7ASr3Os7OuDkq6lkzCfeJ54ld6YvXRdf6d/Ebi4Mc7iXm4pS/hA
	3Neju13/HXQ==
X-Gm-Gg: ASbGncuQLnncb2P4O9M+aee9KmdCYsoNXpsh4mufDnfi/CjmzumKMpRkb5cb6EPltLa
	mRYpXX3ALA+/Uwlk9w4sLn5RBV1u3jtIpwmhLwvb3qO8Lq6WmpVpUV77MITk2q7FKP2lax9bEYw
	97VMNXpbaLeIGZ1oR/3nYTnQRw3iwSC7LoUD9t052jNb9rpx4V7Mr8LcHeyEKxZJ63LDBWmGrWq
	QydyvvOdDPj8v5xdrKVufa6rgiv9Pkla/ZgRyF0V05A1PqDb7Qcg+xeT29nNompzLcSldEPaqWs
	vh0wJS8q7IjF5lVE0ZqghGkKC/DRIMuqdpNU1babDxxwg8NZZGY1lQ6CUulq4eVURX+aT+L7KDd
	2LGDie7yv5ffpZdAPivNogtAsQ7YyJfiTze4qTwaGDlHPxIME/jxWfwTpFayqCnOZqbQErA8aOo
	ab4LTp7seOX6oqlmtGomSi4ZSmADGoV+OvmKjqX+xQb/3Himfg41WbcyM+qQ4r
X-Google-Smtp-Source: AGHT+IFxIH9jfV/RWAbce1/H/pLcaMN1DtMzvU66F5/t/lzbYkrchMrfDWq7ziyApOqmo0GYQ7+Rqg==
X-Received: by 2002:a7b:c4c1:0:b0:477:9890:4528 with SMTP id 5b1f17b1804b1-47a7f90f296mr22741845e9.2.1765331038494;
        Tue, 09 Dec 2025 17:43:58 -0800 (PST)
Received: from [10.200.8.8] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a7000c984sm705234a91.6.2025.12.09.17.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:43:57 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 10 Dec 2025 10:43:28 +0900
Subject: [PATCH v4 4/9] dt-bindings: arm: qcom: Add Milos and The Fairphone
 (Gen. 6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251210-sm7635-fp6-initial-v4-4-b05fddd8b45c@fairphone.com>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
In-Reply-To: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765331010; l=824;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=Oj83634LuR0Sk6h6LV1CwwmH8/xA1oyqe0fNzBAzWv0=;
 b=EOx8pyQClbvxV0JmxPZtxhQaHpK3rsiOVVqGjOi/NNcSkhi4NB2293BkQWHtDObYSmVC6Frya
 Yl7gJHRuUU6DjCXJCKCgPEBBMffksNyiPLo6G0Z5+OwcMXj2haqKv0Y
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Milos-based The Fairphone (Gen. 6) smartphone.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index d84bd3bca201..43d45fe95ed3 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -61,6 +61,11 @@ properties:
               - qcom,apq8084-sbc
           - const: qcom,apq8084
 
+      - items:
+          - enum:
+              - fairphone,fp6
+          - const: qcom,milos
+
       - items:
           - enum:
               - microsoft,dempsey

-- 
2.52.0

