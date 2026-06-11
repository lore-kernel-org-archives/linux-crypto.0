Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0132D367F3A
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163418; cv=none; b=TDotkHV89eL8HebBYXS3vajGjmg2b36tBbipcZxE+uYLHsSUoI8DgRWVi1wbH4XQO6X399eq+DJc4iz87cVz7As1JbotQptCWi4kVJenlLYsRjwoyey22trshy3H4yvylFY+MdCVmWesakmVHEne6rmSVUgf32LUwB4tWNEqVW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163418; c=relaxed/simple;
	bh=ZhwkxMNrbLlRGOKH79ICGkEWHub2AqZM6xi8x+7MMLo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YJmYYI17nfWhiRgbclabi28HAWSOaT0xfwZ+ZeIQLD+sTTHIs4OuliirAoSqzXs6IXKTB1VMcv7M7g1ws+wjGBFo+mJdujCsVuglbtDJZoYutevCP9JuDTtVAOqi5K4T+Z5pLtUgP0UYEC7aEX9Xn8fDweVZVfT8Oz18OxoE+44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=C97H820/; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="C97H820/"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id C84D01A38A1;
	Thu, 11 Jun 2026 07:36:46 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 95C0B5FF03;
	Thu, 11 Jun 2026 07:36:46 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 420E8106B9E52;
	Thu, 11 Jun 2026 09:36:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163405; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=pLer9r9C/w4e5tX9P7DiI5ZjR9vsAoGaJ188GmfbwEQ=;
	b=C97H820/jxH/vQc+MSDI5b3XZ4A8fpynF2s04fAcXduU2FuqFL/VMOovCaHAZapwlNxE7d
	Bs3/LUvYb8m5sN7PMTwU0j5K6dS74F0FRZLoly/jXfqHNVnmqb6O+ai90+BmoQCI5gA6tk
	DUpM3xYevJk84C77Ew+yZdduTsrR9GihXMUCwLE5R4LWRhE9adCjp3LStS1T+ZnFIyNTvN
	qwTKlZalAPgRh3g0KVgK30w9G7w+NB++5N0BmuT9B8uoPwwTeWuxQib5feFEBxLVgyV3PR
	uwOqkGR3qLw2JVGn1+5bF1qYcovBwF6d7vycaJSqAFgGanlIcfUsfMwBOGXBWw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 11 Jun 2026 09:35:57 +0200
Subject: [PATCH v2 03/19] crypto: talitos - Add missing includes to driver
 header file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-3-aa4a813ce69b@bootlin.com>
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
In-Reply-To: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=1415;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=ZhwkxMNrbLlRGOKH79ICGkEWHub2AqZM6xi8x+7MMLo=;
 b=S8LsvFYcvSVZLt3UA0h8KvaKFkqCufMScIBNwNxnZh4JiL1526MkWntuP+42ZegeyTUYtauKo
 sEtFmeoPhfkAWnWm4h3tZb0Ov6XOmYjPLxh7lN306fWEMa1e7VBERdi
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Add explicit includes for types used by the header file to make
it self-contained and fix implicit include dependencies.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 3 ---
 drivers/crypto/talitos/talitos.h | 6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 12fb61ee8066..58663edd4ad4 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -15,10 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
-#include <linux/device.h>
-#include <linux/interrupt.h>
 #include <linux/crypto.h>
-#include <linux/hw_random.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index d4ff8d589f46..56e36a65ddcc 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -5,6 +5,12 @@
  * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
  */
 
+#include <linux/device.h>
+#include <linux/hw_random.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/types.h>
+
 #define TALITOS_TIMEOUT 100000
 #define TALITOS1_MAX_DATA_LEN 32768
 #define TALITOS2_MAX_DATA_LEN 65535

-- 
2.54.0

