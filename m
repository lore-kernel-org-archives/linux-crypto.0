Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641B816D31B
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 08:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718958106; cv=none; b=VpgpkaIOuZPwVhG141hGYE5zbMX0OZ4GRRCihYOcdMy23W/VFivTfZ3lZHp7v5AjbIXPNE3V6fqDddx9WLhtpfFKFl7epI8+34/gYjVytpFRuSRahRX52ZXLLfFZDHIRIw58qkO/sHkC8gGz+M41nzLe+aA4vhRtGLOpCI1LjHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718958106; c=relaxed/simple;
	bh=WirT4bT4tmCljyDRZtwHJgsdAfDt/AizWIeiRZuMgLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qQpyfiWCxsanSXF8rxsX36WoF+N9p+elf8Gbvf6dA5dSAzZ6hcJOeJUdmGGTQdoA3ka1QBJ+6FdFiat6PJSZTy3sAPmSr3MNCSoH/9YK0tVyMTYADBOsfJdDKyegOJRzZX2NdF1J0/12sd6U0n2XmH5AiKRv7L/YuKzmWRuxlJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=B9c6xS3L; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="B9c6xS3L"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f44b45d6abso14316645ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 01:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718958105; x=1719562905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=B9c6xS3LRM/+Z1lkS0cHnrvmDGx+k8aRE8hFbLsizQVOUgsbLZ6dHP9dXNr2KwpdZv
         XDizi5FAefDEhlc6M7+wInyqgYOEl1Z/mj8GNXnSDikGBK3ahm1y0m30gAuqjVgkxqHq
         spE3nmg2cRZqJELXqfmowz4wBt2bovVlnDEU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718958105; x=1719562905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=W15IQFFSg5v4PTlAv7e2GHUQJlu8l8OyFRMRQvn7WtgUlaPVj+fUdGaY/lsk/74g7L
         2TRuT1nDoB3guEu5kXNAvqHpaw7w47NrSmryAVQonImE1jw8SUeczxNherLvSABJ8y4x
         129HHPizE2Zcimgr+sPa0TJW29l3e6j0U5z4/PCQadoCfWK2OdYXUh1s6Nk5ujWOYTdr
         4uLAl7SMXvSpKD0Kc3XUD5iCAjS0xJwJIZRf8g8PmKNMDQt5omxMUueNcpeIMPIdD1Fv
         /mzVw37yPTc20f6mDAp0JzisEHFPqRbOMrb2PY9h14spC9UGlvteKanCQMptsVaEI9L0
         SFqw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ/1PRgJaCf5ZnZORIKMJP3PpGlDQmSO1q1GK3mMZQ2ye/jyCMbK4aA6A8nC14VEKxFaojek+Jo299MzSduWeeRL9XWhLEoQscECvO
X-Gm-Message-State: AOJu0YzHcUv7WyWJ7wXCahNoZUchlaYFwkSp8J+hfjZMNLUpWkZwdHqc
	Fb64s391dib1J4jce+ehFxEPOXRWkyfVNLRT/arPYLZjsex/10ODHlJbZWdPdvI=
X-Google-Smtp-Source: AGHT+IE2hoqwLql/AIJN9EKd9XIfA/phaoNOVzmlMO6gYdTPE3mN45SobLEA2iqd+cUvYOzV5rzR3Q==
X-Received: by 2002:a17:902:6548:b0:1f9:cea7:1e78 with SMTP id d9443c01a7336-1f9cea71f5cmr29442855ad.50.1718958104137;
        Fri, 21 Jun 2024 01:21:44 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5c97sm8673555ad.125.2024.06.21.01.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:21:43 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v5 6/7] Add SPAcc dts overlay
Date: Fri, 21 Jun 2024 13:50:52 +0530
Message-Id: <20240621082053.638952-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
References: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Manjunath Hadli <manjunath.hadli@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 arch/arm64/boot/dts/xilinx/Makefile           |  3 ++
 .../arm64/boot/dts/xilinx/snps-dwc-spacc.dtso | 35 +++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso

diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/xilinx/Makefile
index 1068b0fa8e98..1e98ca994283 100644
--- a/arch/arm64/boot/dts/xilinx/Makefile
+++ b/arch/arm64/boot/dts/xilinx/Makefile
@@ -20,6 +20,7 @@ dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zcu1275-revA.dtb
 
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA.dtb
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA.dtb
 
 zynqmp-sm-k26-revA-sck-kv-g-revA-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kv-g-revA.dtbo
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA-sck-kv-g-revA.dtb
@@ -29,3 +30,5 @@ zynqmp-smk-k26-revA-sck-kv-g-revA-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kv-
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA-sck-kv-g-revA.dtb
 zynqmp-smk-k26-revA-sck-kv-g-revB-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kv-g-revB.dtbo
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA-sck-kv-g-revB.dtb
+zynqmp-zcu104-revC-snps-dwc-spacc-dtbs := zynqmp-zcu104-revC.dtb snps-dwc-spacc.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zcu104-revC-snps-dwc-spacc.dtb
diff --git a/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso b/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
new file mode 100644
index 000000000000..603ad92f4c49
--- /dev/null
+++ b/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * dts file for Synopsys DWC SPAcc
+ *
+ * (C) Copyright 2024 Synopsys
+ *
+ * Ruud Derwig <Ruud.Derwig@synopsys.com>
+ */
+
+/dts-v1/;
+/plugin/;
+
+/ {
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	fragment@0 {
+		target = <&amba>;
+
+		overlay1: __overlay__ {
+			#address-cells = <2>;
+			#size-cells = <2>;
+
+			dwc_spacc: spacc@400000000 {
+				compatible = "snps-dwc-spacc";
+				reg = /bits/ 64 <0x400000000 0x3FFFF>;
+				interrupts = <0 89 4>;
+				interrupt-parent = <&gic>;
+				clock-names = "ref_clk";
+				spacc_priority = <0>;
+				spacc_index = <0>;
+			};
+		};
+	};
+};
-- 
2.25.1

