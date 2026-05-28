Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA2E3A718D
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959369; cv=none; b=FgrbLws3heO1dW98ax64nz2AqC7JUZ3xuC/F3Dz4P7mZpgOStsumPwv53eyjIE27L8Kw64olmn+r5gTLJV+DLD6C4k8/zBw4xaV2oc71QJDkmI1a+kLzALb8yAOMS4SY8W9tC6t4rFB3GMhfWyXQnZc1qgiakk1jTJz17g51ybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959369; c=relaxed/simple;
	bh=72MPFqbB4vxLjGV2gDXUUwFThJMyUooH3sc4YYxRMtg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cQW7a7prXRanGml+NeAT0xxTvMLeqtRl9gGnr0Ig2CUDH/QcQhZxX/zqPCpBs3fYiqgJZ9bto45BAaGFCWa+t37Ygv01PhA09fyaCnNSa3WLz6M1sbCnfsGbqFn6w3zyJqJ99KERHJNSJYAl2Gx2/2UjLDyj91NAXa16aXnDfqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ieQIid/E; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ieQIid/E"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 891BD1A3701;
	Thu, 28 May 2026 09:09:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5EA6960495;
	Thu, 28 May 2026 09:09:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A515D10888508;
	Thu, 28 May 2026 11:09:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959361; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=+fbd49VQbiv6xrXLwhNaPzxvtEck45Nwq5EsZcqp56A=;
	b=ieQIid/EmKM5f38V7LVlhelmaDxC24I/2ix1iXivD4xcFTtzaUC2B2mKQ4QooB984BAV9U
	6831DaOprMtW9Wg4Hk7ZsJHC5kcGtBMZE1+SUUrDmFKdWMwsWsx24kKLpX+0TsTRmyFZ89
	sw7yKq04grzwVLC2loLnyQVwDK44wl1d8Gw6UZ83lX92fPj6cp5TI1fF8mjeO21Gjw4FTO
	4hd3ifAfgBEXvMLsbe8sA/ok5Y512e+xEw46X/Jf03f5uC8yJz5VvAzVgetfwD4dje/AGf
	Ksx2QWBgMA55PjjEPsE1wS3yQt6SLKM9rqJ8ckTuR3QqWi7TSR0/flgKlduyyA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:16 +0200
Subject: [PATCH 03/29] crypto: talitos - Add missing includes to driver
 header file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-3-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=1415;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=72MPFqbB4vxLjGV2gDXUUwFThJMyUooH3sc4YYxRMtg=;
 b=LVJFk9q4RDbWM9Wh4ADC/N7So8tA3P8q2KS+fWaavmwbmrcuuZDvSciFRNL+EW7zNVi0UR4FO
 QZfgjdKURYADXSJG1YdzXlE4OMzWK/0cDpmY9pjKwUfRtU7YLnYeg5X
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
index 3610d9f6d5ea..8ca587b98d92 100644
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

