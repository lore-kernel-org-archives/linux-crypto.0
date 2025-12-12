Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47B62264C7
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 20:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765571466; cv=none; b=Gqfg18ySVGBSFYJ8sMp9i3NGtgjtuDAofpcBTYIbLS6p1M4wI1Ep4fBWi52wQfZIOOQHZ0VOh2Vjhof3EJWl5K/ZtWTA4ZP3lEvCmr/Iqc91RlpGbRs4CfpgBo0xs7l7jT6balFMSv40fgnwZQz5YO5toRVp/9rrB4ZZONZkNeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765571466; c=relaxed/simple;
	bh=J119RAkprD6j3J1yrBVO+Yzsu3R/pfrKmz2szdNEoLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F9wXV9YrTKMSz0bi9yZX2wLM/eZym4+XZEK3qCNFlBKo8UZgxgy65XCc2eQsBSfrJZkEyyY8GB1QhYyQkDcksuJyrA/gq7oVFwB9iwcobXEfQ8RdP3dnWtHNlYtQJHqkW1mb5sdeGvK5/TqXLjb/GnoW4+j2fqX6n0HbKwrLzE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.104] (213.87.146.132) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Fri, 12 Dec
 2025 23:30:42 +0300
Message-ID: <2e753abc-7319-4305-aeeb-9f1cdd0419e6@omp.ru>
Date: Fri, 12 Dec 2025 23:30:42 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: drbg - drop useless check in
 drbg_get_random_bytes()
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller\"" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	Karina Yankevich <k.yankevich@omp.ru>
References: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
 <aNCo7yjktKTFg9HH@gondor.apana.org.au>
 <12e0fdc7-8978-44f4-9763-7cb4d8376be6@omp.ru>
 <aNH49MZHzZNOGSID@gondor.apana.org.au>
Content-Language: en-US
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <aNH49MZHzZNOGSID@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 12/12/2025 20:20:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 198959 [Dec 12 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.20
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 84 0.3.84
 c2f198c3716e341b2aaf9aead95378b399603242
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_arrow_text}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.146.132 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info:
	d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.146.132
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/12/2025 20:22:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 12/12/2025 6:17:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 9/23/25 4:33 AM, Herbert Xu wrote:

>>> then please change the drbg_fips_continuous_test function signature
>>> so that it can no longer return an error.
>>
>>    I didn't understand what change you meant here...
> 
> Make it return a boolean instead of an int.

   That means drbg_get_random_bytes() can be made *void* inst6ead of *int*...
I guess I should do a series 2 patches then?

> Cheers,

MBR, Sergey

