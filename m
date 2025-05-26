Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AD713D8A4
	for <linux-crypto@vger.kernel.org>; Mon, 26 May 2025 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748241886; cv=none; b=Yl1dVxc506bvExb7ZVpASdvcsB1Bbnnb6o2S75yRp6Ezgxl225FCQjBvH+jpcfCeJgnChR9iFrC5NedGD6FMoq2Hf/9BPvAX49K4MS/dBQISPUeUxV5XWquew8fHzAXk17gz9AKJm7uTxMFdSxhzLW6XPRrxe8YXc9mz5ighjLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748241886; c=relaxed/simple;
	bh=iS/DQm1M1mLXZ5zGmO1HQ5QD5UU7q2oRM2D392X5VAg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ont5yzJa59RvWXsYTc6sjZWew9qAw5c7M7lZwQVg86ejLUycRDbS2d4xHFEL/aVUf3o4dym+AuOn9pqeku8brj3GYHRYkMaXe1KB12JKr1uzuS1sav0i5PyACGQdkBnNTsjNrYGtSgTArjQjtUtwoRhD6CMAmnuxIZwKgg5wfQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H4Gial++; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H4Gial++"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54PKgCPI001737;
	Mon, 26 May 2025 06:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jw1jMo
	sY3m7NHzrWVq7wlsZBs81ARy2R+5OQVf9MWT0=; b=H4Gial++wHAZcuL0U5+4uq
	URe/zDWUrHb81nyHH1PmNjcdi5SAyY/NgQCVPsnw2ugQFeECbU7t46Bn10DdN0tb
	nRc9wKwEU76EwNUtf9j4hkLjYBNAPprEfUvfd9A0XTGYFe8PTcIG3mJQ1dVuJROY
	2gFDn4baWLeYyKEB8tRjwApxJu2gB/gdPp+oBF5I5QNBXXBQMKGalpYNXPVzAVMs
	kyFLKa6yEFnZLJvQsKWLY/Qj2X09ER+w9IcVHCorF/a6wnUI//y8bcIpP3RZoRWM
	+82hg1EFYYyLs6f0W259kyODgTJwotY4Ja0cxL08xLOOeXPv1BfuESx/0xsouZ3g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u4hn7sk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 06:44:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q3Ue8H009539;
	Mon, 26 May 2025 06:44:37 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usxmmwvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 06:44:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54Q6iXgQ59638046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 06:44:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AED6420043;
	Mon, 26 May 2025 06:44:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C17C20040;
	Mon, 26 May 2025 06:44:33 +0000 (GMT)
Received: from [9.111.209.94] (unknown [9.111.209.94])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 May 2025 06:44:33 +0000 (GMT)
Message-ID: <9d81a919-6122-4d82-b2c4-bd6d6559ed1e@linux.ibm.com>
Date: Mon, 26 May 2025 08:44:33 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: api - Redo lookup on EEXIST
From: Ingo Franzki <ifranzki@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
 <aCsIEqVwrhj4UnTq@gondor.apana.org.au>
 <d862f12f-8777-445e-a2d2-36484bd0e199@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <d862f12f-8777-445e-a2d2-36484bd0e199@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HvB2G1TS c=1 sm=1 tr=0 ts=68340dd6 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=HW7JQlagPmmKNjHo3GkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-GUID: hFXUKocJngcCuVXMRoIQgPXyYargSRuj
X-Proofpoint-ORIG-GUID: hFXUKocJngcCuVXMRoIQgPXyYargSRuj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDA1MyBTYWx0ZWRfXwSRXPmBZQweh flqeMCVEWY2cEn0RQCqkmAJHyHrbrmv/n0VKg8wWLzHQMqbSFUY2YkP2TwbVhH/ZKtK+1nX7xfo US9b71IBwchyockEHyYkbO6hly+5JeBJ5OUxq83d9QS1Qjp/0+C9h5v/ZmlH8WACqcH22QKpgQY
 7cRijWkmQbKUxk3Qm9XWg0PflcoswraYS3vYGodb7VlaGn+4F0tJgRHVKiOCBdV+VglQ47ffhmH yAAJSiw7HXNiAqB6mnQHnUMthYvLcW9vl7VRra18t/Z5off/FT7/aWzG5T1NcUGd/vxp3DiA6mL ZNoh0VBjDbMZGw9iCEb3VAJRV/6w3bHPfW4XhYWsfo4610J0MwR67S9y8aFW2WHQVUDtLg6Ht1D
 NpvdBf1pNG4KClKBbL11Waiw9ARC4PS9HBNPtUAmJZkIh+f9/kQN4hrVRTNu5QbWOsy+xy4J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_03,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505260053

On 19.05.2025 15:47, Ingo Franzki wrote:
> On 19.05.2025 12:29, Herbert Xu wrote:
>> On Mon, May 19, 2025 at 10:09:10AM +0200, Ingo Franzki wrote:
>>>
>>> During this weekend's CI run, we got the following:
>>>
>>>     alg: aead: error allocating gcm_base(ctr(aes-generic),ghash-generic) (generic impl of gcm(aes)): -17
>>>     alg: self-tests for gcm(aes) using gcm-aes-s390 failed (rc=-17)
>>>
>>> Last week, we had a similar failure:
>>>
>>>     aes_s390: Allocating AES fallback algorithm ctr(aes) failed
>>>     alg: skcipher: failed to allocate transform for ctr-aes-s390: -17
>>>     alg: self-tests for ctr(aes) using ctr-aes-s390 failed (rc=-17)
>>
>> Please try this patch:
> 
> Since I can't reproduce the problem at will, I can't tell if your patch solves the problem. From what I can tell it looks reasonable. 
> Nevertheless, I have added your patch to be applied on top of the next day's next kernel tree in our CI so that it runs with your patch for a while.
> Lets run it for a few days and see if the error still shows up or not. 

It has now run several days in our CI with this patch on top of Next without showing the error again, so I would claim that your patch fixes the problem.
Can you please include it into the next kernel? 

> 
>>
>> ---8<---
>> When two crypto algorithm lookups occur at the same time with
>> different names for the same algorithm, e.g., ctr(aes-generic)
>> and ctr(aes), they will both be instantiated.  However, only one
>> of them can be registered.  The second instantiation will fail
>> with EEXIST.
>>
>> Avoid failing the second lookup by making it retry, but only once
>> because there are tricky names such as gcm_base(ctr(aes),ghash)
>> that will always fail, despite triggering instantiation and EEXIST.
>>
>> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
>> Fixes: 2825982d9d66 ("[CRYPTO] api: Added event notification")
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>>
>> diff --git a/crypto/api.c b/crypto/api.c
>> index 133d9b626922..5724d62e9d07 100644
>> --- a/crypto/api.c
>> +++ b/crypto/api.c
>> @@ -219,10 +219,19 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
>>  		if (crypto_is_test_larval(larval))
>>  			crypto_larval_kill(larval);
>>  		alg = ERR_PTR(-ETIMEDOUT);
>> -	} else if (!alg) {
>> +	} else if (!alg || PTR_ERR(alg) == -EEXIST) {
>> +		int err = alg ? -EEXIST : -EAGAIN;
>> +
>> +		/*
>> +		 * EEXIST is expected because two probes can be scheduled
>> +		 * at the same time with one using alg_name and the other
>> +		 * using driver_name.  Do a re-lookup but do not retry in
>> +		 * case we hit a quirk like gcm_base(ctr(aes),...) which
>> +		 * will never match.
>> +		 */
>>  		alg = &larval->alg;
>>  		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
>> -		      ERR_PTR(-EAGAIN);
>> +		      ERR_PTR(err);
>>  	} else if (IS_ERR(alg))
>>  		;
>>  	else if (crypto_is_test_larval(larval) &&
> 
> 


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
