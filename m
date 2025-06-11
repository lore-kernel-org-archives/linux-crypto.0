Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2F2BD015;
	Wed, 11 Jun 2025 19:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671328; cv=none; b=n7NHC2rxWbQ9DAZJW6mVoiMQhgwV6I/Zy955Yf4+pGJvMCGmsSFO9tAzNC6CtweCEgbCmHGWM4HHMYMSBTVSm4HyitRQ3yk07ZvjhtfSA0sbJM+zqeJopRf6/xr+FU4WQofLxNzjj+5E42MgNC9IE6Cr6hbBVvNQxBbAf759IfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671328; c=relaxed/simple;
	bh=QqgIym6p0/qWG6bPfyPWCvi9fxJfP7GcleXqFk/F74k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbHUXgpOJkwZTJRk9pWGTJr8XTLQ3G/WDUZZXrX5GcrReSR2zD/oP3xAmWEoW5U+Qm2rYYi2IIE0BR0ASbicklgNN1N1aJqV3eejoW3cwxtaPo1hmys3VR1T7amk7DdsHCTjLnNt9LIAm2gHgCNDPsGI0fHHP9rU/H9k0XYnwA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=f+TOU63+; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="f+TOU63+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671327; x=1781207327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QqgIym6p0/qWG6bPfyPWCvi9fxJfP7GcleXqFk/F74k=;
  b=f+TOU63+WD6enj74efvGIVRLTZeB50P5KKi8WFof9/dpKj6BbwJ4E94w
   5b9jgi53bXzeOBPMbownBvvXUsnOu1hUbym/sil2aP9Q7iSeSqWLkhMQI
   0TigZ2aOP7w4qzQiEmPUCvLILwUJw4BRboV+nIhP/JELRjDR57rKA2Exf
   TiVcqOf2o66yZxuz312VfGVrhROjqBmRRrVI92RaDmVi4+LlhdZMntQn6
   YWrpKpR7I0PxYSJkrtecsAxgkOBtrAUrTYCP13AiIyfYCiWfObKpzjdkk
   aDwbEddFTbIe2JqtgP0DcxB4FtMLporADzAFeuBgW1Lkj1iR0/Vfcywg7
   Q==;
X-CSE-ConnectionGUID: Mlj04rVUS3aXDCaAEgxBzw==
X-CSE-MsgGUID: tdR9S1agR1iDCe8VcV5Rsg==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="210175081"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:45 -0700
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
Subject: [PATCH v2 03/10] dt-bindings: crypto: add sama7d65 in Atmel TDES
Date: Wed, 11 Jun 2025 12:47:27 -0700
Message-ID: <1fa63c0ff667c61c924f1571d9c2f03cd1fcf7b2.1749666053.git.Ryan.Wanner@microchip.com>
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

Add DT bindings for SAMA7D65 SoC Atmel TDES.

The SAMA7D65 SoC has the same capability as the SAM9x75 SoC.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
index 6a441f79efea..6f16008c4251 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
@@ -15,7 +15,9 @@ properties:
     oneOf:
       - const: atmel,at91sam9g46-tdes
       - items:
-          - const: microchip,sam9x7-tdes
+          - enum:
+              - microchip,sam9x7-tdes
+              - microchip,sama7d65-tdes
           - const: atmel,at91sam9g46-tdes
 
   reg:
-- 
2.43.0

