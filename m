Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052CA19D07A
	for <linux-crypto@vger.kernel.org>; Sun, 21 Sep 2025 20:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758486836; cv=none; b=g/uGHK9Co532rUESoCqXDsPuslAjpY30W0OPajKx507FpUduJ6uDMSMjYBX7bRViEZfqeRPFH8qwxUgPnXL2TjPlllzIP8A9UGA5WefAtReUezVz3aGSdow01QC0IBUbANQH+9xjpsWpnAQW0/deXg2Enr7YZIRRS7FMV4gCUmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758486836; c=relaxed/simple;
	bh=yCF15YUUOUAJ4mn3mqoZEwQaxOebiecs8ozOpEVL+kE=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=UDQZy0Z8ESSQxLb00Qsqv9HdnHQW89TJcyZdLnTOPwcdnJyxyOtrnmEPG4oyL0cGqoBepuwmnbjtf+NxLozgljL6Stib4hgt3ccBbB6aTkRoGUzy4sImwaLdHBfayML+gJ6pqIgvOGuaPQBmtTDUwN8o4zsxwOq5SV1ATjiZQXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.103] (213.87.161.70) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Sun, 21 Sep
 2025 23:33:37 +0300
Message-ID: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
Date: Sun, 21 Sep 2025 23:33:36 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller\""
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Karina Yankevich <k.yankevich@omp.ru>
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] crypto: drbg - drop useless check in drbg_get_random_bytes()
Organization: Open Mobile Platform
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 09/21/2025 20:18:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 196458 [Sep 21 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 67 0.3.67
 f6b3a124585516de4e61e2bf9df040d8947a2fd5
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info:
	omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.161.70
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/21/2025 20:21:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 9/21/2025 5:57:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

drbg_fips_continuous_test() only returns 0 and -EAGAIN, so an early return
from drbg_get_random_bytes() could never happen, so we can drop the result
check from the *do/while* loop...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
The patch is against the master branch of Linus Torvalds' linux.git repo
(I'm unable to use the other repos on git.kernel.org and I have to update
Linus' repo from GitHub).

 crypto/drbg.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/crypto/drbg.c
===================================================================
--- linux.orig/crypto/drbg.c
+++ linux/crypto/drbg.c
@@ -1067,8 +1067,6 @@ static inline int drbg_get_random_bytes(
 	do {
 		get_random_bytes(entropy, entropylen);
 		ret = drbg_fips_continuous_test(drbg, entropy);
-		if (ret && ret != -EAGAIN)
-			return ret;
 	} while (ret);
 
 	return 0;
