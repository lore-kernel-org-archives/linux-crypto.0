Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692DB360EF7
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138043; cv=none; b=NY+6raU1l2Y3JUt8dA328jbZecGICk45ACk9xb20f/GFA5FjGYrvdKxBi9r4Mc8rsB8uZrJmDp6/sg8Cys5r2OyW1Q3BQosqLMRlN8Mji/VUcbtq54roHtriS+t7AC3M/HVeYCFeD/qZlmRRq+54M5TDuyg9ldfwhC6cVyYOuzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138043; c=relaxed/simple;
	bh=g7nzFkqbUuQylgPSSwpsCxIR9V3zNvMz072ZBgxP4hA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BSefA35FOaRD7Ggbegc8Oechd4dVbWJhZoO5FAVNzSe5Snf4uM5nvlCr+U9bXwBKBakRJrqDSoil1F6Usziucb2Bl/ceuaxe/S6FHIUYBT9wYL0fVcUAMsU5MdSBavKV5w6XLcEiGZRJRiAaAbm4tvtmN3yovJ6mvocfoZVmInI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=MwfaG+gd; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="MwfaG+gd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 861551A01F2;
	Fri, 11 Sep 2026 14:47:19 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5B364601DE;
	Fri, 11 Sep 2026 14:47:19 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2635311C7AFA9;
	Fri, 11 Sep 2026 16:47:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138038; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Ohbu6+DJKRUK4B2j2zUWdHaU347gQh155kgQ+RKBPHA=;
	b=MwfaG+gd9VAU1GBzea+CnASUzX1RfOVLqk5tNetRWEJsCPi8v7QregJ5zlAIuJaOhHM1AF
	CsYuX/7FDfznpX91zDBRnKto+3NVxCkA13vaxu9uRjRuotsCxmFpVqb++omjgo2d1/cVQo
	jk+LvXRcRgq555CagwxVf8Tl8GWYtbGqzz15f2OU26Y3c1m1PCs68cDXuQ4J2cfnOY+hsW
	xhn53n6+QhRYqGSXjO/A91CSxihQ3m8LImLTMvsv39x3Kcqzyb1ftIuFIF/M6xsw5T4jB8
	mAQEz94RS2GSweftd2P1jpyG9QW6NtnOjPx0xA4BtAcwXveiVU/e0N10Rn6S3w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:20 +0200
Subject: [PATCH v6 03/19] crypto: talitos - Add missing includes to driver
 header file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-3-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=895;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=g7nzFkqbUuQylgPSSwpsCxIR9V3zNvMz072ZBgxP4hA=;
 b=HsPlzxXwnGk/64l4QUm8fJmZml17GV3uX2uHzmdNkXVT4IscuYvV6NyxGweqitnpHQNi+t2pK
 RooIQf3lBV2C+fr0HAnyjfSgZKoacXlUSp1bI7g8XWUuQZ1NeYeau3G
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Add explicit includes for types used by the header file to make
it self-contained and fix implicit include dependencies.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.h | 6 ++++++
 1 file changed, 6 insertions(+)

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

