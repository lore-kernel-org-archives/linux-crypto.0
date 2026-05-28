Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846973B443F
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959399; cv=none; b=sUVvtVtF/kR8TRnZEPiG5eoD6oOTmPoy7bGcVyHDZG8UbNXz8NSAjMHVRb84y2QLCsXgkTgAj///L6xqIAsTLAI7U2QWvlI7LHXxbjYUGByP1g7v92tY8pZY6QGB1otHQK4D5av7lJNoZAmKLMRu5QRsnM/CUdCGTyxkWVTvfxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959399; c=relaxed/simple;
	bh=RTLGPCn4Yl9FCwEWU+ZjV1xR6Pj/feI8xfccScr+XeM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ocsFWmnoKg5ylUQv9LNa2gIm+zhGr9BdFWdAQX9KDxrAIz5/gRPs5dC9PRr5iHF+hrmmH7QoGly0Fe3CEA8B4CL/hIp7p/7EMUN8UjXBf3twAnGJc+5F7cNjnlkSAU78U1P9jy+O3zNAwygfMQYokKthyWqDyM6n8z87oQ7DFIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=00SAzke+; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="00SAzke+"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 3A699C62447;
	Thu, 28 May 2026 09:09:56 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 12C0B60495;
	Thu, 28 May 2026 09:09:56 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B966210888CA7;
	Thu, 28 May 2026 11:09:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959395; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=GmBOagk7heMxPnu+nJQo7jUrc6JXEHxO6S90oTM45jQ=;
	b=00SAzke+uMOHasOjTywdtTWFtcx0NB6Qnax+I2jh210x+TkkufQMZZn+7yOVPUhaaG0bkQ
	onFjRRfxCacOYv8ncQs/uRtPv7n+KWn7XFNUbHdbsmkjfUUzmAXCoSD8ea9F4qQGqtZhRT
	+ytkZDCf48LmU/wlkNtaV0AgRyJd5NK2++bc+MllqTg+wAp9kqstPAq/YktGbMRVM1rs+o
	qOtILZ8dfLxvy4W649Vj0wWumCHopONViGq36MJZeXcwu4LP0/d1B3q5l/eI+V67xz9lRV
	jbIICJKNuhlTDS/D7yw/AVCguewe631iJKYWUbsE7TpJL1lgKGh2rLNtf+7O1g==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:41 +0200
Subject: [PATCH 28/29] crypto: talitos - Clean up includes in core driver
 file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-28-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=1573;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=RTLGPCn4Yl9FCwEWU+ZjV1xR6Pj/feI8xfccScr+XeM=;
 b=5n1IveK/PBtxDvB6d0imj2yMjdZG+DV9Fs2TWSu9i+oLDcipN1unm9/CmcuMlxmNy8VeOCdUg
 r/I5RubDLZ5Ch0BiIgtZ3bCjRsSWPI+pEehnf0gTXnnAkhW+1ABlSZ1
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Now that the crypto implementations have been moved into their own
translation units, the talitos core driver file no longer needs the
includes that were only required by the hash, skcipher, aead, and hwrng
code. Remove them, and drop duplicates already provided by talitos.h.

Also sort the remaining includes alphabetically.
---
 drivers/crypto/talitos/talitos.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index a032907e900f..43939a9cd9ce 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -12,32 +12,15 @@
  * All rights reserved.
  */
 
+#include <linux/crypto.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/mod_devicetable.h>
-#include <linux/crypto.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
-#include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
-#include <linux/io.h>
-#include <linux/spinlock.h>
-#include <linux/rtnetlink.h>
 #include <linux/slab.h>
 
-#include <crypto/algapi.h>
-#include <crypto/aes.h>
-#include <crypto/internal/des.h>
-#include <crypto/sha1.h>
-#include <crypto/sha2.h>
-#include <crypto/md5.h>
-#include <crypto/internal/aead.h>
-#include <crypto/authenc.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/hash.h>
-#include <crypto/internal/hash.h>
-#include <crypto/scatterwalk.h>
-
 #include "talitos.h"
 
 /*

-- 
2.54.0

