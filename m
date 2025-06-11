Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502CA29B213;
	Wed, 11 Jun 2025 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671318; cv=none; b=U7un6vIdYgw6G7yFijd6M+f5j5/YXyPVbLyVU7Z2vyrBfsu7t7e3xybdo+1sipsEL1L3IexdN3oEkxys/ImFh7QVw8B2vva31HmEvbLQpYvAbf6bkwgEA8O5zvSslVX96Uoi2OxMu8Cm3Fqwu+a1LLCB6cbRU4duncwT+zHRoL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671318; c=relaxed/simple;
	bh=0IogV/WYEoJgdGYIarAuHouch0dnxthSZymoHBE3dXo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dfr5cv1rmbQMmBQOs2IEd6YPiiP+E+ZGt99uAR1uml1L9BeEUgZyyOOWFUU3ENKonjyIfwDV+ON1mJJUPiH/JN1pOib4egofuNgvayd/1LvjEGqfSFdh4hXlHiGucFKCCVRuhWYaoW5CaGMGHdtq7Y5LRnkZj5BgKLyW3nAYIl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=t2u+pK0C; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="t2u+pK0C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671317; x=1781207317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0IogV/WYEoJgdGYIarAuHouch0dnxthSZymoHBE3dXo=;
  b=t2u+pK0CwDcybMGCHeCVPA/NLlCRq4NYx1yLEa8zua7OujMZXJpEHQpK
   VlhXs98WQj9LnpN9TgFJp+4ijVa6lSriqH+zZiuCHiu8qa4Usg/0kQzD2
   k2COdkUjKKwBO6hnFkp8rIa/hhg/dGtgIt1ZmYtpvqAQ9vIeIf0pwAn8z
   axVjaoxqK9/veLFAdMfNlEAV9xgzh50krNEvFkKj0sR85Z3qMpxDpzyYX
   wQhTbZFp1ZUvcCOkB+frR72pXFPjQxFyX+nSd8TZTbRsaGUmVy2Fi9MWb
   dZ+Hk2Td9HZ+n9rwnxgyxbND8gPZ5vQQH97MgRwKFi4UFVBZCFZ2fWQxt
   Q==;
X-CSE-ConnectionGUID: VqjTqfGTSymHXSpb+r0c0A==
X-CSE-MsgGUID: AHBRzxCASWuSQB5jtvbCVg==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="42226222"
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
Subject: [PATCH v2 01/10] dt-bindings: crypto: add sama7d65 in Atmel AES
Date: Wed, 11 Jun 2025 12:47:25 -0700
Message-ID: <7aa1862f790ea19bf7bb55e07ec4b9295c5f7a44.1749666053.git.Ryan.Wanner@microchip.com>
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

Add DT bindings for SAMA7D65 SoC in atmel AES.

The SAMA7D65 similar to the SAM9x75 SoC supports HMAC, dual buffer, and
GCM. And similar all 3 it supports CBC, CFB, CTR, ECB, and XTS.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 .../devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml     | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
index 7dc0748444fd..19010f90198a 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
@@ -15,7 +15,9 @@ properties:
     oneOf:
       - const: atmel,at91sam9g46-aes
       - items:
-          - const: microchip,sam9x7-aes
+          - enum:
+              - microchip,sam9x7-aes
+              - microchip,sama7d65-aes
           - const: atmel,at91sam9g46-aes
 
   reg:
-- 
2.43.0

