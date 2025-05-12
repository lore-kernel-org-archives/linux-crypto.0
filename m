Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E03298C27;
	Mon, 12 May 2025 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078189; cv=none; b=jWY8CF79Sqc8fqKQg4Sff1kJPwoM+Wy8BEwQ/YVNqwI10cJ8akF5bjFq/nS3M5r4F7iedRXKfzexaj2wy7Ka8jIAzx+XK4WIhKsQTYycj0yDOX+AEsxZv/53PKeUxTyXCP50Mw1E2ZzTnOSqcqznnrqUDHEQAwjAPUKvHMzBFcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078189; c=relaxed/simple;
	bh=DSd7HCJtABKxLA0P+qbEhaLgR9tQYl+AuyBtzzok9Dg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3bi/eVGopuOLwcNWlkxnzqW6brxaFPNWKPd0ZVnzxaSxVLBv6NYiRQ9W7nPWgpQpe7LVi4ZOfglEuDVABfPPgligIkGu+5+DllhX0+QyUMol8npd/9/uIytGdD0bR5fbJr9qHg6OUB+NFuMye2pA9O11U831EaY7dJ1qp3O500=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=lpbeeWr1; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="lpbeeWr1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078187; x=1778614187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DSd7HCJtABKxLA0P+qbEhaLgR9tQYl+AuyBtzzok9Dg=;
  b=lpbeeWr17hN6TGbls/V0A7mwoFc2R9M4Uvc0J04dedJxFzyQlCPevK+n
   eZChPNBonogkUVP4fY8L6VDfZeJCwVTfGK//2pvobAx1LMxMbLe4dxFPR
   Nzoa5Yi85QlxoDsTmqfSAplwraIbuJZ+o/TZuzXwP8j2QLk14/jQQH2cT
   Xm17R9011lbSgZevmtGmn0FvM0tgwee8nlMyFIOuSpEDmD/Rx2u6UEHkO
   tUoFeSgRrm4rYj9Eowju+gRJMPzxmpxqVDYGsie1R7N0IUCROWg5bY2Er
   7/2pmS3W78H9AiN5QUnI56zLV8xEzNWDUOtu0S0AJXs+NRMlsMQfOgatL
   w==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: xTN55bTJSl6rW4XcLv8AWw==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006610"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2025 12:29:37 -0700
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
Subject: [PATCH 4/9] dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
Date: Mon, 12 May 2025 12:27:30 -0700
Message-ID: <68e45a56e70e0b0b001870905917e8f7ddac61a3.1747077616.git.Ryan.Wanner@microchip.com>
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

Add compatible for Microchip SAMA7D65 SoC TRNG.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
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

