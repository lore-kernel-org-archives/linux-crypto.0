Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2C2BD582;
	Wed, 11 Jun 2025 19:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671330; cv=none; b=VPF3XuDUFH5uMquhF/0VezTuAtPILdMZgnzT3uX0hKqT6YA62SI6bJ0YsNNgp0om14ncOXCOAePTOUoLx2x2d71CybSBcb5VKH95OnQdkCx23nMDZwuGc6j9KFUVyONM5zEIIIl0Ro00GaSbZKy0/kWKt24MkcK7FgC3kYfWRsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671330; c=relaxed/simple;
	bh=e2CR4qFcyAvu1VwvbaZBR1DNF3T1rdks6W3neIG4I04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sXTUBlChxsFuS+VvSs4k/XxC57t0xu97q9sFaAT9F0RKoZVnfzdw6zV/NTChiBY306PwLB0phB1TyLxRiZ/YKabrKKVXtftUBTIW0kCrtDvQei3iQyzdcniLhFnjEaeN0vgCk67SAAI+VXs31O+yQk5ijkw9vIEbz9EGVgooLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=sd/D0s+g; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="sd/D0s+g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671328; x=1781207328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e2CR4qFcyAvu1VwvbaZBR1DNF3T1rdks6W3neIG4I04=;
  b=sd/D0s+gwOO94hJ3+ZPa88jgmGqdTM+ACPK7C4fYIpLBwE9R3pT9o6mq
   JUj+m8KOdqRz5nkBJeFOz0Q7nOpmtms438A/5lKEVd0VWA/UQEpgfpiVG
   jL2P0P+HSCQRVDTqxteJOP44162i3u3PVwxFE8iEKbkCM+0wyAcQJrm5Z
   7PcdPkQzHC34TEqy/e4bWJ+q/nHaQaRbJlIOQzajQfpmgEqnsH67sfeqB
   IDxEgUsUycAm/0eVY/xpurG1AwF69CEhWYQNdK03wmE94VJ3+OPPSaAya
   2nobDG+AZsb2A2oTCpnRkz/P1WituUDe9sgHss2Vimkk7Zr00sstac5Kv
   w==;
X-CSE-ConnectionGUID: Mlj04rVUS3aXDCaAEgxBzw==
X-CSE-MsgGUID: jMm4TowrQFuTZc653joPyw==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="210175090"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
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
Subject: [PATCH v2 04/10] dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
Date: Wed, 11 Jun 2025 12:47:28 -0700
Message-ID: <80878d76cfa34ebbc262f245facb98d4a1bf9569.1749666053.git.Ryan.Wanner@microchip.com>
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

Add compatible for Microchip SAMA7D65 SoC TRNG.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
index b38f8252342e..f78614100ea8 100644
--- a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
@@ -24,6 +24,7 @@ properties:
       - items:
           - enum:
               - microchip,sam9x7-trng
+              - microchip,sama7d65-trng
           - const: microchip,sam9x60-trng
 
   clocks:
-- 
2.43.0

