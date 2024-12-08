Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BF8130499;
	Sun,  8 Dec 2024 10:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733653297; cv=none; b=q5eGUC6UCNsGQvREe/6zOG4Omqrg1swrO0iqQsamFetTBhPzgxE6f8zC37NiFqZGWe+mmlG228B0Hue0osXFLvCLTvlgwNHVUhrYGUQPe/yib9aDrAX3WVc6a4PH6Lznkl2u37+YNFUFkmstfR2lvMuDX44bBgAg/MUa85LW/54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733653297; c=relaxed/simple;
	bh=yKgJQxQOPShS45+r7j/u6QpR3XzJWrnUL/9ntipLe3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JwqDDC02tunvB7AMABMojNXPRg8/Gdn3ZfyyoBSze0cEa6xjqQcYP5iEkiIDN15SrqhuYDG4S86GeIv8ekrMDOh4yx/1P7WXp5Z2n8C969BceqfGFcMAg613JffrhhvA4sVVHKf5WjKR7SoRHBE+vRGaa0CsCdFCJ5vemPX785I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cX6q/QPD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cX6q/QPD"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B88PYbg013820;
	Sun, 8 Dec 2024 10:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kiT/qW
	Fh0en1k/C0lX6HQhn+T6CYX5xHsM/7W5rRJaw=; b=cX6q/QPDxK4zvOWW3oYuTo
	IWm1/NyiAVc40gMAI6cIB32zAWA+Xk+81JqHUwUNca+bpgSSDaX2KexwH2Lc0zJw
	2dFdhElxdRD0o5h1M86kbSH/fAIEL61EceUl5QmPbsl9ssarcvZzK5D/983o92Hm
	wULiC+sCmv/gcpveiqACTCSBTPOw1nQ7/ykPqZFp6jqMXeQhmF+vkkXQ/0L8AtVY
	IdsADCdagvMFJFLxiEv9MXlZQnA23HV8FzvpfsLzn3qjVjFFxdEB245zA2FDlCHx
	vS8rVE91rboLKOPPqOfYpIBul5zbEm4fMV0yJCWZM3Rexzh1MVogwHsi92LqPsiA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce1vchc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Dec 2024 10:21:18 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B8ALHYL032743;
	Sun, 8 Dec 2024 10:21:17 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce1vchc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Dec 2024 10:21:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B85UjtV016919;
	Sun, 8 Dec 2024 10:21:16 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12xsqyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Dec 2024 10:21:16 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B8ALFe031130178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 8 Dec 2024 10:21:15 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7ACCE58055;
	Sun,  8 Dec 2024 10:21:15 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 370CE58043;
	Sun,  8 Dec 2024 10:21:12 +0000 (GMT)
Received: from [9.179.1.228] (unknown [9.179.1.228])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  8 Dec 2024 10:21:11 +0000 (GMT)
Message-ID: <d81e9a7a-2209-4fb2-93fe-1fd2afece176@linux.ibm.com>
Date: Sun, 8 Dec 2024 15:51:10 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] cpumask: work around false-postive stringop-overread
 errors
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org, kees@kernel.org,
        nathan@kernel.org, yury.norov@gmail.com, steffen.klassert@secunet.com,
        daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org,
        linux@weissschuh.net, gjoyce@ibm.com
References: <20241205123413.309388-1-nilay@linux.ibm.com>
 <2024120757-lustrous-equinox-77f0@gregkh>
 <2024120710-cahoots-obituary-d32d@gregkh>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <2024120710-cahoots-obituary-d32d@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TBoiXFFugO5XuhtcfKAZ_PEaDyFmYp_N
X-Proofpoint-ORIG-GUID: jkm3_E33xP421M-RQYtb0a6N-Xs2YLdR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412080083



On 12/7/24 17:14, Greg KH wrote:
> On Sat, Dec 07, 2024 at 12:43:19PM +0100, Greg KH wrote:
>> On Thu, Dec 05, 2024 at 06:04:09PM +0530, Nilay Shroff wrote:
>>> While building the powerpc code using gcc 13, I came across following
>>> errors generated for kernel/padata.c file:
>>>
>>>   CC      kernel/padata.o
>>> In file included from ./include/linux/string.h:390,
>>>                  from ./arch/powerpc/include/asm/paca.h:16,
>>>                  from ./arch/powerpc/include/asm/current.h:13,
>>>                  from ./include/linux/thread_info.h:23,
>>>                  from ./include/asm-generic/preempt.h:5,
>>>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
>>>                  from ./include/linux/preempt.h:79,
>>>                  from ./include/linux/spinlock.h:56,
>>>                  from ./include/linux/swait.h:7,
>>>                  from ./include/linux/completion.h:12,
>>>                  from kernel/padata.c:14:
>>> In function ‘bitmap_copy’,
>>>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
>>>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
>>> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
>>>   114 | #define __underlying_memcpy     __builtin_memcpy
>>>       |                                 ^
>>> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
>>>   633 |         __underlying_##op(p, q, __fortify_size);                        \
>>>       |         ^~~~~~~~~~~~~
>>> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
>>>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>>>       |                          ^~~~~~~~~~~~~~~~~~~~
>>> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
>>>   259 |                 memcpy(dst, src, len);
>>>       |                 ^~~~~~
>>> kernel/padata.c: In function ‘__padata_set_cpumasks’:
>>> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
>>>   713 |                                  cpumask_var_t pcpumask,
>>>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
>>> In function ‘bitmap_copy’,
>>>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
>>>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
>>> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
>>>   114 | #define __underlying_memcpy     __builtin_memcpy
>>>       |                                 ^
>>> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
>>>   633 |         __underlying_##op(p, q, __fortify_size);                        \
>>>       |         ^~~~~~~~~~~~~
>>> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
>>>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>>>       |                          ^~~~~~~~~~~~~~~~~~~~
>>> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
>>>   259 |                 memcpy(dst, src, len);
>>>       |                 ^~~~~~
>>> kernel/padata.c: In function ‘__padata_set_cpumasks’:
>>> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
>>>   713 |                                  cpumask_var_t pcpumask,
>>>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
>>>
>>> Apparently, above errors only manifests with GCC 13.x and config option
>>> CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
>>> don't encounter above errors. Prima facie, these errors appear to be false-
>>> positive. Brian informed me that currently some efforts are underway by
>>> GCC developers to emit more verbose information when GCC detects string
>>> overflow errors and that might help to further narrow down the root cause
>>> of this error. So for now, silence these errors using -Wno-stringop-
>>> overread gcc option while building kernel/padata.c file until we find the
>>> root cause.
>>
>> I'm hitting this now on Linus's tree using gcc14 on x86-64 so this isn't
>> just a problem with your arch.
Thanks Greg for confirming that this is not isolated to PowerPC!!
>>
>> Let me try this patch locally and see if it helps...
> 
> Yes, fixes the build for me, so either this is a real fix, or something
> else needs to be done for it, so I'll give a:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> for now.
Okay so now we've an evidence confirming that this is no longer PowerPC specific 
issue. Hence as Yury suggested, in another mail[1], fixing this error by disabling
stringop-overread globally for GCC13+ and CONFIG_FORTIFY_SOURCE=n, I will spin a 
new patch and submit it.

[1] https://lore.kernel.org/all/Z1HTdtvNjm-nZSvJ@yury-ThinkPad/

Thanks,
--Nilay
