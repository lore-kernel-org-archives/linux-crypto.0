Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F982296FB5;
	Fri, 23 May 2025 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748011956; cv=none; b=n8liAFgOsZT2M7C+p0SRylciiQujm89Kov7Wigc2AjzXwuB5qIDSCW6ZYgDBcpsmficLNbNfX/B4Qkv8LkjhNheTgwwYQFc9iJPrYRb+qnM9sVonb99HbQOveerJ18Oxi4dyV/e7MFwQJzC05+XCt8Q8F0IHQsX5WUf33nwjXGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748011956; c=relaxed/simple;
	bh=+MJiwlZWvXhDPE9kpI43GVSLiUWQd7Gbvjsu/hdzMcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BH2tFEXRz/YdArH+v3zr6qE6TP/UKj1vrP0d2GlHKnYwtCW4mlQcbFHuk9NAXTZbXo4swq5bwBAn7w/UGBQE59JgcqH7V4Uw+WS1Gs9xgdsL2tYUtCpkLAAZaGhf/h+We45UfFcoeT2YDuJlfv0pcwZicswZAs3ay9mlApNvu2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l+hAM7fT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l+hAM7fT"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NB5vKN009195;
	Fri, 23 May 2025 14:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oanZTE
	KttunMQXmCVrew/bO1hrnnxAliy3UF3i2/xNo=; b=l+hAM7fTWG8zh9Pi6gMuVl
	y5L7UTsLmgxPlb6OWO0yag20KfwXxu4dHpSftJR+G/gruBUmJfH1gc+qPY39388a
	D8XHmF/iq+3Qtr1lQl327XkBS9xnVO9qciuuKqs6mPVczjoEi+4LQDKyhhn7X8u7
	ylBLJHgDKLyD3hdH3iYxvYDzJ1gbHsPc0dY7PDOz/DUqGgKqWmhoUsXxuRWibeXN
	A4WVO0WBkw44KsSE8m/KphOwBRIzU4VstVe5PZHoTqghMYeJOHIBtWuStattTuaR
	BLpEKaKmd869XaK100Zy/8JwXxtmFCpNcdrZi01w+ZlD5b6kFKwJcLXFXXMeTaiw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t55364u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 14:52:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NEmf6o032087;
	Fri, 23 May 2025 14:52:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmpyq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 14:52:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NEqPZG4719326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 14:52:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3ADD52004B;
	Fri, 23 May 2025 14:52:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6B7020040;
	Fri, 23 May 2025 14:52:24 +0000 (GMT)
Received: from [9.111.78.193] (unknown [9.111.78.193])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 14:52:24 +0000 (GMT)
Message-ID: <667f78e9-1058-45ed-8d86-f8bfb98bcded@linux.ibm.com>
Date: Fri, 23 May 2025 16:52:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/6] s390/crypto: New s390 specific protected key hash
 phmac
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-4-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250522085755.40732-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S7C6pmWiot9BVlXAFTAok4Joug5ZVBqs
X-Proofpoint-ORIG-GUID: S7C6pmWiot9BVlXAFTAok4Joug5ZVBqs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDEzMCBTYWx0ZWRfX9m6dfZIbieuq n+OJA2Aj7wHVFitG88xntQ5Izhk/lxBXvEdR9cNo29LB+cLOD8TFrFIP+Km3QJhpYL5/bO2tSl/ 1FBNndeFLCTzA4G3mkKNqPxKDbQYE/6L4qWdkEHmMmIJK3Ic2WUWTLZa0NkgwJLU/rncDI1ah/8
 fage732tXgoGxNI4TNsKPjP9WuKATatQDKSFD7/AkQGN6z1+Ckoq9yXmPcdKqa3yUxQhNwGpxog WBOej7P2EQtxRGrLIW6s8zWGCZBr4p2PuvWP6FoL+ljtFCmGerXjBcnm3vqMRnsJwA4QLOsXd+I L3d5/d+/NBo5GLvH3o2oW92Bh9RqZdQiIm3oKT4DRYsV93UorND26kG/XOEAhAseIpU8TcE4Zas
 Zv2wkVHbQib6L6eJyY4ed5otwvyB1r8C4hhPZnWCth1uykfN8dz2HB/rL7Vg9M4+37fFtofC
X-Authority-Analysis: v=2.4 cv=BOmzrEQG c=1 sm=1 tr=0 ts=68308bad cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=hx5GYAagJ-RlrTjt-HMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230130

On 22/05/2025 10:57, Harald Freudenberger wrote:
> Add support for protected key hmac ("phmac") for s390 arch.
> 
> With the latest machine generation there is now support for
> protected key (that is a key wrapped by a master key stored
> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> for the s390 specific CPACF instruction kmac.
> 
> This patch adds support via 4 new ahashes registered as
> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> 
> Co-developed-by: Holger Dengler <dengler@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

See my comments below. The rest looks good to me.

> ---
>  arch/s390/configs/debug_defconfig |   1 +
>  arch/s390/configs/defconfig       |   1 +
>  arch/s390/crypto/Makefile         |   1 +
>  arch/s390/crypto/phmac_s390.c     | 899 ++++++++++++++++++++++++++++++
>  drivers/crypto/Kconfig            |  12 +
>  5 files changed, 914 insertions(+)
>  create mode 100644 arch/s390/crypto/phmac_s390.c
> 
[...]
> diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
> new file mode 100644
> index 000000000000..b61454dedf0a
> --- /dev/null
> +++ b/arch/s390/crypto/phmac_s390.c
> @@ -0,0 +1,899 @@
[...]
> +struct kmac_sha2_ctx {
> +	u8 param[MAX_DIGEST_SIZE + MAX_IMBL_SIZE + PHMAC_MAX_PK_SIZE];
> +	union kmac_gr0 gr0;
> +	u8 buf[MAX_BLOCK_SIZE];
> +	unsigned long total;

The clear-key hmac switched to u64[2] instead of unsinged long for `total`. Please synchronize with clear-key hmac.

> +};
> +
[...]
> +/*
> + * kmac_sha2_set_imbl - sets the input message bit-length based on the blocksize
> + */
> +static inline void kmac_sha2_set_imbl(u8 *param, unsigned long nbytes,
> +				      unsigned int blocksize)

Same here. I would prefer to use this in the phmac as well.

[...]
> +static void s390_phmac_exit(void)
> +{
> +	struct phmac_alg *phmac;
> +	int i;
> +
> +	if (phmac_crypto_engine) {
> +		crypto_engine_stop(phmac_crypto_engine);
> +		crypto_engine_exit(phmac_crypto_engine);
> +	}
> +
> +	for (i = ARRAY_SIZE(phmac_algs) - 1; i >= 0; i--) {
> +		phmac = &phmac_algs[i];
> +		if (phmac->registered)
> +			crypto_engine_unregister_ahash(&phmac->alg);
> +	}
> +
> +	misc_deregister(&phmac_dev);

The misc_register() call in module init is missing, see my comment to patch 5/6.

> +}
> +
> +static int __init s390_phmac_init(void)
> +{
> +	struct phmac_alg *phmac;
> +	int i, rc;
> +

The misc_regsiter(&phmac_dev) should go here.

[...]

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

