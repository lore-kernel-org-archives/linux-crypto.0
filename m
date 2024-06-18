Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2FB47A5C
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 04:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718684907; cv=none; b=mnb7rWNciFBRJP4xOw6vcQUcgV7fttCBGIxMwv2XNT/jxYotdiMWMkeEvGokex3/10RFZdu1fObs9vwgIEWg6QH8vnrDsIClkvQ8d69r0rH3RmCAIb+i5ighgfxFtIxNW8+8DUElJ3SWwLG2kOHUjN9jVV0uMQvEzSRCLym9hRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718684907; c=relaxed/simple;
	bh=WirT4bT4tmCljyDRZtwHJgsdAfDt/AizWIeiRZuMgLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CgglSCZBASu9B+EInR9acsK6u/g7Ka4Bh96WCByulGHO+Bh8Tkckt+0nkORq1XH7Lg9v4ubnfKi/WDukUW8PWswHYzwkwsJ8OAW5PcfLhop3dYKbNwv4rnxvcoOf/K5fHM6/M4OFwaflpTrZDSJ+bI4FQOtTDefz6Dze5yyJocU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=jzsM/PuE; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="jzsM/PuE"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f480624d10so41447905ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 21:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718684905; x=1719289705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=jzsM/PuEGfEQcskAc73kiqXRS0eXDinlmz8wnygEuIJ9vVSGd4FelvpgmyA3wcuQTo
         PFJF6VRlGGiUXwqMdVGMl6bbAfAB7y6TVGQzkNz+knuQmUu7gksaiHvyEPMf4l1157MR
         EBVd/LOliXh5e/xPcISxcNBUTPWLbn3izjY+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718684905; x=1719289705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=M8dsmvB4biMmAjq5WGu17+0S55p46JpEtU/TSVqECNVQTKc7ekJUlOPdK2N/fVrTRU
         x/1ESQCtedfA2QOzcAdtQBhAScdwXWVxdvAHnHPQla41xBoA5UYXMaji1EYEWuBW/rBn
         ZuIjWNY5VuqJ9F9GkBS6I0lcxxY7GvjAaRUSk6TBG9v/Em7Q2shNIgC1EIINLyQDcB82
         owRnc1B37oTuKcIpUjPc2hBAZfp/jAJ9IMycTlONNi7phg7scFgeZVoPj+cdDwygyiDu
         nEreDc6mTq+tBbS1Lf0IWdt33WK7BsaxFfQb/7sRpW6uzzEZFFlrYxt7h+g2N0ctBt8t
         vEXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGmwR1+qFSNErhjhDNbPACrHQtWWwVExcqFjLys+8IX97n+uvrFzM37eFe20u5DY3lD1HHvqpXa3SVpaAPnydbKva2NMdNhfNUvKda
X-Gm-Message-State: AOJu0Yw27xWPZ6sQ1QPloqGGtDpi84fr4z/jcs0ORrOLNzZQwno9eURJ
	MP7MWWw9WLfLQxY7rUbJIiwgbwt2CnLmbcM5WBWynhzsuNyR9dcLjFY7xYoHalM=
X-Google-Smtp-Source: AGHT+IHu+kfLX514N3WpHdHhHPGEFWPGAuj7c0W1NWi3cGd2XAMncrDMpvN9gJHCOZnO32fRyRstbg==
X-Received: by 2002:a17:902:d2d2:b0:1f4:a6cb:db3d with SMTP id d9443c01a7336-1f862804b23mr133579605ad.44.1718684905182;
        Mon, 17 Jun 2024 21:28:25 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f1770csm87912405ad.230.2024.06.17.21.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 21:28:24 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v4 6/7] Add SPAcc dts overlay
Date: Tue, 18 Jun 2024 09:57:49 +0530
Message-Id: <20240618042750.485720-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
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

