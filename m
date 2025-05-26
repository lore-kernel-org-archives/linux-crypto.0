Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7E720D4EB;
	Mon, 26 May 2025 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748268389; cv=none; b=ePAjfB27yv7ZU64SGfFoyu4tMmjlDVMh0y9Kq5salYn4a/unP8vv0W40ApSMA7gkQfnb7GXTtLmTElMJU4DgKtZVu8mZhhLCWuN2HFrgUn+0QaS4SWLkvBRfl8bSg2m4/GSNJoWBYudI3BMNQQqpattCLB4wtilX4Z1plndFv4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748268389; c=relaxed/simple;
	bh=8VsKYZ6KxeMZthY7JuoI1Xwf/1MRGBmthAsokXCpm2o=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=GzptA05E7DKkYts24CJzm4J0++Hp+EtTKcTlC7kfCU5+tQHAToiJj3RsPGczzXAjY8TPThvL+S4J2LvDz4+ROELiIgS6bu4gK1e2Q2/8P8D4DIkWwdJXG8ownszQS442/rJwsEPTQgjDyK9+FvdrQ1o6rCZXaVH/BazXS71N+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=da+3YxPB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="da+3YxPB"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54QC90CM020497;
	Mon, 26 May 2025 14:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=zJOGFon2tbDPZRVzsu1EKQfawFr2x4HjZswhWTL7SBo=; b=da+3YxPBQAVi
	rBFFSeNmC23R4UTCEyIX14c8j0fM7hBgzeFZGueazI/cZ6S0PZH4M11ZOE6pZRNK
	H8BQiACw+YEx2x78tjuwjHU2bm34OGZ05FwkPMJf1ybdM4vg7283YVmihUiiv2ng
	7LCfApOQ3Hub19scKlw1XZrDKcokB/GSwGXODCp+Rku39+Z1l6GpWifN+Z3+ZvBx
	WQJrO/lJC4UP0Y5eQjbdaikNbGzMDRosa9VgKfIlScjJSpBc9ZiMD0IsibDvKl0m
	A6S3MfRp6RqGAPX6ek+PIuE0k7c9JOe1q1kNJqVPmwzuxySK5tZUSJUNDXPkCrww
	0FwnTbWvzA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46v0p2daev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 14:06:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54QDBvxk009546;
	Mon, 26 May 2025 14:06:23 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usxmpc06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 14:06:23 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54QE6Lj126870452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 14:06:22 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D07F95805E;
	Mon, 26 May 2025 14:06:21 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C7D358045;
	Mon, 26 May 2025 14:06:21 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 May 2025 14:06:21 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 26 May 2025 16:06:20 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
Subject: Re: [PATCH v11 5/6] s390/crypto: Add selftest support for phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <5c7ef880-15a2-4f24-96a4-75b6d29f7c4e@linux.ibm.com>
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-6-freude@linux.ibm.com>
 <5c7ef880-15a2-4f24-96a4-75b6d29f7c4e@linux.ibm.com>
Message-ID: <f24b49ae2c25815913fffd82dbecadcb@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V7ZcBwBskD6joKpztyK3nf8NwdefkC3-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDExOSBTYWx0ZWRfXzq8P0LEEayPG adBEaqldtR1qiT0TFuLvzn6EkMuW5NRGteHi8OC8myfnzfTLWpTzn6Q6T9tzYQDCPRTOKzoyuJv X+DEKpSCh7Jxp3WHiFgPqX15xjfg5T7V0Ud1N9eJkf/oUSpp3dY5igJ01wARVkMhC/Ulu6GZ5Nj
 Xk/EbujRWXdQPsAKR1FAi6ki+j+5sqhNxk1Q51kJ/VpFF6+nvTMa+4K5d7aAXlvKgBrCuBB2lnO 7iaAd37teSL6LToMqtS3PUcYST2NkmhuCCRCNSEschEaX+Nfz4vhLJKLT7Dxqooxr9AGkp6XnbS QP1dn3tp7tZVROkkcXd4DAwsQS3XmSYHloat10NtNFrc9tqwUj9mwoKQpDsDZTsOa2sWWeb6zTo
 vs04iu6V23Rk7pBcYsxsQtXtStMFlpAq9IcG7MvqCNmWqcD6XGxB7q7Yf0PqaPqxSDF2QhFP
X-Authority-Analysis: v=2.4 cv=Q7TS452a c=1 sm=1 tr=0 ts=68347560 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=m2qi5rkTakaL2VkNlNkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: V7ZcBwBskD6joKpztyK3nf8NwdefkC3-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_07,2025-05-26_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxlogscore=746 phishscore=0 clxscore=1015
 malwarescore=0 adultscore=0 mlxscore=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505260119

On 2025-05-23 16:55, Holger Dengler wrote:
> On 22/05/2025 10:57, Harald Freudenberger wrote:
>> Add key preparation code in case of selftest running to the phmac
>> setkey function:
>> 
>> As long as the CRYPTO_ALG_TESTED flag is not set, all setkey()
>> invocations are assumed to carry sheer hmac clear key values and thus
>> need some preparation to work with the phmac implementation. Thus it
>> is possible to use the already available hmac test vectors implemented
>> in the testmanager to test the phmac code.
>> 
>> When the CRYPTO_ALG_TESTED flag is set (after larval state) the phmac
>> code assumes the key material is a blob digestible by the pkey kernel
>> module which converts the blob into a working key for the phmac code.
>> 
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> 
> For this series, the explicit calls of CPACF for hashing long keys is
> ok. Long term, I would suggest to switch to introduce library
> functions for sha224(), sha384() and sha512(), all similar to
> sha256(), and use them for hashing the clear key. This will remove the
> hard dependency to CPACF SHA function codes for this module. But we
> should do this in a separate series and do the same for clear-key
> hmac.
> 

D'accord - but let's first focus on the real implementation and when all
this rework on the next kernel is done, we can start to use the library
functions instead.

> See another comment below. The rest looks good.
> Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
> 
> 
> [...]
>> @@ -854,6 +986,17 @@ static int __init s390_phmac_init(void)
> [...]
>> +	/* register a simple phmac pseudo misc device */
>> +	rc = misc_register(&phmac_dev);
>> +	if (rc)
>> +		return rc;
>> +
> 
> These 5 lines should go into patch 3/6, as it uses `phmac_dev` already.
> 
>>  	/* with this pseudo device alloc and start a crypto engine */
>>  	phmac_crypto_engine =
>>  		crypto_engine_alloc_init_and_set(phmac_dev.this_device,

Done - this code piece really should have been in patch #3.
