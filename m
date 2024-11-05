Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284E113E04B;
	Tue,  5 Nov 2024 16:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730822886; cv=none; b=kBOwp/0jt7J/TwTaSN1CfovUl7J5JkfvFn7g7n1S/0PX/dq8w+NL3dK4u89x6lAYrKodbR46SToe+u3ygcWRvrZRgnPu8Zs/lRLPCg0NvG5iH9GVZ0ULjxVgapAF7aAAdIuBjVkQAU48c1PMCXPFw0EMpdyLJDmO9QgdNGnjjL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730822886; c=relaxed/simple;
	bh=GnvD6s9MeTiXCjVbmwdRNdrYglCDctBXp6jTZChnCNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDlbMzFCgH+OcT+wZe7EjZgNR/P2vP9PhMXghA5knEv02tX9XsP8CFr6Sm/1A/X1/9PgH9IWCHLMxDSAcTLZKHtVy278O/tW39Ws1g3GBbOr6gPqDIvEeF/YhOF9r5MTEvz/cXkbaDyFqQEU7+9GYa840umfPm3hKVKqrdrFJJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AjadvngL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AjadvngL"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5Fdt1g017497;
	Tue, 5 Nov 2024 16:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ajb5XI
	wuc91MXG2T4vk9EwqnUW1WO2OidJO49fMqsDk=; b=AjadvngLLDO53OrCHTU9df
	qjeuvsDRVKRzkr0UiSCrG8GxKDwJ+GGdDfkaXQ6kKzky+mnpTTwahpALx6a7GQRN
	KhXyqeqN+8dv5OSHfaPS6Gd1t9y5Ak0unjZlJ7P4spUaI9NCF5HiJfyZsbD+Bjfg
	rfoXud3hqoCKByD6LtSwF5RZ6s/JqwKaw8GhD+whlf0EIl88E/s21CeoZg+LtSl7
	ousVo+RzIwRwsSin7wfTByyRQLfhLvhks03JsQNN5OySvX+m3F70OnbuFBnr+w/A
	cISeJnG2UAmDtWy/Z0NEDGj7rfA50YeaDB4qXRoSCxpoLpcNGBcmLgXNs2c8EY6Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42qp6wr316-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 16:02:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A57JSqE031516;
	Tue, 5 Nov 2024 15:34:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nydmmcvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 15:34:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A5FXvmA56230158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Nov 2024 15:33:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9A3E20043;
	Tue,  5 Nov 2024 15:33:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B887B20040;
	Tue,  5 Nov 2024 15:33:57 +0000 (GMT)
Received: from [9.152.224.243] (unknown [9.152.224.243])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Nov 2024 15:33:57 +0000 (GMT)
Message-ID: <26ee840b-bff5-4cbb-9e12-ed15d28777a4@linux.ibm.com>
Date: Tue, 5 Nov 2024 16:33:57 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] s390/crypto: New s390 specific shash phmac
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20241105135833.391957-1-freude@linux.ibm.com>
 <20241105135833.391957-4-freude@linux.ibm.com>
Content-Language: de-DE, en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20241105135833.391957-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aZlSjl6yXQJ_CxqhMCLRl9j66ssBd84O
X-Proofpoint-GUID: aZlSjl6yXQJ_CxqhMCLRl9j66ssBd84O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 clxscore=1011 mlxlogscore=863 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2411050121

On 05/11/2024 14:58, Harald Freudenberger wrote:
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
>  arch/s390/crypto/phmac_s390.c     | 468 ++++++++++++++++++++++++++++++
>  drivers/crypto/Kconfig            |  12 +
>  5 files changed, 483 insertions(+)
>  create mode 100644 arch/s390/crypto/phmac_s390.c
> 
[...]
> diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
> new file mode 100644
> index 000000000000..10835fcb818a
> --- /dev/null
> +++ b/arch/s390/crypto/phmac_s390.c
> @@ -0,0 +1,468 @@
[...]
> +static int s390_phmac_sha2_clone_tfm(struct crypto_shash *dst,
> +				     struct crypto_shash *src)
> +{
> +	struct s390_phmac_ctx *src_ctx = crypto_shash_ctx(src);
> +	int rc;
> +
> +	rc = s390_phmac_sha2_init_tfm(dst);
> +	if (rc)
> +		return rc;
> +
> +	return s390_phmac_sha2_setkey(dst, src_ctx->key, src_ctx->keylen);

You should call setkey() only if the key in src_ctx has been set.

return src_ctx->key ? s390_phmac_sha2_setkey(dst, src_ctx->key, src_ctx->keylen) : 0;

> +}

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

