Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E15142E70
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723625887; cv=none; b=MuD5J+ATbt22v2CG9s+P/IzNi/hefvON+argetNpuwhWPXRvZzoRHEqtj8WgBT/JaYLPpasgY6A0/PRdVFKVRIBcT8bKR1IlhHLESEcyF8kSRSw72kLuViUJ/4e1CmchDGkXVEc4XG4ov6Kbm7yxmh/X9lXjP8mrKAZh42ssvmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723625887; c=relaxed/simple;
	bh=nKfIWh5tTXBWbHuSF6DmM/umryirIIkMzXbySRjO3bQ=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=rnVm+zrtjL8rTIEM2agmGGAolZHXLDRkmKuj/qrD9NTDPqBlSeuqTpUsEMTxIMs2IQ5CivS7bLBImlqsAryCNcb5xQ/n0tLFiY7yv5nfJSbai5mqdpNJbPsnNBsAQnhwJcUKkVjtDOR/UU9kj0AMeEHGhJIKJkXHI3EWZ0dmq24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YdUj2Me5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YdUj2Me5"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47E8ctfh007540;
	Wed, 14 Aug 2024 08:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	mime-version:date:from:to:cc:subject:reply-to:in-reply-to
	:references:message-id:content-type:content-transfer-encoding;
	 s=pp1; bh=oNE7YUbR9F5FZRA6oSai4Ae9eOaSBu5JA+0MCethd7E=; b=YdUj2
	Me52zQlWagrosWAmeD+eTCiGWSOTEmZ4EZV8CsFlXT2SKANep/Rbsj5gcRBSHgO0
	gUnhR1la8MFAsg9zBJcIMJYkD+hnDoqbkqDa3cIPSHvO6dkziynterfYYwslurPO
	gvRVoVf+P+lWN3AfAU30YDsQk1OAz5rBM27/fsHJ1DfygiGN3GULwsrhabdJgChr
	LBauJfujwn0JoIbQ+sCPgPOhgwtM6bkV1Fh/mzJ/q526uOXUznwwVsKI6ni6ZIiC
	4fA7zbRDcnq1yum+sas2ddey9kwtnT2AU+9m6tdbkVKqhvjQKIuM9WYzCJXydDtP
	wkxBF34yslN6lM9Vw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 410s8g81sh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Aug 2024 08:53:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47E6DZiQ015888;
	Wed, 14 Aug 2024 08:52:58 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40xm1mreaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Aug 2024 08:52:58 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47E8qtnj59900238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 08:52:58 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D94A45805B;
	Wed, 14 Aug 2024 08:52:55 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8473C58058;
	Wed, 14 Aug 2024 08:52:55 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Aug 2024 08:52:55 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 Aug 2024 10:52:55 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Holger Dengler <dengler@linux.ibm.com>
Subject: Re: RFC: s390/crypto: Add hardware acceleration for HMAC modes
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <ZrsVYl3NYdRbUMNm@gondor.apana.org.au>
References: <20240807160629.2486-1-dengler@linux.ibm.com>
 <20240807160629.2486-3-dengler@linux.ibm.com>
 <8511b5079e158b79232f7be9d03fbba5@linux.ibm.com>
 <ZrsVYl3NYdRbUMNm@gondor.apana.org.au>
Message-ID: <e3ee41957dea7c296aece5daa56a692b@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RJG8R_XA5dDdpiOsPQ727fde1px_OOI3
X-Proofpoint-ORIG-GUID: RJG8R_XA5dDdpiOsPQ727fde1px_OOI3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-14_05,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 phishscore=0 spamscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2408140059

On 2024-08-13 10:12, Herbert Xu wrote:
> On Tue, Aug 13, 2024 at 09:37:24AM +0200, Harald Freudenberger wrote:
>> 
>> +static int hash(const u8 *in, unsigned int inlen,
>> +		u8 *digest, unsigned int digestsize)
>> +{
>> +	struct crypto_shash *htfm;
>> +	const char *alg_name;
>> +	int ret;
>> +
>> +	switch (digestsize) {
>> +	case SHA224_DIGEST_SIZE:
>> +		alg_name = "sha224";
>> +		break;
>> +	case SHA256_DIGEST_SIZE:
>> +		alg_name = "sha256";
>> +		break;
>> +	case SHA384_DIGEST_SIZE:
>> +		alg_name = "sha384";
>> +		break;
>> +	case SHA512_DIGEST_SIZE:
>> +		alg_name = "sha512";
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	htfm = crypto_alloc_shash(alg_name, 0, CRYPTO_ALG_NEED_FALLBACK);
>> +	if (IS_ERR(htfm))
>> +		return PTR_ERR(htfm);
>> +
>> +	ret = crypto_shash_tfm_digest(htfm, in, inlen, digest);
>> +	if (ret)
>> +		pr_err("shash digest error: %d\n", ret);
>> +
>> +	crypto_free_shash(htfm);
>> +	return ret;
>> +}
> 
> The setkey function can be called in softirq context.  Therefore
> calling crypto_alloc_* from it is not allowed.  You could either
> move the allocation to init_tfm and carry it throughout the life
> of the tfm, or perhaps you could call the s390 underlying sha hash
> function directly?
> 
> Cheers,

Ok, good catch. I'll discuss this with Holger when he is back from 
vacation.

Thanks for your work.
