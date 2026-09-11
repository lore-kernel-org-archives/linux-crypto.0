Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27523376A18
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138071; cv=none; b=NM3sR70tj9kId31tIB+gHjgmss6gAfj0RR11a1/Qp4OmryPCpeFFkK4WydPBXSd1xIeQ4I4alX3jis0tBWWOA+xRnDZ4ij9w56WRijPo0EFHt6YA537sIKdXeZBbg1ywO90uH1J8HOetkORpQF3iiwIEkMP+aq8WCrVmB8aAwYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138071; c=relaxed/simple;
	bh=MoLSJShYdg4TLyQKfnDd7BSx1ypBC56lEwzknDyAq0E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YJN2+KcDgtpsSD/+iQxdeoQBF2ULHnKtVzGvLxR0heeu/3cExzSHH+ODDNpk+eFP2gKWaqrHuVmKGAoU5xg5r+fWP3FEzo2oVcBwpGRTf+udD5HJHzFc6mowXU2P8DdumRGyrthr7WdVS48DWVhZzFfPJkVB+RwqJ81R5r/PFkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=2SalrjJk; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="2SalrjJk"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 6CC551A010A
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3AD1A601DE;
	Fri, 11 Sep 2026 14:47:48 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2093811C7AFA5;
	Fri, 11 Sep 2026 16:47:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138063; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=eQTwp2txeZTwedD6jV2F+eDGbk6Sf4N8OC1HP9iAerw=;
	b=2SalrjJkrO6udKkTsptWQQEkL7HLPmGZqiLYVrx5ajuJ3RuVs2Couhc0FPJhXCDlOgXsom
	pTsewlpLlaVjLhl9QWytcKTLngtng2t+D5/kfCMTmlI5KJsiy+7bVJZAPJ04SCvDjBDGJG
	CtpDuxfbN2kGwn/VNJ9ebRt8mUhnBpjy+pMqysJ3nba+xkdxQNv++VRULezVWu3P0Igozo
	9c4RnqFRv+GzBhZoEVVNuF9dGO4yrTTBjSwXdr3XMxGyiacCWO/soeYfY9yOpW3ekbb4cP
	pduHCBpCItZW7jQJURoEqm63Py6WDfhy/QCP2w6kRfRBlO9VdBTUth/CREbY2w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:33 +0200
Subject: [PATCH v6 16/19] crypto: talitos - Introduce is_sec1() helper with
 static key support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-16-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=2752;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=MoLSJShYdg4TLyQKfnDd7BSx1ypBC56lEwzknDyAq0E=;
 b=TmQvDpH/1YeFy4W3Ve4N4GwMX5yXNqToz/aaU+taS0ALFHBkDV2/o1UI3qjYWYpi6Z6blvjCI
 b2LGQ3tSXMhBGDNM5t77yNljNkSA0nfj0F54wXOhYGy+79p9znqCinI
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
index 56b57ccb48dd..fe1e1ae2eeb8 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -1194,8 +1194,12 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -1315,6 +1319,10 @@ static int talitos_probe(struct platform_device *ofdev)
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

