Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603521F94A;
	Tue,  8 Apr 2025 05:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744089389; cv=none; b=e/gEElUFBGJXw2xWlIzmOJIJzkZUKJ1pIgsY6ac3wHWh50BxhNjMxO42u2rtHWt+ECtnNVdXV90YI1Ki00AqfwKU761hzMVtDRq3Lcx10yTt/51bXR5VSwQ3mYYTl4wTqsU3dXW5LPVCZyUAyK+8tRp+RycFhqKXpEYXevYLxfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744089389; c=relaxed/simple;
	bh=6i+FFVX/anHI+k6g7iGUIS/XAYqB9uVRlZSL2DifY24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dD70s3TDAkY2zkRTvPhocDFGqGgwMa+UzjMGkROPJ/mPDlUMi3tJdUmFq6S8cNBfovD0wwEg//u0zzW2eLxBT9TQA7AvcRvzhQr8AreVTwFv+TWxixT9Ep77tbea/I/WVE7tucTx6l7vx68w2wsqRWcxkJoCgkzSMZwcGlDiqoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oAUTate8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oAUTate8"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537HBW2C005830;
	Tue, 8 Apr 2025 05:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JwOomz
	DNqGfIw+1k6STDaVGVQQItqMPhmNt/V6LOo7g=; b=oAUTate84ADkXKfdAFgq/n
	UzQj6xcnsenBFoUPR0gxS1Q9MSWaK5Ws7LKhONpPOcZhXokD75/nrdOui2TU7ryL
	4qiRUsoOyTc90z0R08pbHeNyWoMmRGRc+hG/Be5Y/9lDTpNGus04qAun/uOElSdp
	8+Q0pP71eoivLQpwgxEDTocs5vx0zyL7QLPU3uc+KtzJijRvX6rG7Z68BonXP0OE
	TQ3aZXrXpoj7O2JmgBrxRIZVSjQgxL8sCKXo/nqVnQT1Jpy2J38Zb6HlrYMzS5Gt
	NKxSJP2q2b6xl6V6lNrL7e/QmKKrkISpIoO5pwim5+yrfQTCIVdEXIaSMmEQ7SWw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45vjvxjf31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Apr 2025 05:16:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5382q3V9011062;
	Tue, 8 Apr 2025 05:16:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45uf7yhab1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Apr 2025 05:16:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5385GEiL48497054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Apr 2025 05:16:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48D062004D;
	Tue,  8 Apr 2025 05:16:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D319620040;
	Tue,  8 Apr 2025 05:16:12 +0000 (GMT)
Received: from [9.109.204.62] (unknown [9.109.204.62])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Apr 2025 05:16:12 +0000 (GMT)
Message-ID: <f79f914e-2104-4706-9876-43d084aee1c3@linux.ibm.com>
Date: Tue, 8 Apr 2025 10:46:11 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: scomp - Fix null-pointer deref when freeing
 streams
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <3c239727-6c46-45c2-80e7-d6853427f72c@linux.ibm.com>
 <Z_SkEnIWk8E0mLJf@gondor.apana.org.au>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <Z_SkEnIWk8E0mLJf@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: btnxESdXXpQ6IJEg0gOpRAf2Gt9JczYz
X-Proofpoint-GUID: btnxESdXXpQ6IJEg0gOpRAf2Gt9JczYz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-08_01,2025-04-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504080034

Hello Herbert,


On 08/04/25 09:50, Herbert Xu wrote:
> On Mon, Apr 07, 2025 at 11:49:27PM +0530, Sourabh Jain wrote:
>> [   90.892796] NIP [c000000000845eb0] scomp_free_streams+0x6c/0xe8
>> [   90.892803] LR [c000000000845ee0] scomp_free_streams+0x9c/0xe8
> Looks like I never tested 842 which curiously does not have a
> self-test.  Please try this patch:
>
> ---8<---
> As the scomp streams are freed when an algorithm is unregistered,
> it is possible that the algorithm has never been used at all (e.g.,
> an algorithm that does not have a self-test).  So test whether the
> streams exist before freeing them.
>
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Fixes: 3d72ad46a23a ("crypto: acomp - Move stream management into scomp layer")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index d435d4b24469..f67ce38d203d 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -111,6 +111,9 @@ static void scomp_free_streams(struct scomp_alg *alg)
>   	struct crypto_acomp_stream __percpu *stream = alg->stream;
>   	int i;
>   
> +	if (!stream)
> +		return;
> +
>   	for_each_possible_cpu(i) {
>   		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
>   

The above fix resolves the reported issue.

Thanks for the fix.

Feel free to add:

Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>

Thanks,
Sourabh Jain
