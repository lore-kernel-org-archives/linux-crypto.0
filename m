Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D35749620
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 12:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748004879; cv=none; b=nBOsxqQos4rQQK8FPkrfcBUTc0/O0HbSopoQYnRHHJ4Am9i64ZdIFYMPRCLmotumYCYpZnfRPUt936+x8LoTgfc+WgxblPGVBkTa1texl0pa+V10M+Y1BpL0PjyjIsXOTxGuv+cPZEkcPl7CLilMArcZ3nhPc1DBxN+8cBdhBd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748004879; c=relaxed/simple;
	bh=cy7IvrsDctMmHojx9y+Cg9lQO5a+gDI1Y8tiKdgSIFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4W32nQEn3LKNw+tWBp52iln4PtKjJx5pkcJ7YUYAkHpaW6ZepQxurvRyMduoxi53BtkqJ0LArhNABa6GVL8WTd3NeVRyIIokL3WD7wan5aOMuvgFamhtI8w7NRoLbXWtwkZMI34SQwT3fr3EKdccK1W2dWcNDdgbny9mLuojo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=In48ebQ7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="In48ebQ7"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NB7qh9025509;
	Fri, 23 May 2025 12:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/mLwIt
	dEreEeqq/htLhdige8D/PAlix5quaB0WDDsiM=; b=In48ebQ7sWBCxw97vFXm5a
	SGORCge1bvxwsGiJMWNBCY9in3vzWN78t19qBWeV7UXqKSAYL1ayOZeMiif5XhWz
	0Clf/b25lkqhEnqSb8suPXCinVYVqN3y7LiMQKFDA1NtasNxF0Ss8UjVsQJlsK8V
	UyzIODx/r1MFEy+Fi0uwz1lV48wnoB+4jh/JAesgwhDLsHLS89Dfb7SoQ3Dj3Kt9
	b1ATLcIUkIB2wA6Y5yYvI77JZUVdlooCpnPBCZKd5ymHwYUES7ggeG3j+lehmDmN
	YkalgrEUTNX/bbMtqbLbf18hbxYa63UeejtqhmJizgyu0dd1fn3rLtx7NrUGEUAg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t9j948by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 12:54:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NAlP40020707;
	Fri, 23 May 2025 12:54:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwkq6k93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 12:54:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NCsQ7V27656632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 12:54:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3B362004B;
	Fri, 23 May 2025 12:54:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FE9820043;
	Fri, 23 May 2025 12:54:26 +0000 (GMT)
Received: from [9.111.148.185] (unknown [9.111.148.185])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 12:54:26 +0000 (GMT)
Message-ID: <f1a46095-6894-4c56-ac86-c0239bde91a6@linux.ibm.com>
Date: Fri, 23 May 2025 14:54:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s390/sha3 - Use cpu byte-order when exporting
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
 <aDBe3o77jZTFWY9B@gondor.apana.org.au>
 <38637840-a626-49a9-a548-c1a141917775@linux.ibm.com>
 <aDBqCEdH0U-cNIHA@gondor.apana.org.au>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <aDBqCEdH0U-cNIHA@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UCrDi8NoFGYXw2MYY5cUPap341cQGxe-
X-Authority-Analysis: v=2.4 cv=O6Y5vA9W c=1 sm=1 tr=0 ts=68307007 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=m98gcy3dsU6vXUG0cD8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDExMCBTYWx0ZWRfX9NPEZuKp29rK nVdIhRyIeFJKi5bRrW1CSJiwFmlCjiAsPZFwyafzvF5pjcwaUbUQXHJUA0SqKHLqVUZuxmUmuwW r0iRBTEL+RXdflYGG0mM3rb4VhVIe2ps2Gc52ZogdSrQnAlhg+QNY92WVATc1jm5lNmn0sRYgTb
 2avY1frc0OwwBZGgskxLT3EBCFbeVxAPsygvOPiYe2ZPjE+g7fABAalxU8muqBe8lkNgwB4Oc9B ipskCVwDS4NEOw7MjNjTpnz8MqK1mScM1B6UuKYOAT4EpYfV7jKnBXzwtgar6M5q769dpnnnJz0 U9iZiUKcvTDwhLXDUfn7u164ij7UE1vm6wwbvPs09asg7xjV3vWZ2g4SCA2FTExnlV2vZb3LAr7
 TWxM3xgqnONEbJyMe3AYH7mIYiSOg+EICcichINrrlQJ63iIRuvtFVeRf10FVkNTezsDOKkE
X-Proofpoint-ORIG-GUID: UCrDi8NoFGYXw2MYY5cUPap341cQGxe-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_03,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230110

On 23.05.2025 14:28, Herbert Xu wrote:
> On Fri, May 23, 2025 at 02:03:23PM +0200, Ingo Franzki wrote:
>>
>> I hope you can sort it out what belongs to what.
> 
> Please let me know if this patch works or not:

Yes this fixes the selftest failures.

However, I am not sure if the handling of the first_message_part field is correct (or even was correct before your fix).
The first_message_part is essentially there to control the setting of the NIP (No-ICV-Parameter) flag for the KIMD and KLMD instructions in s390_sha_update() and s390_sha_final() in arch/s390/crypto/sha_common.c. That NIP flag is only supported when MSA 12 is available (facility 86). 

It must be 1 until the very first KIMD or KLMD call has been done, and must be resetted to zero afterwards. 
If NIP is set then you can omit the zeroing out of the initial parameter block. This saves a few cycles for the memset, but also for transferring the (all zero) IV to the coprocessor. 

All seems OK, unless that you always set first_message_part to zero at import. So even if an initial state was exported, after an import first_message_part is off. Previous code did retain the stat of the first_message_part field in the exported state as well. 
OK, one can argue that this loss of performance improvement is negligible for a saved initial state situation.....

> 
> ---8<---
> The sha3 partial hash on s390 is in little-endian just like the
> final hash.  However the generic implementation produces native
> or big-endian partial hashes.
> 
> Make s390 sha3 conform to that by doing the byte-swap on export
> and import.
> 
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Fixes: 6f90ba706551 ("crypto: s390/sha3 - Use API partial block handling")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
> index d757ccbce2b4..cadb4b13622a 100644
> --- a/arch/s390/crypto/sha.h
> +++ b/arch/s390/crypto/sha.h
> @@ -27,6 +27,9 @@ struct s390_sha_ctx {
>  			u64 state[SHA512_DIGEST_SIZE / sizeof(u64)];
>  			u64 count_hi;
>  		} sha512;
> +		struct {
> +			__le64 state[SHA3_STATE_SIZE / sizeof(u64)];
> +		} sha3;
>  	};
>  	int func;		/* KIMD function to use */
>  	bool first_message_part;
> diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
> index 4a7731ac6bcd..03bb4f4bab70 100644
> --- a/arch/s390/crypto/sha3_256_s390.c
> +++ b/arch/s390/crypto/sha3_256_s390.c
> @@ -35,23 +35,33 @@ static int sha3_256_init(struct shash_desc *desc)
>  static int sha3_256_export(struct shash_desc *desc, void *out)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> -	struct sha3_state *octx = out;
> +	union {
> +		u8 *u8;
> +		u64 *u64;
> +	} p = { .u8 = out };
> +	int i;
>  
>  	if (sctx->first_message_part) {
> -		memset(sctx->state, 0, sizeof(sctx->state));
> -		sctx->first_message_part = 0;
> +		memset(out, 0, SHA3_STATE_SIZE);
> +		return 0;
>  	}
> -	memcpy(octx->st, sctx->state, sizeof(octx->st));
> +	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
> +		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
>  	return 0;
>  }
>  
>  static int sha3_256_import(struct shash_desc *desc, const void *in)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> -	const struct sha3_state *ictx = in;
> +	union {
> +		const u8 *u8;
> +		const u64 *u64;
> +	} p = { .u8 = in };
> +	int i;
>  
> +	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
> +		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
>  	sctx->count = 0;
> -	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
>  	sctx->first_message_part = 0;
>  	sctx->func = CPACF_KIMD_SHA3_256;
>  
> diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
> index 018f02fff444..a5c9690eecb1 100644
> --- a/arch/s390/crypto/sha3_512_s390.c
> +++ b/arch/s390/crypto/sha3_512_s390.c
> @@ -34,24 +34,33 @@ static int sha3_512_init(struct shash_desc *desc)
>  static int sha3_512_export(struct shash_desc *desc, void *out)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> -	struct sha3_state *octx = out;
> -
> +	union {
> +		u8 *u8;
> +		u64 *u64;
> +	} p = { .u8 = out };
> +	int i;
>  
>  	if (sctx->first_message_part) {
> -		memset(sctx->state, 0, sizeof(sctx->state));
> -		sctx->first_message_part = 0;
> +		memset(out, 0, SHA3_STATE_SIZE);
> +		return 0;
>  	}
> -	memcpy(octx->st, sctx->state, sizeof(octx->st));
> +	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
> +		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
>  	return 0;
>  }
>  
>  static int sha3_512_import(struct shash_desc *desc, const void *in)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> -	const struct sha3_state *ictx = in;
> +	union {
> +		const u8 *u8;
> +		const u64 *u64;
> +	} p = { .u8 = in };
> +	int i;
>  
> +	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
> +		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
>  	sctx->count = 0;
> -	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
>  	sctx->first_message_part = 0;
>  	sctx->func = CPACF_KIMD_SHA3_512;
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
