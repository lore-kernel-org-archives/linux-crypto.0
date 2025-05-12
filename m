Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A048298CAB;
	Mon, 12 May 2025 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078190; cv=none; b=XGAaQfAvgvBX5qIaj2uCmQ7K+eK/fsusNvdgc0GfyNj0DLVxwDUrOrwFsgTIiAGsqLZD1wWheROGh9tFUqBmHsZCH9RRO5heruMxs6NfPnNh1bE4gWQEeID5W2pnjDanbK6Rq75uD0eY2+d6jVy9fL90rYepCyAUxn1BD9rUSrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078190; c=relaxed/simple;
	bh=Z6V7mSq7GXzEixyZ5bJFvSwoZa1KZkqKDSMRxyrkX9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMej6iwNIpkQwiFWt5YM7pXTH4IV4i8nGlmBxfBCNx9xIFbj4f61/IG1YAdObXG6COSouIvsfurLfVTFeW8nZN6crXA3zL49ZcOBXEccutCfb8vVctOupYa3RtsCjLF/H2SMfRQeCFIuEqdzUqDl1z28HHKfnHkOlabPY5mkjmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=zo6cfCWF; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="zo6cfCWF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078188; x=1778614188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z6V7mSq7GXzEixyZ5bJFvSwoZa1KZkqKDSMRxyrkX9g=;
  b=zo6cfCWFR7mycV8x2O4QhOvFCGZlqfOndyKGqDf6/MpACJfWRSlgqTbl
   5Kr19I/dilpJLoJcF6XoGVeNO9klNQ84KAk2AmubRv3wftgDQaS6MawYB
   IKGTotilajtcIXpZHaiDe6cEJof0bIOu/3zs4rL+OEK9v04vfrQ/Bbr2u
   zfaZWbc8boqpgF/KAmqPKZRxPFNHBSBgG2g5MXkGPltCb28e+xq3xhu2Q
   dkD24un5f2CWpb6s1RBSj08e9dxx/tqRAuf/l683AU+l4K9c84bOD1kTm
   5xaJaJiWAO74ScmtB+St9Wn+9SL+CWQ3b+oGPCvsYzgiwtczC6q4fQf43
   Q==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: ubj1cdGBQbusmFztRimBgA==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006611"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2025 12:29:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 12 May 2025 12:28:57 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Mon, 12 May 2025 12:28:57 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH 5/9] crypto: atmel - add support for AES and SHA IPs available on sama7d65 SoC
Date: Mon, 12 May 2025 12:27:31 -0700
Message-ID: <9535f6957dcfcab2172f4d468450dc44cf485d02.1747077616.git.Ryan.Wanner@microchip.com>
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

