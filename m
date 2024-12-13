Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A157B1EBA05;
	Fri, 13 Dec 2024 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098920; cv=none; b=p+XKg8v1LbDbJIcnrsF+Hho04W9uwhe05tfODj9gZu/jb1AAM/0OsGvP1fSew/epCyfP08NEvHCpEVqVehwVkvyynzQOzhvtOX145uIklxrLisAO1MdPzIR4bz1KZE//pKiG6ULRaPiqUONPa3CQBPnThMU6xDPTgvknlVEUcXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098920; c=relaxed/simple;
	bh=IcCQfYZWzkifiFKf9ZaFqQYo55YnzW65SY14NuZvJ04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IeH26Ud4iURpilhlabbllX4izzslmENIVmzEvWr54oqdvwVkfv0X/XDol+JJxzL8HkxbAHs0pnGElpNe1/xEjA/n8wBWWW7AvlXeAMhMtOMwgZCd2O3SPMaD3rZNaP9SgbLIAQLbDznqMah+/N+/VTA7w5MaEwMUtxTVzZOHXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=vXRYkLVj; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="vXRYkLVj"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id D8A78120016;
	Fri, 13 Dec 2024 17:08:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru D8A78120016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098916;
	bh=WeJhxmz45dI2UhJMRdBxsOUNB6YdH3pv0oUYPtja4rc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=vXRYkLVjU2FdN+lVd6VkbF7dtu6i2JYT3El0K/QRHPSgICxT5OCiEuw4ooRieq3Ii
	 pbzfXlVTXACn67Yp4bC75G0vyUQ6m1brz7Nb9R+e1bH6LphYw4kdNAtkksyHzEnpYX
	 FZN5cxUjrl/lbOEjfg3njkC8rM5WwXPdULI62iyDlIjuhdU5EhD5GLZWLzpKtKyw6i
	 3CFBTPflYCdE8M3yftvcq7k+7HRaYfxlcgtqMN7vMqp0fNIJziea2DacRJJIZL8RZa
	 omBpgFTFXqSmekpQtqHYqyLjqb66E6PkGB2zdPsjHYaMs9kDbvQNOamsLuDP5EYGbX
	 Se554A5F/ehoA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:36 +0300 (MSK)
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
Subject: [PATCH v11 21/22] arm64: dts: amlogic: g12: add crypto node
Date: Fri, 13 Dec 2024 17:07:54 +0300
Message-ID: <20241213140755.1298323-22-avromanov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 47 0.3.47 57010b355d009055a5b6c34e0385c69b21a4e07f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/12/13 12:33:00 #26873825
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

