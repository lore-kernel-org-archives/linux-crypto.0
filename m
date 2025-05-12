Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CA22989AE;
	Mon, 12 May 2025 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078187; cv=none; b=gsePK/frtlW/V/o6wQOupMi4SFScHC6O5VMSH3k5DhiUZh940qZG967yfAWWGurXiZSitRD4JkQGMIRKyEp78fw81FFdmt1cH3pEAO53V0Py4X4gyWRPlkxvTUhZjKIN8w98tIB6lY1pM0oFgEW0vBhzVd+cvr94N17fkOY4iGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078187; c=relaxed/simple;
	bh=/61U+nFwbRYm9NmcMk+7wewKlEE4ETc8NUwzLZDc/gA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1+uh+rSVDCQ4oxiGaAhwWNiOP7bQ+Ig/CPIt1FGbNJJ/5f650Bz60CkhpvwHlwl7Mj6cg5R9ybEN+kMvK7GNeaZYPrck61oIF9lSEL4jRC6ThrrwE/fU4OpNn4gHtCxqQmazpc5EpcVroWoxx7+uJ73yDu6wRS/uOTjh/cuiwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=PMTaLIFH; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="PMTaLIFH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078185; x=1778614185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/61U+nFwbRYm9NmcMk+7wewKlEE4ETc8NUwzLZDc/gA=;
  b=PMTaLIFHPRLMhmP11cjel4bgUf4RPSJTDcekm6HLb/AHSBr+Qc2d0fGL
   zH+uBNGIwh2XzYXdhz19A3AJ9zHCTAVE0R5JKOJDVAxxmxtPqiIApcnts
   nSCc/JNdc7+liJ8Ny/m7xQy90haZ/T1LpDCHj0JOzy2pcCZ8t+0vWPi6f
   bgQMop/jEg5jYMVYshnX0T1zUOEmojbWCNBqP675uj/vBUiDdORB1laTD
   Behpc2F9CnjCi9X0MDr1jB1ghZ7aHBmZFU5HwHP93bGzG3G1QzGJ4+8NV
   wPVKpFqn0Y/vE7BD0Berqe+WeDPrrjPDtC/lTvFIqMefRZprfr4ohPkqX
   g==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: NLlxROieQM+TrxnEaF/p7w==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006608"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2025 12:29:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 12 May 2025 12:28:56 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Mon, 12 May 2025 12:28:56 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH 2/9] dt-bindings: crypto: add sama7d65 in Atmel SHA
Date: Mon, 12 May 2025 12:27:28 -0700
Message-ID: <5c87dd0c60e3ab295bf084cabb59199d5cb4d93b.1747077616.git.Ryan.Wanner@microchip.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1747077616.git.Ryan.Wanner@microchip.com>
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
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

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml     | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
index d378c53314dd..375464222942 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
@@ -15,7 +15,9 @@ properties:
     oneOf:
       - const: atmel,at91sam9g46-sha
       - items:
-          - const: microchip,sam9x7-sha
+          - enum:
+            - microchip,sam9x7-sha
+            - microchip,sama7d65-sha
           - const: atmel,at91sam9g46-sha
 
   reg:
-- 
2.43.0

