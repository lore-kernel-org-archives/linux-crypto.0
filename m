Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8690EC8FE
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746451887; cv=none; b=Bu9p0be0WpRQzKu1elPn1cHlstP5Xw/LbMtrrWQgdwECeruAadLMuvoAiMmowCYt1AgkaWKY/bFh0mcA+FMZW8ZcebqI0tN1IpcjC9bU58pduxXGC4wRh7pueeIUJHInnI2nZR7ZxjnQV9Ft6gSNwiFjmuhsYKliQOJyKUJ8Iws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746451887; c=relaxed/simple;
	bh=9vuZWKZCBFxezRU/zHa59Sr9XjDAud0SBF8y3+RIRUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=haTRx4qJxBk55xscBFr97pw/S+H7NptlhU70qrlmf5XJ5CFoQQ/uRfViIMbqZSWq4ildY/+The84RoB5RdJFKQeR1r2vZM6K48s+S6dmzy+bsVN0GyOF23baycBTxXZTXQq7btQ/gZeGy07Fr8Y5GaF/thMTqUs/6GVmKhAH24w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CDSmGOZd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CDSmGOZd"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 545AfLOT010802;
	Mon, 5 May 2025 12:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=99aahL
	4GoB8DQvuaxB4kVfw7rQXYGn5INTVtgjTAwVg=; b=CDSmGOZdQPQ2xBdyrKrMXp
	expcylQ0/Sh58AvAzdwW3lb/H6u+GMg8nfq3jctAqMgPSSO6nDN/7MjdFWxB0Qxw
	aiP78nPxC2V4I88QmEFWs+BzsxQuVSGEjMNuQfd7RIjWYEd5HOJ2dmgDtWkCu/DZ
	XvNm9iQktkCgeXLu3eCacdDkxVzY8uvVAX8XnNFUIYY1v0OmZCSMAoUoIiO4wQOw
	qZUmSc8C3VBz3U5/pENUJYruZk3rLMT/0QiTpsI+Bemj0eR5yQYpuGC/W7B6C4ym
	jKJBd0CzxJHYqyN9aKbuTcPaA8vvengpqn0VZ92Xy2mTnpsd/jROH/HlN4CQwZfg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46eusrrgnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 May 2025 12:45:15 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 545C8DM5002728;
	Mon, 5 May 2025 12:45:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46dxfnp7v6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 May 2025 12:45:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 545CjAQh56623454
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 May 2025 12:45:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DEEF20043;
	Mon,  5 May 2025 12:45:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EB7D20040;
	Mon,  5 May 2025 12:45:10 +0000 (GMT)
Received: from [9.111.162.37] (unknown [9.111.162.37])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 May 2025 12:45:10 +0000 (GMT)
Message-ID: <9c50b5ad-39ae-4c0e-ac9b-ee95e8b7e8b0@linux.ibm.com>
Date: Mon, 5 May 2025 14:45:09 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s390/sha512 - Fix sha512 state size
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
References: <632df0c6adc88f82d27bbabcc3fc6d7f@linux.ibm.com>
 <aBCX_l0kSHVx4xQn@gondor.apana.org.au>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <aBCX_l0kSHVx4xQn@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HXn7LYSyB806AsiPOrXavZgAB1SIbl20
X-Authority-Analysis: v=2.4 cv=dMSmmPZb c=1 sm=1 tr=0 ts=6818b2db cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=9qcPPypGzFYYKdnir20A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: HXn7LYSyB806AsiPOrXavZgAB1SIbl20
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDExNiBTYWx0ZWRfX45OkBb3tQnXE Qzw83BxmaltJMBWmOvtGouD2qrD/N44WeztjNiLUYdbxaqTmdYo/XD+KVSPrbtRL0Ne2y8MaT+n S8o5QfPoawitXYjCBE35ZHii8IpnA7V+uhKRKxiMbqMeLI0P/4nyFdaF+sur4PSyKHX/TP6Vc3k
 V3ULtc7OvSqGBNZ4RZkNxngQqqbjFHLerdoHcF1kpIXRbNnFfjhxLc2YU1qvQWcm++hZX2rbRV6 WLf8NQkleqoUiL2HG1AzvUVHpIF1IZnfWXopB0QqR7gU2HXpndjWRhoTePQYYFO1y4EURYWT7pT jQFDsrUruyCxjlL3IWsKTu08587kb1l3RTSz+hsMOgYRX5LBYlEdAlVfoN4C1EwxJRHueoYIgOS
 WLlad1IBVM1pQIf/6vGXEIrd2Th0YWmpYw/96HQ9Em7VOS7wLtOnPnm8C6pAVxRiI70FFVdK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_05,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505050116

On 29.04.2025 11:12, Herbert Xu wrote:


> diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
> index 14818fcc9cd4..3c5175e6dda6 100644
> --- a/arch/s390/crypto/sha512_s390.c
> +++ b/arch/s390/crypto/sha512_s390.c
> @@ -22,13 +22,13 @@ static int sha512_init(struct shash_desc *desc)
>  	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
>  
>  	ctx->sha512.state[0] = SHA512_H0;
> -	ctx->sha512.state[2] = SHA512_H1;
> -	ctx->sha512.state[4] = SHA512_H2;
> -	ctx->sha512.state[6] = SHA512_H3;
> -	ctx->sha512.state[8] = SHA512_H4;
> -	ctx->sha512.state[10] = SHA512_H5;
> -	ctx->sha512.state[12] = SHA512_H6;
> -	ctx->sha512.state[14] = SHA512_H7;
> +	ctx->sha512.state[1] = SHA512_H1;
> +	ctx->sha512.state[2] = SHA512_H2;
> +	ctx->sha512.state[3] = SHA512_H3;
> +	ctx->sha512.state[4] = SHA512_H4;
> +	ctx->sha512.state[5] = SHA512_H5;
> +	ctx->sha512.state[6] = SHA512_H6;
> +	ctx->sha512.state[7] = SHA512_H7;
>  	ctx->count = 0;
>  	ctx->sha512.count_hi = 0;
>  	ctx->func = CPACF_KIMD_SHA_512;

We still get one selftest failure on sha384:

/proc/crypto:
name         : sha384
driver       : sha384-s390
module       : sha512_s390
priority     : 300
refcnt       : 1
selftest     : unknown   <---------
internal     : no
type         : shash
blocksize    : 128
digestsize   : 48

Syslog:
alg: shash: sha384-s390 test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"

Shouldn't the sha384_init() function also use array indexes 0-7 like your fix in sha512_init() ?
It currently is:

 static int sha384_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 
 	*(__u64 *)&ctx->state[0] = SHA384_H0;
 	*(__u64 *)&ctx->state[2] = SHA384_H1;
 	*(__u64 *)&ctx->state[4] = SHA384_H2;
 	*(__u64 *)&ctx->state[6] = SHA384_H3;
 	*(__u64 *)&ctx->state[8] = SHA384_H4;
 	*(__u64 *)&ctx->state[10] = SHA384_H5;
 	*(__u64 *)&ctx->state[12] = SHA384_H6;
 	*(__u64 *)&ctx->state[14] = SHA384_H7;
 	ctx->count = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
 
 	return 0;
 }

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
