Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C5115D5C1;
	Mon,  7 Oct 2024 11:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728299253; cv=none; b=lOpzdhNbdBhxO3rsHtz5kSPdf326u7lDjwZ0EXPAhfrhgpmfOCKoaRU/1a/knhdLepQt9NS9qcHqjZglFvL6Jduj2VAw6tT4rxaOdiGf+Dl/VHf8vDoPFNyuCgYEAmAqgwZG/QJ8fSS7ja16qrYzWREKAHqkZbBs4hGVSKFn7HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728299253; c=relaxed/simple;
	bh=WIsUAcB6g5ekP+h/5Qa+2MJuGTsIxkOO9FCOSqFplbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeqHJRyH+bzbck0GK6v0vaJpD+j29oE6HSR9aXVRhMuN5/z/vmIfzR/aPF3EdzATJyApKc9rNwM9xjIVSlnUqD1Y6vwr2Ky5rBTQBp5Ux9udLbr6QKxCoCFZ7VfioFISmePHKDNJmow29DS1j/yD8APtsPPjhO+v3RKP3xGqMRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bkfsrNLI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bkfsrNLI"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4979nq3s003196;
	Mon, 7 Oct 2024 11:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=H
	lfaUppSnhlYTBtOdNhHzLyqLgKPEpMIJGf6GhYDUFw=; b=bkfsrNLIIeP81w49E
	sxCVoSfOA7o54mDxq4BSn4bML01kfdUMKoCShlwoOa15wuNnxA3sgyyST7y9qkHu
	+f8xWn16qZ0+yF38M8MjKCAaaHxg+mKjQuRIU2X+B/rWbg4Du92yGBZyriPAWgny
	ohZbqT+c/Vl2giYVVpNjNuAxv2s+9A0o5l/U18MwD6MpDsCLq+m8YwJRjrYTwLr0
	5nNqyxbxLrRZCWIsxKF8WeH4fuR84sxHuLC9VZ7rxiaNpZV0Urot/wXaWBMoxDBm
	4wJZrCkSr7m3s+yM4eNouk/0lr2VOmp+3U+yn4N6dxNFVhHbdwkb3Jp33P5XcWWI
	3LB4w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 424dbv8bkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 11:02:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 497Au0CT011512;
	Mon, 7 Oct 2024 11:02:05 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423g5xe745-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 11:02:05 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 497B23iW41812290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Oct 2024 11:02:03 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC56958056;
	Mon,  7 Oct 2024 11:02:03 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CF4B58052;
	Mon,  7 Oct 2024 11:02:03 +0000 (GMT)
Received: from [9.61.253.216] (unknown [9.61.253.216])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Oct 2024 11:02:03 +0000 (GMT)
Message-ID: <e1b6c598-0200-49b3-b1af-176826a5e83f@linux.ibm.com>
Date: Mon, 7 Oct 2024 06:02:03 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] crypto: Fix data mismatch over ipsec tunnel
 encrypted/decrypted with ppc64le AES/GCM module.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240923133040.4630-1-dtsen@linux.ibm.com>
 <ZwDQLmwA1LvWx5Dg@gondor.apana.org.au>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <ZwDQLmwA1LvWx5Dg@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Fh1jG0QpfSRCnmdfj-GbvttqGPMGgb90
X-Proofpoint-GUID: Fh1jG0QpfSRCnmdfj-GbvttqGPMGgb90
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-07_01,2024-10-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410070076

Thanks Herbert.

-Danny

On 10/5/24 12:35 AM, Herbert Xu wrote:
> On Mon, Sep 23, 2024 at 09:30:37AM -0400, Danny Tsen wrote:
>> Fix data mismatch over ipsec tunnel encrypted/decrypted with ppc64le AES/GCM module.
>>
>> This patch is to fix an issue when simd is not usable that data mismatch
>> may occur. The fix is to register algs as SIMD modules so that the
>> algorithm is excecuted when SIMD instructions is usable.
>>
>> A new module rfc4106(gcm(aes)) is also added. Re-write AES/GCM assembly
>> codes with smaller footprints and small performance gain.
>>
>> This patch has been tested with the kernel crypto module tcrypt.ko and
>> has passed the selftest.  The patch is also tested with
>> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.
>>
>> Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stitched implementation")
>> Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
>> Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefile")
>>
>> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
>>
>> Danny Tsen (3):
>>    crypto: Re-write AES/GCM stitched implementation for ppcle64.
>>    crypto: Register modules as SIMD modules for ppcle64 AES/GCM algs.
>>    crypto: added CRYPTO_SIMD in Kconfig for CRYPTO_AES_GCM_P10.
>>
>>   arch/powerpc/crypto/Kconfig            |    2 +-
>>   arch/powerpc/crypto/aes-gcm-p10-glue.c |  141 +-
>>   arch/powerpc/crypto/aes-gcm-p10.S      | 2421 +++++++++++-------------
>>   3 files changed, 1187 insertions(+), 1377 deletions(-)
>>
>> -- 
>> 2.43.0
> All applied.  Thanks.
