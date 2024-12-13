Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7CA1E9B06;
	Fri, 13 Dec 2024 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098919; cv=none; b=dr+z6C8PruP3Cum0cEVEho20t6H6g8TIzb3IZvYSeark4fhgJo5eVlFTJVOpPzYYBhtKksBemLQix2Ypl0gDOgSL0JF/x/6SUZ1ryZbsw9upb8Ye5y6eK2sR3GQ8P8xnGWXFEYdPhdZdmCkiIIQlPVsrAqMDZbUZr9WBTw8ZAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098919; c=relaxed/simple;
	bh=NYcx2qYs2UGdkq0kSCLYNWuCYpKqFQcIoLnHxtVT8xU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGhAlQvHQRzDJKvStJVrr2OFIc1yg4YgF2eE3ULuPZwuw5BRqwS7xHIkbJdPgI+OwvNWcObZ5ck4u4RIMQbdUzDFFuc/eLeUo21xSDYnxWdrLKwpp6lUT/jbyswQtVh/YL65KPxUh1xOU9WiGNma4h/pPv3wDFr+HEBqzLDc0Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=OK8uktay; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="OK8uktay"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 34C8F10002C;
	Fri, 13 Dec 2024 17:08:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 34C8F10002C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098916;
	bh=upsI7GPQCIaWboSOQUIx/D+n94yGMlr6ofSLBMZyt24=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=OK8uktayP6dWwDnrhbEdvq8L08L2wUdzRht5EDmBUJFVxbjqerIRxvAj5rowQjP4o
	 BW9qtFZUQf6Opiqsqmpa1JGzVCAxasEtzKhRXKKcSkAl5zSkpyVjhg6DG9jc/Tizt4
	 EWebmYr7RVlLpAaFhfKNnO2niJ8oWP2hXAsJ34bBlDXdCK6ms+/doB/+uoV6JlSrHW
	 unlHQPzF1ERPdkvREVTTJlWXeDYol/qSRZiUcouqE6KOQrYz+4cCPfHyIjpBggLOMI
	 04l6ikd90hAmoFNLR+Ccy6imH82/yHfLXCZUUxe2QEuaJfiCLNZEMR9QEhcSVyM14A
	 ApVDOOVkp0KKw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:35 +0300 (MSK)
From: Alexey Romanov <avromanov@salutedevices.com>
To: <neil.armstrong@linaro.org>, <clabbe@baylibre.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <krzk+dt@kernel.org>,
	<conor+dt@kernel.org>, <khilman@baylibre.com>, <jbrunet@baylibre.com>,
	<martin.blumenstingl@googlemail.com>, <vadim.fedorenko@linux.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-amlogic@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@salutedevices.com>, "Alexey
 Romanov" <avromanov@salutedevices.com>
Subject: [PATCH v11 20/22] arm64: dts: amlogic: s4: add crypto node
Date: Fri, 13 Dec 2024 17:07:53 +0300
Message-ID: <20241213140755.1298323-21-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241213140755.1298323-1-avromanov@salutedevices.com>
References: <20241213140755.1298323-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 189823 [Dec 13 2024]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 47 0.3.47 57010b355d009055a5b6c34e0385c69b21a4e07f, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;smtp.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/12/13 12:33:00 #26873825
X-KSMG-AntiVirus-Status: Clean, skipped

This patch adds a crypto node declaration for Amlogic S4-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 957577d986c0..846b9d1481ba 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -66,6 +66,12 @@ xtal: xtal-clk {
 		#clock-cells = <0>;
 	};
 
+	clk81: clk81 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <166000000>;
+	};
+
 	firmware {
 		sm: secure-monitor {
 			compatible = "amlogic,meson-gxbb-sm";
@@ -586,6 +592,13 @@ mux {
 
 			};
 
+			crypto: crypto@440400 {
+				compatible = "amlogic,s4-crypto", "amlogic,a1-crypto";
+				reg = <0x0 0x440400 0x0 0x48>;
+				interrupts = <GIC_SPI 24 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clk81>;
+			};
+
 			gpio_intc: interrupt-controller@4080 {
 				compatible = "amlogic,meson-s4-gpio-intc",
 					     "amlogic,meson-gpio-intc";
-- 
2.34.1

