Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7FC132805
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 18:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650451; cv=none; b=tfVou36AKTSmTUnY73xUHEyTR6FOh10A91+rRc8/M8ZDfznshTobbYOdTvSImslZHE8TaP9Oq2DZv0cNJqCxSW+Dg1Xz0w0ZrEAJ594nZN3UgC+jylks1Qag28IAzJKOk9090ax9SV8KQXoOC3NurGfQ70j0Yj9kAJK93nEvLoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650451; c=relaxed/simple;
	bh=WirT4bT4tmCljyDRZtwHJgsdAfDt/AizWIeiRZuMgLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CrH3T+VTsLQCq/RNVHTRi9WRmoYw3XB4kb23yjNby5dmqdETfQ8wpzNI0xusbTg3SeHVUIsCBXNhm4OXx7HPuu0YvMNDLLOk+/Ovvn3gOVmmhTH3pOxCDWNWfmdchTkjkWMEixs6477Yy98j6/ZwqUwOGGqNbOCZttnbKyojdyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=WX+Z7mTN; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="WX+Z7mTN"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e0f0398553so12957125ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 11:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1711650448; x=1712255248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=WX+Z7mTN5bidwGIdnBLG1fqSWSIkdOKYC+Ge0La2XYrXmMrWKH5s01mGyDicWcgtLi
         cAF37QL1tuIbhr5VUQomtzt65IQxXXxsJ5XVUvTQB8qtEFTZjRsAe33ieNLRyh2zpiTD
         sscEITKYJnPLhvyJBGsfWF/ZC2TjOIuQLkn1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711650448; x=1712255248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=qoO+vhICg3DVc5BjUZa4UmeTC8Rp29nn4IT0LV89NO48W/a3XqPViN2SmQXxtO2YRS
         dDmAZF4/OxoSf6OsHqxUUEi4DihDmq8r6cvzpXN95ZoxJNJmQDi8fZLtExbsKfLzW2fe
         +w9EovfxaMNZPormxdxGKC8aFIsVwMTkvVSSQClGebTXF2Ngzgxm/nAk6tv3gFuTCR7g
         T42t4vGWFtRJiPBIaLABbnozK7DCYOrf9adHtqf+VIYHFLY9xXVHnu6CvJl6pHDfgimN
         rkC0Z9uy7+3bmsGGBoWuwgdJH+fx/rp1KkXTmikelhSv+y23cHhwAEIlqRV7USxe/1H6
         3ShQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGtfeO4UX0b5dJpACrIsk87T4XFY4MUwzp+TONTLIE1ed/c8hkuSoJmjViChpNQxp3zookEhxqkJXimgliY7VAMLKzHyuNJ8juVks7
X-Gm-Message-State: AOJu0YxhqOEtZYNlEx1VXGPWQRkCC46KErVKKRTJxlB/pz99IpgOV5Ah
	a5IiXin+eRfdUJqGwaeJSgVE2ANjk80CP65ejPSjO7mSHXEu2kh9AiHsSj1CpNc=
X-Google-Smtp-Source: AGHT+IGMuAn+CohIB/CcAVAP38mE/rMbkR4BURMsbP1+3NjQl8V2JIEWPTTDAvT2PY3ph6AozCMb0g==
X-Received: by 2002:a17:903:214c:b0:1e0:bb04:7776 with SMTP id s12-20020a170903214c00b001e0bb047776mr211020ple.37.1711650448086;
        Thu, 28 Mar 2024 11:27:28 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b001e223c9679asm846059pla.93.2024.03.28.11.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:27:27 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 3/4] Add SPAcc dts overlay
Date: Thu, 28 Mar 2024 23:56:51 +0530
Message-Id: <20240328182652.3587727-4-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
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

