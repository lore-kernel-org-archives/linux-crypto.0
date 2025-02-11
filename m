Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A31FBCA1;
	Tue, 11 Feb 2025 12:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275762; cv=none; b=mFXFYD0DBUGkMPxJWIY4QbKzYJZ4+8ix7qZXqbCuM3rxEJdWz39NrUiL/sLDvFYM6iva8z596Uv/Iz0kelRcm8rvHp4wO8TZTDWcBO9RqR0bnLuXRKHb8VKJ0QRFgykTOdsDcvRf0bzWovCzawWFoRTmb5gL3w3ZpCP8D5DZx/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275762; c=relaxed/simple;
	bh=97jrskvhlAXgZqsK+kGEXoVzNhFqmpE13NGubMutl0Y=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=FMv02LEh+lbemaZeab1dSH/Dz4TYfWhDHzMFCtmbwtinuJBo1kzsOZSuutlw8h9eqhhyuGFHk5SgtBsWf42l8U4Dxb/1Vhox/5Yaw5xcrytE022Qc3rsAgrWA6pv7NhXz5Oq5yeOl93p/cn9kRP29pVNi1WZI5IlgdbbeFpJGww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RJPOwar6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RJPOwar6"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B7X3Vn015490;
	Tue, 11 Feb 2025 12:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=ccsXllvEBKuTE+D4Q/u6d4MvUjvSi5fxXuGxl/E063Y=; b=RJPOwar6uQI9
	UTL3gXZpciZDDHWHw/CieV90v+EKJQFJyhVAeC58NbJbRLwETvZ9XKJvnC8SiWEQ
	zuBQjDcPWl8jFvaEJCnA1zPD/BUrrSQuqWWxe7CvwiM9Fv6lx+5YwIXxQkYNdvj1
	nDrTGzA+8TDeN+Cws1fsuJ/FOPxzu+fqlpyaORY2EjulTfgfxs3TLMiNzjdx+dll
	bcEDL5VhGUd0ktWOOJi4FJF9yYha9dNcrGfikf1NQh3C/ns+Wi3PZWWeP3OKATrr
	B+8sJgEAXIZKVizCC4NJo6x/4aNDTHmvgbwChS7ISQv6mAWmHF5ew56FJm2cdhAl
	MktTIdAwmw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44r28ps54h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 12:09:14 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51BBkuZR006250;
	Tue, 11 Feb 2025 12:09:14 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44r28ps54f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 12:09:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51B8KD94021894;
	Tue, 11 Feb 2025 12:09:13 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44phkskb6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 12:09:13 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51BC9C3N25821886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 12:09:13 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8E305805E;
	Tue, 11 Feb 2025 12:09:12 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 612AE58045;
	Tue, 11 Feb 2025 12:09:12 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Feb 2025 12:09:12 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 11 Feb 2025 13:09:12 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: ebiggers@google.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, dengler@linux.ibm.com,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key hash
 phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250115162231.83516-3-freude@linux.ibm.com>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
Message-ID: <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C0SWG3XnLjOOKPqLicsAjG0L2MUzOc_h
X-Proofpoint-GUID: eajUi9FSaQ9LqZDSBSEyFzFCnms2-X_1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_05,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=594 lowpriorityscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502110077

On 2025-01-15 17:22, Harald Freudenberger wrote:
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
> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---

...

> +
> +	  Select this option if you want to use the phmac digests
> +	  for example to use dm-integrity with secure/protected keys.
> +
>  config S390_PRNG
>  	tristate "Pseudo random number generator device driver"
>  	depends on S390

Hello Eric

with your commit
   7fa481734016 crypto: ahash - make hash walk functions private to 
ahash.c
you move the crypto_hash_walk_* functions to private context into 
ahash.c.
So for example my new phmac does not compile any more.
What is the replacement for these functions then? Should I really do
the scatter walk by my own now or is there a set of new functions to 
come?
