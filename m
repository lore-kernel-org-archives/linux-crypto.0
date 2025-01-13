Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8353231A5B;
	Mon, 13 Jan 2025 07:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736754324; cv=none; b=kti+/7SSXtYuXPuAuQrH3j00bSbQ8gUJb+v6AcVJc7q+3DfYOZySZm3KxOW+MPGWay2895OrYCsklYTyQ8yOQTtfjIZfd19unaWKdOaSDwxSU194DoTYCjhEtlS6R3jq8npRh4ZCXOlfxXbvkAJZ30SZr8eXLW6LGL5edGH+1BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736754324; c=relaxed/simple;
	bh=9UR7XaoBIYrEopR0bb2oUMRVAgfO1MuY5IfgY85cJOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EJK7R/dCNnb9IjjrkM4zMmvmRrKJ5A9xTNLWhllN9kG73Gz5S8kj3kUireAYDXzObnA16Glz/E/YK+83QQCTK6XVRbAzB9f2Gfq1ew3ySXzXs/jnrf2zI0bS2DPG+T327sEtcvlXL8lSpvW3vvm8flgpbQO5tXe/kiFIIig5ARs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CH1efmUL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CH1efmUL"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50CIh68e017895;
	Mon, 13 Jan 2025 07:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HMqDm+
	1QhqmjUgeavGWF0V6HolHyRYX3RZXiz/vg2fc=; b=CH1efmULdEOjf0S02NUq+a
	EkNeAVrPLd0KkjULDso3Nxs9E14l3Ped/yIYrC5QUkWM7GgXDnywgjy7+JqnTsgv
	pIjfUC0GoEZsrRLBCiZ7z/EswHc421mLvgrO58dnCIvI2qP9N6NrceKUPK1ps5VP
	disMMxtsWBUUHup7V+YUxOonxtwn6biLhDQPrz1uUKNLFfRcuN/XqfgsvdNB3gIV
	pzFRPh2G1+lVtTQZXZLpvyjVU4QPDJHfBNEoAJkJMmiHWSvnGGvv7FkuD4IjduxQ
	vyJN8RmAtCvRhqrcdtB0tKdaerDQhu8f9SakcC81kaeGNvCBC8GyDanFlUAxIiog
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 444f74jh63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 07:45:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50D5Q5Tx001089;
	Mon, 13 Jan 2025 07:45:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456jmv49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 07:45:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50D7jE0252363760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 07:45:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D405B2004E;
	Mon, 13 Jan 2025 07:45:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 896BB20040;
	Mon, 13 Jan 2025 07:45:14 +0000 (GMT)
Received: from [9.179.7.252] (unknown [9.179.7.252])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 13 Jan 2025 07:45:14 +0000 (GMT)
Message-ID: <7ceb1b7d-30ad-443a-8719-1f8747f3d2a1@linux.ibm.com>
Date: Mon, 13 Jan 2025 08:45:14 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/3] s390/crypto: Enable phmac selftest invocation
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20250102094615.99181-1-freude@linux.ibm.com>
 <20250102094615.99181-4-freude@linux.ibm.com>
Content-Language: de-DE, en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250102094615.99181-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0ZHGVv3TMPYOB0LUpjAVgjip5vSUCTb2
X-Proofpoint-ORIG-GUID: 0ZHGVv3TMPYOB0LUpjAVgjip5vSUCTb2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxlogscore=941 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501130063

On 02/01/2025 10:46, Harald Freudenberger wrote:
> - Add a little helper inline function
>     crypto_tfm_alg_get_flags()
>   to crypto.h to retrieve the alg flags.
> - Add key preparation code in case of selftest running
>   to the phmac setkey function.
> - Add phmac selftest invocation to the crypto testmanager.

Can you please split this self-test enablement for phmac into a separate patch series.

> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  arch/s390/crypto/phmac_s390.c | 144 ++++++++++++++++++++++++++++++++--
>  crypto/testmgr.c              |  30 +++++++
>  include/linux/crypto.h        |   5 ++
>  3 files changed, 174 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
> index b2b389e94a37..3d80168775ab 100644
> --- a/arch/s390/crypto/phmac_s390.c
> +++ b/arch/s390/crypto/phmac_s390.c
[...]
> @@ -687,10 +799,26 @@ static int s390_phmac_setkey(struct crypto_ahash *tfm,
>  		tfm_ctx->keylen = 0;
>  	}
>  
> -	tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
> -	if (!tfm_ctx->key)
> -		return -ENOMEM;
> -	tfm_ctx->keylen = keylen;
> +	if (crypto_tfm_alg_get_flags(tfm_base) & CRYPTO_ALG_TESTED) {
> +		/* no selftest: key is always a key token digestable by PKEY */
> +		tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
> +		if (!tfm_ctx->key) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +		tfm_ctx->keylen = keylen;
> +	} else {
> +		/* selftest running: key is a raw hmac clear key */
> +		tfm_ctx->keylen = sizeof(struct hmac_clrkey_token) + bs;
> +		tfm_ctx->key = kzalloc(tfm_ctx->keylen, GFP_ATOMIC);
> +		if (!tfm_ctx->key) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +		rc = make_clrkey_token(key, keylen, ds, tfm_ctx->key);
> +		if (rc)
> +			goto out;
> +	}

I would prefer, if the conversion of the self-test clear-key is an additional code path and not a replacement. I know, that this might end up in an additional memory allocation, but I think it is worth to do so.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

