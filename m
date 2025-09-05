Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7823309DD2
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 10:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757068870; cv=none; b=YBUW6stMmWp8jCt5Fp5zB2pblSI9sZeOGaiLFxyVmSl/8TXrnqUiQI772OlHHiiaZfZ3j2i8apZzOvosFXwlA2n9rHF+lrCaYOH+6Ay+Be8Z4YzqNXg+8zOs/hbWDiEK9Brmf0QDBetcjVbyMVA8NTGyRzB5l4nb3xFBQLHcokw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757068870; c=relaxed/simple;
	bh=xEZQ2DP+0xmVOtTUyk0n7mNgFjGNQdkHGCz5TGjrLY0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=apJNQuedV6l9B72q24buxsmnn8tTgtOnH9q+vmEFQtVT2S/mvavEJuJrLxUjmNVyuYdKmTb/M/+gkBsA42P9HB/y6yEDSmTJewNuI/Wz4HxNKOjVJ5w0XUoPkyXcs0HQQ21SDHvEPkaEn3i4UqlzwaS7C2a+zYRkQJ8zS7fr5Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Q0hhARJK; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Q0hhARJK"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3da4c14a5f9so1948110f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 03:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1757068866; x=1757673666; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I1rvQZQxLwmsRnPml37c1Lfi5R0CJr98kBiMU9gyfu8=;
        b=Q0hhARJKtDduuOM++E9K8JShdedFgklsuGWTdQ8S+72wPzMCiWwXFUFmFY2ioGS5S3
         1ApB3bKmcqftSDgwo264haM1Nh4HLbthC8muLPMPpzrOVwGg79YS3qArGvrZOEp26U2+
         sUiX0BSY7MA7RCsCJcAMp8nymUIZDZzyMo6poflCTQbHZJv0ahLBr4q33j79d1i0UZ3g
         jKpAO+7J+tB7fuh79PMK9hC0jtw+/hvEyoUXlBy4gAKbpEJOeJkIGREwxc1V4CRZ1LwI
         wceV15QnwEQgg4POUN+Wnm8tStou0bL1RjdXLlih+JB10FCQIc70pOuAd7pCRforHZC+
         amBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757068866; x=1757673666;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I1rvQZQxLwmsRnPml37c1Lfi5R0CJr98kBiMU9gyfu8=;
        b=kXp/H3aZZ275E2sWhYwpkj6NMBCyXgz6hy2+IvpBo+XbouiDOWM6+9NcyX6dZP+uiz
         42nQ5kVDWFGZY5mDWKf5g2MFmOdkPzBpMP3iNKHr4HRFrj675f9aEU1cjyPuXgqmaI30
         St/kRoTU3drwKM6YCYyoXrK8/dGq0Fjbms1qI+fgvatAPFH++ZHvgJyWP/UYpGKRqSkN
         MLwl62/id6xqqY0F96cAxoVX5V+yeukB+eY0vdmNEajUwHtVAg3RjVj3VmgQSoS/sC/l
         gg5CS7lEPmr+Pp5EhqwWAm5TTV1sU2G41JjbPtysR8Te7gWC5IHuWw8c6g8NOGALE82+
         BeyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWflohonz52seTxsSFjzsyQ3FHdUVlmBJ0oMXsAJlJRgnYSJo8Zy2H1M11NizyuMCiBaDiMiLImGTQTBpk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyep6qzHFqQaW4Ks9uzsDLb+lmx81meqDIMvrqfTYqW4PiIcNdq
	mQc60HU4AGgcvtz36VFHOlUd3yX+A8aKvqFxkc0Nwhts9A9QF2JZBCamyfz/ohynRTY=
X-Gm-Gg: ASbGnctgIEIB2CT+LC+0Rf3stfga5jWIOc1H+KxEndT3842wrwpBVOgahTfSL/7/kzT
	JBruA1QFazibfvciuM4subUfs1pOGnZkg+IbzGkAwrWJDTsV7uzejAEbx4afG9usUXYkuKjJIb9
	gxKxt/qv4HngdmKFNseYiNGpC+jVDL56PDHKp1EHVls5wDz8L3dz2xPjMlXX2BB6z8sK0J5ZmrT
	aOkJWsqiwOseVnNyKMLftGZ6IXcVcXgQPnmlKOvZGNIDvRiJZoxG7CbTqA9jrmYl+hUblaFdkUv
	+SkBFzL5qdBNkSrShpxciMISZv/EZQb7FQd1d5/+h5F0MZooYcpUb4ckOWqhTa1yxhfAg7S3W6l
	HjvwPVsMFC+8wsm1miE18In2zBJIMUU7obAh56pcWgXPNdlIeZZC6KVPD6gT4V7ASvpw9UMzciz
	a56E+ChhNBYU3mJZB2Xu1815eGBrKQyA==
X-Google-Smtp-Source: AGHT+IFIuk0QBVF+N8cmk094clxzhJ4H7q4AzYcSgacFq2+ob1IqwwEgeaHutExdzNR3cASZWiUeOQ==
X-Received: by 2002:a05:6000:288d:b0:3dc:15d2:ba9d with SMTP id ffacd0b85a97d-3e30463df0cmr2266019f8f.31.1757068866016;
        Fri, 05 Sep 2025 03:41:06 -0700 (PDT)
Received: from [172.18.170.139] (ip-185-104-138-158.ptr.icomera.net. [185.104.138.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d6cf485eb7sm20990738f8f.3.2025.09.05.03.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 03:41:05 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Fri, 05 Sep 2025 12:40:34 +0200
Subject: [PATCH v3 3/7] dt-bindings: qcom,pdc: document the Milos Power
 Domain Controller
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-sm7635-fp6-initial-v3-3-0117c2eff1b7@fairphone.com>
References: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
In-Reply-To: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
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
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1757068857; l=891;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=xEZQ2DP+0xmVOtTUyk0n7mNgFjGNQdkHGCz5TGjrLY0=;
 b=NjgjfvDq5UjS7i8ksrCpgumVPl316Un9DA2C5ULUSAe79FSyGV164Wjf6IlnP0bB3sye3THyL
 vPBrwd2qGQ4DqkyA8E2ISIlwJ///87lFFBwCUWBWF3YyR4N0p5Tq7p4
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Power Domain Controller on the Milos SoC.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index f06b40f88778929579ef9b3b3206f075e140ba96..3f90917a5a4dd9d068ec472565f5009690ea2c5b 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -26,6 +26,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,milos-pdc
           - qcom,qcs615-pdc
           - qcom,qcs8300-pdc
           - qcom,qdu1000-pdc

-- 
2.51.0

