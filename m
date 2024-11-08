Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315791EB9F2;
	Fri,  8 Nov 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731061795; cv=none; b=TWJ6/w6KcjHaGQ/T8HHxZ74qGZpP2+qI5Kzh1Ir71oxNCkehtmJJsP+3mdWYoFAvgFt/nNutQnf5oc3RUCvDwFclcg9PXH+gw1814bcFNkARXdSIPUArMMC1LdpaZwMxYYJr0xC2+smXQUq4ttTSOS3jF5OxrZqVzcFIExm2eIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731061795; c=relaxed/simple;
	bh=/P6YvjbUvGcf4aGvjlaB/kKxOCviJsRjuBp0eYVpakM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuavbVhl8tmHKnLbHv+zF59tQcsakMuuye0XG03voFgmIvMG+eabf+FixxCad/qGDrsHdXgogjlaBX4HvJvDIbcBy7mN5vDEOcSpIiuG8qgvPBPMAGbL9df8EkW5da3XWa0pI6VoT/FjRK6mN9QlRfbdVgmEE+s6WJA4tfj0sIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=JTXbqCEX; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="JTXbqCEX"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 8FC81120004;
	Fri,  8 Nov 2024 13:29:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8FC81120004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731061791;
	bh=wQFF6Ki0zrttrsw7unC4oaeUR6e0skFxyp3whBHpKL0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=JTXbqCEX0rj9Pu8D38PEJAeNyXLklY+Q4TZh4DreKbJJukWcWaGvgdmOu3t8bq7wq
	 LaVsC0K9I8pt9ZcPqsP89qWEXQTb+xDHjkZ0B8BHroeOJ/mzc6oUi+UNkk+flBDlsz
	 OhBtlZDUA+0SxtZHohc5zPs5bkBUEJ+IzcmXLvAjVhVG8lOHu4Ruz2i2PfKixPQiEe
	 WYuqHBsI8q8ryZMANUVE+EdLJnvmOKJfXJxs063qtcpedlnVf4ZD8ci2W/1iQEBsDS
	 g2Zs/04TAb7Cl3Ph1Zv4xwP0W+R4vEZYTqlv8O+MY24c0hL3AwnTIz/gDIaYZyyhbA
	 1cmVvPN8RG60A==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri,  8 Nov 2024 13:29:51 +0300 (MSK)
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
Subject: [PATCH v10 17/22] dt-bindings: crypto: amlogic,gxl-crypto: support new SoC's
Date: Fri, 8 Nov 2024 13:29:02 +0300
Message-ID: <20241108102907.1788584-18-avromanov@salutedevices.com>
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

Now crypto module available at G12A/G12B/S4/A1/SM1/AXG.

1. Add new compatibles:
  - amlogic,g12a-crypto
  - amlogic,axg-crypto
  - amlogic,a1-crypto
  - amlogic,s4-crypto (uses a1-crypto as fallback)

Difference between this compatibles:
 * Different registers offset and the number of setup descriptors.
 * GXL doesn't support hashing like the others.
 * G12A/B and A1/S4 crypto HW don't support 192 AES key.
 * GXL, G12A/B and AXG require a reverse IV key before processing.

2. Add power-domains in schema, which is required only for A1.
This is specific vendor design: in old SoC's power domain for
crypto HW was not configurable, but in A1-series it is configurable.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 .../bindings/crypto/amlogic,gxl-crypto.yaml   | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index fdc39797a2a9..106a9d1fed69 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -11,8 +11,16 @@ maintainers:
 
 properties:
   compatible:
-    items:
-      - const: amlogic,gxl-crypto
+    oneOf:
+      - items:
+          - enum:
+              - amlogic,s4-crypto
+          - const: amlogic,a1-crypto
+      - enum:
+          - amlogic,gxl-crypto
+          - amlogic,axg-crypto
+          - amlogic,g12a-crypto
+          - amlogic,a1-crypto
 
   reg:
     maxItems: 1
@@ -24,12 +32,24 @@ properties:
   clocks:
     maxItems: 1
 
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - reg
   - interrupts
   - clocks
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          const: amlogic,a1-crypto
+    then:
+      required:
+        - power-domains
+
 additionalProperties: false
 
 examples:
-- 
2.34.1

