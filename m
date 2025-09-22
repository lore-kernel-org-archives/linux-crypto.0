Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A53918BC3B
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 14:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758551234; cv=none; b=BKQ1hT+3pYixe+pyCEEXEqXmyW80D5ks9LROBVAmQIoBJyX0YFJTAoRzo3ciN43RgIKz9GTUwlZrp8mMLKjwZkZGf52obe4ZoLUQaLQMjEpixpmryXhb7N47f+Tx4ZFTWhgBuAu9YyQKzxb/U+kgsVjjYzLB9I/b4pnOQQV6pfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758551234; c=relaxed/simple;
	bh=JwJZj/dLmfhftFtX+TTx9osr4ygwi4VMOVODMDZTg6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pvG6bsLWGrHVqW8ObuynasRC9ZBV/qAgsl/UE6UygV+MmxqiSVwSPsEXDVYYPd6v5euZoCKch6X+ct9AuhQGxYhWGtc2DK+iACUJBICCZeT5BEQxfoCyiAD8CpI3/nw6jdw/O48TU0vyWC7fOEUD9dv7qjnUk9Ugo47V3E6dVZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.103] (213.87.146.175) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Mon, 22 Sep
 2025 17:26:57 +0300
Message-ID: <d7854b99-44e0-4d19-b74a-9de53f25eed6@omp.ru>
Date: Mon, 22 Sep 2025 17:26:57 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: drbg - drop useless check in
 drbg_get_random_bytes()
To: Yann Droneaud <yann@droneaud.fr>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller\"" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
CC: Karina Yankevich <k.yankevich@omp.ru>
References: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
 <51375fee-f3be-487d-8384-a2f07600d578@droneaud.fr>
Content-Language: en-US
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <51375fee-f3be-487d-8384-a2f07600d578@droneaud.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 09/22/2025 14:17:43
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 196484 [Sep 22 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 67 0.3.67
 f6b3a124585516de4e61e2bf9df040d8947a2fd5
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_arrow_text}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.146.175 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.146.175 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.146.175
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/22/2025 14:19:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 9/22/2025 11:10:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 9/22/25 9:19 AM, Yann Droneaud wrote:
[...]

>> Index: linux/crypto/drbg.c
>> ===================================================================
>> --- linux.orig/crypto/drbg.c
>> +++ linux/crypto/drbg.c
>> @@ -1067,8 +1067,6 @@ static inline int drbg_get_random_bytes(
>>       do {
>>           get_random_bytes(entropy, entropylen);
>>           ret = drbg_fips_continuous_test(drbg, entropy);
>> -        if (ret && ret != -EAGAIN)
>> -            return ret;
>>       } while (ret);
> 
> } while (ret == EAGAIN);
> 
> return ret;

   Yeah, that's more clear, thanks! I'll mention you in the Suggested-by tag
when I recast. :-)

MBR, Sergey

