Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DAC232395
	for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 20:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763239536; cv=none; b=Webxk8/ghRSoPWqBp0dVtJrFyvZaYePU2adLmSXEk1Ih2RlGobpW2KaMzSBWbkQQQt+0B5RqcGCrFSyL53UXYwXRrF9QiJ6U1mnLLTUkb7R72tK8IZlt1X05r/YX3EkVQPKcigTXoqdZ9rKd4X1MZAXPN5hL2sngtCtEostbqGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763239536; c=relaxed/simple;
	bh=9IrsNUai8hrJv3DivA0xbRcJoWWJOWnE+9BkopR6e0o=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:Content-Type; b=BvXFg4hgkMuv0zLbCSD8sqUkJuSl4zQ1QupYUj3Ggl1A0JllUop8cPGSe8lc84hdKoDPcdZHNP0rllv/u1TnBeb90jMQhjRvIx3GDwtdq4OazuoOm4gluRQAwJ0ayEysIamuggqml6Qd5zuuhYO0kIsEJ/xhq8ch1G8uaLvOsZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.104] (213.87.132.14) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Sat, 15 Nov
 2025 23:45:13 +0300
Message-ID: <28d3bdbc-c3f4-4f51-9d83-73c4b4ac85cc@omp.ru>
Date: Sat, 15 Nov 2025 23:45:12 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] crypto: drbg - simplify drbg_get_random_bytes()
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller\""
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Karina Yankevich <k.yankevich@omp.ru>, <lvc-project@linuxtesting.org>
Content-Language: en-US
Organization: Open Mobile Platform
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 11/15/2025 20:30:11
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 198116 [Nov 15 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 76 0.3.76
 6aad6e32ec76b30ee13ccddeafeaa4d1732eef15
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.132.14 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.132.14 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	omp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.132.14
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/15/2025 20:32:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11/15/2025 3:16:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

To begin with, drbg_fips_continuous_test() only returns 0 and -EAGAIN,
so an early return from the *do/while* loop in drbg_get_random_bytes()
just isn't possible.  Then, the loop condition needs to be adjusted to
only continue the loop while -EAGAIN is returned and the final *return*
statement needs to be adjusted as well, in order to be prepared for the
case of drbg_fips_continuous_test() starting to return some other error
codes...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Suggested-by: Yann Droneaud <yann@droneaud.fr>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
The patch is against the master branch of Herbert Xu's cryptodev-2.6.git repo.

 crypto/drbg.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: cryptodev-2.6/crypto/drbg.c
===================================================================
--- cryptodev-2.6.orig/crypto/drbg.c
+++ cryptodev-2.6/crypto/drbg.c
@@ -854,11 +854,9 @@ static inline int drbg_get_random_bytes(
 	do {
 		get_random_bytes(entropy, entropylen);
 		ret = drbg_fips_continuous_test(drbg, entropy);
-		if (ret && ret != -EAGAIN)
-			return ret;
-	} while (ret);
+	} while (ret == -EAGAIN);
 
-	return 0;
+	return ret;
 }
 
 static int drbg_seed_from_random(struct drbg_state *drbg)
