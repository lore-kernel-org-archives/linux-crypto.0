Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF7F2264D5
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331059; cv=none; b=mysqPmdSDQC7S1hD5ggr0W9jynz/DThmVrmPtY3w1BNUN8eXFkRNaFbFaRvKkjRF9skj5SAs9nXT6OU0vNbBgHFsS9w6/M7SsQ4qdy9C2qp28ca1D9N6tCmddcZgBBU/kAKvHV/GHcE68RPIl0jfxixhIdzjS+y6N8AO2VkP1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331059; c=relaxed/simple;
	bh=/3f0t4BZ1kTyyQ6hLM2p+V6L+8Ptg1VnPTNQ3bym2iE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oQ1EZfmPQGkzluJj8kD2iVVTm1qOGZ63cNWm7ZAF97Zoqh/VHjjkgsxZ1uq3JvrJBhqNJ82sMSxZaOxr/Z97YBzgOs3/UsoZggD4E/jxAown/QJznVFgdvr7VCIipkOMlJw0pbPdpTpGg+s0F/ipXXj2/ZucNptCFCDEvl77XM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=EJ4uS21z; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="EJ4uS21z"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso64400415e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765331055; x=1765935855; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xzEHSBM8EKEFfz+/7Xm+vBx/uKXNxWFQzQb23oP1Qig=;
        b=EJ4uS21zhi2/KLhQygJ2Ct9XRFBcIJYjURja7fPGml6kdXkeI9cAqhJ8Wm6CwCOOon
         5MmCmdyheBkka5nCeQmvbYqNIGB2EdSy8Yi+KPMKiqiHlvG2B9ZxT4muAilLZzx6AK9o
         47Y16D/SMBv5k4Mo1l+yrzUZdUzU9btj9N3PvPOvUD1qwJKGO5jGe6BidWZdXMAyh854
         trM+CrDLK9T4o0uKCVyFf8cS/3qEsr04ogmJmd657IE3lCrMckAbDwQBDqzTSbrlxxAL
         NAlIh0vy1c8te2NeRSYc8gOR7B7v2uIepnZjJDqOEtC5v9jClqblxXtMQ/BKCSOgf5Wm
         36Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331055; x=1765935855;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xzEHSBM8EKEFfz+/7Xm+vBx/uKXNxWFQzQb23oP1Qig=;
        b=ZYYU220Gs7+Qnp7uGZCPtMenMflnulKalFWJVs03lHQ1N97qwCYtKgytOAYIq55jgQ
         xzt6nP27FY7jAMB8KhAsukfPoo9MaXD4QP5rEr1Vb1ePR9pGuJyEad8j2HNxtUzHxHs/
         vnMg2mgqCzPUMH3xyrPWNtoMG5MJMIK9UOIi3PgA8hzy+G1MSPUzzRCGU2DX9EFAXYD2
         Iypu/8vhEUmRnjzOiHwn4ncZsHBva33Xdg5fXRWZEl659KOEunxu+JV0K3rXbi2OFezr
         Exb0NFYC6jtfbsSLyyusIG6RWyAN2tYR+d6+RTi0/1C63rL3vO6uJIh19A13OUdd4Y0P
         kSBw==
X-Forwarded-Encrypted: i=1; AJvYcCVaLkdUGkvHBAWs0z8zlBGb+nZD16ggyOYLtIArGtdZj39OqKpz8pZcXO7UQ1jqW0fIbUT1lwzt+oVfx0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb1VaNT/VIcNG7yqJMIHopjxCJO6YLzXsiO03sT365Ki6+DlqK
	yzig8a2eVLwzPG6PghQdqhJQXvZiO48MdRv+lN5ZE37ZX9J9voK6hkSbGJUIlOJN/xPozgg65At
	87NMivdMI+Q==
X-Gm-Gg: ASbGncsoRzVltXivFQggLOj4FX+MrXhQfk/Q6O/supFH/KmNDqoIcLEW6T2llVlv0Xv
	Ag4yGgsB0GxNbohlpfrbl7ygv+/cQsg6iCQWyTq0myBrtOCOwQC+zR2hqd0u8uRyRJnJHS+Wpda
	2f/a/hnHXRYGdyv1DIhHp0w7unWEUIvPx4y3L0Pu1X9C6vMc82ssAAkTRZ9mQJrMHT6Z8yiOlhu
	yBuYIHasfQyU3fxEGxkCK83HKyuEA1oYhXZIdiIcGwftAbJWgt0RwMDxY3HHBlhqCh8J2X3RhlQ
	K/++fnopRVo4haJDjX500pine67i8wn3f9TK1bzWX84xaSS/kwU1kZF2ME8WR1xjSn7Se+OKvqN
	FEbfgel399L2YOSukmfXwCRuVRBAb2jnnrjiG9sa2vpkAr5fkx9aR4WP+aQsxJcPnRyKSeufWiI
	nHLv0NNeUYl5yYo2yUWpXz1fAv3OcxKhV0lTV8Ydf81x7jgPQrBg==
X-Google-Smtp-Source: AGHT+IEpb8pZkLOZmhq99p0rKl8a6UhTcVeHwd5tDv1ixcq9g2mK9P+mksQcDeiot2w3P8jiZMQnmQ==
X-Received: by 2002:a05:600c:198f:b0:46e:7247:cbc0 with SMTP id 5b1f17b1804b1-47a8384c2d6mr7043475e9.18.1765331055026;
        Tue, 09 Dec 2025 17:44:15 -0800 (PST)
Received: from [10.200.8.8] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a7000c984sm705234a91.6.2025.12.09.17.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:44:14 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 10 Dec 2025 10:43:31 +0900
Subject: [PATCH v4 7/9] arm64: dts: qcom: Add PMIV0104 PMIC
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251210-sm7635-fp6-initial-v4-7-b05fddd8b45c@fairphone.com>
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
 linux-crypto@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765331010; l=2204;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=/3f0t4BZ1kTyyQ6hLM2p+V6L+8Ptg1VnPTNQ3bym2iE=;
 b=JHks+wlOz9dw6vQB0HKk0ZK3dlNr3cs4hUE/f7/+7JcDmpcSweHGNYwVniHnAzAT6bx7wHkUE
 qyEky8Ll/afB0lSIPzc346s8Fr8ngztmwAkkRKXRKhaL34MDBrehFKH
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Add a dts for the PMIC used e.g. on devices with the Milos SoC.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/pmiv0104.dtsi | 73 ++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/pmiv0104.dtsi b/arch/arm64/boot/dts/qcom/pmiv0104.dtsi
new file mode 100644
index 000000000000..85ee8911d93e
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/pmiv0104.dtsi
@@ -0,0 +1,73 @@
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
+		pmiv0104-thermal {
+			polling-delay-passive = <100>;
+
+			thermal-sensors = <&pmiv0104_temp_alarm>;
+
+			trips {
+				trip0 {
+					temperature = <95000>;
+					hysteresis = <0>;
+					type = "passive";
+				};
+
+				trip1 {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "hot";
+				};
+
+				trip2 {
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
+	pmic@PMIV0104_SID {
+		compatible = "qcom,pmiv0104", "qcom,spmi-pmic";
+		reg = <PMIV0104_SID SPMI_USID>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pmiv0104_temp_alarm: temp-alarm@a00 {
+			compatible = "qcom,spmi-temp-alarm";
+			reg = <0xa00>;
+			interrupts = <PMIV0104_SID 0xa 0x0 IRQ_TYPE_EDGE_BOTH>;
+			#thermal-sensor-cells = <0>;
+		};
+
+		pmiv0104_gpios: gpio@8800 {
+			compatible = "qcom,pmiv0104-gpio", "qcom,spmi-gpio";
+			reg = <0x8800>;
+			gpio-controller;
+			gpio-ranges = <&pmiv0104_gpios 0 0 10>;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		pmiv0104_eusb2_repeater: phy@fd00 {
+			compatible = "qcom,pmiv0104-eusb2-repeater";
+			reg = <0xfd00>;
+			#phy-cells = <0>;
+		};
+	};
+};

-- 
2.52.0

