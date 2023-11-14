Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BB3BE5B
	for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2023 05:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Qkr0ULZJ"
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E009D19F
	for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 21:05:50 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6c115026985so5384631b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 21:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1699938350; x=1700543150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUFzhD1p24wLrx8VbEeet2u8tL5aDkpM6zodr5HbbIc=;
        b=Qkr0ULZJv52vHOiTdaF8P+tq0EbPvlAwCMod3QiBWJNpJ4SHJJwyf+OhaCso8kZr1d
         7aSshTnI28HkSMCRmuDoBXJtUhZ4SuLpljofClICqJ5VWfbmnT4bjy2nibkG0zvureEU
         RpQrL5NKWLwp1x17Eq13k64kBO/0gfbUDRlM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699938350; x=1700543150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUFzhD1p24wLrx8VbEeet2u8tL5aDkpM6zodr5HbbIc=;
        b=GGKDy4hL/TzzrhP/uErzd8wj7Izup3/Rsw2Q+h7ds+2T9Od+xhl2MHVCYLGfVN3uR6
         K8gKB163qMmTkKRQ0trssnk5X7OgZRJ2KjZSWIfa7YAWmyYixyx4sw3Q9jgWKrQw3Pwt
         QkRyNKrUGDgJ7elsONBLWK6bov3UvRGm1co7mYT9e5iAhithsv+vG9Y2C1xau/eJ+Gix
         lr4pHl/yWlN+wmo5yuVaIi9NzaigNyviGwF0LbEnHaCtQT+IvbnvaOy9K9tHDkbPMn6D
         Z4LqZtnMz+hvzcvdN6iA61WYOAnGfNYI4auSy6fCEq5xbxi+7wFMYWcBnUs+BOQJAgcw
         RlIg==
X-Gm-Message-State: AOJu0Yyf65X0aAZQoQI+P6nUkQOzJoLswE0cR8XmuVepnXk5Nm91o2es
	eaRy/TcEnIsoR3MiUZwgjP6gLdUPKnJ7QfKC43E=
X-Google-Smtp-Source: AGHT+IG0HIcgXSdQxDstojJt+0DhmgRbPIN/h+nzazX9xjzM9YVIHFPm2+1RNEiukSvAiWvW9J8zxA==
X-Received: by 2002:a05:6a20:3d1e:b0:157:1b5:61ce with SMTP id y30-20020a056a203d1e00b0015701b561cemr11674429pzi.4.1699938350459;
        Mon, 13 Nov 2023 21:05:50 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a20-20020a170902ee9400b001b896686c78sm4910131pld.66.2023.11.13.21.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 21:05:50 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: [PATCH 3/4] Add SPAcc dts overlay
Date: Tue, 14 Nov 2023 10:35:24 +0530
Message-Id: <20231114050525.471854-4-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231114050525.471854-1-pavitrakumarm@vayavyalabs.com>
References: <20231114050525.471854-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: shwetar <shwetar@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 arch/arm64/boot/dts/xilinx/Makefile           |  3 ++
 .../arm64/boot/dts/xilinx/snps-dwc-spacc.dtso | 35 +++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso

diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/xilinx/Makefile
index 5e40c0b4fa0a..d947dab02516 100644
--- a/arch/arm64/boot/dts/xilinx/Makefile
+++ b/arch/arm64/boot/dts/xilinx/Makefile
@@ -21,6 +21,7 @@ dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zcu1275-revA.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA.dtb
 
+
 zynqmp-sm-k26-revA-sck-kv-g-revA-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kv-g-revA.dtbo
 zynqmp-sm-k26-revA-sck-kv-g-revB-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kv-g-revB.dtbo
 zynqmp-smk-k26-revA-sck-kv-g-revA-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kv-g-revA.dtbo
@@ -30,3 +31,5 @@ zynqmp-sm-k26-revA-sck-kr-g-revA-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kr-g-
 zynqmp-sm-k26-revA-sck-kr-g-revB-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kr-g-revB.dtbo
 zynqmp-smk-k26-revA-sck-kr-g-revA-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kr-g-revA.dtbo
 zynqmp-smk-k26-revA-sck-kr-g-revB-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kr-g-revB.dtbo
+
+zynqmp-zcu104-revC-snps-dwc-spacc-dtbs := zynqmp-zcu104-revC.dtb snps-dwc-spacc.dtbo
diff --git a/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso b/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
new file mode 100644
index 000000000000..7ba7fbd769d2
--- /dev/null
+++ b/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * dts file for Synopsys DWC SPAcc
+ *
+ * (C) Copyright 2023 Synopsys
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

