Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEE72F0C64
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570251; cv=none; b=IT6ldY+mB5VxpqJXolHxPvGjFC95jKZgWmbDM/p5WQcnK0pzc2BumYcFHZISr4jCEx9FnCArOOlxiddfr7LA+DKgXfW/fT0jE9lrcrdwn9RGToz00ol+JozzC1e8JGeGWh1RFrIJH8o3n7LyFpYMOY5kGhqPh6kdT5qvBX9Mlac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570251; c=relaxed/simple;
	bh=RXoYN+zZwrNsIkx5t1BbiguQlYFTW3PadPP0bbOR3T8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GGRybo8Wx7ugFpmwXdfm56y78GVGC9CMPSpILkvDJg+0tb7sOIUbdjoSqAwKXK4yOGSY52GdSYRDoJY71l2LiCbVZe8Yj1BHD93Zj3I2qEzD2ENX0N7dkjb5SKY1rONoEGxvH+DS7DiXQL30DOZ6jEcQHcF8kIO9DDHgbRObjXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.103] (213.87.146.175) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Mon, 22 Sep
 2025 22:43:59 +0300
Message-ID: <12e0fdc7-8978-44f4-9763-7cb4d8376be6@omp.ru>
Date: Mon, 22 Sep 2025 22:43:59 +0300
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
Content-Language: en-US
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <aNCo7yjktKTFg9HH@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 09/22/2025 19:28:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 196488 [Sep 22 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 67 0.3.67
 f6b3a124585516de4e61e2bf9df040d8947a2fd5
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.146.175
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/22/2025 19:31:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 9/22/2025 4:27:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 9/22/25 4:39 AM, Herbert Xu wrote:

>> drbg_fips_continuous_test() only returns 0 and -EAGAIN, so an early return
>> from drbg_get_random_bytes() could never happen, so we can drop the result
>> check from the *do/while* loop...
>>
>> Found by Linux Verification Center (linuxtesting.org) with the Svace static
>> analysis tool.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>
>> ---
>> The patch is against the master branch of Linus Torvalds' linux.git repo
>> (I'm unable to use the other repos on git.kernel.org and I have to update
>> Linus' repo from GitHub).
>>
>>  crypto/drbg.c |    2 --
>>  1 file changed, 2 deletions(-)
>>
>> Index: linux/crypto/drbg.c
>> ===================================================================
>> --- linux.orig/crypto/drbg.c
>> +++ linux/crypto/drbg.c
>> @@ -1067,8 +1067,6 @@ static inline int drbg_get_random_bytes(
>>  	do {
>>  		get_random_bytes(entropy, entropylen);
>>  		ret = drbg_fips_continuous_test(drbg, entropy);
>> -		if (ret && ret != -EAGAIN)
>> -			return ret;
> 
> That's a bug waiting to happen.  Does the compiler actually fail

   You mean the change is risky WRT the drbg_fips_continuous_test() changes?

> to optimise away?

   Looks like both gcc (14.3.1) and clang (19.1.7) are able to optimize away
this *if*...

> If you can show that this makes a difference to the compiled output,

   It does, however the code (from my cursory look) seems to get even worse,
as *return* -EINVAL generates actual mov, at least with gcc 14.3.1...
   However, it's clear that drbg_get_random_bytes() can be made shorter/clearer
(see the other reply), so I'm going to recast.

> then please change the drbg_fips_continuous_test function signature
> so that it can no longer return an error.

   I didn't understand what change you meant here...

> Thanks,

MBR, Sergey

