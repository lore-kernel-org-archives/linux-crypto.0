Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0C71F1312;
	Fri,  8 Nov 2024 10:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731061798; cv=none; b=a2Sk3yLV1JRWE9S1E6xg0hVOcFM2V3qj6mpYBj32wGqwTB8ykymprtCVgJ+SWikI6evQAcgZRzc/sxrXgQRZ4niORNE8ft5cW/p5BrzNn3MtbIgiTtn4B9cAC6nVKRu+LJEwy1gKzdpqj8RJNaar4Ny79PBs7Pbd1nWg/k8lLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731061798; c=relaxed/simple;
	bh=IcCQfYZWzkifiFKf9ZaFqQYo55YnzW65SY14NuZvJ04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdbSKo9Idgeq3FdGL48ADyBGNTXZ+y6tgvOGrHrK7K+ySiBVfLuMRicO20fE2K7ik9YBn91d3MDrTCy91JjLMJPGgTrOfn7B59DONmtVvdUEZ0R6pHNQhRyBCw2HaJ3eYxD7fMr5dNKBBOQYUdZpWzvO6qrIYyJaWlPOhlpJwx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=SAoziDfA; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="SAoziDfA"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 0291B120032;
	Fri,  8 Nov 2024 13:29:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0291B120032
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731061795;
	bh=WeJhxmz45dI2UhJMRdBxsOUNB6YdH3pv0oUYPtja4rc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=SAoziDfAZRwqv+YVKNKWADgia9u+6B2DwBJYpf1RzbdVhJQIjAW0yHiNlzFbjE8iX
	 wG+q6MWTadW+veau4tgAZQtrJfJBR2DXQAmWsJlq8ekWs987s3QY+2VSuV5kjMUGYa
	 davNUF+Aw8lryefu8CUDCFDPzvIjfyLQqSmkbzqY54uc6o/QrZXVsrHumkujTGhkOA
	 deEQIw/Z+FZLRJP8FwV7WDbOkI0K51Qx+3CJykBiYVt85CsZo0WVUnnVJaRVSr7mxb
	 ilqkN59VzYYLo/hVBF+HnCcM0sNGaqEf/0LGX7lTl9DH+TeEWXKec4KWfiHtKD5QfM
	 jIXfhtUcv9SQg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri,  8 Nov 2024 13:29:54 +0300 (MSK)
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
Subject: [PATCH v10 21/22] arm64: dts: amlogic: g12: add crypto node
Date: Fri, 8 Nov 2024 13:29:06 +0300
Message-ID: <20241108102907.1788584-22-avromanov@salutedevices.com>
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

This patch adds a crypto node declaration for Amlogic G12-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 49b51c54013f..97c5c8464948 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1733,6 +1733,13 @@ internal_ephy: ethernet-phy@8 {
 					};
 				};
 			};
+
+			crypto: crypto@3e000 {
+				compatible = "amlogic,g12a-crypto";
+				reg = <0x0 0x3e000 0x0 0x48>;
+				interrupts = <GIC_SPI 180 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clkc CLKID_CLK81>;
+			};
 		};
 
 		aobus: bus@ff800000 {
-- 
2.34.1

