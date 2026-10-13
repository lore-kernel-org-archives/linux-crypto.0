Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E9A503BDF
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897139; cv=none; b=EbY6Ai6YGSGA39jOwFC42QK0y4hpBg3oIU134uKGO0XjSGKk8MRam2+eGqUe9n3fFx8ls38gsTtAydNI4N74BWuccW4rE2Ww7WBvh6+wsceYCwZG4LF2K1mUoR6P5ZWoAV3WP0DpOTlmgJ8WlbvnUF19TapSR3WXygI5DIkFUcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897139; c=relaxed/simple;
	bh=U6IcePdthCGZiad3lXSLFaN3vxoXD05wVK+ZJ+U5+zI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EZ1Mx5Fm+1CKade0SF+V3AvQ0wb1/FP9y899nwA/ZlktgpT4IYmRYwQ77SvltPMMi6DpZG5BqDjnUQWH71QsFwv5fSqTDLNQ4X3SsvhtftC2lS0VKvTn8EYk+xFlsgAoCVz7PSBfjU6NYQhQjk+gMLndZIzs/nqdOceoDC86lLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=TSXE35DK; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="TSXE35DK"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 70CE34E411FB;
	Tue, 13 Oct 2026 13:12:16 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3FD8F60362;
	Tue, 13 Oct 2026 13:12:16 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5C96011D71253;
	Tue, 13 Oct 2026 15:12:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897135; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=bz29orfNA7C8pW4YJSE6YqNm1XeS4qPm2yekmF+Eb8M=;
	b=TSXE35DKBQWfcnwSoqKyl9t/E3xJOdNjRCWOFmQ44wUgJmsoCAziKbuZ8R2ubWvmR0VVem
	6AEYuuK2L9/g2TXBzJhlaylSSwthjYi7XWbSeb2UOH8wRdWAEetV85DbfTIQshjMqcKXpj
	R+fpFeo2jeWAZR1u0FeoFt7p0YikzHTpUH8gMYOe3KQlFVJofN41GaMhyxWc7tGkEjFgF6
	q86P35GtjnoWtkMuvXkaRSiuXOedlQ1sDwESaL0ob36/bwlLISMnucxMCTuR29J83mLwCo
	WEODMDh09+ejfhhWjBjjgb/8eSfsfNdQK9RfqmLxFz0+MhVnY9ft50P94hEF1g==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:29 +0200
Subject: [PATCH v8 03/20] crypto: talitos - Add missing includes to driver
 header file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-3-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=895;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=U6IcePdthCGZiad3lXSLFaN3vxoXD05wVK+ZJ+U5+zI=;
 b=rkdYxaVAzuDB9lae0rKuiPo6KI5fDBDiGMU41GbRr5HGC5YZ1lPJ/z/2oUXuUrERCYnVs3zOU
 G0YR07/LEZfDUWnSRMAHkw8OTO4MQE4wPSQGRLw/RxijDtWYaFqnF7W
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
2.56.0

