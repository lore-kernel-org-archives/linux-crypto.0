Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CD921ABCF;
	Fri, 27 Jun 2025 07:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751008426; cv=none; b=s1JFNPX88W6q9JK6MfcKle/X73n2Mg01fWBoAuf+KgzDOqkuSxdT+PXUBgFT/4jCZNko/cnrHWUxotbJwz+xzNrhy8E5DdGHlKH8iEZsvfNoqlANqvisk679aqjla0p4h8ENfz5S12YqsGbZrcyEfwSEZfC1pF0xcNbZH2U5CG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751008426; c=relaxed/simple;
	bh=oRuObBtJMtdBKai9YZobdenr/0LZEFyJ3a9I12B3qtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEkXt4LEb35glHnWVDmvOTemcDuQOwtETopnfgY0vV9FXQMLlcs69pR0oR4b6A8g9kiVIeWx3aclfYlLEh78fFkHK+hO6F7uszBp/Z/VefoGvbo80xVsWnKVtyMe0fXWZ3eu4iN4FrgRYMz/QEI7tHpL4TBNuAT43jPnFqZtBe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H13tz36R; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H13tz36R"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55QNKWdo031037;
	Fri, 27 Jun 2025 07:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XWRt4G
	RXhBmxphzhbfGlkUq+/WLGTB8nhodH4wYi1xc=; b=H13tz36RvleqtiC7TAKN0d
	P2BLWcFKahhE1j6gxEijFPCJ0WYpnm74ZJJPZWdkRE0jT/dXt0njJaUFwoohOiIZ
	6FPa81AHcW1ARa2h9EpI0sys5jHEiKBDDM22DU0a6fn+eI/G//KDvXPqIzPHY+C+
	CybX/8DaIfhKUEzhM/j98kTPh4glAzyx4iFW6JqM/ZlXstis64Gwd59UVwtn18NA
	EO3NucMys5DI2UjFRCXG1J8039Exd/vnZQYLZvPa24vjeYiyBOpapMffkcTh7hTN
	yq3wz8/eKfuenAlgXbB6WZFPkpeYNzBe+if3PKI6bH/CUw3FfYCJKuy9GMKZhIGg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dk64baud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 07:13:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55R5FM3q002918;
	Fri, 27 Jun 2025 07:13:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47e8jmjtxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 07:13:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55R7DNiN58720700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 07:13:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B9B120040;
	Fri, 27 Jun 2025 07:13:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 408922004D;
	Fri, 27 Jun 2025 07:13:22 +0000 (GMT)
Received: from [9.111.221.254] (unknown [9.111.221.254])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Jun 2025 07:13:22 +0000 (GMT)
Message-ID: <8bd4f8d6-394c-4d3e-b0cb-59ba7da518ae@linux.ibm.com>
Date: Fri, 27 Jun 2025 09:13:22 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Syzbot finding: invalid-load in arch/s390/crypto/sha_common.c
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org, Joerg Schmidbauer <jschmidb@de.ibm.com>
References: <12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com>
 <20250626173441.GA1207@sol> <20250626231357.GA3143208@google.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <20250626231357.GA3143208@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDA1MyBTYWx0ZWRfX3H9yFcv3Ixk6 dXVJQXyM5zqCHn9jJvSlmzt0B33ONuEhCuuriwvAD6RgOIPHkto9lCgMnTcyHfYEvtbYCl849zD qw52BeDZSgZiuWJEUqWhTfIBu8/rU9/zR6LSwqqMsn7pwnC0034fmx5furlJgh434tKul2iN2x4
 M5JFSdVr7neQ9joDzkIOp+RpG6JbRFKBFi0WHNN+F3LbjJNeUemEm86qETWRvDO5N3+Tr2QhZvX 6QTZX+OoaOFJFt97Dj1AYkZVYvILpckJgfs5XMa2OarpssEZT79jtjxfjnkRZfAVeXoboCZEruO nXP8VQbK89JZ3qYZ6+Cug7dqUYRyAcCIzmYsq28ggdQm4BuZQlwZWZUEChr6wk1qtvpzlmwGEwC
 cSnJc+HleKnRKif8EQX/G9kgIBtXLRRmvuKXKBi/uhXY7lh9/ZMJ1gikor0L21CNtqRcHnse
X-Proofpoint-ORIG-GUID: CB24ixmxRbY4hLFMNSP4KsQE1__P_1X0
X-Proofpoint-GUID: CB24ixmxRbY4hLFMNSP4KsQE1__P_1X0
X-Authority-Analysis: v=2.4 cv=BfvY0qt2 c=1 sm=1 tr=0 ts=685e449c cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=R9pBmaMNjwuukGYZFQAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_02,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 suspectscore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506270053

On 27.06.2025 01:13, Eric Biggers wrote:

> 
> Sorry, looking at the stack trace again, I realize that's not quite correct:
> 
>  [<00026a33d51d0d6e>] s390_sha_update_blocks+0x2ae/0x310 arch/s390/crypto/sha_common.c:26
>  [<00026a33d7de95c4>] crypto_shash_finup+0x424/0x720 crypto/shash.c:152
>  [<00026a33d7e06022>] crypto_shash_update include/crypto/hash.h:992 [inline]
>  [<00026a33d7e06022>] hmac_setkey+0x5c2/0x7a0 crypto/hmac.c:73
>  [<00026a33d7de8e1c>] crypto_shash_setkey+0x8c/0x1f0 crypto/shash.c:56
>  [<00026a33d7dee7c2>] hkdf_extract+0x42/0xa0 crypto/hkdf.c:50
>  [<00026a33d5fd5c16>] fscrypt_init_hkdf+0x146/0x280 fs/crypto/hkdf.c:73
> 
> This issue actually occurred with hmac(sha512-s390), i.e. the hmac template on
> top of the algorithm with driver name sha512-s390.  So this seems to be a
> regression from earlier commits.  I think this one:
> 
>     commit 88c02b3f79a61e659749773865998e0c33247e86
>     Author: Joerg Schmidbauer <jschmidb@de.ibm.com>
>     Date:   Wed Aug 28 13:52:30 2024 +0200
> 
>         s390/sha3: Support sha3 performance enhancements
> 
> That introduced 'first_message_part' but forgot to make sha512_init() set it.

Right first_message_part should be set to zero in sha512_init(), also in sha384_init() as well as in s390_sha1_init().

> So s390_sha_update() started using an uninitialized variable.
> 
> The following more recent commit then changed 'first_message_part' to a bool,
> which made UBSAN sometimes able to report its uninitialized use:
> 
>     commit 7b83638f962c30cb6271b5698dc52cdf9b638b48
>     Author: Herbert Xu <herbert@gondor.apana.org.au>
>     Date:   Fri Apr 18 10:59:34 2025 +0800
> 
>         crypto: s390/sha1 - Use API partial block handling
> 
> Fortunately, this issue no longer exists in SHA-512 in the latest linux-next,
> since my SHA-512 library work
> (https://lore.kernel.org/linux-crypto/20250616014019.415791-15-ebiggers@kernel.org/).
> greatly simplified how the s390-optimized SHA-512 code is integrated.
> 
> However, my SHA-512 library work is targeting 6.17.  I think you'll need a fix
> for 6.16 and Cc'ed to stable that just initializes 'first_message_part' in the
> old code...
> 
> - Eric
> 


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
