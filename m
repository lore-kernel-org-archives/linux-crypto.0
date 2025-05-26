Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F9C28EB;
	Mon, 26 May 2025 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748267935; cv=none; b=bY4H7XyaJM3J5sOHw5xVnU10AFvuGKfDn/TgXGmKvCcZi13IQ+GeqJ9XnZWPMEUqP1K2EsxTQPbsCr0qabKHZZkv46OaxWTfOIcIfDPbp5hO3FagmnEDuCQpUZ1fMJQZAVfvGPp+4OJ6tJh/fDr8Hc3fSks82xmHrKq8mQn+7D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748267935; c=relaxed/simple;
	bh=aDc2QWj3ux3lR1MK3l1CPZh50mq+BrFqL7Y8B4peIJ0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Pk5hQDNDv4ZW1Sz5Lz38JMy4vCPg5714LW3pGrJrOKvknYdpyuG3z0t7We4ZGTV37pQrw74Pn5J/tRsmnfcvg69wPfd7LS9AH7yh3ySsx90kMGmXEpzMGDvk3ou8S7e0aq5jd5Q68uD8Fbw9aUNm4BZBNESxqAXGIBY+eMmQ2Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rxhoWR6E; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rxhoWR6E"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54QCsw6H008601;
	Mon, 26 May 2025 13:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=ifjTnUTdKWwGYR5ht4WmoUiJvuuR+EF5YQU0WjPAK7A=; b=rxhoWR6EO8wf
	IlbGnGUn9XrgSwb/9FI18LBFUQVo6fcvO42oCewkPB2f3xq1MZPRC1TAgZaE7VBR
	ZN9FgZLdK/1ZU8RJ/XfXbDG9RwdIbgA+AH/m3iunPGwf08MfzoLdtwpPcklzD6Pj
	OQ8wfBhA5OsV2BCpiCtj2Trf3IHmjjZ1V3Z66oGuotqwyWTU6lQQcynlxfvmBqjf
	hmCm5v/uRGJWoom9zI9nnydQVjK1bzHJ+onTSsCpvs8xHYqosCfVNACpK5oe6OP7
	FBHtJBPuxPnL7OBFFVT5yAa9AFBQA24W6yOINjfuOlQryNhRsGIw0F4mib6gkdjo
	BcU2HGtlzg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u5uchfmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 13:58:49 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q9PFd5007966;
	Mon, 26 May 2025 13:58:49 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46uu52x3fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 13:58:49 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54QDwlXx30671528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 13:58:48 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B66F95805D;
	Mon, 26 May 2025 13:58:47 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32DFE58054;
	Mon, 26 May 2025 13:58:47 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 May 2025 13:58:47 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 26 May 2025 15:58:46 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com
Subject: Re: [PATCH v11 5/6] s390/crypto: Add selftest support for phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <aC7qCsLN84LfWy-e@gondor.apana.org.au>
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-6-freude@linux.ibm.com>
 <aC7qCsLN84LfWy-e@gondor.apana.org.au>
Message-ID: <48c8cfa0a00d34f271d04d9d68dc7337@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AlXWfV11KkYpjJGypux9VtuWWNQ-j3Pn
X-Proofpoint-GUID: AlXWfV11KkYpjJGypux9VtuWWNQ-j3Pn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDExNSBTYWx0ZWRfX89Ykae1Rq9Dp Ak7TB4yTCnoDoAFvK97s0EQYCuBxjQRqZ2kA1OGCqNF3gJ3JueBQ9j60fvBq9wlcEt6Iv0cCFgX Yz7MoTwksHkSlln0MMddCcYcLYA3qu/smwbRzXNd0Snd9hleWiHCeGGnsdDsoyG0yPO6xm+99tp
 oAzyJQaNemJ6roGq1pbcJwX1re9iQXVETUQQJTG5j1HUnnwpvegZNID4MzUlwJ8qrXs4DJynzJz tOPfUJILABNfBeh3m18JkWyx8uBEJyRP5LoGFlyQQu3X7FabrEOZmh8B3t8T7QuOP9ssWyFfAeN 8GYqjC91Utl7RTgEXmMbaQzk/F97Y/E21Hc9LmOaGxfEPfEumqflAjWzh8yks8SPWGeYZ103uKg
 cvzhHNdFTeeI5TtansQ5bEXHqPgM3Gc2MAsGciJWeeVAzS148v+xruw7+B9oh+68i0C33EXH
X-Authority-Analysis: v=2.4 cv=fJM53Yae c=1 sm=1 tr=0 ts=6834739a cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VtAC8mx2-aAPUfWygUgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_06,2025-05-26_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=657 suspectscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505260115

On 2025-05-22 11:10, Herbert Xu wrote:
> On Thu, May 22, 2025 at 10:57:54AM +0200, Harald Freudenberger wrote:
>> 
>> +	if (!(crypto_tfm_alg_get_flags(tfm_base) & CRYPTO_ALG_TESTED)) {
> 
> I think a better helper would be
> 
> 	if (!crypto_ahash_tested(tfm)) {
> 
> Thanks,

Done, there is now a new inline function:

static inline bool crypto_ahash_tested(struct crypto_ahash *tfm)
{
	struct crypto_tfm *tfm_base = crypto_ahash_tfm(tfm);

	return tfm_base->__crt_alg->cra_flags & CRYPTO_ALG_TESTED;
}

in include/crypto/internal/hash.h
see v12 of this patch series.
