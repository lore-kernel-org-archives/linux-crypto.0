Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE92021772D;
	Thu,  5 Dec 2024 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733400381; cv=none; b=TXc75bXsIX5KAdbZGYlbOEyItKfMdLhmuajb1BCytTG4vPcEeuCY/jbD3/WhaQosiWFlfdhgUre/WQV0KLKMToR5GdoTt3mlZMi0x7u27b+PR5GOlUgmZjTH5cy2DE3nQlXdQarm6YlBEXZ1b3Dh8K5a3TocONngbv/HNgwmBlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733400381; c=relaxed/simple;
	bh=Yy/HSf7tVDLJwAwkXXm2kqEosZ+dnoV2NQXCXkMSZGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDJwv2UMDGypGrcD0qZnfFHXa2MT7nZeKc9PScAkJd/9ExVxL/P9+sXVLD3gEy5PRD7UOYHMVr18xpD2FB+4XdssNBqwDjdXzGXh849/dD/fBibEhqzjtuirV7aqv5Hjan+5euyaLlY+cGo2t3itPKqJVMvte1LRYJPDLXlD0KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f8WRzxEP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f8WRzxEP"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5A0Y8O027747;
	Thu, 5 Dec 2024 12:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3tZtoJ
	tQWlWyIWi49AkTuKFTyY2Lp/CvC4XNQ55C92g=; b=f8WRzxEPSiGSb8nZb1qzVP
	BjW8VVQwmjlGlu0OdPOHoPwSVwfNN2Sk4weQjmDNm1li4twPSENxgFTqoToUC1i8
	z5XnYHU4rqfGW5/7gW5JFGxkY7EFGInal77q4DYRsdXbL8F28ybM0u0lAVCHyXQk
	6DROTpLeNWXi28b8FeQ/wB6LmpDmrprOXuuH20O5tAPGqT60EBWwCQW3xA1L7qr4
	evyX1+QypJDGBQm3TCpX/un1IPbB7nT2f5VPLndxpfj2ns5Y96OH28/yFmsaQZsc
	sjkihOji3jYDMDpthYWmcA31YrHfu+o7UGoaSH8+zuueZ3Mrfm55lXslrRNelj3w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ba1ygj5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 12:06:01 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B5C1Avf006274;
	Thu, 5 Dec 2024 12:06:00 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ba1ygj5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 12:06:00 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B59x7l7020366;
	Thu, 5 Dec 2024 12:06:00 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 438d1shu23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 12:06:00 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B5C5xRS32178790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Dec 2024 12:05:59 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B93B58043;
	Thu,  5 Dec 2024 12:05:59 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9B3258053;
	Thu,  5 Dec 2024 12:05:55 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Dec 2024 12:05:55 +0000 (GMT)
Message-ID: <9d0a0051-697c-4e25-9fbf-17786475a0e6@linux.ibm.com>
Date: Thu, 5 Dec 2024 17:35:53 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cpumask: work around false-postive stringop-overread
 errors
To: Brian Norris <briannorris@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees@kernel.org, nathan@kernel.org,
        yury.norov@gmail.com, linux@weissschuh.net, gjoyce@ibm.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org
References: <20241112124127.1666300-1-nilay@linux.ibm.com>
 <Z1Cvs1xNSDQRJ1Ri@google.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <Z1Cvs1xNSDQRJ1Ri@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jwCzN67Sj2ryP554-LOmUL4NqMToZnuQ
X-Proofpoint-GUID: -K5m0KhpJ3G2DkYLolWv1S50iFj3-SCg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412050083



On 12/5/24 01:08, Brian Norris wrote:
> Hi Nilay,
> 
> I see you didn't CC the maintainers for this file. You might consider
> looking through:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> And:
> 
> $ scripts/get_maintainer.pl -f kernel/padata.c
> Steffen Klassert <steffen.klassert@secunet.com> (maintainer:PADATA PARALLEL EXECUTION MECHANISM)
> Daniel Jordan <daniel.m.jordan@oracle.com> (maintainer:PADATA PARALLEL EXECUTION MECHANISM)
> linux-crypto@vger.kernel.org (open list:PADATA PARALLEL EXECUTION MECHANISM)
> linux-kernel@vger.kernel.org (open list:PADATA PARALLEL EXECUTION MECHANISM)
> 
> I'll leave the full contents intact below for their sake, with a few
> inline comments as well:
> 
> On Tue, Nov 12, 2024 at 06:11:24PM +0530, Nilay Shroff wrote:
>> While building the powerpc code using gcc 13, I came across following
>> errors generated for kernel/padata.c file:
>>
>>   CC      kernel/padata.o
>> In file included from ./include/linux/string.h:390,
>>                  from ./arch/powerpc/include/asm/paca.h:16,
>>                  from ./arch/powerpc/include/asm/current.h:13,
>>                  from ./include/linux/thread_info.h:23,
>>                  from ./include/asm-generic/preempt.h:5,
>>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
>>                  from ./include/linux/preempt.h:79,
>>                  from ./include/linux/spinlock.h:56,
>>                  from ./include/linux/swait.h:7,
>>                  from ./include/linux/completion.h:12,
>>                  from kernel/padata.c:14:
>> In function ‘bitmap_copy’,
>>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
>>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
>> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
>>   114 | #define __underlying_memcpy     __builtin_memcpy
>>       |                                 ^
>> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
>>   633 |         __underlying_##op(p, q, __fortify_size);                        \
>>       |         ^~~~~~~~~~~~~
>> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
>>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>>       |                          ^~~~~~~~~~~~~~~~~~~~
>> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
>>   259 |                 memcpy(dst, src, len);
>>       |                 ^~~~~~
>> kernel/padata.c: In function ‘__padata_set_cpumasks’:
>> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
>>   713 |                                  cpumask_var_t pcpumask,
>>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
>> In function ‘bitmap_copy’,
>>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
>>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
>> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
>>   114 | #define __underlying_memcpy     __builtin_memcpy
>>       |                                 ^
>> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
>>   633 |         __underlying_##op(p, q, __fortify_size);                        \
>>       |         ^~~~~~~~~~~~~
>> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
>>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>>       |                          ^~~~~~~~~~~~~~~~~~~~
>> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
>>   259 |                 memcpy(dst, src, len);
>>       |                 ^~~~~~
>> kernel/padata.c: In function ‘__padata_set_cpumasks’:
>> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
>>   713 |                                  cpumask_var_t pcpumask,
>>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
>>
>> Apparentrly, above errors only menifests with GCC 13.x and config option
>> CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
>> don't encounter above errors. Prima facie, these erros appear to be false-
>> positive. Brian informed me that currently some efforts are underway by
>> GCC developers to emit more verbose information when GCC detects string
>> overflow errors and that might help to further narrow down the root cause
>> of this error. So for now, silence these errors using -Wno-stringop-
>> overread gcc option while building kernel/padata.c file until we find the
>> root cause.
> 
> You might consider running this paragraph through a spelling checker if you submit a
> v2.
> 
>> Link: https://lore.kernel.org/all/7cbbd751-8332-4ab2-afa7-8c353834772a@linux.ibm.com/
>> Cc: briannorris@chromium.org
>> Cc: kees@kernel.org
>> Cc: nathan@kernel.org
>> Cc: yury.norov@gmail.com
>> Cc: linux@weissschuh.net
>> Cc: gjoyce@ibm.com
>> Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
>> ---
>>  kernel/Makefile | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index 87866b037fbe..e5adba7a30f1 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -120,6 +120,7 @@ obj-$(CONFIG_CFI_CLANG) += cfi.o
>>  obj-$(CONFIG_PERF_EVENTS) += events/
>>  
>>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>> +CFLAGS_padata.o += $(call cc-disable-warning, stringop-overread)
> 
> Personally, I'd recommend a comment here, noting that these warnings
> seem to produce false positives on GCC 13+. But otherwise, this seems OK
> to me:
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> 
>>  obj-$(CONFIG_PADATA) += padata.o
>>  obj-$(CONFIG_JUMP_LABEL) += jump_label.o
>>  obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
>> -- 
>> 2.45.2
>>
Thank you Brian for your review!

I would incorporate all your comments and spin a new patch and send it out soon...

--Nilay
