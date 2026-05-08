Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7737647E;
	Fri,  8 May 2026 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778250989; cv=none; b=ZhW1IdsBinvhB2FVz9ucUOf0P24EfM3Z8J8b32hdViJe2Nmv0+hQckm8IE12hLOZhrmA7tXpy0LAHTefvthZrH/fFZ+EoiRLWETKwytY1sH97acGXtVM5XLszuM67AKS9YPh0aKwl+D29y4QWD5NHax15KiY0XVOlt4H8VVUFI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778250989; c=relaxed/simple;
	bh=HTzF3qjbOgYeg9orOUtAOFYiCZ+t9zseChnZnB9wafc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pwqDONF7XAvMi3GZBMFGSGklMfdTDsq4SoFhMcWEjUKHqftNQ4oQXjF3o36KihPjYeCaQCBsKwCwFr//Ml+RoDgyCmyEG2hjitQleWNZSJNamzk2mR755owr7Xn1ph+9X9ZTmEcsASImbptkGocFIvzjFox4Qckm+m9/VAP2GUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LUnI8b4n; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LUnI8b4n"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6484WM113313225;
	Fri, 8 May 2026 14:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gWIy2r
	fhdV6WhckDQliCixZNUHahLJryHMWsID/dvq4=; b=LUnI8b4nsJGZb5vi264cIS
	ByyD9z/OTphiCN0n4T6lWhX4u4fUEYjLDlQWEbaHdJmr4NCVAqUbjZkNANN9Qvlo
	PyEXK0VyHMGrlvqFUGM3Ksr+crD1ccZesgz5QrgbTd+jSAxTn/vSrOK92pkZLZpQ
	ePa18NHl08HlTwTQ6xd5DXmsYPEVvk72XqsrfV75c8WxlxTeeOne1hPLwNhohVbm
	JfzwnUW71kvN/aTMv+8RjlEYvDL7LAG6kuCzWTZQH+HfBhB1/7xLsDfbsFSDAnzn
	0oq1k2G+cEgYj9rN9BOSIXCiE5VJPcl+ky4u7MD7s5zKy6PxN0J3u3tvPrsZLiCg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1v3et-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:36:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 648EOgXA016049;
	Fri, 8 May 2026 14:36:19 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3hgg1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:36:19 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 648EaIDJ15139436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 14:36:18 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2214058058;
	Fri,  8 May 2026 14:36:18 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A78158059;
	Fri,  8 May 2026 14:36:17 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 May 2026 14:36:17 +0000 (GMT)
Message-ID: <73f5e02d-d154-47b9-b876-f8c6c184db2f@linux.ibm.com>
Date: Fri, 8 May 2026 10:36:16 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto : ecc - Fix carry overflow in vli multiplication
To: Anastasia Tishchenko <sv3iry@gmail.com>, Lukas Wunner <lukas@wunner.de>,
        Ignat Korchagin <ignat@linux.win>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260508114844.29694-1-sv3iry@gmail.com>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20260508114844.29694-1-sv3iry@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: x-JSgRWe9DDA-P8-pn_FEvAfXL9eYELI
X-Proofpoint-GUID: FEgelG7xWC-hq_a6A92BmNwlhH2hBDDW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDE1MCBTYWx0ZWRfX+Hvlnijp83Ba
 A8cQ7YYyrm/7AxwQ/Q9KINxA7IaQmdltHikhZWIthdGu5IlQ6vNOiIITv0tOmcmy++5NRgWtavG
 Whr1GRbJIaH2lUdVAwAsjdSDe0lnWNghuRiOaHXotqiiiZ6Rt5i1hC+DdxX/HSSCiFgMFJKw+2p
 aKmffYbGOJPNtG+5ZSYio6gCw0BD1XaDNEd4R8on6x0LeA0aq1k/9kn/hYyIBoPDj+3DIrICLzh
 qKGugt8gR8lnFl3vJ/PCziDfqyZu8qEbnbxSha0T3KXjgLesnv/ctuvFa+lsmzZHTk+Y5pSE8w8
 QYmYqup0RjekN/BTexaLNocE0MlZjbQmZhCl2dyAU9aby0ACbhhBRkCH7EyxIw9vkuY3y/PCe+P
 guQfDzyphsyGeohzSLdTMUIJqvtTZkvsghqJUntPy4xPmjniDNHIYO8B0G6RsEJAib3DdD9K+IB
 tpLmH4iGsf9Fr4GCNbg==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69fdf4e4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8
 a=q09hNBxbWzpWlAAnaukA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080150



On 5/8/26 7:48 AM, Anastasia Tishchenko wrote:
> The carry flag calculation fails when r01.m_high is saturated
> (0xFFFFFFFFFFFFFFFF) and addition of lower bits overflows.
> 
> The condition (r01.m_high < product.m_high) doesn't handle the case
> where r01.m_high == product.m_high and an additional carry exists
> from lower-bit overflow.
> 
> Add proper handling for this boundary by accounting for the carry
> from the lower addition.
> 
> This issue was discovered during formal verification of ECC functions.

Thanks!

> 
> Signed-off-by: Anastasia Tishchenko <sv3iry@gmail.com>
> ---
>   crypto/ecc.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 43b0def3a225..dfe96471407c 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -427,7 +427,10 @@ static void vli_mult(u64 *result, const u64 *left, const u64 *right,
>   			product = mul_64_64(left[i], right[k - i]);
>   
>   			r01 = add_128_128(r01, product);
> -			r2 += (r01.m_high < product.m_high);

Maybe the following or something like lt_128(r01, product) would be 
'better' replacing 'r01 < product':

if (cmp_128(r01, product) < 0)
     r2++;

/* Compare two uint128_t; returns -1 if a<b, 0 if a == b, 1 otherwise */
static int cmp_128(uint128_t a, uint128_t b)
{
     if (a.m_high < b.m_high)
        return -1;
     if (a.m_high > b.m_high)
        return 1;
     if (a.m_low < b.m_low)
        return -1;
     if (a.m_low > b.m_low)
        return 1;
     return 0;
}



/* r01 < product */
if (lt_128(r01, product))
     r2++;

/* Check a < b; return 1 if a < b, 0 otherwise */
static int lt_128(uint128_t a, uint128_t b)
{
     if (a.m_high < b.m_high)
        return 1;
     if (a.m_high > b.m_high)
        return 0;
     if (a.m_low < b.m_low)
        return 1;
     return 0;
}

> +			if (r01.m_high != product.m_high)
> +				r2 += (r01.m_high < product.m_high);
> +			else
> +				r2 += (r01.m_low < product.m_low);
>   		}
>   
>   		result[k] = r01.m_low;
> @@ -488,7 +491,10 @@ static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
>   			}
>   
>   			r01 = add_128_128(r01, product);
> -			r2 += (r01.m_high < product.m_high);
> +			if (r01.m_high != product.m_high)
> +				r2 += (r01.m_high < product.m_high);
> +			else
> +				r2 += (r01.m_low < product.m_low);
>   		}
>   
>   		result[k] = r01.m_low;

