Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE2938F9C;
	Tue, 28 May 2024 11:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716895224; cv=none; b=HHKbXyU/Qf/NzYdH+44prd/jIXCOiOedYwoMJSWJWN2KEJhlYUg3MTG4hiM+pU5w5RfscUs8OMdPM50g4kfHTUNLKwB2t13myvBuRlpcrtd3fxdAkE374wY+WqnKizetDAGbGCrJxzy4vT8/GDZGknpGONjqdI38MKR+YGkkRH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716895224; c=relaxed/simple;
	bh=8AOe/BleNnP0CIoRBQm0Zw5AmK0p47fRi8znDX1W7R4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H3+WAIaF3WX8PDOuky48QMogJm/jUeIsIDnm8SzuRoIla3XI4xDYQXBThI2Pq9i76m3Tm9XFXjPfUwDDSeby/MWQYafWU4HXgPYwWe6kcdvMz9q/jWrrdM4SIAsGZ6K4K8WXqgfiOn+aslCUWrdRBlBbMTYMEb3aCZBcfu2TulY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SAk10m025534;
	Tue, 28 May 2024 11:19:04 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Dibm.com;_h=3Dcc?=
 =?UTF-8?Q?:content-transfer-encoding:content-type:date:from:in-reply-to:m?=
 =?UTF-8?Q?essage-id:mime-version:references:subject:to;_s=3Dpp1;_bh=3DAc2?=
 =?UTF-8?Q?oGUA/aYJP//WzOPJKhx/MViZXpqQqjAELcfa5yHM=3D;_b=3DGihh02UALLnyXI?=
 =?UTF-8?Q?yBbbJMzCcahOvodvLU07+NxyBFlpma+Vw0wlibo/SpSNGroL1vicED_c3MEG3ZT?=
 =?UTF-8?Q?JO4h9i4WTnOyVLVCK5abeQTkfKONu1MoAI69apVJ08//dYK0339TaKiDbOcK_HF?=
 =?UTF-8?Q?gppbp0L+KvbNjWSqSnWvXKGQXRAOcSMOwzLvbuuakr97tOAGb0mqppG/JX3iqjQ?=
 =?UTF-8?Q?729_PWqQ3Rc/UqD8JGuhNNooFU74eG3TVgF4I8dLc6Ab008E1J+CTkXx0MnhIBH?=
 =?UTF-8?Q?hapCvbiz+_reEAdm3nEjXaANHP91RUH3aj5qW9G0coe0VzR2WRRzNKz+QcC2PQh?=
 =?UTF-8?Q?7npwo6TwC8jjmmS_mA=3D=3D_?=
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydd3br68n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 11:19:04 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44S8w849011118;
	Tue, 28 May 2024 11:19:03 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ybtq06pj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 11:19:03 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44SBJ0rY12780230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 11:19:02 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BF6358055;
	Tue, 28 May 2024 11:19:00 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 950175804B;
	Tue, 28 May 2024 11:18:59 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 May 2024 11:18:59 +0000 (GMT)
Message-ID: <0e3bfc37-53d6-422d-adb0-3ee23bbb0a8a@linux.ibm.com>
Date: Tue, 28 May 2024 07:18:59 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
To: Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20240527202840.4818-1-jarkko@kernel.org>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20240527202840.4818-1-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rTpVYHwhO9S8DVZtKgnM0A06BJPf_XbF
X-Proofpoint-GUID: rTpVYHwhO9S8DVZtKgnM0A06BJPf_XbF
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_07,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405280085



On 5/27/24 16:28, Jarkko Sakkinen wrote:
> Public key blob is not just x and y concatenated. It follows RFC5480
> section 2.2. Address this by re-documenting the function with the
> correct description of the format.
> 
> Link: https://datatracker.ietf.org/doc/html/rfc5480
> Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

> ---
> It is a bug fix that does not really need a stable backport. Still
> categorizes as a bug because by following the existing documentation
> you end up with an error code.
>   crypto/ecdsa.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
> index 258fffbf623d..55114146ff84 100644
> --- a/crypto/ecdsa.c
> +++ b/crypto/ecdsa.c
> @@ -215,9 +215,8 @@ static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ctx)
>   }
>   
>   /*
> - * Set the public key given the raw uncompressed key data from an X509
> - * certificate. The key data contain the concatenated X and Y coordinates of
> - * the public key.
> + * Set the public ECC key as defined by RFC5480 section 2.2 "Subject Public
> + * Key". Only the uncompressed format is supported.
>    */
>   static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key, unsigned int keylen)
>   {
