Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB0B1E32C3;
	Fri,  8 Nov 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731061796; cv=none; b=KUuw8pAVHQjrp+E3DW/D8cq/IpDG4J1mOGfbFLmbxPKBE3embWOrL9aX4POkt+Vazv+3Aivvda3NuGsza4OMPxcQX1d6GFaAb0bY+BRrqUBaoCQ/u/loAlpUPKITiyOX0BQwF2LiNSG0A9HPQ/TwjuAByKZSSTEAEFW56yUmT88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731061796; c=relaxed/simple;
	bh=o8XkxtspSuRWmsYjYNu+q9DddGdgU31ZUt7io1E/xaM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TNsZCsJ3Tmvia9mHHMbpBkFDPRGRmB/L6gQ//WmVkUaBU+WkDylXDAUHsBEv01/hb3fVNaTlC/Pt5m1P8YBlijTnuG5XKNB7bptSIsrCcOMa3iGjGUTAzbfMMxxdXleIRWEWbBVbs5rt7Hv6gYqGsZ3GiM3LuX0hQ2P2++td+qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=pb+r+DMa; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="pb+r+DMa"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 978F012002E;
	Fri,  8 Nov 2024 13:29:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 978F012002E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731061792;
	bh=mpk8En28wzqDoi/15J4TdwNO8+HwmpbDNxataxIMwtg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=pb+r+DMaxOfN8Z66q4O6OcUJLgJl0LlhhaZrCdbol+AZFre9kfSZEG8Ak5o1ShfeQ
	 EcT4kRc2PT3/ZdFjTFJ57aephJhq8+aa/3IXBiA1vKW9MnEZep+vZz0i5iJQhYcCK7
	 3zyw3bfiE2BQMNk02HZg/W3mIpQgMHdJxaTdw9tFJfJiliLO+NfUfSCINpuseKwzoS
	 dVyZfsuYEavvOYSg9L3GISLPNkqcFNWVJ0esJUhNz6OKWxS0QFcUOlkATeNvOYsS+q
	 YEAHF19UWmnT+r42fJDNzErUb48y1G+1b77DMJ8nOfY0t04wB6BJaNgm6PQ2oWIULT
	 rXUgcfvFRK3LQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri,  8 Nov 2024 13:29:52 +0300 (MSK)
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
Subject: [PATCH v10 18/22] arm64: dts: amlogic: gxl: correct crypto node definition
Date: Fri, 8 Nov 2024 13:29:03 +0300
Message-ID: <20241108102907.1788584-19-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241108102907.1788584-1-avromanov@salutedevices.com>
References: <20241108102907.1788584-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m2.sberdevices.ru (172.24.196.120) To
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 189039 [Nov 08 2024]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 41 0.3.41 623e98d5198769c015c72f45fabbb9f77bdb702b, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/11/08 08:34:00 #26834472
X-KSMG-AntiVirus-Status: Clean, skipped

GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
engine is hard weired to clk81 (CLKID_CLK81). And remove clock-names
field: according to the new dt-binding, it is no longer required.

Also, GXL crypto IP isn't to seconnd interrput line. So we must
remove it from dt-bindings.

Fixes: c4a0457eb858 ("ARM64: dts: amlogic: adds crypto hardware node")
Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index f58d1790de1c..628d30fd5fcb 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -68,10 +68,8 @@ acodec: audio-controller@c8832000 {
 		crypto: crypto@c883e000 {
 			compatible = "amlogic,gxl-crypto";
 			reg = <0x0 0xc883e000 0x0 0x36>;
-			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
-				     <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
-			clocks = <&clkc CLKID_BLKMV>;
-			clock-names = "blkmv";
+			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
+			clocks = <&clkc CLKID_CLK81>;
 			status = "okay";
 		};
 	};
-- 
2.34.1

