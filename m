Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DC430CD91
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 10:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757068875; cv=none; b=qCo3AEHckp29kp5KQulIfB6yxZLOxmZs5f4sSyphzUP5P1ko/2PPsSlvurlZFTQSdvTskmeaDBnrtSuzKoA/msrnlz7MuDk9qQ2xONja/r6pAKXERkSR+4H0bKzdMG8OpywoZTzLidRDEriC0hSZRK9PT2EBbdFg+jomlyexCGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757068875; c=relaxed/simple;
	bh=Vv9fLYuM7b+kP/yRcfQ9Aaf/yhYxH4QsjzEqIWP0bPo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CDzMHwUX+nWGnhHlxkdVvNtLae0QabPUwVyu7iTyevjzdukgWrJCm4LlKtiYcZXKyrMz4JPgM04BnQgi8cbNTiSOThj116nZ+uSkhla8+hJaevL9rKtbxJDfG9VG6TU/0xVKt+CS9GU++pnRS+P+69gr5qdwioH9JpuDVj6MASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=LA7iSbfz; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="LA7iSbfz"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b84367affso17619495e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 03:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1757068872; x=1757673672; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iUxSJ8NS/EKCWIWVdT7Xows3IlnWCRwYYijslmaC7tg=;
        b=LA7iSbfzvcyDSnKZ9m6v5oqFRyHpQTZ6jrqp0o2ppd6/WKeqF1tPDst7m3CLSJmsMy
         2sgzIKq83JngnZk9HAEs147LUgrztWn3Kwajxnu/IfbXhdffrZXjQH1KylQoopN9KW5x
         XrHD5jgzMglmqH0QPjPdiEFiQf1VdTB3HUEGg+Vh9o/PR9rf49Fs8IoUZaJkZBGH3RDm
         CtJ7cPPQf1klPHoIgeLa9yfSw7a9cWGi89pRK0I1S11P77MK5cAiUWVp71wJgumUWh0S
         7LcVFjOlmeEX7/g8HLqpzhfHjHoI6h23/fuR21cpEco4QC+Urb3l9XsxM9qkXss6P+MA
         FJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757068872; x=1757673672;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUxSJ8NS/EKCWIWVdT7Xows3IlnWCRwYYijslmaC7tg=;
        b=SllQG5VbX14OsKVT4cLLEloWddhQvqvPyoJH5SsVKjJMPM6Iq0h/0tC6Tmk/JXcWPP
         zTWAMev3ozlyVia/0m4Chrn3FXtyn/ig1gyMXCgBjL+X66qZQSZ1MDYaLjGJ0aiYiwxa
         RnDtpd66l40earjQdS1++3Ymup0WvBjukOIBfLn+hIev0+d6sxe5Z/vGR4YVu16AjwG3
         +/hS2cYhgsvClks4sUOjqhMHGb6OQv2LVaJsSpM8qVY17UHWyDlZRq1jdx81dZNUJQ/K
         rBJCkTBsN1Ft8Zd5DJsmwqMMniuVYxLltzKiLGefoIYfd1bz2E79x1JH3+q8TsFC/anF
         Y4PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKOsHiUhY1xUDjJpUD6XkFusk24r1ceLngXzPVcjWdx8/K+CUAzR0PaQWR/P7lYMbhb0Mvl8LZjPUkerw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVaFb8J+uxTaKkVS6Zk54a0dX5gxPHT+htpDHXHElfWcEtHy0i
	IG7LDayopmygLczrE6aGijf2b5ViEnQPu6+ECacbe9GZEF5KjV1M2Uxh1R2t9qiFIwY=
X-Gm-Gg: ASbGncsq05r0g/ooe9sp30VnKcuicIoGWP8IanvVPMuhz9QFemim93h8WQ9w4QI8bPH
	NgouXvBCYtnAQGx3tXQlRMIKcTXKot4bKTilqy4cEQceX0aQM9EoWrKrNerJUq+OEELZKH/Tf93
	XTH1mOpHWiPQBRyEX+eliJzvLVJC+JHPn7KVu12tSQaKkHkmG/3aK3bGP3CNpKTI5F1ZJloRFSm
	M4jV5ZB4CTW6E5o/UMixNzFc7sqrHV5HduNcyleRwPwXC62qyXCJ4nujpXkuTGjqg6g/IfgFAPK
	qjcj8iFlUtauCusJAw7IJxgkQbWSaCI8MRbvBXYt41l0dbBZV/8S0C8kskdzgXGBly31UiDz2D8
	mw69hGGB2TjbR+t/RXkZMbUlpWj0BWlEiWonf2yjEK0peALTqwjAv16vgsJfMuemJjFILdrkc7k
	O7XFKLlX9xmOZEvRoh/1E+1D9N51Z/qyEezCJ+F6aQ
X-Google-Smtp-Source: AGHT+IEVXQE/CskVMSpfS1GtOIvpVNOfUMU+P9xIanoXIT05tmzKechNro4i6hwVm9EJLTjofdfxZw==
X-Received: by 2002:a05:600c:4454:b0:459:dfde:3324 with SMTP id 5b1f17b1804b1-45b855b34f8mr174028005e9.29.1757068872257;
        Fri, 05 Sep 2025 03:41:12 -0700 (PDT)
Received: from [172.18.170.139] (ip-185-104-138-158.ptr.icomera.net. [185.104.138.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d6cf485eb7sm20990738f8f.3.2025.09.05.03.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 03:41:12 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Fri, 05 Sep 2025 12:40:35 +0200
Subject: [PATCH v3 4/7] dt-bindings: arm: qcom: Add Milos and The Fairphone
 (Gen. 6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-sm7635-fp6-initial-v3-4-0117c2eff1b7@fairphone.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1757068857; l=880;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=Vv9fLYuM7b+kP/yRcfQ9Aaf/yhYxH4QsjzEqIWP0bPo=;
 b=XzDY84jHgnwOW/UMZlFy7LOSxACVXWrRrAIQsHGoMcTUKa4XPYE4kxJ3MRwgYaFc99JjXPhS5
 IBoEJqN22GXBcGyGqN/515GfauIIGyEksVCUeNPCws6B2PhKU4SaaO2
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Milos-based The Fairphone (Gen. 6) smartphone.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 0110be27c4f6602b25aa4feb742bfe62e4a40d51..b4ea462062bfe1ccfb34d22deb1d2407443430d5 100644
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
2.51.0

