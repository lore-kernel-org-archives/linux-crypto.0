Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8EE53E30D
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176764; cv=none; b=rtMTWODiM/cbYLtw/jtta85kmCxCoUmqCgYWIn7Hwu0mpnmh1PDz3vg3tIdAJpM3bivOGJPiujtorOIQNDzVj1XaEGfU2jel7RuX8hTuQ3E6xtSzx4dUXyTqIkPKXj7M3m4pN90xBMaVEwHyAlgDNf2jC0/maNVz0VNCubxCSIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176764; c=relaxed/simple;
	bh=g7nzFkqbUuQylgPSSwpsCxIR9V3zNvMz072ZBgxP4hA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HGIwJ5J+nVecvy/Pgfj6OkdUlA3JgTxV7sX4UPrjQRtCaeugo599lFjXgraEiX4eGwT8o5TkcQHi8ir+SW0372vAWMYX3oAxrZCul5pUU1Eqv26KQjx5x8k3PjzLlw9Mb0swORZHTKaADFhayRAD/4c+tVUW9B3c7jV2Ty1G5FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wUnZxlP4; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wUnZxlP4"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 1B9B91A0FEA;
	Wed, 23 Sep 2026 15:19:21 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E3E8E60580;
	Wed, 23 Sep 2026 15:19:20 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0955E10329106;
	Wed, 23 Sep 2026 17:19:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790176759; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Ohbu6+DJKRUK4B2j2zUWdHaU347gQh155kgQ+RKBPHA=;
	b=wUnZxlP4uJo0ikEK8NhMiSA3Azt9kybQT7RLmyKOlqbk9gUNtSdBow+CApB/No+ZA95gYV
	8vs5WGB++R2ti2gwUsMQEiCzUzixS1+i69Cbhy2+kTC03TWr70xSbHldLf6+uwAEE3yi9i
	0iu7sbSVQiRgPY0zRJ9j8iqQr+P3tBwcB5VcEq/V/sbVyy7+v+Kw75Fhvxv7q77WmKP75f
	3I6v1Mt/E+IQlpJ/shD6f/5l9pPGQFzDS6msyUKDBuL1Vxy+ySv+j6fi0zuXn/BC/T7BOW
	dH6+inaMnQgmPVrvVNb4GAb1aL50dzuZmkfAsEF/2U8uagbaKkco6FB2wyGidw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 23 Sep 2026 17:18:39 +0200
Subject: [PATCH v7 03/20] crypto: talitos - Add missing includes to driver
 header file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-7-3-rc2_talitos_cleanup-v7-3-9a45261fc097@bootlin.com>
References: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
In-Reply-To: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790176746; l=895;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=g7nzFkqbUuQylgPSSwpsCxIR9V3zNvMz072ZBgxP4hA=;
 b=yCfEJ96UZPUIGpUnabBiLRpMdKds3hgF15I8OgZkY1ubGyp2MXs37O/fahqwI9SEVvOV/dz1V
 tFfUdE/IRElD6yD+gs8OFtEw7oSgplOz0LcFvuRvSFwrljC01UUGQrz
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

