Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2EA1F872D;
	Mon, 26 May 2025 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748268176; cv=none; b=uQ7M8RouvDaz9Yc9a4tCYc6ve7KBKHfLdsLrobaa/UAucH/GvdNbriJxBfPRgi8ACN5SnrTa5B+j2k3VaUtfKbGlp5497ot9Yt+o1spQiQzNV8QRGFaJ7pIIBZ4AH+rB6bQ+HhBTVmBIajtfIcPEVFC/nvjZ2DHafGtQ31ATZ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748268176; c=relaxed/simple;
	bh=nVcSuWjTkjSLgWZsKrjlIALyYgHC9+SdyOXKxbZnlTo=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=EOBSL1dDDLkFiTBq1lapUXn2/1hv4rX7O2yfFoYU38vwVnhuFd3wETH24E8kR+KQjhlbFszLBr/7vO2E9jFL1pjugQSJSJyeiTp90JOSckesM0imbaxxnCwUX1eq7QS61lXQdEl4qiYP30O2YgE1lnAWn7pEjbwNPMKmSvRESkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tJB2VRFR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tJB2VRFR"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54QBbnt3030267;
	Mon, 26 May 2025 14:02:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=Q5W1/elG2huF+Di0Yk4EHDRKD9P0ScS/YIySRrodFwM=; b=tJB2VRFR97GA
	DbklKlqi5Oo5Q0ahwCViTPH8SS5zj8cjcCqbJbTkVJqJ+ZZPQzpWgIGa2o9j9mg/
	FvLFt+jrPfKfPQXKs8GgMVBb1U3q2fDmhvtRFffBzCuMI25KcRc4yVW5yAEBs9jL
	WimhrNrmtdGyIqn28M5NKpUWGx/IYzvt+afdDy4slPo0sMtlS8yfAHLn0SvJMz22
	PbBxlWqG0ndVoqdV0O6cQAX1RPyovNNTCbXKbepzAdykNQdPckExgLNCnYSvrj99
	6W8cxbYqMOIbJukeE0akjdGjktL+rh/2YAvMOJB4d7jR7dJiKamCdcihroKYLEO3
	YyAvT5vKMQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u4hn9ku7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 14:02:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54QCorO2010565;
	Mon, 26 May 2025 14:02:50 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46useppdvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 14:02:49 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54QE2mCY46727506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 14:02:48 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DF7B58059;
	Mon, 26 May 2025 14:02:48 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3C8F5804B;
	Mon, 26 May 2025 14:02:47 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 May 2025 14:02:47 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 26 May 2025 16:02:47 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
Subject: Re: [PATCH v11 3/6] s390/crypto: New s390 specific protected key hash
 phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <667f78e9-1058-45ed-8d86-f8bfb98bcded@linux.ibm.com>
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-4-freude@linux.ibm.com>
 <667f78e9-1058-45ed-8d86-f8bfb98bcded@linux.ibm.com>
Message-ID: <c95c35c925d87b2ee932dd5195371d85@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HvB2G1TS c=1 sm=1 tr=0 ts=6834748a cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=5FmYOr4UixDQrpmFvOwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: vJrtxuEEMH_fUab2RrN8vsv0zs_AnxrP
X-Proofpoint-ORIG-GUID: vJrtxuEEMH_fUab2RrN8vsv0zs_AnxrP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDExOSBTYWx0ZWRfX+8BeNp/sX6I0 sAWg1QfsY/O9vH6YtOVJ0tBGQYyEIAyHAbSgT+OFvgOKRiUPZpEkR0vhE1DJuTPYD22bcytP7yw CjH+CrQmXd0FSwW0JIPJLqFAY7KmHililmvVR/DEW7MJ/bxiPx3zlYhRRdPb+kKgd96Ksp3n5Y4
 eJGHsj7CSsPohzIGrr4gMqxXjm27ituFCpxyCwx6/jd4YRNgPQ9ZpdbOzDLGmQm411Pxwr6fJV7 i1Ky5frGpVJ/UOBUq9HTVsnlpLbRQ8jJdroL380mtiTNNDPaqOAEe4xkXH+CLhIc9W3pnWkdsBl D6fj9bP5u+76PfkPSkWzBTJLPeK/d9Q/yBT6Mp2A9e5zuHPjXJaAOgUX7fJCub3oYvdbKCld7tG
 RIKKVfJ5btqa+NvffYezt8o802AwTJXjbqrhwQSYnTC1aphh6F4SS/fJoxcgKo8LbLHIMr3a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_07,2025-05-26_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=969 impostorscore=0 spamscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505260119

On 2025-05-23 16:52, Holger Dengler wrote:
> On 22/05/2025 10:57, Harald Freudenberger wrote:
>> Add support for protected key hmac ("phmac") for s390 arch.
>> 
>> With the latest machine generation there is now support for
>> protected key (that is a key wrapped by a master key stored
>> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
>> for the s390 specific CPACF instruction kmac.
>> 
>> This patch adds support via 4 new ahashes registered as
>> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
>> 
>> Co-developed-by: Holger Dengler <dengler@linux.ibm.com>
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> 
> See my comments below. The rest looks good to me.
> 
>> ---
>>  arch/s390/configs/debug_defconfig |   1 +
>>  arch/s390/configs/defconfig       |   1 +
>>  arch/s390/crypto/Makefile         |   1 +
>>  arch/s390/crypto/phmac_s390.c     | 899 
>> ++++++++++++++++++++++++++++++
>>  drivers/crypto/Kconfig            |  12 +
>>  5 files changed, 914 insertions(+)
>>  create mode 100644 arch/s390/crypto/phmac_s390.c
>> 
> [...]
>> diff --git a/arch/s390/crypto/phmac_s390.c 
>> b/arch/s390/crypto/phmac_s390.c
>> new file mode 100644
>> index 000000000000..b61454dedf0a
>> --- /dev/null
>> +++ b/arch/s390/crypto/phmac_s390.c
>> @@ -0,0 +1,899 @@
> [...]
>> +struct kmac_sha2_ctx {
>> +	u8 param[MAX_DIGEST_SIZE + MAX_IMBL_SIZE + PHMAC_MAX_PK_SIZE];
>> +	union kmac_gr0 gr0;
>> +	u8 buf[MAX_BLOCK_SIZE];
>> +	unsigned long total;
> 
> The clear-key hmac switched to u64[2] instead of unsinged long for
> `total`. Please synchronize with clear-key hmac.
> 

I've picked these changes from linux-next and reworked the affected
code parts to use a u64 buflen[2] now.

>> +};
>> +
> [...]
>> +/*
>> + * kmac_sha2_set_imbl - sets the input message bit-length based on 
>> the blocksize
>> + */
>> +static inline void kmac_sha2_set_imbl(u8 *param, unsigned long 
>> nbytes,
>> +				      unsigned int blocksize)
> 
> Same here. I would prefer to use this in the phmac as well.
> 
> [...]
>> +static void s390_phmac_exit(void)
>> +{
>> +	struct phmac_alg *phmac;
>> +	int i;
>> +
>> +	if (phmac_crypto_engine) {
>> +		crypto_engine_stop(phmac_crypto_engine);
>> +		crypto_engine_exit(phmac_crypto_engine);
>> +	}
>> +
>> +	for (i = ARRAY_SIZE(phmac_algs) - 1; i >= 0; i--) {
>> +		phmac = &phmac_algs[i];
>> +		if (phmac->registered)
>> +			crypto_engine_unregister_ahash(&phmac->alg);
>> +	}
>> +
>> +	misc_deregister(&phmac_dev);
> 
> The misc_register() call in module init is missing, see my comment to 
> patch 5/6.
> 

Yea. Somehow this code piece moved into patch #5 instead of #3.
Done, see v12.

>> +}
>> +
>> +static int __init s390_phmac_init(void)
>> +{
>> +	struct phmac_alg *phmac;
>> +	int i, rc;
>> +
> 
> The misc_regsiter(&phmac_dev) should go here.
> 
> [...]
