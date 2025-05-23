Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA48227EB9
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 11:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748000472; cv=none; b=RkwHwdY/NTsrex4fvITD+VN7jyR71o+sWe2+iVX3eK/UXMQPcPdKv5UpAIA/9kZl+wHDujqHXh5mc9LE5LMkkClMGfQI0VDi9qWrGlsDm46/KZD+5W2LMwIDP8FZmXDH6KDCQdI/B6JI11ZncNuDzfWgB0tu3P3z4DCtpcvlM5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748000472; c=relaxed/simple;
	bh=ROH0KbiR4fYfAoy/HTsB547lzpcK1LNW/gQiMh645Pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N3M1qURVHvYH5M7EbBKYq1gpCDqXisIv/6wDYNE/uqyBfMGAhP7u8jmxWwx/SZhE9lmVYeETBsILxAELLeTs35/wR5WiizMjXMlDodUrt6vETYnMut63SYND4VLux63fG795+WllXAAv/i0iFQwV6H0HEoQRAemSRXiun1MVIgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LKWJIXQf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LKWJIXQf"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54N8uKpq030315;
	Fri, 23 May 2025 11:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=G+1bHO
	hArgT26ApAtpkh2HjwFAvj15r0ZqnOABbeUTc=; b=LKWJIXQf5+djTbv8iKWPAi
	wnVbKy0vdCvXB870LPMfc13yGCzL1gaegYBHVwmIR4nlJGGBRnj9Bi/Ip27GLuaq
	F1ZH+ZqJ6P+F3b5Bv1lDds6oSV3fnl/37QN6y5p0vG919z+XBxLQgQui/vfsMqGw
	90Buv+lKt2clWhsjx7xB7ce6foEmp84krT8henMHtlU5hlQvSnaJpqTcHqXkL0tF
	I4rKcUfZl30ecfvAuYzm1gBXhCVfO4hKAV7dPiVE0BBxXkoUpkwWrl46Z5huw6Xl
	cXf4xOQOIzyxsdzHvI6xqziorHJkcm3/FOCx/hggXRUVyp2aOwkr6BSOY+saKkQg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t669n251-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 11:41:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NAEmpa020733;
	Fri, 23 May 2025 11:41:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwkq6bw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 11:41:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NBf0ZM55247206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 11:41:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADEED20043;
	Fri, 23 May 2025 11:41:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89B5120040;
	Fri, 23 May 2025 11:41:00 +0000 (GMT)
Received: from [9.111.148.185] (unknown [9.111.148.185])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 11:41:00 +0000 (GMT)
Message-ID: <4d6617be-2070-4edc-a4ba-98f9667d0fde@linux.ibm.com>
Date: Fri, 23 May 2025 13:41:00 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s390/hmac - Fix counter in export state
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
 <aDAM9LKOWSKBbIUn@gondor.apana.org.au>
 <152288d2-a034-4594-a5cc-d46faf34ac24@linux.ibm.com>
 <aDBa8tuSvw1mnnKL@gondor.apana.org.au>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <aDBa8tuSvw1mnnKL@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RrPFLDmK c=1 sm=1 tr=0 ts=68305ed1 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=9qcPPypGzFYYKdnir20A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-ORIG-GUID: 3iiQxXO-f2-N30-B0oP8lutuVSJBYmSb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDEwMSBTYWx0ZWRfX47tRa9sKghIe aAOFYuW+lhIZs3MoI7VxqHule3FHtu3ZH6R9hOoBoAGUf7dm7yfbKi6ZutDSBRcqQjBdlCITov5 vRTPDm716aoTMF0vTacH5l2do2dj37J5fDGbNtHTyh43IN00wlWYrY7Uo3KRZuvX3Ecb9xGkIHC
 O8T3YeXMd1teZF51JJLDu/VzCeh+MMD2lY3sCRUFZOK9suzTMDIx5PuPVDURThVwDe/eBE20lJf hNHAFcTSsZ31899xgQn7sjFLm2xcrK0vFL4i8cuIB6QS40YY9ZRky178NU0Z5GkHLjlo1s6SjWx h1n7n3/ZxWjt7v1Oy9dPXq5qqjXzQb6K7+c0S4ePh0/pPxPXfLFPiWALVMBBk010C9dhexYU82D
 79Ze3fsrcqM1MppDR5C+k74YYOWI3yv+GxhyJjbw2bu84r4/4ECdeu+u8GJsY1ibYZEYRdZ+
X-Proofpoint-GUID: 3iiQxXO-f2-N30-B0oP8lutuVSJBYmSb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_03,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230101

On 23.05.2025 13:24, Herbert Xu wrote:
> On Fri, May 23, 2025 at 10:02:18AM +0200, Ingo Franzki wrote:
>>
>> Yes, indeed, reverting this commit makes the problem to go away. 
> 
> Great.  While I've got your attenttion, could you also test this
> patch to see if it makes the hmac errors go away?

Yes, with your fix below and with commit 18c438b228558e05ede7dccf947a6547516fc0c7 the HMAC failures are no longer seen, but the SHA3 failures are still there (I guess that's as you have expected it). 

> 
> Thanks,
> 
> ---8<---
> The hmac export state needs to be one block-size bigger to account
> for the ipad.
> 
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Fixes: 08811169ac01 ("crypto: s390/hmac - Use API partial block handling")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
> index 93a1098d9f8d..58444da9b004 100644
> --- a/arch/s390/crypto/hmac_s390.c
> +++ b/arch/s390/crypto/hmac_s390.c
> @@ -290,6 +290,7 @@ static int s390_hmac_export(struct shash_desc *desc, void *out)
>  	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
>  	unsigned int bs = crypto_shash_blocksize(desc->tfm);
>  	unsigned int ds = bs / 2;
> +	u64 lo = ctx->buflen[0];
>  	union {
>  		u8 *u8;
>  		u64 *u64;
> @@ -301,9 +302,10 @@ static int s390_hmac_export(struct shash_desc *desc, void *out)
>  	else
>  		memcpy(p.u8, ctx->param, ds);
>  	p.u8 += ds;
> -	put_unaligned(ctx->buflen[0], p.u64++);
> +	lo += bs;
> +	put_unaligned(lo, p.u64++);
>  	if (ds == SHA512_DIGEST_SIZE)
> -		put_unaligned(ctx->buflen[1], p.u64);
> +		put_unaligned(ctx->buflen[1] + (lo < bs), p.u64);
>  	return err;
>  }
>  
> @@ -316,14 +318,16 @@ static int s390_hmac_import(struct shash_desc *desc, const void *in)
>  		const u8 *u8;
>  		const u64 *u64;
>  	} p = { .u8 = in };
> +	u64 lo;
>  	int err;
>  
>  	err = s390_hmac_sha2_init(desc);
>  	memcpy(ctx->param, p.u8, ds);
>  	p.u8 += ds;
> -	ctx->buflen[0] = get_unaligned(p.u64++);
> +	lo = get_unaligned(p.u64++);
> +	ctx->buflen[0] = lo - bs;
>  	if (ds == SHA512_DIGEST_SIZE)
> -		ctx->buflen[1] = get_unaligned(p.u64);
> +		ctx->buflen[1] = get_unaligned(p.u64) - (lo < bs);
>  	if (ctx->buflen[0] | ctx->buflen[1])
>  		ctx->gr0.ikp = 1;
>  	return err;


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
