Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94E14E80DE
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787441; cv=none; b=b/dyM71NJsHN1L5bR8vGJkvmd+RFtj9bB3QBMfTz9/peXfaCxs/PGxePap7Z25l1Kopn64gZyieM6B24Q8iGDtOUZYMyepsUyujFPcJddfEYEKM6cfMuhJwr1EWGcR3Xj5/tLj5OqS8jJa+HfCIZjVvubux3YiXqDGrml1ZMjpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787441; c=relaxed/simple;
	bh=vFSTLNRrZ6eLdKlszPb1mYsHg7VDedLTdmgCk0wKe9c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nF4svAHARZrIwykEEGNVmS7kawCrbs3KfvnZzSDTKGDY93dRNrTTnRCx12K6s55XTTLjhtPsyZRrAzokOv+kEy1hIEfs4tx2KvMlejHb8mzAz4Nggg9mFMzrt3X9IiuT52yZPG7MsGN7UzF4RiWO/M7IteiO2R1+Red2YjNYuzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=HJ1ZpOx5; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="HJ1ZpOx5"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 740841A1A39;
	Mon,  7 Sep 2026 13:23:47 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 4993460383;
	Mon,  7 Sep 2026 13:23:47 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E9FBC11C7AF29;
	Mon,  7 Sep 2026 15:23:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788787426; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=BYLQVfrm2gGmdLutl+qbsE6ahiX0VvgmjHbvQAFG68E=;
	b=HJ1ZpOx5/bwOM56YaBmWZb5oA9WmWob8osydVRq3miOuYZ/ebq7AE5tJUHjI+TDfs3sm1+
	BEDDPS7dWrnaMJxc0VY74cRs0401M4l8PhsUan7EYK1xsL33nFLNndii2M+XDRYjhsJ3LE
	SWYFZqaLOpiz4zfT8FmDLXyyFfCZ8zGkpWe8ASvgSEzTWnclw+62RccJs7crBY9j9MALuf
	i380yK/xyzkz+0lSRPYw7nsvzlT/Uk0Sm9oqAva8Ok2b+fl8fW4VGaJdamSguponFlGZLE
	hnseZHhJyBIbY6QvJqzAWZHxu68KkSOAE4wDO2gS1XhW8rkzXyDhwcXv7qo5DA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 07 Sep 2026 15:22:50 +0200
Subject: [PATCH v5 16/19] crypto: talitos - Introduce is_sec1() helper with
 static key support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-7-1-rc1_talitos_cleanup-v5-16-860f43cd7317@bootlin.com>
References: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
In-Reply-To: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788787387; l=2752;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=vFSTLNRrZ6eLdKlszPb1mYsHg7VDedLTdmgCk0wKe9c=;
 b=ZDfQinRIoEGdzPt+hCwBkClk+y+TVMlW3M8Cvfp4TC8i2JBaasezm4sJEqV1MAyWgjsrFlKey
 nQp25ceq/tZBWX2bw3x3bcOwkemxQCHcrYeVijLYAirq0bBo2LGPw9J
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

In preparation for per-SEC-version code paths, introduce an is_sec1()
inline helper that abstracts the SEC version check behind a static key.
The goal is to remove all bool is_sec1 parameters from the call chain via
the is_sec1() helper.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 10 +++++++++-
 drivers/crypto/talitos/talitos.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index ff938cc4e837..c93e3b551f6d 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -1196,8 +1196,12 @@ static int talitos_probe(struct platform_device *ofdev)
 				  TALITOS_FTR_SHA224_HWINIT |
 				  TALITOS_FTR_HMAC_OK;
 
-	if (of_device_is_compatible(np, "fsl,sec1.0"))
+	if (of_device_is_compatible(np, "fsl,sec1.0")) {
 		priv->features |= TALITOS_FTR_SEC1;
+		talitos_init_branch(true);
+	} else {
+		talitos_init_branch(false);
+	}
 
 	if (of_device_is_compatible(np, "fsl,sec1.2")) {
 		priv->reg_deu = priv->reg + TALITOS12_DEU;
@@ -1317,6 +1321,10 @@ static int talitos_probe(struct platform_device *ofdev)
 	return err;
 }
 
+#if defined(CONFIG_CRYPTO_DEV_TALITOS1) && defined(CONFIG_CRYPTO_DEV_TALITOS2)
+DEFINE_STATIC_KEY_FALSE(talitos_is_sec1);
+#endif
+
 static const struct of_device_id talitos_match[] = {
 #ifdef CONFIG_CRYPTO_DEV_TALITOS1
 	{
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index c2fc71282c0b..5927dfe84770 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -14,6 +14,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
+#include <linux/jump_label.h>
 #include <linux/scatterlist.h>
 #include <linux/types.h>
 
@@ -224,6 +225,33 @@ struct talitos_crypto_alg {
 #define TALITOS_FTR_HMAC_OK 0x00000008
 #define TALITOS_FTR_SEC1 0x00000010
 
+#if defined(CONFIG_CRYPTO_DEV_TALITOS1) && defined(CONFIG_CRYPTO_DEV_TALITOS2)
+DECLARE_STATIC_KEY_FALSE(talitos_is_sec1);
+
+static __always_inline bool is_sec1(void)
+{
+	return static_branch_unlikely(&talitos_is_sec1);
+}
+
+static inline void talitos_init_branch(bool sec1)
+{
+	if (sec1)
+		static_branch_enable(&talitos_is_sec1);
+}
+
+#else
+
+static __always_inline bool is_sec1(void)
+{
+	return IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1);
+}
+
+static inline void talitos_init_branch(bool sec1)
+{
+}
+
+#endif
+
 /*
  * If both CONFIG_CRYPTO_DEV_TALITOS1 and CONFIG_CRYPTO_DEV_TALITOS2 are
  * defined, we check the features which are set according to the device tree.

-- 
2.55.0

