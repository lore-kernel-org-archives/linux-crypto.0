Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7EA26A09B
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747662435; cv=none; b=RCuWrVdBDOlkkR/5mba0el9iUWSJCEv5e/a01BNhmGaqBpNJskX2oFkTN+kzYLeqnh2IdlqOhHY9OtJgKZpviRq1pN+e+HNXhti6pdj2Funuc4kYH9vKTjBeK52AIExTJSkiNpX0Ob5FVRGLGCqUFcXBewpkUAD5z+blMMv7QLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747662435; c=relaxed/simple;
	bh=Z8DiVDlc1WxHZhbmSbM1PqA0v/T+pnR9RRku3fVUZDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=REXkOmWpii8+YF46cn/773VUe/KkwvFMkhGh9cVC4/F7y8jakmrSA9fhz4XC2EGDKGtamIhOvSTETtd/CzZiujntLpf7wmBSJWV+JrcSC1/zPs9k2VHZTVm7tKBAKl1jPAV91z9LDZhAdhoAobBGkGobgXem8haQ4wtCtl1ZbkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=prEc4tzw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="prEc4tzw"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JAHgaF016130;
	Mon, 19 May 2025 13:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=X+0jBd
	k1QSBrS9IoWzcTObjYj68euThjpaufov5tAUM=; b=prEc4tzwnLYn2VCsmt9/HF
	KMYcEh1nbjup9Omai44boZE7eUY/bAlun18VpJv4inaKjsi33n7g6jEhC5JOQOqV
	jQ+VKL5kZ8Hsgg2ZOhIqB+3nZIel3pCUQqCxAkHiKWMQWThTni2VBz7EhelLtf5a
	qNxYRWkqc2uephBcami4mh2Y4kv8dAAVSjzeeC2TnRVS+YItpV9+1pr8hTbGvny0
	7x4e86NKk+24HOpzaysxzBv67yTX5Pw7QGT7qoDn44G7GC/8X2+LNhK+KbJzhkfe
	Qpw1D2Uq2y8OHoflLXyqLcIr+PeT0C82NVAGHI/3up8v9w0Npil6zhb1I7mhKvdw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46qgs2vqs0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 13:47:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54JDOYZX013862;
	Mon, 19 May 2025 13:47:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q4st743d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 13:47:06 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54JDl2rd56820210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 13:47:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE11820040;
	Mon, 19 May 2025 13:47:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8B4220049;
	Mon, 19 May 2025 13:47:02 +0000 (GMT)
Received: from [9.111.147.66] (unknown [9.111.147.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 13:47:02 +0000 (GMT)
Message-ID: <d862f12f-8777-445e-a2d2-36484bd0e199@linux.ibm.com>
Date: Mon, 19 May 2025 15:47:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: api - Redo lookup on EEXIST
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
 <aCsIEqVwrhj4UnTq@gondor.apana.org.au>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <aCsIEqVwrhj4UnTq@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z/fsHGRA c=1 sm=1 tr=0 ts=682b365b cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=Jdrvd1ioTxSbWW3W9SUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEyNiBTYWx0ZWRfX+XG0ZfPnCWoU a3PcIfEY3LT5y69v1sqDEuftAf8Q8ZIuxkY/f7DbfFHyvuADc4qF0cvur13b/anp4mpq8ZcTJA/ L3GaJUqu3fh/myumc3QYQ13nlJxhG0ZKh5qbah6q8RMrMziF+Yt/8BtiLFR3x+sVhibtx/ZnwT8
 nyIqiIsvsnuhkEjRqd1pZRxwAc3TxIbsOFsYdT1F/EgXootTrGFvWsRxT4bMRxbKCHOFOAVXbeX quApOucNKMO1UDG289AQampIxMZIwAhbB77Ex4FL6jmcO+UbZZV9vILEeQ1FhW7J3xF4oULerFr ET5JII2Q7sxyuuwAnzRlUL9pG9guHxLAwDhCVT6+6VXxKQpPxVu5ZiF5bUy+NxShHu5rMFH7jn0
 Sddbb8F65J5cYw/bQeT0GOHx1U+xcALkJUexetevLQ/frAJFeTZ2bSF+lgfYL5P5vwZpZvJE
X-Proofpoint-ORIG-GUID: NRAg-_CZ5cg5I-dOuH_JbUO0PeGbU0M8
X-Proofpoint-GUID: NRAg-_CZ5cg5I-dOuH_JbUO0PeGbU0M8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 adultscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190126

On 19.05.2025 12:29, Herbert Xu wrote:
> On Mon, May 19, 2025 at 10:09:10AM +0200, Ingo Franzki wrote:
>>
>> During this weekend's CI run, we got the following:
>>
>>     alg: aead: error allocating gcm_base(ctr(aes-generic),ghash-generic) (generic impl of gcm(aes)): -17
>>     alg: self-tests for gcm(aes) using gcm-aes-s390 failed (rc=-17)
>>
>> Last week, we had a similar failure:
>>
>>     aes_s390: Allocating AES fallback algorithm ctr(aes) failed
>>     alg: skcipher: failed to allocate transform for ctr-aes-s390: -17
>>     alg: self-tests for ctr(aes) using ctr-aes-s390 failed (rc=-17)
> 
> Please try this patch:

Since I can't reproduce the problem at will, I can't tell if your patch solves the problem. From what I can tell it looks reasonable. 
Nevertheless, I have added your patch to be applied on top of the next day's next kernel tree in our CI so that it runs with your patch for a while.
Lets run it for a few days and see if the error still shows up or not. 

> 
> ---8<---
> When two crypto algorithm lookups occur at the same time with
> different names for the same algorithm, e.g., ctr(aes-generic)
> and ctr(aes), they will both be instantiated.  However, only one
> of them can be registered.  The second instantiation will fail
> with EEXIST.
> 
> Avoid failing the second lookup by making it retry, but only once
> because there are tricky names such as gcm_base(ctr(aes),ghash)
> that will always fail, despite triggering instantiation and EEXIST.
> 
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Fixes: 2825982d9d66 ("[CRYPTO] api: Added event notification")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 133d9b626922..5724d62e9d07 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -219,10 +219,19 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
>  		if (crypto_is_test_larval(larval))
>  			crypto_larval_kill(larval);
>  		alg = ERR_PTR(-ETIMEDOUT);
> -	} else if (!alg) {
> +	} else if (!alg || PTR_ERR(alg) == -EEXIST) {
> +		int err = alg ? -EEXIST : -EAGAIN;
> +
> +		/*
> +		 * EEXIST is expected because two probes can be scheduled
> +		 * at the same time with one using alg_name and the other
> +		 * using driver_name.  Do a re-lookup but do not retry in
> +		 * case we hit a quirk like gcm_base(ctr(aes),...) which
> +		 * will never match.
> +		 */
>  		alg = &larval->alg;
>  		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
> -		      ERR_PTR(-EAGAIN);
> +		      ERR_PTR(err);
>  	} else if (IS_ERR(alg))
>  		;
>  	else if (crypto_is_test_larval(larval) &&


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
