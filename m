Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC331EB3D;
	Fri, 23 May 2025 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748012600; cv=none; b=cEOX/azNj7m9R6BUF+QpQGOEO01t4ikuQe6QdV0iZeAc4DVQ2XDmYsErsN/T621Tne96dsW2a9RFJDWh0pieLFLLT7H9KY+zfcfV3loUperMtsxXKXaRsUIsdLmP0vx1iubTie5BktLIE7Et16ybivtyvNEvknE49kuhlsptNtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748012600; c=relaxed/simple;
	bh=fUog4EcZ6l3VCGVXwvy9HlqR49ZQiexktQK4/+TeFAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KN5C3p0Mnp9gjk4QONMPwohLu2b3grf0iuBA2dKireQ+BLJ6p9xk7ckCNvyPRlwHoDeYT7oYOCJdi9AIOUxiJnln3fJ+BP4sCxpDYDiTMI2HOf99L2dTim4qfNDKDgcZYu1fxJ0uzpRmfd68f25o8mllbniQ+mWaOqgTDc90Lnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vk3Yhjy7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vk3Yhjy7"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NBLn5A006444;
	Fri, 23 May 2025 15:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7GCoRc
	f0ZdqRRv5LBfq9T+RGaEeMQ2ZkeujoJkyP61w=; b=Vk3Yhjy7I2PZQQ1GecjhSn
	4q3p8d/Mbq6itE6mnyDzLquv0+7JCqs3XTMC9hSPqrVr/d03XrjyUX9IUyvs3uOs
	XMT/r/P03g6/8NrkFZMEbF4+0+sjdKQ7dSFgdeqBXIFTdKOPyFdokAAj9wpjpwY1
	ueOINJupE/UXHCyczWAlPufuXqnieGQyTn+8C7AOW3zS2RvkreJlC0+peLI2+WLs
	y9W1lg/0Uww2YL8T4aWezF3VzbZ8j2y5Q7iSKD55Viw6OQN6XBShOMpnzCsG/CCK
	OkzL97CI0FkEfRHF6UlRR91lTLqojwV6BfggWGrXWjmHWms8l8dYKUHiEgJWfvwA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t9m7vt09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 15:03:15 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NEaroB024701;
	Fri, 23 May 2025 15:03:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkrf2r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 15:03:15 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NF3BP127460346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 15:03:11 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EA5520043;
	Fri, 23 May 2025 15:03:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 149F920040;
	Fri, 23 May 2025 15:03:11 +0000 (GMT)
Received: from [9.111.78.193] (unknown [9.111.78.193])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 15:03:10 +0000 (GMT)
Message-ID: <271ec75a-74c0-43a8-9878-aeb1862bb161@linux.ibm.com>
Date: Fri, 23 May 2025 17:03:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 6/6] crypto: testmgr - Enable phmac selftest
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-7-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250522085755.40732-7-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=SMZCVPvH c=1 sm=1 tr=0 ts=68308e34 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=w46-cfdy0MOtRbFV-QQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: VCQW80Z9Q4oBVv7-YksF4HxacW3330Sg
X-Proofpoint-ORIG-GUID: VCQW80Z9Q4oBVv7-YksF4HxacW3330Sg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDEzNSBTYWx0ZWRfX7FmZ7KRmJpnj NbTwO+xmAqUV/wUC6N8fi8aQqCSIjhpU6WT1PHq9W7MziA1mtHzZV6MQ4IJVKvY/mjLex1N+yut lUb3DzGYCero7cFWDKE8jHvMroJ2f+CqbWe2JjTkL5Pe7YkK+MLJaipDaxyyviEVyIy1cg2Hffg
 RORJaK/QvATdGL+KLsUMpEuXS80ATJGwBjtEM4dv64tcnYYsCSC/+PEqQJiONjgXq/fkR+sIwFO 41R7s+pbmugHNyeudzkO0lMxL1oKn9Sk1UBgSCGavGTOv/I8t4SrDs+C9E88f9qAbUbb6kF1EgL izskkMemm+45wnH1Eabs1xUlcl3yZxPyirKgWfW7JKyZ7l6P4iidMWcEdNjKUvilxJ/1CbWji/7
 YZYQBSW4a71lj0ew7XNIdolKbhOOwkugz6qNcePkx7Kq3HC9QJtuzAM2xhRrI7orSbkyZL52
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0
 phishscore=0 mlxscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230135

On 22/05/2025 10:57, Harald Freudenberger wrote:
> Add phmac selftest invocation to the crypto testmanager.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

Acked-by: Holger Dengler <dengler@linux.ibm.com>

> ---
>  crypto/testmgr.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index abd609d4c8ef..243dbe8f02e3 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -5385,6 +5385,36 @@ static const struct alg_test_desc alg_test_descs[] = {
>  			.cipher = __VECS(fcrypt_pcbc_tv_template)
>  		}
>  	}, {
> +#if IS_ENABLED(CONFIG_CRYPTO_PHMAC_S390)
> +		.alg = "phmac(sha224)",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = __VECS(hmac_sha224_tv_template)
> +		}
> +	}, {
> +		.alg = "phmac(sha256)",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = __VECS(hmac_sha256_tv_template)
> +		}
> +	}, {
> +		.alg = "phmac(sha384)",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = __VECS(hmac_sha384_tv_template)
> +		}
> +	}, {
> +		.alg = "phmac(sha512)",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = __VECS(hmac_sha512_tv_template)
> +		}
> +	}, {
> +#endif
>  		.alg = "pkcs1(rsa,none)",
>  		.test = alg_test_sig,
>  		.suite = {

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

