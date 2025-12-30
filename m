Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE6A2A1BA
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 23:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767138752; cv=none; b=Xa2F2mTLcX51UFzBK3Ni7eBpyOMWsnA4jTyHcxjDYIqubBU6v4b1/vQPzoGDIb97O1DlCkzz5w1zt+0hSGVVFKsMMDvbKPuULxXUSy0+EFtDJKbDUKNgwf45z9eZwMYBOK5fefMeA3/y1ugMBmkT00LwTlOxvZMAV3+cCGhTdPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767138752; c=relaxed/simple;
	bh=Yj+1kBT/xzBsmsLD/iNchYPF23fp+YZZBWM7ypXQ6Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mH6sFutABs3vCWB3RCGQe77f/y8tp6rANi8kQL8ZTKvklfhY04O9NUip2wctOSjwp1yiftMTb7u1aR/NrEoHhdmYt9/u9pcWG/Tpqd9dcdSPAJJOSEzTYuoIUO2meODmD/7SbKI+602Eh7WMGXCaV1PihQBsxPFMUNiJ8fqwkxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=STtIoNEE; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="STtIoNEE"
Received: (wp-smtpd smtp.wp.pl 10168 invoked from network); 31 Dec 2025 00:52:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1767138745; bh=2V/j4nTU5LxxzBYu2oXs3k3yGpEUDph8mKEMwSjdXfI=;
          h=From:To:Cc:Subject;
          b=STtIoNEEIJyHhD9sAE6oKpK0pJRyZER+ZFQdfX9fuYnz4wOtJfxmPJee5vuElr2Bd
           Zjj3cWJgnbinTCeKIuNMiDiIFfRzZODu5Ph5Q3cYGzRubGODiJSnD9TZTbpv1KgSZl
           zWkdnMgC/M6l5/dhtN6W4WnMQEUYiPGVYeMgE0HfpzZq/5FqKiAVZFBS6gfkKctj/G
           KhFki+LlBIy65wuS/slfUHbAf3e9m1HgZ1qgailwqlzU94MUR/uk5cT74aFmk8EmSR
           h6dmFrwLB5A+PDfsJoWjWsdCfWQOa2YaGoBnKJoKux82A/D2kCQb4tqT7wS2xs94u/
           +YvE7FxSRaTGg==
Received: from 83.5.157.18.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.157.18])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 31 Dec 2025 00:52:25 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vschagen@icloud.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: inside-secure/eip93 - unregister only available algorithm
Date: Wed, 31 Dec 2025 00:51:57 +0100
Message-ID: <20251230235222.2113987-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 40b4068a9f09c1d9b430ab71df20e0df
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000007 [cfRB]                               

EIP93 has an options register. This register indicates which crypto
algorithms are implemented in silicon. Supported algorithms are
registered on this basis. Unregister algorithms on the same basis.
Currently, all algorithms are unregistered, even those not supported
by HW. This results in panic on platforms that don't have all options
implemented in silicon.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../crypto/inside-secure/eip93/eip93-main.c   | 107 ++++++++++--------
 1 file changed, 61 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 3cdc3308dcac..dfac2b23e2d9 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -77,11 +77,65 @@ inline void eip93_irq_clear(struct eip93_device *eip93, u32 mask)
 	__raw_writel(mask, eip93->base + EIP93_REG_INT_CLR);
 }
 
-static void eip93_unregister_algs(unsigned int i)
+static int eip93_algo_is_supported(struct eip93_alg_template *eip93_algo,
+				   u32 supported_algo_flags)
+{
+	u32 alg_flags = eip93_algo->flags;
+
+	if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
+		return 0;
+
+	if (IS_AES(alg_flags)) {
+		if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
+			return 0;
+
+		if (!IS_HMAC(alg_flags)) {
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
+				eip93_algo->alg.skcipher.max_keysize =
+					AES_KEYSIZE_128;
+
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
+				eip93_algo->alg.skcipher.max_keysize =
+					AES_KEYSIZE_192;
+
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
+				eip93_algo->alg.skcipher.max_keysize =
+					AES_KEYSIZE_256;
+
+			if (IS_RFC3686(alg_flags))
+				eip93_algo->alg.skcipher.max_keysize +=
+					CTR_RFC3686_NONCE_SIZE;
+		}
+	}
+
+	if (IS_HASH_MD5(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
+		return 0;
+
+	if (IS_HASH_SHA1(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
+		return 0;
+
+	if (IS_HASH_SHA224(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
+		return 0;
+
+	if (IS_HASH_SHA256(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
+		return 0;
+
+	return 1;
+}
+
+static void eip93_unregister_algs(u32 supported_algo_flags, unsigned int i)
 {
 	unsigned int j;
 
 	for (j = 0; j < i; j++) {
+		if (!eip93_algo_is_supported(eip93_algs[j], supported_algo_flags))
+			continue;
+
 		switch (eip93_algs[j]->type) {
 		case EIP93_ALG_TYPE_SKCIPHER:
 			crypto_unregister_skcipher(&eip93_algs[j]->alg.skcipher);
@@ -102,51 +156,9 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
 	int ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(eip93_algs); i++) {
-		u32 alg_flags = eip93_algs[i]->flags;
-
 		eip93_algs[i]->eip93 = eip93;
 
-		if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
-			continue;
-
-		if (IS_AES(alg_flags)) {
-			if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
-				continue;
-
-			if (!IS_HMAC(alg_flags)) {
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_128;
-
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_192;
-
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_256;
-
-				if (IS_RFC3686(alg_flags))
-					eip93_algs[i]->alg.skcipher.max_keysize +=
-						CTR_RFC3686_NONCE_SIZE;
-			}
-		}
-
-		if (IS_HASH_MD5(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
-			continue;
-
-		if (IS_HASH_SHA1(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
-			continue;
-
-		if (IS_HASH_SHA224(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
-			continue;
-
-		if (IS_HASH_SHA256(alg_flags) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
+		if (!eip93_algo_is_supported(eip93_algs[i], supported_algo_flags))
 			continue;
 
 		switch (eip93_algs[i]->type) {
@@ -167,7 +179,7 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
 	return 0;
 
 fail:
-	eip93_unregister_algs(i);
+	eip93_unregister_algs(supported_algo_flags, i);
 
 	return ret;
 }
@@ -469,8 +481,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 static void eip93_crypto_remove(struct platform_device *pdev)
 {
 	struct eip93_device *eip93 = platform_get_drvdata(pdev);
+	u32 algo_flags;
+
+	algo_flags = readl(eip93->base + EIP93_REG_PE_OPTION_1);
 
-	eip93_unregister_algs(ARRAY_SIZE(eip93_algs));
+	eip93_unregister_algs(algo_flags, ARRAY_SIZE(eip93_algs));
 	eip93_cleanup(eip93);
 }
 
-- 
2.47.3

