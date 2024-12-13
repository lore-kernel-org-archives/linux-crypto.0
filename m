Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770521E7648;
	Fri, 13 Dec 2024 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098918; cv=none; b=ScdbhTPyJbETklirszZMOzPVdpXuJCoJ17zjhoIzKXnFCq63hU7dGLxjiQso6+/X5Bk1D0n45oyfR7hmUX/JWOhbTsKmgSDD1KUkYrUkPHy0JxY4/cOdAVvTcQqsr199ebS75VatR79h4ROkVCj/dRXOxPwzNFP/mynTW8DM6qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098918; c=relaxed/simple;
	bh=k5aXyoHleIWZKuUF2ugjZDl4DcIotUoCJpEXGsXJ5jI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSsHiI+6Sxv75/og1fCrpP9dtR7zClrFFNdJZe9u4HhWbPmWkMdOaF4cbY0g03dp/iaB49gAfY4Zm+Mi0qHQbvY00ljz+Y/tANW+VeLnx29d5dGR6k+XVv55dZYPGpmgC98rNnDGbto6VwvRi9xyR61jfu9RxMiQ0AQYY4NRJdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=MJ+7XvaL; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="MJ+7XvaL"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 9A23D100026;
	Fri, 13 Dec 2024 17:08:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 9A23D100026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098914;
	bh=1XBodIi2opPjwnHZvnRlQeWi9xUuG1Bb+Vc+QrK3Jvk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=MJ+7XvaL3NDqa6NYl3PUbg43y1Uv6fh5pF3cL5UQdeYjtSgXvnPgvRh9X8H7nyj3h
	 Q6Bbs3aMRvRZAW6hl+N+MactjL/RHjLdJ+3kI4q1BEBpyzZtEW/oJn6lBwpLCe1nSf
	 2jzvhy1z4EtjhsI9yncNmDJD3SjunfMVxfy5BEP7D6oQ4o+D7PEzMqT1Iv2AywCb2G
	 yVo25YUCTiSJceAXoF34FH/A05P27PxrxoimccRGSbcDsa/xWGlFHlDUUPPRLFFvuZ
	 +leZrpFlqpGgVIDA82ckRYzZg5D40/f8QXE14F/iFqQ7gDUWp4m6Xym6TBNQpywONt
	 D9KVL8uo3f+Xw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:34 +0300 (MSK)
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
Subject: [PATCH v11 19/22] arm64: dts: amlogic: a1: add crypto node
Date: Fri, 13 Dec 2024 17:07:52 +0300
Message-ID: <20241213140755.1298323-20-avromanov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 47 0.3.47 57010b355d009055a5b6c34e0385c69b21a4e07f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/12/13 12:33:00 #26873825
X-KSMG-AntiVirus-Status: Clean, skipped

This patch adds a crypto node declaration. With the
Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
index 1eba0afb3fd9..7734dd84c8f8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
@@ -664,6 +664,14 @@ sd_emmc: mmc@10000 {
 				power-domains = <&pwrc PWRC_SD_EMMC_ID>;
 				status = "disabled";
 			};
+
+			crypto: crypto@6000 {
+				compatible = "amlogic,a1-crypto";
+				reg = <0x0 0x6000 0x0 0x48>;
+				interrupts = <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clk81>;
+				power-domains = <&pwrc PWRC_DMA_ID>;
+			};
 		};
 
 		usb: usb@fe004400 {
@@ -745,4 +753,10 @@ xtal: xtal-clk {
 		clock-output-names = "xtal";
 		#clock-cells = <0>;
 	};
+
+	clk81: clk81 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <64000000>;
+	};
 };
-- 
2.34.1

