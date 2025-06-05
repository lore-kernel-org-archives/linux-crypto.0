Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5162367C4
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749130148; cv=none; b=cvchsI1NQyciURTg2vNnnwGtJflWYuZ0c3gMWJl9QPDR9Vadxrm7pjxuNOFS44UXk2PD6moRZYXYxrHzd3pjjUX+Bpnn3avAYPntzUO2V7ayagNtvyvNl1AoAOhieHFN0esrQvcHcUks0ZGTouFiKZHk+bejNZKykL4Eh67eOLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749130148; c=relaxed/simple;
	bh=2nkvGSBl5ox/pYySvCXYnjgvrURu9GkrOjEdzWpl3CE=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=oAiJXopTqgnZZyJtzKMpTmA+rRXcO//MST2XRRCzCNvJy46H+jvrMbwzbrBJ3m6C/IEQt5NZB87bc7w5M2rtuU/hiB+Ne4myl96Iv2QWQTEPgSYzNW9OQO+1hjGwuOzTj7OtjrIfgwz3ztqhcf0kD+t4dlg7+w1vGbfEVm3GgfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KbVFrbF3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KbVFrbF3"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555DIl4K017568;
	Thu, 5 Jun 2025 13:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=zBNR2avORbyCh6rzY5bimfANln0Qcf/RguZ4j1rQioI=; b=KbVFrbF3KcCE
	HWqUJq+8EZlS82/lV78lcIf+4dRh9JCrYdB48hq4d1e45xtcWKYeNkkMePF/ZZg/
	zb5mcyiNTqEzZve/J8ZQNozj3oxckwwzKTchdWih48uqsyV6azgaUeBKhGe2qn7O
	CSNBNTz5ZrPJ/X7p4NSgQKDppxIxniV1Z9D7rwZRa8Vv+slRKV34c31EESvwGaSP
	VqVTjIxvbIQ2fPRo8WBpze7XZke3pt2cRu3XPQfX7ogiSqMSNO7bhtUtoORTBQy3
	bCE8H/1gTToCVWcWfIqi5l8gaPOaKEUtjZo+7fcge135TeoEUiTFHpU4szvqoCSj
	wtAXE11xnQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 472fwurbb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 13:29:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 555D4X6Y012511;
	Thu, 5 Jun 2025 13:29:02 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 470et2mhbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 13:29:02 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 555DT1XJ26477176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Jun 2025 13:29:01 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78F3A58053;
	Thu,  5 Jun 2025 13:29:01 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00C1958043;
	Thu,  5 Jun 2025 13:29:01 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Jun 2025 13:29:00 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 05 Jun 2025 15:29:00 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Holger Dengler
 <dengler@linux.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: ahash - Add support for drivers with no fallback
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <aEAX4c2vU46HlBjG@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
 <c9e5c4beaad9c5876dc0f4ab15e16f020b992d9d.1746162259.git.herbert@gondor.apana.org.au>
 <74ae23193f7c5a295c0bfee2604b478f@linux.ibm.com>
 <aEAX4c2vU46HlBjG@gondor.apana.org.au>
Message-ID: <c38cecabd936e4fae1ae4639dec3d1ea@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDExMSBTYWx0ZWRfXyAcD6nrJM5m3 6jQ8Wp7IRR6qeaagMyMNzPEB0fWpsBe1L9M25bKz/e5y1hly+nxI1+84UqF3evQSmF/BYeLcHFO vpEQZa83Ox4V8wZPR3g37taZxIbIe7A/kpcljXnuJVKV3OK1KaPauZFTqLLXZ+KsIkzUZAr7bNu
 KQeHZXR6OvZRf+oNR9jSU2LIaLJ8EmovrZFDskLTu2U2dMHMPumjOoLrmra5/Clu4NAsZVUtnVX +r2/qsekkOywTvy9jSR5jvfg3c0+04jmX4ZWlA7vifYkWAP3FlHk2psH4sI/5d9hQnhXs3KCDdg 8h2l2TxUeTq18m68CtAWYRZSXNRDGIoLh/BnrH8FQ9tpZ9XY78BZHtsKM98DeyjiHBhoE2zQFl+
 lPw449Q88MQcTre2yWUum9xLsgVwhUrIOR3k9N/XIveQSxFSiaOPk2qZ381roh+ePiEVeaBP
X-Proofpoint-GUID: WgRXxRrEYwWTofPBByTB94GU_DjaDq9H
X-Proofpoint-ORIG-GUID: WgRXxRrEYwWTofPBByTB94GU_DjaDq9H
X-Authority-Analysis: v=2.4 cv=QtVe3Uyd c=1 sm=1 tr=0 ts=68419b9f cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=FNyBlpCuAAAA:8 a=VnNF1IyMAAAA:8 a=tiGPeMbl3nj_ULYjH6QA:9 a=CjuIK1q_8ugA:10
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_02,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 adultscore=0 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=862 lowpriorityscore=0 spamscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506050111

On 2025-06-04 11:54, Herbert Xu wrote:
> On Tue, Jun 03, 2025 at 03:49:16PM +0200, Harald Freudenberger wrote:
>> Hello Herbert
>> 
>> I am facing a weird issue with my phmac implementation since kernel 
>> 5.15 has
>> been released. The algorithm registers fine but obviously it is not
>> self-tested
>> and thus you can't access it via AF_ALG or with an in-kernel customer.
> 
> So the issue is that this algorithm cannot have a fallback, because
> the key is held in hardware only.
> 
> Please try the following patch and set the bit CRYPTO_ALG_NO_FALLBACK
> and see if it works.
> 
> Thanks,
> 
> ---8<---
> Some drivers cannot have a fallback, e.g., because the key is held
> in hardwre.  Allow these to be used with ahash by adding the bit
> CRYPTO_ALG_NO_FALLBACK.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index e10bc2659ae4..bd9e49950201 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -347,6 +347,9 @@ static int ahash_do_req_chain(struct ahash_request 
> *req,
>  	if (crypto_ahash_statesize(tfm) > HASH_MAX_STATESIZE)
>  		return -ENOSYS;
> 
> +	if (!crypto_ahash_need_fallback(tfm))
> +		return -ENOSYS;
> +
>  	{
>  		u8 state[HASH_MAX_STATESIZE];
> 
> @@ -952,6 +955,10 @@ static int ahash_prepare_alg(struct ahash_alg 
> *alg)
>  	    base->cra_reqsize > MAX_SYNC_HASH_REQSIZE)
>  		return -EINVAL;
> 
> +	if (base->cra_flags & CRYPTO_ALG_NEED_FALLBACK &&
> +	    base->cra_flags & CRYPTO_ALG_NO_FALLBACK)
> +		return -EINVAL;
> +
>  	err = hash_prepare_alg(&alg->halg);
>  	if (err)
>  		return err;
> @@ -960,7 +967,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
>  	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
> 
>  	if ((base->cra_flags ^ CRYPTO_ALG_REQ_VIRT) &
> -	    (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT))
> +	    (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT) &&
> +	    !(base->cra_flags & CRYPTO_ALG_NO_FALLBACK))
>  		base->cra_flags |= CRYPTO_ALG_NEED_FALLBACK;
> 
>  	if (!alg->setkey)
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index b50f1954d1bb..a2137e19be7d 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -136,6 +136,9 @@
>  /* Set if the algorithm supports virtual addresses. */
>  #define CRYPTO_ALG_REQ_VIRT		0x00040000
> 
> +/* Set if the algorithm cannot have a fallback (e.g., phmac). */
> +#define CRYPTO_ALG_NO_FALLBACK		0x00080000
> +
>  /* The high bits 0xff000000 are reserved for type-specific flags. */
> 
>  /*

Works perfect - tested on a fresh clone of cryptodev-2.6 with my
phmac v12 patches on top.
Add a Tested-by: Harald Freudenberger <freude@linux.ibm.com>
Please push into next, maybe fix the typo "hardwre" -> "hardware"
Thanks




