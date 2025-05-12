Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CEAEAC7;
	Mon, 12 May 2025 19:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078211; cv=none; b=pWGD4X3VwiFwTwOuZE1ICsgNW98yZ7z5ltkz7XPvVOP7Y+aRY83+KphGBNuyrJDicOMB/fM7WPSVzTSP5NsaAbbAWytoFsgPJNNM2840MXSYEg1wCR5nUsjzzl/+/NxjxsHBLkEtWL2e8wp0FFVfjNjv92U+PsQoW1HCP1KQAXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078211; c=relaxed/simple;
	bh=EAq9igK9ZsRG9y+KYZS6Syh/KUFHCf2/FcNcB//qTFw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NseYPSqQtyDMpi9eM8RAm87/S0IPnnaZvdMrqlRSpGcH3Ht0UNSbWgWg+qmg4pz7/lLEfhFrO0PxaT0Cb0XNuuvE3PCnbonGWTmZYJ2G13OKQEObpbbTRXF7nA27kqK0JTinmMXMHNCZ/SoI8VZd+5U+T2UU/yIuEhvoj5Ntq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=vSrPR2KO; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="vSrPR2KO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078210; x=1778614210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EAq9igK9ZsRG9y+KYZS6Syh/KUFHCf2/FcNcB//qTFw=;
  b=vSrPR2KOSZex4Hxb/iD5+eKTFcdSj47MfYuLoE7yonDgG+Ew9BW9ETTu
   gUX6f3YKNag4rBaWd4NyqWJltP7c9PIWi9TzwJwTNXsDR54tWOqFyl7NV
   xgBOjKQk1wAD5EnDF8iKOjgxd9NMh5/sM7mnerbRKRwv5FURaTG8EumiP
   bTUlzY/R2HMXRwPUA7UIZO6vAwXMf+uKT6mW7YRSSCwnfPPVI6bDGoIrK
   CkqDMumVzsFiDkPEePWvr7YLOXtdWweo3tRAKSRFAlGJlgINFllg3fzgV
   oOPxHxHFTx4rTxfL8GYRoAkvf+Dro+Ya401+adKiQ3bLNzQaiKdpp/pVc
   w==;
X-CSE-ConnectionGUID: lnPSkm7mSRKB1sBnpug5Qw==
X-CSE-MsgGUID: z8AX82L7SnK3k23+cBcxsw==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="41049771"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2025 12:30:09 -0700
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
Subject: [PATCH 1/9] dt-bindings: crypto: add sama7d65 in Atmel AES
Date: Mon, 12 May 2025 12:27:27 -0700
Message-ID: <a5509576e211bcf528e088f78e619575a26bbd8f.1747077616.git.Ryan.Wanner@microchip.com>
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

Add DT bindings for SAMA7D65 SoC in atmel AES.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml     | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
index 7dc0748444fd..1de4ee70a05f 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
@@ -15,7 +15,9 @@ properties:
     oneOf:
       - const: atmel,at91sam9g46-aes
       - items:
-          - const: microchip,sam9x7-aes
+          - enum:
+            - microchip,sam9x7-aes
+            - microchip,sama7d65-aes
           - const: atmel,at91sam9g46-aes
 
   reg:
-- 
2.43.0

