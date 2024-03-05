Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A026958138
	for <linux-crypto@vger.kernel.org>; Tue,  5 Mar 2024 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638144; cv=none; b=YmDi0o5VFhlVMYKINrbnjd9xEiqeHG7M5hVnDIWcMkYVGwZtDfMMFqIKY3RyaR1FbGt47hSCy8HjVg5/y0cJXOlXuUGKaEYheP9Y38r4GpuTEf8tE9Fp28ynzP7LOOVH2UDuPzgfJnB0qkTtG95V4GZ8ulqdmFyEu7y4fys9fxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638144; c=relaxed/simple;
	bh=WirT4bT4tmCljyDRZtwHJgsdAfDt/AizWIeiRZuMgLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KwAPPAMTtwRAzineyuIXkqL/plZ0frwa+L6MaRJ9v2wzr4Whu940ff2HXHXOIp3EXfe23kuyM1EWCS+R2NpJdxUadlTLnuY4XQ65VNJPxlMyaIcKBDua4w+6vm45GF4nQr9tQp+2MOTODMBeUWg5koEGijo49DJPOfMSmgIm6Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ZkjUV4x7; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ZkjUV4x7"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc49afb495so51694255ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 03:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709638142; x=1710242942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=ZkjUV4x7CAINAaGgaM/s1WdsIbQ4IzE4k33H7y1Dd9EVCI+pohG1Wz6twm+TFDTITN
         xxgS+vyq/VeWWUvcbkuCgY4vPvvEADFECs87Ja4Akojp95LLN8oBSvJEaJIxkDdcgRrP
         Y/uNP4qrrHpJvBzHi71MiFKD78vHdj37IXDrg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709638142; x=1710242942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=gBy1CYNL0K0uYvlsThK1tUPxsFWQzWqU+DxosFfNfLRl6S6+7daWUbiAir4pqH/ZWU
         IETcGWbpM7DL84MtlgUP9XZU7yW5aKy39HJe8U1ypBjfTk4orbGBmVrsFCzcO/laGT2Y
         MqJyPM8j1McFO68048p4K1LfYR/9elJH3nmvdd/pySdcqynSEkfiD/NqlQLlA2GQ4KrS
         C+5sWrmXDBaSUqqSBUH/e4U178f+OneaBH0vgTRZ/Hh9rNT9qempP0ERNE7dkDLB3tNA
         7FXZwddP9WmHhLDLCTmY3xgJ8l8amPGpT2VAsJIQlDUJyPySDPS+7Z9arFZ6NOiOJpqP
         gs/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWEWH9SMH0GQRH1euyJOuGrC9spQ9rfAcagUk64p1/Ux6yxm+Mx2ktAgJTcNuM3MkXPdCcbqTNEknkLrhz+wOhc0kPRYo/fpX2DX68n
X-Gm-Message-State: AOJu0Yz6V1jhlRUo+BA5VBo8rJorzEQjfeG8d+08XVE0MGewbFhryj9x
	DOMK0DX23syzMXXWetD4Ggk4IB5SySDzlEHt02Xfzb/kGmXlCkhkeZu9LIEZg1qM0mWy9yNalR0
	F
X-Google-Smtp-Source: AGHT+IGOYArZeXqyUR03z1VvPX0yLXrgZanNFcLYM7phEYIsVDxuz1f0oqp3b921ivXbD6Tw8qcDJA==
X-Received: by 2002:a17:902:f684:b0:1dc:b6bf:fae8 with SMTP id l4-20020a170902f68400b001dcb6bffae8mr2066626plg.59.1709638142128;
        Tue, 05 Mar 2024 03:29:02 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id mp16-20020a170902fd1000b001db7e461d8asm10287212plb.130.2024.03.05.03.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 03:29:01 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 3/4] Add SPAcc dts overlay
Date: Tue,  5 Mar 2024 16:58:30 +0530
Message-Id: <20240305112831.3380896-4-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
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

