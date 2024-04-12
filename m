Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD71317BA9
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 03:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712894066; cv=none; b=G5kkOCSvM7ol8oTa3HSF8aEv8jK7ewQKpspZh9pgilyhycglAnxTOUrqkyZhPdw13CF0huuFlwUNWtC65kZE/6KKdlzKi67bk3fSebyBT97c1HLgIlDSe4MfP2rA+1p+3rl2qyw7IVFTPatLDJg2/7fbcJ9XdgouWiS+iH/U0Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712894066; c=relaxed/simple;
	bh=WirT4bT4tmCljyDRZtwHJgsdAfDt/AizWIeiRZuMgLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UsQg6IOjVWShtS0myHL9T7B71DBsEyMc98Fsfth6L+7EtS4KiTOdj9gelhcl+WKUqBc8Xve+9pIdGhULEEB3mCd1iseOCxg5wVdnhN0j703QtYMY3ZzZEvBPsw4lTF/xc68jt/X/vjHNFN5OE8M35BwsrGjHaTjdG9RuLNbpsjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=H06yXkZr; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="H06yXkZr"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5aa2551d33dso319790eaf.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2024 20:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1712894064; x=1713498864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=H06yXkZr10VaUJdBf0qiftTJp/OD8+hJXk2vjgM3pgW13r4KhHUQOr/gcMlLsJPmOA
         erTTivhSaK/vyX67nSI1gptm23iSXp4NxEsCG+Cm9ulm31cbIkq1eJ829eGF/i8Fpm9n
         yLpkBMWSQ6AryKy8gzK29r0D92Gj52e6rhV9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712894064; x=1713498864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5cfWMtWXGsB/SuVB2xqL3O8y2vBNkEblP3Chb8x//I=;
        b=t4Or1nLL/D7MkOp+CwjSvOmzTF6LScDDzuU8N0UOQGjbcA/hmD/UN5RQSqzKNz1Tx9
         9Wf99iJNBdXP7y9QNiZjHXk0IE2qiuDnu6VT63ev8vhGnDiTESNu8nxPBJKLRJl7k6Cu
         kJckh5s3J13kzLeArct/H4SUn0aXexdAj8ose7St3/ziVCARa9F2fO1IoccbDoD/QG43
         WeDjwVNnTiLy+ynFcBoMtAdORE9TeFAyKg8IyBPPo5E2ra5pK4b/lCprIEV51qMfg+lC
         yGOQydLIcPzVJFPcK8b1S4Y6c6azg+jyHoKjS+NpRGRG2SMYYv98yAFq8S8ZjJhK664m
         pZbA==
X-Forwarded-Encrypted: i=1; AJvYcCVked3j0kX2jYqxMC3ZBGI/AMjAn5+A7safllQ2N3tbwDqW23B14RyIIwqTvlmPQWuDPwKnNX3xyj+p3yDbxemCm+XM5wpFHXI//sTo
X-Gm-Message-State: AOJu0Yw7vfGrITCC9w9knwH/NGgpq6WndP3LB7Lx2J/Es7/sI16m6v6R
	ndYWFM3SwnXDFoY5LzJEHsSj2RmzvrEksNe784jbOWiYnmJDHUWgv1DbzGwuE1k=
X-Google-Smtp-Source: AGHT+IHB3LWffeoNDRqoVKgngMNJhglf+pmbogHK84OBvC3KUIXHkpLx93l40BD5tHG+1+zNr0E7Dg==
X-Received: by 2002:a05:6870:1584:b0:229:f768:f6fa with SMTP id j4-20020a056870158400b00229f768f6famr1498590oab.8.1712894063796;
        Thu, 11 Apr 2024 20:54:23 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a193-20020a6390ca000000b005dc120fa3b2sm1842910pge.18.2024.04.11.20.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 20:54:23 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v2 3/4] Add SPAcc dts overlay
Date: Fri, 12 Apr 2024 09:23:41 +0530
Message-Id: <20240412035342.1233930-4-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
References: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
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

