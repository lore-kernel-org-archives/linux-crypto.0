Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506C41A3BC3;
	Fri,  6 Dec 2024 09:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733476217; cv=none; b=o9EkAOGQYO2iG0n80+DoEpGK6SianL9MvVsuo6CURptDhpVLe6ARxMTRDj8o83anVnMjPAqJAxZRmjv7AdVuonlRHaS4LqWJhR2AEQcPjLQVyVATroMufo4Hpa57IiLCsa5L80B5eiWXxk3vteBdkvgqkRQyOzaFmOPiA6o/CEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733476217; c=relaxed/simple;
	bh=a4OSLk9cY5elkTID42SmCpeConZ/a9UZ9EAi2Xb31sI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2PbFRdLAp9dCvjOoBUwDn3kptwHxQO1K7m1bz7mqdU7nBnpRBGNiqfbJUNkF3lCGwYsnY3XyzzqeXHecyzH44Ic2h7GViouLTSI8etpmJeVhnMollyVb0OTsFfTNn7TdlH5esyvZS6D1iZoKGcH/SXXdjAPv4pS0l7+v3r7XX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Pkxz/Z8Y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pkxz/Z8Y"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B68HBnb027955;
	Fri, 6 Dec 2024 09:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=j0Uomf
	YWhPFuwFUCsJsWZucZJgrDiqRY/AlJmNMWj9k=; b=Pkxz/Z8YiwjBE7oLpswxop
	bk7n8ZXn+02IlhaAN/zwF7YGqW9T0IaHr6wVZRkeylBHHvjWSPbmG1eezDvBcpTz
	qZu/Aja434oCq8jAguHlRB+FoLl9Nxlz1G36/MFV6nez8rVZBvryeU1cYZw8NvVS
	s3NsTDDEOoU55TpbmnBlKSQ2JhQd/OYmzChRnFVoOuhPm81TRPRcS2bZw/E4y37D
	DFDYmAdziFJtIxPsPJA/PDaF93tHZDPRLPhj8XLnax4BGz5C3RvZb6pgZtrwvr9c
	6R0YxsrEwDCvDCkqUzZMNgL1kKpw712v/JmRF0rNxNYa+V+XqnFu8B5Zk2jkJ+Yw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ba1ynnxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Dec 2024 09:10:05 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B68oC58007156;
	Fri, 6 Dec 2024 09:10:05 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ba1ynnxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Dec 2024 09:10:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B67vDNB020536;
	Fri, 6 Dec 2024 09:10:04 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 438d1sp1s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Dec 2024 09:10:04 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B69A3RO45482292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Dec 2024 09:10:03 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78C3458059;
	Fri,  6 Dec 2024 09:10:03 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0130558057;
	Fri,  6 Dec 2024 09:10:00 +0000 (GMT)
Received: from [9.179.0.162] (unknown [9.179.0.162])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Dec 2024 09:09:59 +0000 (GMT)
Message-ID: <9c99c993-c8b5-483e-af87-c94373e14e80@linux.ibm.com>
Date: Fri, 6 Dec 2024 14:39:58 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] cpumask: work around false-postive stringop-overread
 errors
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org, kees@kernel.org,
        nathan@kernel.org, steffen.klassert@secunet.com,
        daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org,
        linux@weissschuh.net, gjoyce@ibm.com
References: <20241205123413.309388-1-nilay@linux.ibm.com>
 <Z1HTdtvNjm-nZSvJ@yury-ThinkPad>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <Z1HTdtvNjm-nZSvJ@yury-ThinkPad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MexZ1YLyT6SiaIVlIjEeFPMObrPw0SFv
X-Proofpoint-GUID: yeLizGQ8ew_rI1ie5eFm3M2HMh2BoarK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412060065


Thank you Yuri for insightful comments! Please see my responses inline...

On 12/5/24 21:53, Yury Norov wrote:
> On Thu, Dec 05, 2024 at 06:04:09PM +0530, Nilay Shroff wrote:
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
>> Apparently, above errors only manifests with GCC 13.x and config option
>> CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
>> don't encounter above errors. Prima facie, these errors appear to be false-
> 
> If it works for pre-GCC13, and likely for clang, you shouldn't disable it
> for them. It should be enabled for CONFIG_FORTIFY_SOURCE=n, as well.
> 
> Check config CC_NO_ARRAY_BOUNDS for an example of how versioned flags
> are implemented.
> 

>> positive. Brian informed me that currently some efforts are underway by
>> GCC developers to emit more verbose information when GCC detects string
>> overflow errors and that might help to further narrow down the root cause
>> of this error.
> 
> I'm 100% sure that Brian is a great person and his information is
> absolutely correct and complete. But this is just not how we write
> commit messages.
> 
> Please avoid personal references, vague statements and news from
> the future.
> 
Sure, I would do the needful for future patches.

>> So for now, silence these errors using -Wno-stringop-
>> overread gcc option while building kernel/padata.c file until we find the
>> root cause.
> 
> You didn't provide any evidence that this warning is specific for padata.
> 

Let me just show you the test matrix for the stringop-overread error:

ARCH PowerPC:
compiler    CONFIG_FORTIFY_SOURCE    -Werror=stringop-overread
gcc 11.x     Y                         N
gcc 11.x     N                         N  
gcc 12.x     Y                         N
gcc 12.x     N                         N
gcc 13.x     Y                         Y
gcc 13.x     N                         N
clang 18.x   Y                         N
clang 18.x   N                         N

ARCH x86_64:
compiler    CONFIG_FORTIFY_SOURCE    -Werror=stringop-overread
gcc 11.x     Y                         N
gcc 11.x     N                         N  
gcc 12.x     Y                         N
gcc 12.x     N                         N
gcc 13.x     Y                         N
gcc 13.x     N                         N
clang 18.x   Y                         N
clang 18.x   N                         N

From the above matrix, we could see that the sringop-overread error is only encountered
when we use gcc 13 on PowerPC machine and the stringop-overread error is seen only when we 
enable CONFIG_FORTIFY_SOURCE. Furthermore, so far I've only encountered this error while 
compiling kernel/padata.c file. 

> And indeed the subject states that this is a cpumasks-related warninig.
> Cpumask is a global subsystem. If you believe that this warning is
> false-positive, it may show up for any other random victim. Please
> suppress it globally.
> 
Yes you were correct, this warning might appear for any other random victims. But as 
I mentioned earlier, so far I've only encountered it with kernel/padata.c file. 
So, if we want to reduce the blast radius then wouldn't it be sufficient to just silence 
it only while compiling kernel/padata.c file? Or do you still suggest disabling it at
global level would be more helpful? I'm OK with either way moving forward. Please let 
me know.

> Thanks,
> Yury
> 
Thanks,
--Nilay

>>
>> Link: https://lore.kernel.org/all/7cbbd751-8332-4ab2-afa7-8c353834772a@linux.ibm.com/
>> Cc: briannorris@chromium.org
>> Cc: kees@kernel.org
>> Cc: nathan@kernel.org
>> Cc: yury.norov@gmail.com
>> Cc: steffen.klassert@secunet.com
>> Cc: daniel.m.jordan@oracle.com
>> Cc: linux-crypto@vger.kernel.org
>> Cc: linux@weissschuh.net
>> Cc: gjoyce@ibm.com
>> Reviewed-by: Brian Norris <briannorris@chromium.org>
>> Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
>> ---
>> Changes from v1:
>>     - Fix spell error in the commit message (Brian Norris)
>>     - Add commentary around change to note that changes are needed to
>>       avoid false positive on gcc 13+ (Brian Norris)
>>     - Add the kerenl/padata.c file maintainers (Brian Norris)     
>> ---
>>
>>  kernel/Makefile | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index 87866b037fbe..03242d8870c7 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -120,6 +120,10 @@ obj-$(CONFIG_CFI_CLANG) += cfi.o
>>  obj-$(CONFIG_PERF_EVENTS) += events/
>>  
>>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>> +
>> +# Silence the false positive stringop-overread errors on GCC 13+
>> +CFLAGS_padata.o += $(call cc-disable-warning, stringop-overread)
>> +
>>  obj-$(CONFIG_PADATA) += padata.o
>>  obj-$(CONFIG_JUMP_LABEL) += jump_label.o
>>  obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
>> -- 
>> 2.45.2
