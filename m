Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37D130AACF
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765812095; cv=none; b=F5Vdph1BRz7Vd/tTb7ZOYAGvYT9HvdazUqqR1xFF9GvLbLawCReqVXtFCnbODQVBeS+0f7FtVx+x3kc3kRBLVO3ZFvJ5c6BEOMHLlZ/AjKCSEDFfSLzXBQJR+DhqePnBOC6iqYfQ9dIVNCotRk4hnPODN+wZ+97bB2sTpcRfisg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765812095; c=relaxed/simple;
	bh=2AbxteOfpeWXIPH2/5LPTMPUkUZvmukzEv1WtArxCZA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=tPQf6VoKj/dHeMg/gYRCaOUR+hSLdiiGOXslO0QQb/f5HXaL/QwMsY5+laUGns3gpgVpkbdJ4ZgyfcPxPTfJLO/ToTqaW1kcfsV/Tsh7Qu/CDP8S+yN2ET+enSUszNmplvXxzBkCep7ooREjdag2G55umOtJyOLq+K0n2x3tB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.104] (213.87.154.182) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Mon, 15 Dec
 2025 18:21:13 +0300
Message-ID: <cdc35a77-6f90-4540-885f-22bf42a0c980@omp.ru>
Date: Mon, 15 Dec 2025 18:21:13 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: drbg - drop useless check in
 drbg_get_random_bytes()
From: Sergey Shtylyov <s.shtylyov@omp.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller\"" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	Karina Yankevich <k.yankevich@omp.ru>
References: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
 <aNCo7yjktKTFg9HH@gondor.apana.org.au>
 <12e0fdc7-8978-44f4-9763-7cb4d8376be6@omp.ru>
 <aNH49MZHzZNOGSID@gondor.apana.org.au>
 <2e753abc-7319-4305-aeeb-9f1cdd0419e6@omp.ru>
Content-Language: en-US
Organization: Open Mobile Platform
In-Reply-To: <2e753abc-7319-4305-aeeb-9f1cdd0419e6@omp.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 12/15/2025 14:58:04
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 199008 [Dec 15 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.20
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 84 0.3.84
 c2f198c3716e341b2aaf9aead95378b399603242
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_arrow_text}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {Tracking_spam_in_reply_from_match_msgid}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.154.182 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.154.182 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;213.87.154.182:7.1.2
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.154.182
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/15/2025 15:10:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 12/15/2025 12:27:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 12/12/25 11:30 PM, Sergey Shtylyov wrote:
[...]

>>>> then please change the drbg_fips_continuous_test function signature
>>>> so that it can no longer return an error.
>>>
>>>    I didn't understand what change you meant here...
>>
>> Make it return a boolean instead of an int.
> 
>    That means drbg_get_random_bytes() can be made *void* inst6ead of *int*...
> I guess I should do a series 2 patches then?

    A series of 2 patches, of course. :-)
>> Cheers,

MBR, Sergey
