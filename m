Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D75194A43;
	Fri,  7 Jun 2024 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717769596; cv=none; b=t+YsnUhXgfgHVs6Ks1afksAyRluyf8xChNkVyS6OWUQ8xSYTKRZTihHy0BV7be2dvcJ72FzLpdV/gx3mzV+5kC40NutClZ8mvsBY3vjtwPmnWVyCvzMgX441yXUWERtxxSJXbkxiz5Eo+rRKlbCFWQ7dcR2ZbZ3RCJ0XqDruqgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717769596; c=relaxed/simple;
	bh=QiDpR1TI+p2zZanenmfX7eDhMqWQYjltCW2O4S1NJA8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DStmS6bJX71d8oBwJM1H/90A2B36rJ1+yqTovW/ASZ6lPNvtUMsqpcy0yxh1ozXymHDj09sg+LNDoCPzm77pn3GaVM6RR+cw0r5jxijpTI8KbH8yBxj2weoShvBHdF6txuTs9EZWb13MEZKDrvwuu1dfsnMhRLz34fCC3sT1BzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=g1qq+7rm; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="g1qq+7rm"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id CEF74120009;
	Fri,  7 Jun 2024 17:13:10 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru CEF74120009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1717769590;
	bh=WJ5Y7nNjU+mHDwFBxYVKvbc+SUuNTkVIZQiALCiymns=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=g1qq+7rmP/9TEXADVYR43zqIDO/L4sJyexDg262/JK0aZQ5QoLmVGqZp6gNCh3IPg
	 jbdhpjjupZGyU+du1IEVLOPiRxdSFMEqiouOWM5ybICRzxqGlnKfWEKhfLFCglT+m2
	 n5Zr/RgNPPcov0z9NrwzcTKrAumG2f9Vih6hsxcdQ0nejOrZ9c5LyJHjvFqtSkOBVt
	 M6iDjEzdex3853TH7W1YoJItQJX49tSHNFJJi7iYEFCse0YKcSla0bFZeLhBQwUfro
	 NvooTFKCfAkq/RVu4bwc04wQAanAdg5HNr63QGz56MNRgrJhyVcu2ALLOXi/pyUser
	 7EZ21LSDyDEAQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri,  7 Jun 2024 17:13:10 +0300 (MSK)
Received: from user-A520M-DS3H.sberdevices.ru (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 7 Jun 2024 17:13:10 +0300
From: Alexey Romanov <avromanov@salutedevices.com>
To: <neil.armstrong@linaro.org>, <clabbe@baylibre.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
	<khilman@baylibre.com>, <jbrunet@baylibre.com>,
	<martin.blumenstingl@googlemail.com>, <vadim.fedorenko@linux.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-amlogic@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@salutedevices.com>, Alexey
 Romanov <avromanov@salutedevices.com>
Subject: [PATCH v8 20/23] arch: arm64: dts: meson: a1: add crypto node
Date: Fri, 7 Jun 2024 17:12:39 +0300
Message-ID: <20240607141242.2616580-21-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240607141242.2616580-1-avromanov@salutedevices.com>
References: <20240607141242.2616580-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 185803 [Jun 07 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 20 0.3.20 743589a8af6ec90b529f2124c2bbfc3ce1d2f20f, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/06/07 12:12:00 #25491508
X-KSMG-AntiVirus-Status: Clean, skipped

This patch adds a crypto node declaration. With the
Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
index 1520d51d41e0..2853454ae81b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
@@ -162,6 +162,12 @@ spifc: spi@fd000400 {
 			status = "disabled";
 		};
 
+		clk81: clk81 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <64000000>;
+		};
+
 		apb: bus@fe000000 {
 			compatible = "simple-bus";
 			reg = <0x0 0xfe000000 0x0 0x1000000>;
@@ -972,6 +978,15 @@ sd_emmc: sd@10000 {
 				status = "disabled";
 			};
 
+			crypto: crypto@6000 {
+				compatible = "amlogic,a1-crypto";
+				reg = <0x0 0x6000 0x0 0x48>;
+				interrupts = <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clk81>;
+				clock-names = "clk81";
+				power-domains = <&pwrc PWRC_DMA_ID>;
+			};
+
 			acodec: audio-controller@4800 {
 				compatible = "amlogic,t9015-a1";
 				reg = <0x0 0x4800 0x0 0x14>;
-- 
2.34.1

