Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC14130594E
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 20:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766002970; cv=none; b=oC6h/SXPHFg28dnnI5wE/NuDk2YC0k6hpxVNwuWNDSiGElBUdWfBL3Gls9VwGwVH/bYefZLynkQgWORhdwZyRoCHSTLfo4CCgK2IZy7R/zcCrlBKmBo+HBMur2CVxrNofbwxX5PHlgi+qIl6RyWNsIOjzr2lIFuWkuXQYb+6I/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766002970; c=relaxed/simple;
	bh=mkNJZYFTHBvQPZKS7HMXQ8mfo6SsJN+SM2B1D0Q7FLw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQFq9CFmXX3cNwh4/wnQsI9wcZb8nJgNEMM9dqEWPHWbHZr/jQ28kgAm0Goto57xInPbDarrEEj2cg8EL4alHjcntpdi81VT56x4FvO6nDK5fn+fblxJQ5KOVdM5cVXLHmxrT4vzpFuu5/h42eZ2w0hnpOH3/XOp0oHx9uJBUlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from wasted (213.87.162.109) by msexch01.omp.ru (10.188.4.12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 17 Dec
 2025 23:22:40 +0300
From: Sergey Shtylyov <s.shtylyov@omp.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH 3/3] crypto: drbg - make drbg_get_random_bytes() return *void*
Date: Wed, 17 Dec 2025 23:21:45 +0300
Message-ID: <20251217202148.22887-4-s.shtylyov@omp.ru>
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

Now that drbg_get_random_bytes() always returns 0, checking its result at
the call sites stopped to make sense -- make this function return *void*
instead of *int*...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 crypto/drbg.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 72d1d130dcc8..9a2af599ead1 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -842,15 +842,13 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	return ret;
 }
 
-static inline int drbg_get_random_bytes(struct drbg_state *drbg,
-					unsigned char *entropy,
-					unsigned int entropylen)
+static inline void drbg_get_random_bytes(struct drbg_state *drbg,
+					 unsigned char *entropy,
+					 unsigned int entropylen)
 {
 	do
 		get_random_bytes(entropy, entropylen);
 	while (!drbg_fips_continuous_test(drbg, entropy));
-
-	return 0;
 }
 
 static int drbg_seed_from_random(struct drbg_state *drbg)
@@ -867,13 +865,10 @@ static int drbg_seed_from_random(struct drbg_state *drbg)
 	drbg_string_fill(&data, entropy, entropylen);
 	list_add_tail(&data.list, &seedlist);
 
-	ret = drbg_get_random_bytes(drbg, entropy, entropylen);
-	if (ret)
-		goto out;
+	drbg_get_random_bytes(drbg, entropy, entropylen);
 
 	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
-out:
 	memzero_explicit(entropy, entropylen);
 	return ret;
 }
@@ -948,9 +943,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		if (!rng_is_initialized())
 			new_seed_state = DRBG_SEED_STATE_PARTIAL;
 
-		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
-		if (ret)
-			goto out;
+		drbg_get_random_bytes(drbg, entropy, entropylen);
 
 		if (!drbg->jent) {
 			drbg_string_fill(&data1, entropy, entropylen);
-- 
2.52.0
