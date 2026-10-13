Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45782511222;
	Tue, 13 Oct 2026 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897159; cv=none; b=au1Rh2zK9sJGyrxcaX28i2LlO2ZoaPOGijNg7EzfGGGOHe1XYw70YdhFLl3osxb+7Gx7ZleXRqChW+mpocJdE/Ts82bsLxaRlEat6nyRcxDe/y77fuuruV91oGJYot8bCLSdVWMIXJ4FwwExyOhZm9N+etdfQiA0wf6ungBMU3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897159; c=relaxed/simple;
	bh=0yjh6ZEzTv1GwL/2y/Nxq/NcroUVeq8xLZKAIUXHcOs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SvQp+JJWZaxxjIQ53JcPtcJ3qPn5Zk3oW0a+uPHynZavSr3I0ellSZbMEafZoIIoU/FOG1to0KmQuSrWVO+n+oWfYfxpzBV58m5ORZiWAL5wXtXmCcho9JX8hixC8ffGLCaJ5w9RpZ2b6HRxCauqMavM03EMy0fi2P6xwxkDDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=0JmawP6r; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="0JmawP6r"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 73E4CC653F1;
	Tue, 13 Oct 2026 13:13:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E6CAD60362;
	Tue, 13 Oct 2026 13:12:35 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 46A5311D7138D;
	Tue, 13 Oct 2026 15:12:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897155; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=QDXaEH4WhIfL9N7Jxa1gmQ48H+lloY4EZXCSfij6BxE=;
	b=0JmawP6rLQzSr2JwMdKqGurR1vFQbhpCIDUeMFXzR/hP0I6tejMTyQDRtPXXXdw9gswKuE
	anOmQ9LNRVa8sJwcNP9so7TJkQruQJ84CB8++dRjfbwZuJWg5VY18E7OByuOtXekzerxDr
	KoxBt+1mvd3QuFnqPXozCmV9OBpMowR6sibm9ffaIgXi6ARuWZMOW3D8jAf+D8GyLtWBJy
	KyamwdmlqytweZKpikngj6Z1MwpOk9UTlurK88fDJOYwEtfWJ15ji+Q6AlWLiLesBRNWaf
	qdv6oNQg8kAPUbJ9CglktIUWN+Be+CoysgCL9vyPysBCil69sQZ0Rmq53hPduQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:42 +0200
Subject: [PATCH v8 16/20] crypto: talitos - Introduce is_sec1() helper with
 static key support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-16-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=2782;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=0yjh6ZEzTv1GwL/2y/Nxq/NcroUVeq8xLZKAIUXHcOs=;
 b=wUKSACpT9nnRNDmnJULssBCS6g8AloEuAWUBzGcB56fkvlp+MDWcb0o77LTGm6kKEsGQAsqYs
 s5aozYhw4d7C00zaLCHE7YpXee0XNokQULuzgAO9fW2zG2MdGlyoOpK
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

In preparation for per-SEC-version code paths, introduce an is_sec1()
inline helper that abstracts the SEC version check behind a static key.
The goal is to remove all bool is_sec1 parameters from the call chain via
the is_sec1() helper.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-core.c | 10 +++++++++-
 drivers/crypto/talitos/talitos.h      | 28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos/talitos-core.c b/drivers/crypto/talitos/talitos-core.c
index 4aba0379b4dc..aa64509ec881 100644
--- a/drivers/crypto/talitos/talitos-core.c
+++ b/drivers/crypto/talitos/talitos-core.c
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
@@ -1325,6 +1329,10 @@ static int talitos_probe(struct platform_device *ofdev)
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
2.56.0

