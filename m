Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C292C178E;
	Wed, 11 Jun 2025 19:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671333; cv=none; b=QBj3K6Lkv/Jbs0AatdjNJhgnlQ7MY2rabYFtozzbDNPrrcaKMw2HRPH+lHtnzXT/MwwuJIuWiZWmkc6tJy9wU5OEYNgizPKnUufUE9oKMJz4KrXqKM1xxA+mLfWK8NE4oTsNHxyovMpAQtMQWk7MNGWFGfEsLbJQnaG2aTDqv1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671333; c=relaxed/simple;
	bh=w/dMst1udcetA1y6IV0fshp6d32+nQG/D7UUjKQHprU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCnmOBjydNsiyh7ihwqTt4NjHCheieTqehHzXD19wRuhbdRLcsKHmN6lUgzvydxtCGzIyVa8TnczPmGavtZ8bljLlhv9ybbeBa/bRjepfidBm5XDn+e/WJ8162G3JWxvSi0T6OPQwoaN+kOwXZGvVHUFRpWhAe3hyP6ZJ/sJNMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=vY9A5y1k; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="vY9A5y1k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671331; x=1781207331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w/dMst1udcetA1y6IV0fshp6d32+nQG/D7UUjKQHprU=;
  b=vY9A5y1kUNXLw7+GcX8PW5/RhMnVgZu8OHuZql1OuIM6LcnjBtZ/m4jS
   8FszAXJ87sWoHv+HvGVod0AsYpoIAeCarJUtK92p7Rtrdi7xkQUQh463g
   pv52xMTJdINl7Dl6sfnozELWSUEDRukZnwgDyr07UWllFrE7emwJ2kqpx
   qve35cdu/TqhXimKaNUcNk5Wn9Q7yaa1wLb3TgroaVK08O0LFh71kHrII
   7GJJcsXZymuHhGcPRGG1r1HGrfE+0odGiUovFp43VJIYH7nXduMx8BZFP
   rgqWXNl4wSBiUCKpiZrv1vIbVNP2wSzwyQfQGNs3eBjv+4iyXE7MGf/qr
   A==;
X-CSE-ConnectionGUID: Mlj04rVUS3aXDCaAEgxBzw==
X-CSE-MsgGUID: rxi0SeHCTBWnsQEPh1vbpg==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="210175098"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 11 Jun 2025 12:48:17 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Wed, 11 Jun 2025 12:48:17 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH v2 09/10] ARM: dts: microchip: sama7d65: Clean up extra space
Date: Wed, 11 Jun 2025 12:47:33 -0700
Message-ID: <ac1decc35e2b4f706cf6ab9378f2c88e5295dde4.1749666053.git.Ryan.Wanner@microchip.com>
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

Remove the extra space that causes formatting issues.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
index 53a657cf4efb..759b963d987c 100644
--- a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
@@ -38,7 +38,6 @@ reg_5v: regulator-5v {
 		regulator-max-microvolt = <5000000>;
 		regulator-always-on;
 	};
-
 };
 
 &dma0 {
-- 
2.43.0

