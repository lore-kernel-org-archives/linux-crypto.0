Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DBA288CA2;
	Wed, 11 Jun 2025 19:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671330; cv=none; b=SwDkE2Nt32twR+yeTXxfAKPBKdLIrBsksouLVMhnzSI4IuYzx5hh+8t+RAnHCiBIf+vt6ngwHkqFdVfScaePWYVoWbsM6zx9Pg82O5KEgHeYO9IUGHmlRdtVMu82xroZnrJdNlaIjVApwjGZ4mBL/AaEi+DSVIr+okydhoxaKrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671330; c=relaxed/simple;
	bh=Z6V7mSq7GXzEixyZ5bJFvSwoZa1KZkqKDSMRxyrkX9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RcJN/GzR+TEBsl5DAzxXVjkpWz1W1lvQnKavhXEMYC5cLSmI7irWEKTbkXwBLzLw5lqjwyJnY7d/ncQywRJSBq2yTJnR73p9lZM+voJGAVJVnBKDCvTkruHVyex+JYAMzXBBAo2DdJLyWZA6ugv9OHZmCIgsUAWl9Jy/JVmwgqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=Y/dTTSw1; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Y/dTTSw1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671328; x=1781207328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z6V7mSq7GXzEixyZ5bJFvSwoZa1KZkqKDSMRxyrkX9g=;
  b=Y/dTTSw1YPeiKmqouLZqQN6hWHYfeXvmYI8PGZgXb12Y80OxdzO4eBIa
   RMPC+WVEYPyVOPs0ESUTJ/ulCoGkJNVqdrkVL2okeU2nZDwiLbYCwTfGO
   43Bn2ctP6Ex2uHAATxfiB+AUw0OiNeIVi71edRjij3Qnf9Dv7rob784nZ
   qnW/845kKOOaupH8D36caGj/ELyXjOr2WEUULnYneu6giFJmClQVMqouY
   GxZK1Ek/a26SC3ijLVY3I5E4O+IHSuRrtYwQ/f/VIaY7yob08382IQEzn
   Q6Sqjs/9pKWtBFpXzykKKdZLtODBy9gT0HAYQsbw33JsSIUxq7HU/Z+ZM
   w==;
X-CSE-ConnectionGUID: Mlj04rVUS3aXDCaAEgxBzw==
X-CSE-MsgGUID: dVq9KnpeREi65SXQ+s1x9A==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="210175091"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 11 Jun 2025 12:48:17 -0700
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
Subject: [PATCH v2 05/10] crypto: atmel - add support for AES and SHA IPs available on sama7d65 SoC
Date: Wed, 11 Jun 2025 12:47:29 -0700
Message-ID: <b2bc8b978221a2b4e76012a3f3b11e4ad15fcf79.1749666053.git.Ryan.Wanner@microchip.com>
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

This patch adds support for hardware version of AES and SHA IPs
available on SAMA7D65 SoC.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 drivers/crypto/atmel-aes.c | 1 +
 drivers/crypto/atmel-sha.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 14bf86957d31..4a3db3dca272 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2296,6 +2296,7 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
+	case 0x800:
 	case 0x700:
 	case 0x600:
 	case 0x500:
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 67a170608566..f7021925349e 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2532,6 +2532,7 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
+	case 0x800:
 	case 0x700:
 	case 0x600:
 	case 0x510:
-- 
2.43.0

