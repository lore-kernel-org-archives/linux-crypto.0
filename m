Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C9923EA9B
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 13:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768137945; cv=none; b=rb9Hv8V9HlLEoBXHM3UQ0Ub4THoUOAEKflCzKVaE3THLbjT1t4PuWJvuDxxn7EdKkBMu2NSXAvz7AIt3321Ek0FcGo3vas2Xn7w9GDt+d6DvZ+63PC07dPhzRUDdRGmmfc/ZcKYvb1Lwrk2m2UXWzbEJlZ463IryZC8yRTAUxjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768137945; c=relaxed/simple;
	bh=8UisnmU3szOPcO94JTzaz43rBan75wc6RjsMUcLfwWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eKerpgVZrIiQDHljvP2WlzaL+cwE7ERVggUjUKBaPatbJcEFrYLmcHlZoaa1tJqN6j/MSL7xibN4QPh0Z3ADgSrBlrGGr35fDjIcGZyfbPcrlvw8LsFfKAiH0Pu5GEHkMAX36z/icfmaFPDr3N6y5gfceSAvXmBDbk8cs1JyvJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=y8l2u9O3; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="y8l2u9O3"
Received: (wp-smtpd smtp.wp.pl 19124 invoked from network); 11 Jan 2026 14:25:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1768137933; bh=mVcBbUWl9OtqlXJjNpuS18Ua67+5RsTr5xtOGD1mq1w=;
          h=From:To:Cc:Subject;
          b=y8l2u9O3c6IbEbRZDZt7T69WbmriY/m7TWCMYXDoO7C2vn4W80YtIDCMhW98fm4sV
           aswjrISxCLEr/+ff6PG41JY9tsSL+B9iyBd+oFPw+Di5b0snzWlji59NV+4Tg86rCT
           jtOhQVZcEjrICZvPs00teDfYepqVPrbLtsLFWUfczLDHXR6I3rmdDqVRUYffcE3SQs
           CsKw/7uybvMxT8ZHy8Neiip4oHVxOTUncFncd2mLXcabsFqT+ls4SJB4q/LTC8TL+o
           hAiX1koKYjTZejN7uyH3+JSN5gy8UfF//Z30+yoOER4ht2kY7ltYqSvxF5E7mtZpah
           yQns+uqwsn2+Q==
Received: from 83.5.241.112.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.241.112])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 11 Jan 2026 14:25:33 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	maxim.anisimov.ua@gmail.com,
	amadeus@jmu.edu.cn,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vschagen@icloud.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: inside-secure/eip93 - unregister only available algorithm
Date: Sun, 11 Jan 2026 14:20:32 +0100
Message-ID: <20260111132531.2232417-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 5e304fd16fd99187a363d4060307d357
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000007 [gRSF]                               

EIP93 has an options register. This register indicates which crypto
algorithms are implemented in silicon. Supported algorithms are
registered on this basis. Unregister algorithms on the same basis.
Currently, all algorithms are unregistered, even those not supported
by HW. This results in panic on platforms that don't have all options
implemented in silicon.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
v2:
- keep the keysize assignment in eip93_register_algs
---
 .../crypto/inside-secure/eip93/eip93-main.c   | 92 +++++++++++--------
 1 file changed, 53 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 3cdc3308dcac..b7fd9795062d 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -77,11 +77,44 @@ inline void eip93_irq_clear(struct eip93_device *eip93, u32 mask)
 	__raw_writel(mask, eip93->base + EIP93_REG_INT_CLR);
 }
 
-static void eip93_unregister_algs(unsigned int i)
+static int eip93_algo_is_supported(u32 alg_flags, u32 supported_algo_flags)
+{
+	if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
+		return 0;
+
+	if (IS_AES(alg_flags) &&
+	    !(supported_algo_flags & EIP93_PE_OPTION_AES))
+		return 0;
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
+		if (!eip93_algo_is_supported(eip93_algs[j]->flags,
+					     supported_algo_flags))
+			continue;
+
 		switch (eip93_algs[j]->type) {
 		case EIP93_ALG_TYPE_SKCIPHER:
 			crypto_unregister_skcipher(&eip93_algs[j]->alg.skcipher);
@@ -106,49 +139,27 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
 
 		eip93_algs[i]->eip93 = eip93;
 
-		if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
-		    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
+		if (!eip93_algo_is_supported(alg_flags, supported_algo_flags))
 			continue;
 
-		if (IS_AES(alg_flags)) {
-			if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
-				continue;
+		if (IS_AES(alg_flags) && !IS_HMAC(alg_flags)) {
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
+				eip93_algs[i]->alg.skcipher.max_keysize =
+					AES_KEYSIZE_128;
 
-			if (!IS_HMAC(alg_flags)) {
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_128;
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
+				eip93_algs[i]->alg.skcipher.max_keysize =
+					AES_KEYSIZE_192;
 
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_192;
+			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
+				eip93_algs[i]->alg.skcipher.max_keysize =
+					AES_KEYSIZE_256;
 
-				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
-					eip93_algs[i]->alg.skcipher.max_keysize =
-						AES_KEYSIZE_256;
-
-				if (IS_RFC3686(alg_flags))
-					eip93_algs[i]->alg.skcipher.max_keysize +=
-						CTR_RFC3686_NONCE_SIZE;
-			}
+			if (IS_RFC3686(alg_flags))
+				eip93_algs[i]->alg.skcipher.max_keysize +=
+					CTR_RFC3686_NONCE_SIZE;
 		}
 
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
-			continue;
-
 		switch (eip93_algs[i]->type) {
 		case EIP93_ALG_TYPE_SKCIPHER:
 			ret = crypto_register_skcipher(&eip93_algs[i]->alg.skcipher);
@@ -167,7 +178,7 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
 	return 0;
 
 fail:
-	eip93_unregister_algs(i);
+	eip93_unregister_algs(supported_algo_flags, i);
 
 	return ret;
 }
@@ -469,8 +480,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
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

