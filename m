Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F61DC1BE;
	Fri, 13 Sep 2024 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726236165; cv=none; b=MiCHodPzc2cn+NGK05Pzk7MQxxPQ2CrJN8OyGj3024/vPumsfi0WxVIJ8idAtG8EFOhzpvRP91/+xvu4br1xL6MRXjmGFWQlInaGCCkfpVrNZluNWiAewhu2fXj376aYGhp2qToTeMcpIzoMkZNEVtJ+ZjWErAy7K88pYERumD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726236165; c=relaxed/simple;
	bh=xIadB+ccdjgivCpdMAC9iTCqKmHqswcnXcqZndJso0A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rta3GH19kG9/g8UX5OJkVkIgzyfZOVGZaXAfqH7mL73i/DGG+4SFgz3O4pdoEVVCJOyLBaH69RZZSBijSDOXXj8kbAi9Pk1fmwUlH7OEpbzT1QF9d7Ifa35gAs/RbFxONRFTK5sX3U9CcXIiftuVOujZ7GTnFJTWMNsnvW0cLrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UElQ8sCn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UElQ8sCn"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D7daD9032755;
	Fri, 13 Sep 2024 14:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	q1qnqZh7DY6ryMgArU4Ju8GzleC6GLVXI4Bd3rfPRDM=; b=UElQ8sCnQWmar16p
	7X4ABi+d9rh5SjANTV+huVoZ/Xi0qmklOw1ZEtUaJ3iHFEyrAY2mK6wjg9UVagVw
	ur/RxMHrAJNihEW3l61pdjbLpH7syqnTUpiLAQWYF3nlVVF65XCv9jv1q7tvJEoa
	J9aZX7NEdac15UnWtAu/q4ewzyBEirOqa/QxdiwNe7h/dxOao+IPOJ5kYtQoog+K
	gzuyREsT1gvye7bvTFrgYfodG5wBHT64vU0r8o+I1r38gtxIYdOi3BmgZaeRX1uJ
	PG8eKV35fPogodnA1pMa5YlkH4EWucRwarSv5eNPY0Sxox+8DpOmkI5YwMARDxdl
	DwDgUA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gegxag1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:02:26 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DBXLwQ019911;
	Fri, 13 Sep 2024 14:02:23 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41h25qejkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 14:02:23 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DE2MHH14484092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 14:02:22 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDB2058051;
	Fri, 13 Sep 2024 14:02:21 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F7865805F;
	Fri, 13 Sep 2024 14:02:21 +0000 (GMT)
Received: from [9.61.250.246] (unknown [9.61.250.246])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 14:02:21 +0000 (GMT)
Message-ID: <89493ea2-b145-489c-94a5-dad8608b9b79@linux.ibm.com>
Date: Fri, 13 Sep 2024 09:02:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: Removing CRYPTO_AES_GCM_P10.
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240913123043.1636183-1-dtsen@linux.ibm.com>
 <4742a397-eb68-4a79-a2fa-fc45a81e7c2b@csgroup.eu>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <4742a397-eb68-4a79-a2fa-fc45a81e7c2b@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xSGeI4CdAPMDSHJQLkSpkRO4NYNF-uGP
X-Proofpoint-ORIG-GUID: xSGeI4CdAPMDSHJQLkSpkRO4NYNF-uGP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_10,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 impostorscore=0 clxscore=1011 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130095

Got it.  Thanks.

-Danny

On 9/13/24 8:55 AM, Christophe Leroy wrote:
>
>
> Le 13/09/2024 à 14:30, Danny Tsen a écrit :
>> [Vous ne recevez pas souvent de courriers de dtsen@linux.ibm.com. 
>> Découvrez pourquoi ceci est important à 
>> https://aka.ms/LearnAboutSenderIdentification ]
>>
>> Removing CRYPTO_AES_GCM_P10 in Kconfig first so that we can apply the
>> subsequent patches to fix data mismatch over ipsec tunnel.
>
> To deactivate a driver, all you have to do is to add:
>
>     depends on BROKEN
>
> Christophe
>
>
>>
>> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
>> ---
>>   arch/powerpc/crypto/Kconfig | 32 ++++++++++++++++----------------
>>   1 file changed, 16 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
>> index 09ebcbdfb34f..96ca2c4c8827 100644
>> --- a/arch/powerpc/crypto/Kconfig
>> +++ b/arch/powerpc/crypto/Kconfig
>> @@ -105,22 +105,22 @@ config CRYPTO_AES_PPC_SPE
>>            architecture specific assembler implementations that work 
>> on 1KB
>>            tables or 256 bytes S-boxes.
>>
>> -config CRYPTO_AES_GCM_P10
>> -       tristate "Stitched AES/GCM acceleration support on P10 or 
>> later CPU (PPC)"
>> -       depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
>> -       select CRYPTO_LIB_AES
>> -       select CRYPTO_ALGAPI
>> -       select CRYPTO_AEAD
>> -       select CRYPTO_SKCIPHER
>> -       help
>> -         AEAD cipher: AES cipher algorithms (FIPS-197)
>> -         GCM (Galois/Counter Mode) authenticated encryption mode 
>> (NIST SP800-38D)
>> -         Architecture: powerpc64 using:
>> -           - little-endian
>> -           - Power10 or later features
>> -
>> -         Support for cryptographic acceleration instructions on 
>> Power10 or
>> -         later CPU. This module supports stitched acceleration for 
>> AES/GCM.
>> +#config CRYPTO_AES_GCM_P10
>> +#      tristate "Stitched AES/GCM acceleration support on P10 or 
>> later CPU (PPC)"
>> +#      depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
>> +#      select CRYPTO_LIB_AES
>> +#      select CRYPTO_ALGAPI
>> +#      select CRYPTO_AEAD
>> +#      select CRYPTO_SKCIPHER
>> +#      help
>> +#        AEAD cipher: AES cipher algorithms (FIPS-197)
>> +#        GCM (Galois/Counter Mode) authenticated encryption mode 
>> (NIST SP800-38D)
>> +#        Architecture: powerpc64 using:
>> +#          - little-endian
>> +#          - Power10 or later features
>> +#
>> +#        Support for cryptographic acceleration instructions on 
>> Power10 or
>> +#        later CPU. This module supports stitched acceleration for 
>> AES/GCM.
>>
>>   config CRYPTO_CHACHA20_P10
>>          tristate "Ciphers: ChaCha20, XChacha20, XChacha12 (P10 or 
>> later)"
>> -- 
>> 2.43.0
>>
>>
