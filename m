Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B057158219;
	Wed, 18 Sep 2024 06:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726642244; cv=none; b=ObqhoWDXUp+pq1y+RGUX5pVRIwByHF7g9OeU8WEi8Ypf1fGOnb4PIxx5spA5Mzwu6Y1WpE5XrEXuPBLaAI8q4HAdoU+ZJwMxPMvfK9EmmP1eBimr3aMSW0oVry9MpKCQyJphN66Gh7gxm743IhLXtHkJ4Je+UxQBKQzI+85kJZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726642244; c=relaxed/simple;
	bh=Mv/xnR+BMCW4dhQ+cL8x9jaARRDBVamoAssr9uhqXkI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WfvPlgyqG9db3Ad2GtPHMhuGLow6ZtLHQ2symllJ2XRk0vpJYb9S1kdeu/DsFbZriKOr/dV0g8aydahpEU/sMFaOT/YzEU19vwWIIUXNZAoaJeIv8Qho4N1T9I99EODaGo9VnK8rA/ZTtaxuHrZXI7ZpJZB6nX6ttxHm8DRPoTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fgYPP3nd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fgYPP3nd"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48HJwIZW006069;
	Wed, 18 Sep 2024 06:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	qvzu/AwG81onHEOlPN3l1QtvXe/POzJ6SaYH+NjQVpQ=; b=fgYPP3nd1TpAMqPX
	Vn6yW04Os4A7OgdXGjHQjmQktnWkrIaLCG2EZAj5uIm/h6wZuzWKbmKFEI5Jr8R+
	szrRW6PiST7N/ybPfaoCWZ5b/ZKXOH1mih1KVUcnpzlCem8SPCw5a+6/IVNVwepO
	RaA7To4s9J0t5rZOahM8PRfMp5k4KeIymKPPz26DgKTEscyUoFfSyHmHfHKuugZ+
	fnCXgpTOEfz/4TdPdV8mUA/U7k5cZ2RGrw+I6fx7YqNaniGt7PahEC9AeY8O3U56
	UxBOP1gBoC1y61E9Np1vX9F7bH37LrTaQi2GckFQYqRWYm5BMUJZEbvybKgTTeFV
	2evAcw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n41akq83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 06:50:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48I3mY1j000765;
	Wed, 18 Sep 2024 06:50:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41nntq9ecw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 06:50:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48I6oUHt18219384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Sep 2024 06:50:30 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F82C20043;
	Wed, 18 Sep 2024 06:50:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12E9020040;
	Wed, 18 Sep 2024 06:50:30 +0000 (GMT)
Received: from [9.171.211.242] (unknown [9.171.211.242])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Sep 2024 06:50:30 +0000 (GMT)
Message-ID: <4c413338-808f-430c-bc03-624ac789cfff@linux.ibm.com>
Date: Wed, 18 Sep 2024 08:50:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s390/paes - Fix module aliases
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>
References: <6399cdf3-3bf4-4623-8be6-cd8978d11770@linux.ibm.com>
 <ZulMEyvIWNtbZJHD@gondor.apana.org.au>
 <4b694c31-5d5c-40b8-8f2e-da858c3001d9@linux.ibm.com>
 <ZupQq2os75c_BFRz@gondor.apana.org.au>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <ZupQq2os75c_BFRz@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pgVUUORoUDALCS184sxL1_v1odjj0XLo
X-Proofpoint-ORIG-GUID: pgVUUORoUDALCS184sxL1_v1odjj0XLo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-18_05,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409180036

On 18.09.2024 06:01, Herbert Xu wrote:
> On Tue, Sep 17, 2024 at 11:54:30AM +0200, Ingo Franzki wrote:
>>
>> I used 'make defconfig' on s390x, so nothing special: 
> 
> Thanks, it turns out to be an existing bug but it just happens
> to have worked.
> 
> ---8<---
> The paes_s390 module didn't declare the correct aliases for the
> algorithms that it registered.  Instead it declared an alias for
> the non-existent paes algorithm.
> 
> The Crypto API will eventually try to load the paes algorithm, to
> construct the cbc(paes) instance.  But because the module does not
> actually contain a "paes" algorithm, this will fail.
> 
> Previously this failure was hidden and the the cbc(paes) lookup will
> be retried.  This was fixed recently, thus exposing the buggy alias
> in paes_s390.
> 
> Replace the bogus paes alias with aliases for the actual algorithms.
> 
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Fixes: e7a4142b35ce ("crypto: api - Fix generic algorithm self-test races")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
> index 99ea3f12c5d2..b8d9f385555d 100644
> --- a/arch/s390/crypto/paes_s390.c
> +++ b/arch/s390/crypto/paes_s390.c
> @@ -802,7 +802,10 @@ static int __init paes_s390_init(void)
>  module_init(paes_s390_init);
>  module_exit(paes_s390_fini);
>  
> -MODULE_ALIAS_CRYPTO("paes");
> +MODULE_ALIAS_CRYPTO("ecb(paes)");
> +MODULE_ALIAS_CRYPTO("cbc(paes)");
> +MODULE_ALIAS_CRYPTO("ctr(paes)");
> +MODULE_ALIAS_CRYPTO("xts(paes)");
>  
>  MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm with protected keys");
>  MODULE_LICENSE("GPL");

I can confirm that this solves the problem.
Thanks for identifying this!

Tested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>

Trough which tree should we carry this patch forward? 
Through the crypto tree or the s390 tree? 
@Heiko @Harald @Herbert opinions?

-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
