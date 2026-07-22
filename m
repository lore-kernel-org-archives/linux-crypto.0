Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FB548B373;
	Wed, 22 Jul 2026 08:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710474; cv=none; b=Kzzwv6vnCXkBPiB9OIz/53k5QN/gaQKm+ERVp2izMLuo8gftDxTWFKpUsVLyRjmPNkgh6ce1ITrBLUw/1lMzCnhITYFAGDuOLBn+81VloKInw/BtCb8k6rj4JcZMp/2jIWG4XZeYMkC75vgVudRWkIFpt7m4++Nb+Edp/d/HZQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710474; c=relaxed/simple;
	bh=i/s5nKX9dNlWnK//SmFvVr0MxTRg+GuCY45A7o/Z1po=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=caEkWgCxMnIU1snk/z0sJv/OomCKxhD753KJ442xEAs7ZiaOxJp+2QUK56t++k01Euy9VNGGtVeAl72Vk2EPhV9avsiU4ozHkAMJ9vtj+aJBNXuXNfDfwtbvfnaK7MxjOIMSe3Xb7RB0veuOaGRTIstM/+RXiYUtXgDH45XGILM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ibGOb7PL; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ibGOb7PL"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 9F5B54E40EC4;
	Wed, 22 Jul 2026 08:54:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 7584E60388;
	Wed, 22 Jul 2026 08:54:31 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0F6CD11BD3A44;
	Wed, 22 Jul 2026 10:54:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710470; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=mw8cFZ91q1TN3NxU/h3BCXxNS1GzZdNptOBmHQTNuvQ=;
	b=ibGOb7PLOgit81CpLMkcP4LtM4wZB5IuKmDz0YT0dXgRjsXIpks1eA9yicjIJJ9XaeJaO6
	wGBDZ61wvDhuipiJSm4LbjkTbSvVQdJxBdzVBREt92PbYFmi1oUnosNsR2XgF3kvceIYQ0
	hnT4FbK7LJbFNAgFveqgsrhyNuLRBpZtLJXe3WgKjDmTxNy896N8G0OYricASdoKeuGVjp
	TwX1zy7SmtB+odXnuLX0cBY6Ir/aChZBf/vdzIioYH9lBrjttRBRmuQCRUoQTbi9ABNMJT
	q/Uh0Qp5uLvfEWaSpGDcTkADLCBENSZj1VUgDy2hAsSmUetgGfXIdezyDHk6tA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:53:47 +0200
Subject: [PATCH v4 03/19] crypto: talitos - Add missing includes to driver
 header file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-3-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=1415;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=i/s5nKX9dNlWnK//SmFvVr0MxTRg+GuCY45A7o/Z1po=;
 b=DMuhkQ7GBoyyzF86NgnTa6Kg2/jp0jVF7z6geKvTThZQ9Mj3Cl5Dx+fxvtFRQE3+6iTWglueP
 EZzRNzSDRZvDt0y31R27q8J9C2wg2LGNudrBwlBLQt5B31s+BBkZmO3
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
index 3550321ddc6c..64b95c7c5eda 100644
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
2.55.0

