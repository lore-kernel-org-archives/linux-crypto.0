Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323E3264609
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 20:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766002964; cv=none; b=mtUqIwnKxfgZPiK/nNPhM2knQzzF/zVE+pxkqr+kV/jz5upbYJxhPhL12ufdzpk8rtwdlD2FzbPebShSgkkrwVctbhYm61WgBS05VC8hRhrSM9B+NPDOD1Pg8v1irEW4e/TOJt0KzvhbFI81Cvr3GZwU1zDfbAF8ivHlURwPUdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766002964; c=relaxed/simple;
	bh=dVwmSZhsJjWVm6dXt/AqNIvDoEIbTxKoNJ1ERrvkK1I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l7JhG/Un40E72vWNuoCfo90VAa9ykmd64yG/EedQrX96tbKsdEUpxsiiAznRMaTKGFJtulvcO0ErsMaOcpKrjgIPahAOA73P7bh0x+tin5znUVgD55KnCQC9ukB5CuJLaF8K0vsbJtCUf9cSry0U1knz8VPcwhGW6r4/+/vUkJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from wasted (213.87.162.109) by msexch01.omp.ru (10.188.4.12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 17 Dec
 2025 23:22:27 +0300
From: Sergey Shtylyov <s.shtylyov@omp.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH 1/3] crypto: drbg - kill useless variable in drbg_fips_continuous_test()
Date: Wed, 17 Dec 2025 23:21:43 +0300
Message-ID: <20251217202148.22887-2-s.shtylyov@omp.ru>
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

In drbg_fips_continuous_test(), not only the initializer of the ret local
variable is useless, the variable itself does not seem needed as it only
stores the result of memcmp() until it's checked on the next line -- get
rid of the variable...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 crypto/drbg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1d433dae9955..ab7da601a87f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -234,7 +234,6 @@ static int drbg_fips_continuous_test(struct drbg_state *drbg,
 				     const unsigned char *entropy)
 {
 	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
-	int ret = 0;
 
 	if (!IS_ENABLED(CONFIG_CRYPTO_FIPS))
 		return 0;
@@ -253,8 +252,7 @@ static int drbg_fips_continuous_test(struct drbg_state *drbg,
 		/* priming: another round is needed */
 		return -EAGAIN;
 	}
-	ret = memcmp(drbg->prev, entropy, entropylen);
-	if (!ret)
+	if (!memcmp(drbg->prev, entropy, entropylen))
 		panic("DRBG continuous self test failed\n");
 	memcpy(drbg->prev, entropy, entropylen);
 
-- 
2.52.0
