Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55C02BD5B6;
	Wed, 11 Jun 2025 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671320; cv=none; b=OUIHXq/reJse7EJbEWyzmJd+QmkL58p7UWUnlOUg6W0H+pGccn6SxU46LKtRZk3R/9959/2rP7NzawFsXxkpgM4KXC2pYCfnqlbN8r9xYKS7JNHfG2vkV+BV0MJWTkAzAnOIh3nEKL7tRWMyY2IQOe9qReX9WZsw1gUvVxQOa7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671320; c=relaxed/simple;
	bh=dcOfXL9MltZ3nYKkbPpRui8wd9Bj1jDl3/DeSQhb8jU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iODc61BuB6JWqgBVNHlM/uTDn2mcI6uXdHaO7i0CPX6Q6RrdX6IUjtBUAmTg1qBxixBVh5g3cW9nUR86C2teAJ244OxDmqn0ircSDQBlAO9Y3dciBeGvtn+HWZwnUHyvUFf5uRxm94xMF7q9/lI5K4zkQ90nUYC4p86JCaIbUwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=ffepEVfX; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ffepEVfX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671318; x=1781207318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dcOfXL9MltZ3nYKkbPpRui8wd9Bj1jDl3/DeSQhb8jU=;
  b=ffepEVfXYnEwCXTxFdhxe+iLEzxAN1B8Wwq1pRqYWC0eZYUzd03c2umi
   Ols6ucsH4Ksfbo22cYRq3xoBMr4ApHPA4P8g9REurMWB4prdL3MsdZqR7
   DVfCEv8AEDMHGeAPvQ/slj8s7A9sNxfqZA7SqUtIE9HXq5BW4j7Fcrhvw
   tx2U7x3JHFtrk1pVwOfWJI8IBv4q/p0nFXPMdNePCwj56RmBIVKMlHGjO
   HJt+/v2YE2eJ7HR9NCCs4yCO2lwteHNma03PCBq5sSVFlQSLREBcPmoIf
   RPCXzLeofjET+Pf3/u6pHaMn+q6nCUTgCjSMojzW/MziZrNGBl+Ki3156
   w==;
X-CSE-ConnectionGUID: VqjTqfGTSymHXSpb+r0c0A==
X-CSE-MsgGUID: vvL/xi+4RCO3wjDjSuojTA==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="42226223"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 11 Jun 2025 12:48:16 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Wed, 11 Jun 2025 12:48:16 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH v2 02/10] dt-bindings: crypto: add sama7d65 in Atmel SHA
Date: Wed, 11 Jun 2025 12:47:26 -0700
Message-ID: <a62591306df47ba006470a00e6c25d9df419a4fb.1749666053.git.Ryan.Wanner@microchip.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749666053.git.Ryan.Wanner@microchip.com>
References: <cover.1749666053.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ryan Wanner <Ryan.Wanner@microchip.com>

Add DT bindings for SAMA7D65 SoC Atmel SHA.

The SAMA7D65 similar to the SAM9x75 SoC supports SHA1/224/256/384/512
and supports HMAC for the same hashes. They both also support automatic
padding as well as double buffering.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml     | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
index d378c53314dd..39e076b275b3 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
@@ -15,7 +15,9 @@ properties:
     oneOf:
       - const: atmel,at91sam9g46-sha
       - items:
-          - const: microchip,sam9x7-sha
+          - enum:
+              - microchip,sam9x7-sha
+              - microchip,sama7d65-sha
           - const: atmel,at91sam9g46-sha
 
   reg:
-- 
2.43.0

