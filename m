Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F8A322B61;
	Mon,  5 Jan 2026 17:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767632934; cv=none; b=FK4hVqsTWt3m0RF7JvNrYo5xgoMsD41wBd/5GptrltrO18rmHtB8buzYpKHnAq8doCNsRhHWuQowb3mYMmpYfD3t6XFRpytE2VIC9Bc8XhY1Fcc49k/m2gjn5gWyeH6LVav+rlFqPRmDJXOUkRjxBkFYbBRLNob4hN7yzeg04/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767632934; c=relaxed/simple;
	bh=zLtKDWIHIKIks+W4Di7QBPv1ZllrLij0cdaPxpe1wPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nqXCcCVUESHqx8LnlMWwhfxflofkxJtpXhiVppFCCI4wcKro/kTnjIR8YiH86Qs2jgNxdZrz37mNKKnH2ssAQhPjcRwcdBhrwfv+HXehlRzZ9awYKN1sPce1A8E4LrdgPho+El2EN+lHEujSHv03Ptq955gwhyXEjXBaGZjkk0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NCuf6r+9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NCuf6r+9"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605EVMmT026728;
	Mon, 5 Jan 2026 17:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eSIhhO
	ciMRazXcXzkqLXlhyNQaedGTmPkztvFRGJIKw=; b=NCuf6r+9w+dFQ8hls3ORyz
	xjUwokYkXbpdsLQFF8+b6t7/OjQytFlx6bAyOhacS1JluABHrxgefQICnfLOc11Q
	nKe8hTQFaVZ9GXy+NM+qBrAuiWxo7lLkHVWTaSPt59F9XXBRJoJx8fAwwakIf7HG
	kdBfz/lkAlI6QjM3bQn9Jjg0AcFRf61NryKvEu6yoHfwa5N8N2/yHnoFoFQyZmoP
	WDjeUdNE49jHqSvaMzPKJIIDN5P0sb1qLIMbgKCm+LwmdQZrq4Bk5TzTO5Ge8R5j
	3LzZlF3ngFw9AuYR3TEgCNeKiPK6df0pQbviZT7IOiqKdC7kPJNYT82/ee5GGhGg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm70cw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 17:08:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 605Ge3CJ023487;
	Mon, 5 Jan 2026 17:08:33 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bg3rm3n96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 17:08:32 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 605H8WkR58524130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Jan 2026 17:08:32 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8441F58059;
	Mon,  5 Jan 2026 17:08:32 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1D1C58058;
	Mon,  5 Jan 2026 17:08:31 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 Jan 2026 17:08:31 +0000 (GMT)
Message-ID: <0c62719b-adef-4796-ae15-07467de478c8@linux.ibm.com>
Date: Mon, 5 Jan 2026 12:08:31 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecc - Streamline alloc_point and remove
 {alloc,free}_digits_space
To: Thorsten Blum <thorsten.blum@linux.dev>, Lukas Wunner <lukas@wunner.de>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251218212713.1616-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20251218212713.1616-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OdmVzxTY c=1 sm=1 tr=0 ts=695bf012 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=9jGYZitoDxUW5FyFbrIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: hPwKx5WiEt73ys4qxKOD8Az9QRHJlaAs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE0NyBTYWx0ZWRfXysoknPGpu/pn
 NEjHxcIU8sduDQSOP1cBGmBflK1GtVMSMBvVL825IJzVARHhyoYdGx9b2tt1Mhi/n5MVARTK7/4
 09UQWppu2yrw+CVTje8WyB72TmyH2GpE1JyYAmhurlznnF3RXmyr7gUubsb36LJ5lwvlzEzYfw+
 yRz5V1rdee/Gv8yCqq5+ErXxFrP5+PtnVwYCi47iVSbt/9+oYcsQE3um8/dOIuMYhsp8F9ZVTK8
 ryIvU1weRJ1jVJQ/0g1DKUa7BGpwSRo8UlGujDGbQZehgbVamOTUo3VS9oDC3pqFciC5qiGKFWO
 H6wX8OX4pDyKAP2ceKdWCp6sarBIdHyubNYjDT6lkQazwsmfTmk8yppAqCweqAU+O5u2bS3drPd
 1YrvADgWpcNu+7xTehFO1vD5oL2ZvndyKDhgH7oTX+mj3Zdr4tcxJoPOn1hE9Oiw3F/dkAXUmzY
 rrnT5cyrlKxbHIRQJwA==
X-Proofpoint-ORIG-GUID: hPwKx5WiEt73ys4qxKOD8Az9QRHJlaAs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601050147



On 12/18/25 4:27 PM, Thorsten Blum wrote:
> Check 'ndigits' before allocating 'struct ecc_point' to return early if
> needed. Inline the code from and remove ecc_alloc_digits_space() and
> ecc_free_digits_space(), respectively.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>   crypto/ecc.c | 27 +++++++++------------------
>   1 file changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 6cf9a945fc6c..9b8e4ba9719a 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -90,33 +90,24 @@ void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
>   }
>   EXPORT_SYMBOL(ecc_digits_from_bytes);
>   
> -static u64 *ecc_alloc_digits_space(unsigned int ndigits)
> +struct ecc_point *ecc_alloc_point(unsigned int ndigits)
>   {
> -	size_t len = ndigits * sizeof(u64);
> +	struct ecc_point *p;
> +	size_t ndigits_sz;
>   
> -	if (!len)
> +	if (!ndigits)
>   		return NULL;
>   
> -	return kmalloc(len, GFP_KERNEL);
> -}
> -
> -static void ecc_free_digits_space(u64 *space)
> -{
> -	kfree_sensitive(space);
> -}
> -
> -struct ecc_point *ecc_alloc_point(unsigned int ndigits)
> -{
> -	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
> -
> +	p = kmalloc(sizeof(*p), GFP_KERNEL);
>   	if (!p)
>   		return NULL;
>   
> -	p->x = ecc_alloc_digits_space(ndigits);
> +	ndigits_sz = ndigits * sizeof(u64);
> +	p->x = kmalloc(ndigits_sz, GFP_KERNEL);
>   	if (!p->x)
>   		goto err_alloc_x;
>   
> -	p->y = ecc_alloc_digits_space(ndigits);
> +	p->y = kmalloc(ndigits_sz, GFP_KERNEL);
>   	if (!p->y)
>   		goto err_alloc_y;
>   
> @@ -125,7 +116,7 @@ struct ecc_point *ecc_alloc_point(unsigned int ndigits)
>   	return p;
>   
>   err_alloc_y:
> -	ecc_free_digits_space(p->x);
> +	kfree_sensitive(p->x);

With no data in the buffer a kfree() should be sufficient.

>   err_alloc_x:
>   	kfree(p);
>   	return NULL;

