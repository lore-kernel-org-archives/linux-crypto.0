Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F842944F;
	Mon, 25 Nov 2024 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732539668; cv=none; b=A4zT/YMwA52KqOrKxcu9st2QVgUxQ63wSgxMWd79AdUZJACzvhJUE6tJhdR5uC7gQL1tDujUK06osujK3Hs76KLuQp3lQAgqV+PnOYbFMI6nwHrKXINrmvXCmRTDAtIGe6QlSGfQcF+kneLwXOvNgcnhadQKC2pYw9+0NuUpjUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732539668; c=relaxed/simple;
	bh=gDJf6rHg+Qb5l0FZNv7g1GARXrlNNMdpltVEwlOij2g=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=PkTDNtyrdeXm2lwDICiGXCuWaj6/Huf287zL1fMv9gEXJmKxKOj7n+k3/GUV/vVNMF3OcBozQbfzgE99PA97g9rsfQp8CfiyCxgjYx4h/UeI+m7P1grmdIlfOOgeWti6UNmytFCUVWKZhPKE4aE6mzLUUf9EMn+0TbeoqC95IQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SUlqIfw5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SUlqIfw5"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP2EEmE012686;
	Mon, 25 Nov 2024 13:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=5xXhWntJHkm/g/4ib3EBGI1It7tyI4R6QaD/g1HIGXY=; b=SUlqIfw5OVnV
	2ILKDxfbl9Lo4oWhfdt+lmUh9HB2OOOJJXqRSCaLuGzVjhbEX6XLr0CcVYsc1/wn
	AhKMFMve4ybpTtY3pFf38QKaiNUGYZdT5iyfhaQjmSrSbokLdjaXJN0QPF/d4btC
	bemFev+sftLRt/KGgpr8SM9C3omZkObisNhl9siBsUR56HAQVz6B3nQuhYVdIPUG
	U4sEUSN4wYQX3knlPk0+bACTwnh42E0PYjV5+VKdKAJseP+oqgYj3m5svaPmYI8c
	D4ZA22Acj6j8oPmCG7AyLnsGGZ4E2tyoC9OUIjdCgL1wWRXJ4a9u6jOK79MVVzw5
	WeoBcya9TA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43389c8fdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 13:00:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4APC2752024887;
	Mon, 25 Nov 2024 13:00:53 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433tvjxjd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 13:00:53 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APD0qIv52429302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 13:00:53 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD1635805C;
	Mon, 25 Nov 2024 13:00:52 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D1F25805F;
	Mon, 25 Nov 2024 13:00:52 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 13:00:52 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 25 Nov 2024 14:00:52 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, davem@davemloft.net,
        dengler@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 3/3] s390/crypto: New s390 specific protected key hash
 phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <Z0QUl_eSUwEANb4s@gondor.apana.org.au>
References: <20241122143427.135682-1-freude@linux.ibm.com>
 <20241122143427.135682-4-freude@linux.ibm.com>
 <Z0QUl_eSUwEANb4s@gondor.apana.org.au>
Message-ID: <079dc622ca9f4b6883c62025adb336b9@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 80-1bIJQS_nHMMkwAm6lSGPJcKZXpzuT
X-Proofpoint-ORIG-GUID: 80-1bIJQS_nHMMkwAm6lSGPJcKZXpzuT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=650
 adultscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411250111

On 2024-11-25 07:09, Herbert Xu wrote:
> On Fri, Nov 22, 2024 at 03:34:27PM +0100, Harald Freudenberger wrote:
>> 
>> +static inline int phmac_keyblob2pkey(const u8 *key, unsigned int 
>> keylen,
>> +				     struct phmac_protkey *pk)
>> +{
>> +	int i, rc = -EIO;
>> +
>> +	/* try three times in case of busy card */
>> +	for (i = 0; rc && i < 3; i++) {
>> +		if (rc == -EBUSY && msleep_interruptible(1000))
>> +			return -EINTR;
> 
> You can't sleep in crypto calls in general.
> 
> Now there are specific circumstances where sleeping is allowed,
> e.g., when the MAY_SLEEP flag is set, but I don't think this will
> be acceptable for your purpose.
> 
> I see the same problem exists in paes_s390, which was not reviewed
> on linux-crypto.
> 
> So what exactly causes the EBUSY? The 3 retries followed by failure
> seem rather dangerous too given that this could be used by the block
> layer for critical data that cannot fail.
> 
> Cheers,

Well, I fear the paes implementation is similar broken. The EBUSY
is a reaction of the zcrpyt/AP bus when no eligible crypto card has
been found and a ansynchronous bus scan is running. In that case the
caller should retry in the hope that the bus scan detects a eligible 
card.
Please note that the sleep only happens in in_task() context for the
paes implementation.
For the phmac implementation - didn't you suggest to wrap this with
an asynchronous hmac to be able to sleep in the wrapped synchronous 
hmac?
