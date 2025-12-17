Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9512D77F5
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 20:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766002968; cv=none; b=a7AbrRks0Trwk9Gyxa+xqtLZQWhKa4dMx8yW9v6fGZk7kTb/vajHhYnLHrRwzHz1p+cE36uUA8nHF5SB0ROKvcklmqibJtgkzkeks3II9D78pJmSbOyydHJXBY9TuvhfXdJzYwDSVAkXfd0Fjn6YRlL5oNjP+v4s11bk9b0evVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766002968; c=relaxed/simple;
	bh=fc+gRyPVnC7N2lX/arCD12sYjCDK3qBF3as6Prne0gU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQXQigUa09YnWzdrXM/LyHl6WSTTlSNgjo9+KJ0T0Yc4P7m2qFGfY5GB2yQs6vlwmd9ul/UMEG65o613HwRhUYHU+nTTIs/oMJL1p6nbk84gbrjq5GUniA9Yiu5o6kxlDh1YhfjDkWRK4r30erNZmveGYPpUoox6nOt6haeKslc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from wasted (213.87.162.109) by msexch01.omp.ru (10.188.4.12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 17 Dec
 2025 23:22:33 +0300
From: Sergey Shtylyov <s.shtylyov@omp.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH 2/3] crypto: drbg - make drbg_fips_continuous_test() return bool
Date: Wed, 17 Dec 2025 23:21:44 +0300
Message-ID: <20251217202148.22887-3-s.shtylyov@omp.ru>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217202148.22887-1-s.shtylyov@omp.ru>
References: <20251217202148.22887-1-s.shtylyov@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 12/17/2025 20:04:01
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 199084 [Dec 17 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.20
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 86 0.3.86
 47cb2a3d3f5c7e795bff2d0998e8c196722872ab
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.162.109 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.162.109 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.162.109
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/17/2025 20:06:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 12/17/2025 5:16:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

Currently, drbg_fips_continuous_test() only returns 0 and -EAGAIN, so an
early return from the *do*/*while* loop in drbg_get_random_bytes() just
isn't possible. Make drbg_fips_continuous_test() return bool instead of
*int* (using true instead of 0 and false instead of -EAGAIN). This way,
we can further simplify drbg_get_random_bytes()...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 crypto/drbg.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ab7da601a87f..72d1d130dcc8 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -226,38 +226,37 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
  * @entropy buffer of seed data to be checked
  *
  * return:
- *	0 on success
- *	-EAGAIN on when the CTRNG is not yet primed
- *	< 0 on error
+ *	%true on success
+ *	%false when the CTRNG is not yet primed
  */
-static int drbg_fips_continuous_test(struct drbg_state *drbg,
-				     const unsigned char *entropy)
+static bool drbg_fips_continuous_test(struct drbg_state *drbg,
+				      const unsigned char *entropy)
 {
 	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
 
 	if (!IS_ENABLED(CONFIG_CRYPTO_FIPS))
-		return 0;
+		return true;
 
 	/* skip test if we test the overall system */
 	if (list_empty(&drbg->test_data.list))
-		return 0;
+		return true;
 	/* only perform test in FIPS mode */
 	if (!fips_enabled)
-		return 0;
+		return true;
 
 	if (!drbg->fips_primed) {
 		/* Priming of FIPS test */
 		memcpy(drbg->prev, entropy, entropylen);
 		drbg->fips_primed = true;
 		/* priming: another round is needed */
-		return -EAGAIN;
+		return false;
 	}
 	if (!memcmp(drbg->prev, entropy, entropylen))
 		panic("DRBG continuous self test failed\n");
 	memcpy(drbg->prev, entropy, entropylen);
 
 	/* the test shall pass when the two values are not equal */
-	return 0;
+	return true;
 }
 
 /******************************************************************
@@ -847,14 +846,9 @@ static inline int drbg_get_random_bytes(struct drbg_state *drbg,
 					unsigned char *entropy,
 					unsigned int entropylen)
 {
-	int ret;
-
-	do {
+	do
 		get_random_bytes(entropy, entropylen);
-		ret = drbg_fips_continuous_test(drbg, entropy);
-		if (ret && ret != -EAGAIN)
-			return ret;
-	} while (ret);
+	while (!drbg_fips_continuous_test(drbg, entropy));
 
 	return 0;
 }
-- 
2.52.0
