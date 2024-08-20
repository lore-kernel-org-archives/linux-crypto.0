Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC881B3F3D;
	Tue, 20 Aug 2024 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724165838; cv=none; b=RbnalOa6V6X0GA/J7W4AbacYYJAD8vjI/VIYm/82v1nkmJj5ZBtpqkEpHqswOwsYtJ0MQLsoDoW5An5uM302oXNOIwNiMSiJEzZg2ZQPN5aruG2Ra/X0+GCQaFO9G4KsFXJjab9Hud+BvM+Mg6apX3X9CPBNdbDwP50jM6xauSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724165838; c=relaxed/simple;
	bh=E1YJ+GQw2poMnVPxJs8UcGyUyiiOyZI6LqwV+nAWGVU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxYvq+WUVQv+dOk4m6in4e5vCCJa6NFr96GCFriltGiWa7stL6mrpaKbB70s1rOsSQU+M76EfF6dfiKPpEE9dEecyBkZajkj0Qdonh4pVnS9DfiCliVB3RMt/x5SZnLTxAhrPCMe7uXyJNoBqwV7H+jKh6NKcuyqkmbNxEO/4OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=s2b.tech; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=pWRRhPFR; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s2b.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="pWRRhPFR"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id AE6BB10003B;
	Tue, 20 Aug 2024 17:57:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru AE6BB10003B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1724165834;
	bh=EL9SBf+DqUJcJ7AfSQyJNilZ+I8kcNPfN7vrWIIqoPg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=pWRRhPFRH5ysBhxQxM4azFaPgzbdaz4CX5qzoGDBqRBYVDf2zgwIH8OZwT9RpRFkj
	 yYxEt+dhJPEtHRaTj3eyeYcXYn6hwfquWOnRfAghDtm9BQbUSWqSkU8thCN8uVZbO9
	 JVbJ9LlMwMruUMyqjePX8HxXWfn+nVNs8x/OQ8T7WWvlOdpunzX4NdYBNYg35CvSau
	 PIBdSW1XASWKto0tWZwTuHRLYKm4vWn6EDa4oRZdjhj1LBOVZoc9dlNvaSf/4EMwU0
	 BZcG7+FH7yFbdB+QVyYWRyK/2cLTIhZf6PTR6eg9NlesmN2bITLATBT+mZkNDg59mE
	 6aaKlCNYHxqYA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue, 20 Aug 2024 17:57:14 +0300 (MSK)
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
Subject: [PATCH v9 22/23] arch: arm64: dts: meson: g12: add crypto node
Date: Tue, 20 Aug 2024 17:56:22 +0300
Message-ID: <20240820145623.3500864-23-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820145623.3500864-1-avromanov@salutedevices.com>
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 187181 [Aug 20 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avromanov@s2b.tech
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 27 0.3.27 71302da218a62dcd84ac43314e19b5cc6b38e0b6, {Tracking_smtp_not_equal_from}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1;s2b.tech:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1, {Tracking_smtp_domain_mismatch}, {Tracking_smtp_domain_2level_mismatch}, FromAlignment: n
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/08/20 03:45:00 #26365304
X-KSMG-AntiVirus-Status: Clean, skipped

This patch adds a crypto node declaration for Amlogic G12-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index b058ed78faf0..28bce1602007 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1728,6 +1728,13 @@ internal_ephy: ethernet-phy@8 {
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

