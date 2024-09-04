Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B954A15
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 03:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419498; cv=none; b=efT1O4huA4uadHyoBF2qOlqCqzXXJZkC431rIHPG3dWEN3UcVhZ21SioFenX0BZGQoh/ltgpJTsRF9UXhFrISnen8jrfyxJXSw25yIDBySb/oz0wsfYs+8Xq7pVCNV9TObOY3xLb6lmWQt324XV9wCdOHC8Jv/3YOvMMHTSXvRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419498; c=relaxed/simple;
	bh=Iy7fs4AKi9vdrKgov0uKW5D6+7bjnay/XynmoeG69AQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p6U85VYNAdS4xPljXeQuODwDNto8RRLc7kyl47Po75EV5+KbWFIUestmaHeJ8JquA1PAaBj5RHFm1nLEXF5kjsC/skJSKywvdKZB+TmkLBJn/s566g9+M+wo5RUv/WCZwTGR6lKQjU39b66FjM4ambtMH5M0YD603lUZ0vccr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Q6X+PAKt; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Q6X+PAKt"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7163489149eso4077413a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 20:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725419496; x=1726024296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idTKf0dKr/zih0L7EmYisP0d4BWNBFEgjMRLEK9ntkQ=;
        b=Q6X+PAKtncMM1j/uLrGM08vtpa/KSQnNAADxMUy/Ecj+RtdIAtmKAyj+uZzDVciHNn
         tDlYy13H1jofLiQ4Pw0kJ5nNbPKaZTn6OTEYNLLomzUhVWXZsT65HL0fZoFfJqYOXD2X
         JHfrrF7T/jrQDv27l7M5dqQRcLyrmmTpa9ff0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725419496; x=1726024296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idTKf0dKr/zih0L7EmYisP0d4BWNBFEgjMRLEK9ntkQ=;
        b=i1lEV08Z3X10RiunraopJ+TkWIEpVMXGf6fHP2Hdp4WABz5MtijE4xwFBF9os8Yv7o
         UXBJMEPX9UJkS83QxBMXAWMPb5OINlzcqTtRh1NLeHbuVKVW1L/aLik1mw6tmDVe9ggX
         bFWAqrhbsiL8NafMNqlY6RiM/MD9gFpRYGB62xuUK2PoO3F6oaYHInPs/SvR4+ixoWlA
         YXp0MEKa/GCNPBImJBCAfzsMYSkzOYxuhxLWS9yMHPfI+OfoKtbdtu6nGHNdPz/oOFj7
         rTlS6uynQzgSRLPd8k6gMJTM5YLl/HTs9lHuuEFXfEWmoMr6+wfU7ktGfw54uzEtmHV0
         17NA==
X-Forwarded-Encrypted: i=1; AJvYcCW5H/MLa4lZpeE6L6FBVWaa2E9cgkgPMAJyaoH0a1gcP/sy9iGtvlJP0Yymc2FGWQkIKlk9srgQoRl7Ur4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlo0Rsd9T+2K2NQphoLs2CeyIW9SvwJnDfxPsxjstnxYCmpb0n
	DYca4BTjEYBB/yEM6gzb/qHPLsX4+ex7hWYMJzf0erJUT01CVeGh3y/LQS+DZxc=
X-Google-Smtp-Source: AGHT+IHT1Q4wyFc7QTO3Qam6ThH0AZWezC9SyyArVGC2A6XfgCeIgvmWakRixQTjzgV8v4AVsBhTxg==
X-Received: by 2002:a05:6a20:9e4a:b0:1c4:bde5:174b with SMTP id adf61e73a8af0-1cecdfe0a6fmr17640663637.41.1725419496226;
        Tue, 03 Sep 2024 20:11:36 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7177853340bsm590999b3a.82.2024.09.03.20.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 20:11:35 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	robh@kernel.org,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 2/2] SPAcc DT bindings
Date: Wed,  4 Sep 2024 08:41:22 +0530
Message-Id: <20240904031123.34144-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240904031123.34144-1-pavitrakumarm@vayavyalabs.com>
References: <20240904031123.34144-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 000000000000..4432defbe268
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto Engine
+
+maintainers:
+  - Ruud Derwig <Ruud.Derwig@synopsys.com>
+
+description:
+  DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto Engine is
+  a crypto IP, designed by Synopsis, that can accelerate cryptographic
+  operations.
+
+properties:
+  compatible:
+    const: snps,dwc-spacc
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  mac-mode:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    spacc: spacc@400000000 {
+            compatible = "snps,dwc-spacc";
+            reg = <0x0000000400000000 0x0003FFFF>;
+            interrupts = <0 89 4>;
+     };
-- 
2.25.1

