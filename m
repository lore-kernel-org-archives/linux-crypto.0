Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9741AA7AE
	for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2024 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728911612; cv=none; b=FrHZ14ujW9k+9Nqy4xaW0pYNvuXCyvI6rl47ADFI9SloUTb/HgmuJwNKpgr7ipUURGHFEVgPtNh11RzaWUqvlfVufNtJC34vVBsAnX1S9a083mwppGQPyWW4VGm92/f/QIoSWWhbTbWZ6Ak8zfiXZ01gniPTnUOj9Z1C+RH2rUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728911612; c=relaxed/simple;
	bh=mNvBE2UAy0YDq0gR2RadAYujdUlHibx9NBtdrIPEG44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MeTUoBswYTAJxGp3TMkl98ujzim6o47nPt6nSL9e2DuF2Uiikxa2u1rSFsegKkhEogGLhtSW46RiW3Q7qFlbSmfLHPBFpVIIA2R3qI1bb+5yZ8hn3Mm/gbzrjb7aCKWlJC+9ZQ6X91Sg5t1Q+q4JjfAWQ0DksfVAwN8bFqzZRV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ew7lfMFB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ew7lfMFB"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EBsh3t026636;
	Mon, 14 Oct 2024 13:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=k
	FiLprsHn4xySAZOvniMECoOfZJyxBiNP4XVf0PlMJA=; b=Ew7lfMFBK4PhV0U13
	WCSvQxMK6tZ5+y8cBBF6gGqQskDOPLPOVQHEr6ILjc2isIQAGSpXHgBAO6bTbCjf
	Amm/C8bPHXRTMV6b8y0izjtbN0/XVJFGYoIxSGSeatkyZ53aXQGpR7s/Dnhdx+RU
	8hWWAgzT27ULGQfJ5TIBj77N6zdCDAKY4rJAOhaJozM77qYFD+JDPERiojxWP/yg
	3rfSrA2dKNNRaJYepFjL65Zdb2mRt61IDTtVCfpExm4jpQMp6JtE5dMkmLvcc10Q
	flbG05j2rSrjsDDG8e7wyfKmtIqNDOWMVYp2OzJPdINXZl8VIsGjiC1YR11iwzFV
	KrHnw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4292tygdgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 13:13:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49ECgo20005930;
	Mon, 14 Oct 2024 13:13:24 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650pbaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 13:13:24 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EDDO6649152362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 13:13:24 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 145EF58082;
	Mon, 14 Oct 2024 13:13:24 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BE7958060;
	Mon, 14 Oct 2024 13:13:23 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 14 Oct 2024 13:13:23 +0000 (GMT)
Message-ID: <dcc4225b-805d-42e7-abb7-bb06fea625c6@linux.ibm.com>
Date: Mon, 14 Oct 2024 09:13:23 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecdsa - Update Kconfig help text for NIST P521
To: Lukas Wunner <lukas@wunner.de>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
References: <e843333c7b9522f7cd3b609e4eae7da3ddb8405c.1728900075.git.lukas@wunner.de>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <e843333c7b9522f7cd3b609e4eae7da3ddb8405c.1728900075.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xHba5NTOI5K8i6YclZ6dKfrnkrxsXTHB
X-Proofpoint-ORIG-GUID: xHba5NTOI5K8i6YclZ6dKfrnkrxsXTHB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_10,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410140094



On 10/14/24 6:04 AM, Lukas Wunner wrote:
> Commit a7d45ba77d3d ("crypto: ecdsa - Register NIST P521 and extend test
> suite") added support for ECDSA signature verification using NIST P521,
> but forgot to amend the Kconfig help text.  Fix it.
> 
> Fixes: a7d45ba77d3d ("crypto: ecdsa - Register NIST P521 and extend test
> suite")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

> ---
>   crypto/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index b3fb3b2ae12f..6b0bfbccac08 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -296,7 +296,7 @@ config CRYPTO_ECDSA
>   	help
>   	  ECDSA (Elliptic Curve Digital Signature Algorithm) (FIPS 186,
>   	  ISO/IEC 14888-3)
> -	  using curves P-192, P-256, and P-384
> +	  using curves P-192, P-256, P-384 and P-521
>   
>   	  Only signature verification is implemented.
>   
