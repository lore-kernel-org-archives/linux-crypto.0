Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DBB39D6F2
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642406; cv=none; b=knKgOSn6wJ1ADu7RFXsx8oZ9iU4t98m/Iwekc8hCiARwxT0z7EVwsKVSB0sii3r1LiV6urKhEGuA0bhoFbbPguW3FjDKr/S9sRX4xkLzty+NnNYWV/8Ogleial8dsZvsUvxcZFNJnGgr8kqsyv3GSRRjJyu04C3IH4VHzL+5DHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642406; c=relaxed/simple;
	bh=sD5NmdmsXmzVoSiMz6gOTQdaBlya6OoP+fmUbgnCDPs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aEAnw19yMjeu3FR05sAW0d0TjX6B21TXCFQtcaytc0ytpmGzG4IdqrTvKVRrsGP0lvw04Bj6RAQ2En+UcLr8at6woCX3uke5qwTZyVgGJLOTcC6Td1sA3ehPBO2iKRuG+KH8PxQYDPjj4nGkmeIsp63gNQtefqWMcxyy5my+33g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=DJOIaXvA; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="DJOIaXvA"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 138FC1A113D;
	Tue, 21 Jul 2026 14:00:03 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id CD4CE60373;
	Tue, 21 Jul 2026 14:00:02 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5A8E011BD3B76;
	Tue, 21 Jul 2026 16:00:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642402; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=IJzkhZHadDbXIMbPJMOXNyPk9VmgtEsFGR9aeClYE80=;
	b=DJOIaXvA1II77rzBm/ySBoVdAkvSlIAAXC6iLT8zDkqsEwjezZuAt0u+cN0zu229RFkwgg
	NdhAPyr7p3LTPg3ngPmSiN99DVKXnmSCS3o06As2KiSAQyprW42XiIRcV6zpran3a7iozF
	KdGtWTIScIKWasB8VbPV1kz/meS/lLxeIMjv22wxWmFJKpsoXAEDV2R2dPv5xxtW4QfgjV
	o9EsSX6jP8kMNQNOs9C2OArt2oOmdYAEL62SUmknhPm6PI1QX3McZ0uao7LkWjdXO8zQbC
	+Ok/LUUGLZw7HqvePFQKwgjd2fdK3ZyBwcmqPzJGpBiViCmiPLCOCyDO6WLV8Q==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:43 +0200
Subject: [PATCH v3 16/19] crypto: talitos - Introduce is_sec1() helper with
 static key support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-16-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=2752;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=sD5NmdmsXmzVoSiMz6gOTQdaBlya6OoP+fmUbgnCDPs=;
 b=9sj5iu1a82mP/r4i+y8kxZQaMaQ0atL3VVZKzq4h0lfQI1mbHrKwB6YffjIfjEITMYgTnKMmF
 RrBJQzTx4hhCgQPpZanE+TZiN/DPMnvdTtQDAI/SrM379cP27KEi+5K
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
index 3cbce0be705d..b0d176c7dab2 100644
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

