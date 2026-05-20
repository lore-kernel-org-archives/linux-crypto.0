Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB81396562;
	Wed, 20 May 2026 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779263250; cv=none; b=kZfAYHxUgXs6GAVnS1uOfKQ7tLBJIDVw++PzHYD5U6pKipQuwXcprLFi4aPMtLK6M8dZbbNuiGw/KssAVmBHbvFbz8Y5qbGDXRFeSwSISwFrVaCnG4NkmvU+SdVGWAqimmLzl9LZGTQstCEqzKCNOqORQOvbTuM/a47/Jkmgq2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779263250; c=relaxed/simple;
	bh=BOVuVD6r7fGynFSymG3tYnUxgRR3sHbjmMycUkz7aw8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TI/UT5LV29FAUTBR+5rqg4JEFkX/dyf/GPy4DFCimdsqjp4U+8SLgt/6vgOERxXunPAjZrm/DHiK7XRO+VPoez9uUJ07fW5bT9v685R1MSb/HYk2RH1hW+fSLXK4Evui1gvlxYGVqLsMuyYJ2eZ8+pnxt1VJqYXi6jtCTLmzF5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XacvqsH5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XacvqsH5"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64JIUPaa3264940;
	Wed, 20 May 2026 07:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=jnWBek7otMwNnVtGRQneWpUa2PFFQW8ypRyvGiz4+hQ=; b=XacvqsH54Ax2
	EUwLWqTwNh0RkbokW55SNamS0nZwnnbpeBfcIWX26jVrODO+CWyxGjQNjpb/zhyx
	p7xMsLMJwrZKVGddS5C6BWLF9V7rfs/2liMzltJw0zlsmPgPdjZ0jePJzt48moDp
	f30rShluLUCR6fsjVpWNx/6FJXcU3BK92FbzPIdHKumzvzhu6iwya1Qapl/+0BlN
	snHfKSqvSCYDODGgA0pBKS8LcY5Il/gQlsJu2sJIz1p2l05wn5DARB+Kf708zxrA
	Oor1HOpAeBwbF53Ip02Sc6BpGeKguj1O9ph/sbLPSyUG5c9PGnZsiPIdjtJkgb2K
	Pp4VyLh8Lg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6haw8215-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 07:47:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64K7d4VA028344;
	Wed, 20 May 2026 07:47:14 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754ge5em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 07:47:14 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64K7lC8L7078758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 07:47:12 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60B3D58058;
	Wed, 20 May 2026 07:47:12 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24C5B5805B;
	Wed, 20 May 2026 07:47:11 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 07:47:11 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 20 May 2026 09:47:10 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
 <davem@davemloft.net>,
        Holger Dengler <dengler@linux.ibm.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Patrick Steuer
 <patrick.steuer@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel
 <ardb@kernel.org>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: crypto: add select CRYPTO_AEAD for aes
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20260520073911.843561-1-arnd@kernel.org>
References: <20260520073911.843561-1-arnd@kernel.org>
Message-ID: <2b9437e575689047df1624b02e18c545@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDA3MiBTYWx0ZWRfX4uuweW42wRF/
 uhNhELI3tyoG5+ZIAz646Luysn3nUkIu0FQEuGM6NhvGJw3kgW1dOsV2lfKidnNNxKi7Xyk7V0z
 gqsMhL6/y9Mc3cgjyVZ1flXSmoluFLBC36nm459P46fSUJDN0/+pdV6DEcV0DyGilIRaj9Wr87u
 tLIo9+ZSN0ZSzSJlRuFcFidBdbCwiGmUK4Pcf+eb2NyA+TXf1JKUCfhfr3ZQ8goXOjp5byA+JBL
 LFJ2DsUnl0OBn4BaTQisoa+DAD5BQQ894qTLqI2Ezy8bYUL86kcaYWk/OXnVYbJCxuagkNEVs2M
 tCnSH2TQqolW80r6bQvu7Lq0/WRr6iZXNd8Xtj0VQzz71Hk/WIse5H8Onx/0HoEq+TmCi2JlWO+
 p58TRpJp0k9MACuHyGnxezk6qekXHm/y23Zb7FX/3u7/pH9NeFsDOWJdfzEGeGniFdBD+d6wQBQ
 m0U2NplgrGasp/AKKvQ==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0d6702 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=tXU169zhfj9mdt3X8ZIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: eiMKeeFtFqOshUXPd31ya13_OukhjevJ
X-Proofpoint-GUID: eiMKeeFtFqOshUXPd31ya13_OukhjevJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200072

On 2026-05-20 09:38, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The aes driver registers both skcipher and aead algorithms,
> but when aead is not enabled this causes a link failure:
> 
> s390-linux-ld: arch/s390/crypto/aes_s390.o: in function 
> `aes_s390_fini':
> arch/s390/crypto/aes_s390.c:969:(.text+0x115e): undefined reference to
> `crypto_unregister_aead'
> s390-linux-ld: arch/s390/crypto/aes_s390.o: in function 
> `aes_s390_init':
> arch/s390/crypto/aes_s390.c:1028:(.init.text+0x294): undefined
> reference to `crypto_register_aead'
> 
> Add the missing 'select' statement.
> 
> Fixes: bf7fa038707c ("s390/crypto: add s390 platform specific aes gcm 
> support.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/s390/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
> index 00051d27db95..228570a1b233 100644
> --- a/arch/s390/crypto/Kconfig
> +++ b/arch/s390/crypto/Kconfig
> @@ -4,6 +4,7 @@ menu "Accelerated Cryptographic Algorithms for CPU 
> (s390)"
> 
>  config CRYPTO_AES_S390
>  	tristate "Ciphers: AES, modes: ECB, CBC, CTR, XTS, GCM"
> +	select CRYPTO_AEAD
>  	select CRYPTO_SKCIPHER
>  	help
>  	  AEAD cipher: AES with GCM

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
