Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DF129672B;
	Fri, 23 May 2025 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748012155; cv=none; b=ryuacYb+71kJHTBytYWaOZZ9b7x1toON9MO5IQLgZSCRYeaj6tprWwwW4CAj9EhGvCt2gJoThH4O/KwBsf6q8VmNu6q/9SEsnU2T4ATyOHvtys8mFXpJ87Ql63F4xMRgrFHxxx2vVB9vqXlzZ9YfI12USlUk0/8osgpqSNy8DJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748012155; c=relaxed/simple;
	bh=UCD+FVZ3PGw8DbpiFfsFkrdFly81v4NOf9IAicNLBpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s9AWDgi8DJIyzij0GNrBK5R2YeuwzvWlk5AD02IjC+yx4cvae7SRUOpTHV9EQB1CVXM7G8jWQiETHN4+j7aURpcaoQkgg37Tu767lOqugjdwAh76gmQ9coxMia1TF8P9pPoYztPvGL3RK9DeTIkowu8IC2ZryQH3wRFd0ELVsPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Micm/Uj7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Micm/Uj7"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NA5wki030326;
	Fri, 23 May 2025 14:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=I+RwQI
	aY9pd1i2ISXWgbgz0wDFqSP9Pec24RlK6vpdE=; b=Micm/Uj7kOqJanAi+f55Mc
	gLIgZiJugHiOiAaAM7MdTLxG0kIDbj05Feufgi1UCLvRQ3vBOG0XLnK5gMNFrKkI
	WbWE+6PgIPSdDwI+SgBPW5+05bkZX1VsFiyH8GZyVhLeUo2ir/SxH8Zhg9z+hkO1
	XebR7FmLm93poTS818/rLQkUIrUB0KSopzdRjxjtRvtwf/u5xuKtKmpKi9L/5GTl
	Crs3vtdMAlGh5TNiCtIXJl9El3JwFdGufdVa3r/ck+QERXo/HR5MGlWd0eytBGbd
	z+L67k6A33gsO0FEe90UTotg161+LfGONgHeTsgsBV8YTLQE+nEGY1p/pGOx3Yvg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t669nyns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 14:55:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NDi3Ut024617;
	Fri, 23 May 2025 14:55:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkrf153-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 14:55:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NEtjr033685900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 14:55:45 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 924432004B;
	Fri, 23 May 2025 14:55:45 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AAD820043;
	Fri, 23 May 2025 14:55:45 +0000 (GMT)
Received: from [9.111.78.193] (unknown [9.111.78.193])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 14:55:45 +0000 (GMT)
Message-ID: <5c7ef880-15a2-4f24-96a4-75b6d29f7c4e@linux.ibm.com>
Date: Fri, 23 May 2025 16:55:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 5/6] s390/crypto: Add selftest support for phmac
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-6-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250522085755.40732-6-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RrPFLDmK c=1 sm=1 tr=0 ts=68308c77 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=w46-cfdy0MOtRbFV-QQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: qQX2qrxZEBw8Rg6VqJ8FuHYzS6u5Bq4_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDEzMCBTYWx0ZWRfX5V4W3YPol7hP Yx3nvzYAHYoOyY9/EASc4cL+49KGltAhthySr+q9lN1te2RMQiwsU1+7YsFSFlCdmE4MHt0gf/g K2Jk+gGtodnAAMMenR0jbx/27H/V0EXEFgFzOTIOY8KrTKOB1YzChQnVmM+Cqtm57A0Rtg2Poyz
 jCpyFIgJq0sYQs2+HybIknEkwrvHi9K3fyXpLb6luQvTOC03hTH7WsjtzCWPkZxDsBJM+wG8jRg rbz1HZhMaBwBlyTUftsw7Yp6tSnbhzAhoijLjabvOgMupkSH/Zx37VNys5GvQuGgTny6xTY0WKW CpSdiumG9yZiLHonBhDKHiquSVB4EnpRjGq11yf7P7zh9USRTff7BxHw2z17646X/p7ng6ZFnUv
 cgn2nX99MrHmqqSIXPvjsCZ9LZnShCc41hMXuRXYAe+fMMwHa/LYKdUbZWNaRpGgdN7YdfeS
X-Proofpoint-GUID: qQX2qrxZEBw8Rg6VqJ8FuHYzS6u5Bq4_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=915 suspectscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230130

On 22/05/2025 10:57, Harald Freudenberger wrote:
> Add key preparation code in case of selftest running to the phmac
> setkey function:
> 
> As long as the CRYPTO_ALG_TESTED flag is not set, all setkey()
> invocations are assumed to carry sheer hmac clear key values and thus
> need some preparation to work with the phmac implementation. Thus it
> is possible to use the already available hmac test vectors implemented
> in the testmanager to test the phmac code.
> 
> When the CRYPTO_ALG_TESTED flag is set (after larval state) the phmac
> code assumes the key material is a blob digestible by the pkey kernel
> module which converts the blob into a working key for the phmac code.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

For this series, the explicit calls of CPACF for hashing long keys is ok. Long term, I would suggest to switch to introduce library functions for sha224(), sha384() and sha512(), all similar to sha256(), and use them for hashing the clear key. This will remove the hard dependency to CPACF SHA function codes for this module. But we should do this in a separate series and do the same for clear-key hmac.

See another comment below. The rest looks good.
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>


[...]
> @@ -854,6 +986,17 @@ static int __init s390_phmac_init(void)
[...]
> +	/* register a simple phmac pseudo misc device */
> +	rc = misc_register(&phmac_dev);
> +	if (rc)
> +		return rc;
> +

These 5 lines should go into patch 3/6, as it uses `phmac_dev` already.

>  	/* with this pseudo device alloc and start a crypto engine */
>  	phmac_crypto_engine =
>  		crypto_engine_alloc_init_and_set(phmac_dev.this_device,

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

