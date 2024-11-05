Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0A31B3951
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730814129; cv=none; b=CQY33A1eSyYVfc9ncSSG9UOXSdmheqNIHkiT2zTZ5DjnbaHFqRcUNSWKTuakRV1Myir9gbKlLN1Cvbq6Wzz8BaJIH112NE01xugpKVbdTmZXzSXJuJzQJwjIWiqOS8KCYdUhG7TU3f57G/W6v7XPyelsoYyqAcq13WnICbV4Yvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730814129; c=relaxed/simple;
	bh=SOrJ7VkRtcEOzHqGVdGa/P+BLxulsoETsY4GRPLrXzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q+KlPwDt5KOidpqGX32+l5AUZQ5EmHNw5Waqjwmq71KJx95tLr0KkQnRXRcp03AYI+3leLu9+nKmw7qR+/iFblmfG/4CgyGhvJ/8kkcMXei9X7EBIopM/905jFrNP1/SWcdBkrIBahgV6TygQiSjPm/vlTLk4b9iKD36mCXO8gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gHW3AzIx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gHW3AzIx"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5Ddfwm024403;
	Tue, 5 Nov 2024 13:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eBi3F+
	CbVbvcOtKnbgvNiNSfPu8aZAwqGWpDBRobYD0=; b=gHW3AzIxAALEQW65x+kejo
	9BqAte4aR2jDMhkh2HOa28god9kDzTzKCecSzDSaa4Lfys0VQMDvjiYiUp9JJX0b
	CEap8NkwNIf38Ik39Pw2q6GDqAKqHAYdN8UNyucX6x3iVlJgOyWcLTm4cd8NoDRb
	f1H1srCOflJAhB36opP2L20o6k15DmZg2+viMQc9nS9LcGGT4NxgNPYU+TDJGAgs
	9JnR9yb9Qw2x455Lx6H6PaAUclGgVZqXMO/00UD7AMT4EwN/LSwCmPfXrowyaGXZ
	K5xkQT207mD922rhw4O/uTzxAFtEBsyYT4SXB4K2L6sDSBevo7wJfAiY4x9j42sw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42qmepg0kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:42:00 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A58hggB019080;
	Tue, 5 Nov 2024 13:41:59 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42p0mj45c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:41:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A5DfuVJ19202530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Nov 2024 13:41:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EFF42004B;
	Tue,  5 Nov 2024 13:41:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FDE320043;
	Tue,  5 Nov 2024 13:41:56 +0000 (GMT)
Received: from [9.152.224.243] (unknown [9.152.224.243])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Nov 2024 13:41:56 +0000 (GMT)
Message-ID: <b52a986c-5be2-4ed9-b1c3-841fb2d94a74@linux.ibm.com>
Date: Tue, 5 Nov 2024 14:41:56 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/3] s390/crypto: New s390 specific shash phmac
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, hca@linux.ibm.com
Cc: linux-crypto@vger.kernel.org
References: <20241030162235.363533-1-freude@linux.ibm.com>
 <20241030162235.363533-4-freude@linux.ibm.com>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20241030162235.363533-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zHggPzyMV3c8OXi6xUzMvrtPt6eI-b7Q
X-Proofpoint-ORIG-GUID: zHggPzyMV3c8OXi6xUzMvrtPt6eI-b7Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411050105

On 30/10/2024 17:22, Harald Freudenberger wrote:
> From: Holger Dengler <dengler@linux.ibm.com>
> 
> Add support for protected key hmac ("phmac") for s390 arch.
> 
> With the latest machine generation there is now support for
> protected key (that is a key wrapped by a master key stored
> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> for the s390 specific CPACF instruction kmac.
> 
> This patch adds support via 4 new shashes registered as
> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> 
> Please note that as of now, there is no selftest enabled for
> these shashes, but the implementation has been tested with
> testcases via AF_ALG interface.
> 
> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  arch/s390/configs/debug_defconfig |   1 +
>  arch/s390/configs/defconfig       |   1 +
>  arch/s390/crypto/Makefile         |   1 +
>  arch/s390/crypto/phmac_s390.c     | 484 ++++++++++++++++++++++++++++++
>  drivers/crypto/Kconfig            |  12 +
>  5 files changed, 499 insertions(+)
>  create mode 100644 arch/s390/crypto/phmac_s390.c
> 
[...]
> diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
> new file mode 100644
> index 000000000000..7f68ba29626f
> --- /dev/null
> +++ b/arch/s390/crypto/phmac_s390.c
> @@ -0,0 +1,484 @@
[...]
> +static int s390_phmac_sha2_clone_tfm(struct crypto_shash *dst,
> +				     struct crypto_shash *src)
> +{
> +	struct s390_phmac_ctx *dst_ctx = crypto_shash_ctx(dst);
> +	struct s390_phmac_ctx *src_ctx = crypto_shash_ctx(src);
> +	int rc;
> +
> +	rc = s390_phmac_sha2_init_tfm(dst);
> +	if (rc)
> +		return rc;
> +
> +	if (src_ctx->key && src_ctx->keylen) {
> +		dst_ctx->key = kmemdup(src_ctx->key, src_ctx->keylen,
> +				       GFP_KERNEL);
> +		if (!dst_ctx->key)
> +			return -ENOMEM;
> +		dst_ctx->keylen = src_ctx->keylen;
> +		return phmac_convert_key(dst_ctx);

This will clone only parts of the tfm_ctx, e.g. the function code (fc) is missing. I would highly recommend to just call setkey() here instead. 

> +	}
> +
> +	return 0;
> +}

[...]
> +static int __init phmac_s390_init(void)
> +{
> +	struct s390_hmac_alg *hmac;
> +	int i, rc = -ENODEV;
> +
> +	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_256))
> +		return -ENODEV;
> +	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_512))
> +		return -ENODEV;

These two check are not neccessary. Please remove them.

[...]

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

