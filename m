Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43699370AE9
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784641258; cv=none; b=K6FJSw732F5tUgUdnf9E1iQ5RRuP6bYwqSdcWrbDi0nOomYrk1y2tuJWazcFrHstm4V0BqsBkT+zv3+dmxAJ1z9GEbTp1k/viSw/HCZIsDEOeSwP2VRMu5ghRTjzyYmk6tstGLH/jXfg1Cnf7l2PyJj/7yOXwbb2EhWVC8WAgU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784641258; c=relaxed/simple;
	bh=VvWmItoUQiGewUC2IELznrd9XVVzduHJxyDnp+f+yvA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KnqXQDpmhOM/j7oNtr+vIr6JJxthWgnYiSrE3+yz8t91xXfUwvR7DfhncwTC2zk/qEl6frI9QWD4kv93keIQiBVnaxujWLx2oB4Kp53jbOYl4dCnc8WIfq/FoqRKeSPIn9DaGPKaUgyR3rZyTkaUtSzOqFDyqGkJGJ/GjWK6q3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=0g/ZMHQV; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="0g/ZMHQV"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 910EE4E40EA3;
	Tue, 21 Jul 2026 13:40:54 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5A26E60373;
	Tue, 21 Jul 2026 13:40:54 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C2E0911BD0D07;
	Tue, 21 Jul 2026 15:40:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784641253; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Pe9Emy5v5mPIfmU1/Rd8sQfQzmZN0jQSVhfcNdPKtIE=;
	b=0g/ZMHQV9RX1aG1U0KOEJ6T8o7Q5ezJOSL/Kz9J9M3IKvjm32G1Oc0YvuZIqP+hRwzhypK
	rFVLRnGdUMN666EcQAbz6MYiKrOieg2kRav9f7pnxoXzEzG4v99SuACjVGMJb4hbbwAybm
	sA0k0L9nEQNV/pbasPlMXsPfUB0HXRLs0QOAzMGiHx35jZi1Mmm4ThXzJzLqu5bVz7bGYR
	p1R7tVF0MrGXHkHx+CE/Var+UShdH6PrQmo7jRqrKZXLfmFnkwrPTY/BgOBn2BP42QbFIo
	vVG+fz7RTM4lalEI+2dfFg9mmOCCN2Zejx/fh4mvSdU0IJxCXyMer++TdtdXKQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:40:13 +0200
Subject: [PATCH v3 03/19] crypto: talitos - Add missing includes to driver
 header file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-3-6e94359bf72d@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-6e94359bf72d@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784641243; l=1415;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=VvWmItoUQiGewUC2IELznrd9XVVzduHJxyDnp+f+yvA=;
 b=Sp8DgvsqDzppdf1JBMdWfSoUevoe19R/qEvXm+AF1n3wLLYh263O/cRVyZZ7RbAERGAr7NBCe
 JDOjJnTLCPsD5YI1uHqVjppAbw0eHhf/7NHpmaJq8mARgONKZ1SZrw2
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
index 99853faf20e8..753481d3189a 100644
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

