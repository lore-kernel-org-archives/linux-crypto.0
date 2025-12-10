Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE74230D35
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331053; cv=none; b=EizV1J38iXlVBMLar7ZkuFeLChNtaJl2ASXa22HTk9ZQAj2PQ3LQCfIrwLUbCm/VAUPPmpjQ6pPSTiesEVsypT4PNYRnVWpmJrmPC7oGlN8pZqCl4Ji8k5Aa0l4l0rMPcKBbjNPD/2HvSGuf5spPUA//4YS8hEBIXQkjaU094KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331053; c=relaxed/simple;
	bh=LXmL+2Ud8K9B81a/ps47BQzEahaViMs6WOczoItxNxo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X7a1dpH33VQMQHmXT0BkSyOOTdwoPumttf5kSVl3npfeV/oHzBXJZIBB2jHayPCD4G6ScSoV60hD/IXtP3vcl2u1JYHconwIXwTati7myqGU9+CRub2IwUR9pXUWKO8tlPo1MHBb1PLF/rlToz3wvBtSsQHmpXojrAxQxy87MGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=jhwHlcSL; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="jhwHlcSL"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47789cd2083so37732215e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765331049; x=1765935849; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mIRoroTrCwdEAApbWjCwunQZNu3lA9gRM8V7FYg4VSA=;
        b=jhwHlcSLmJUB28Kq5XDs0g+am373zey2gdZ/rwdlhHaIq5k251siOm5nvsBNoOazmx
         Gjg4W16Dk4nYiEjF7dbmqlmwyEQlPrA8FYSVpE3AQ1C5mof9PxOWsSUDFCiwEbKejPn1
         xWhzJRfEj791Ukv36E0YridNUYbV9/sfHai6OQnJtLWvBF5sTPCwup1uHxZHgXos02rg
         MWXwd6wQucHJHLhgqngbXt2HGVY+TBnZMZGie6R3ur5p3zp78l8UOajRWzLk0p2CJxq8
         tT6v1SV2DZSIN5yrdPsUQ2czX56zqGu3y4urYpbjAVEl87wDrYSoubgSgYQs+1KnJ2pV
         0YXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331049; x=1765935849;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mIRoroTrCwdEAApbWjCwunQZNu3lA9gRM8V7FYg4VSA=;
        b=XumEWKiYLAh3T4UOxML4okntEE+dv3f+tPg4y+hazE6GWkM+0ZrBb9fSoq43EQlu4O
         Ti0EnCwt7czQj5L2+2BMtrwoZpg7JnJZafJi2BbeWpFaDNTfiM5jNEdzJWH089Vl+XoX
         sQ6zk1rtJzQOzEj4dmLLPX+BqPaWneVO/7KCMVhZmVRsGPFqRxhByBPErQ+6WFwPvIRE
         zxlx2mVf/gPmmIX6WWMH3Cpru9qFBWYVtMV6hmV+je7ylWABBmMBdZyH1ygRN51c8nG8
         j96/knRpUQBXE41aRu3Z9IGr0rNOFhnQ1OGHei/lWbaHgqEkcAn77GIvpeZgQwk2bFVr
         Mmeg==
X-Forwarded-Encrypted: i=1; AJvYcCXt8iZJUjtRKxFFTA2jy9Ljv1mIArG555N/XQa1WG6mYQUTzujlDj7zG6s/PpM531VHmKdj9DXXChBJefc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDwVqr1nismrM/pywzXa/ibCZAW6WixfDbNmH+YBhBWcFoknwj
	xIoAOUEdg4Cu5mc05I4SYRCLfsWaHpYLux645UVts+fBivKDoMGLBanU7397EX3idIpcfcuyZSs
	CMsR4snkDiQ==
X-Gm-Gg: ASbGncvV2eC6o+rSNsYeyn0CrrmH7oudIMaP1m9YiySAZ/hOnYNGQ/fLT/A7ePKBSWO
	MN20xLvQonhR1JFuybLFBVQGYdVJ4wcVTB60g9Pl6qkLu4Uxcy0oNrJn7Dk21x6oiAfyFrtpMER
	PtyLCh5wyxE0yhfDj+t5i/gyJ2scvZu1JhtmiEhKmKop5mETh1SQvTw+cHRI2t+DwV3GcRuIrQS
	wLHF93NUpBxkZd3TLK/rjdBy3ERJmIkVaQVxGf2+UsEPK2cIzGzWfvVZ4vZKKFB0/uGbK70yaMm
	pOXzhoKyTpxMlcwMdDcbk2afs7W4f0TA9eSMX4wkb9psFOsWRBSWm8PXXuCLyehGCr1q2hm0z/E
	pzmHUoJzCW3PG+TaPAoBC1LoZEYP68wmvVdlRUnwBNYFJzOfcwJTOTVxEBFL9Ahx4o1E+zFsrCe
	n4pxSfz4UM6sFBV9zXDAK7CmxE4Cyy2v5pjRw9JUELEn7nk3U2HEHLQy3em7Zq
X-Google-Smtp-Source: AGHT+IHxrZHyT5JdnhYWsVjRdObYzq/zdfHS0eqhPs7Mg2n/J8NXSme7eVp+eTQMnOeGIvOMANl+tw==
X-Received: by 2002:a05:600c:310d:b0:479:3a88:de5f with SMTP id 5b1f17b1804b1-47a8385903emr4786035e9.36.1765331049453;
        Tue, 09 Dec 2025 17:44:09 -0800 (PST)
Received: from [10.200.8.8] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a7000c984sm705234a91.6.2025.12.09.17.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:44:08 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 10 Dec 2025 10:43:30 +0900
Subject: [PATCH v4 6/9] arm64: dts: qcom: Add PM7550 PMIC
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251210-sm7635-fp6-initial-v4-6-b05fddd8b45c@fairphone.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765331010; l=2033;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=LXmL+2Ud8K9B81a/ps47BQzEahaViMs6WOczoItxNxo=;
 b=nXqbJoE88R92aUN0quHB4SmewPu3iqg7cOV6P8Xk5EWQGIr5x8Sw2iBPFd8xc2GBDAuLQHyht
 cYVM3vbboUuB/aziF7usoPX2qgy83uOrX6m7O/kjcNBx0z+9e4mp0C2
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Add a dts for the PMIC used e.g. with Milos SoC-based devices.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/pm7550.dtsi | 67 ++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/pm7550.dtsi b/arch/arm64/boot/dts/qcom/pm7550.dtsi
new file mode 100644
index 000000000000..b886c2397fe7
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/pm7550.dtsi
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Copyright (c) 2025, Luca Weiss <luca.weiss@fairphone.com>
+ */
+
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/spmi/spmi.h>
+
+/ {
+	thermal-zones {
+		pm7550_thermal: pm7550-thermal {
+			polling-delay-passive = <100>;
+
+			thermal-sensors = <&pm7550_temp_alarm>;
+
+			trips {
+				trip0 {
+					temperature = <95000>;
+					hysteresis = <0>;
+					type = "passive";
+				};
+
+				trip1 {
+					/*
+					 * Current Linux driver currently only supports up to
+					 * 125°C, should be updated to 145°C once available.
+					 */
+					temperature = <125000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+		};
+	};
+};
+
+&spmi_bus {
+	pm7550: pmic@1 {
+		compatible = "qcom,pm7550", "qcom,spmi-pmic";
+		reg = <0x1 SPMI_USID>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pm7550_temp_alarm: temp-alarm@a00 {
+			compatible = "qcom,spmi-temp-alarm";
+			reg = <0xa00>;
+			interrupts = <0x1 0xa 0x0 IRQ_TYPE_EDGE_BOTH>;
+			#thermal-sensor-cells = <0>;
+		};
+
+		pm7550_gpios: gpio@8800 {
+			compatible = "qcom,pm7550-gpio", "qcom,spmi-gpio";
+			reg = <0x8800>;
+			gpio-controller;
+			gpio-ranges = <&pm7550_gpios 0 0 12>;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		pm7550_flash: led-controller@ee00 {
+			compatible = "qcom,pm7550-flash-led", "qcom,spmi-flash-led";
+			reg = <0xee00>;
+			status = "disabled";
+		};
+	};
+};

-- 
2.52.0

