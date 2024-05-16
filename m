Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E6A1DFCB;
	Thu, 16 May 2024 11:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715859531; cv=none; b=is33MTZf0sY0xM3OYr6+5XJeOvOIJRPKNXj8X7im5BowruHxEnw4r5Ex3fq2NiKYpUSTiYb7B/Pffd7JEPocTml+4+E3JER1Z/nNSZpCdCWHpbcSEFoIYzhq4Z2pQ5qvLnUxBcptuwE99vQAeSdfxPUAIBV5gZFwGikuoCSN4b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715859531; c=relaxed/simple;
	bh=2ADI+XAWgpXxNfcc1TvaNZGCMnvF6+6Jc8UOMq0T8zg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UbK0J9RF321SLz0u9IZ62ydB8qc7bj6DxfUmVoVD58TrJjQrFVU1s/XbpZX5BtXJ5gWDgo0lsEo8yBnGe9VzAh4b2DtFcUYQLk/0RRcB+yBuPNuTv491S2cmc71M5bUcXAtMbVQTJtndbx8sHVH4qwfRQPzzvSComPdkSl8jF1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mXh1tGMi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mXh1tGMi"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44GApt4M025339;
	Thu, 16 May 2024 11:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=5bRqxCdtmzjaCx8M5vJhcH031+uvoifMt9dAk8qBbUo=;
 b=mXh1tGMi5ccz6MZb/tYx0Jij+0wATn10hXfo5D5bQWBtRms4r45NWHhFo/4kZN5OzNDh
 3E6S3SzfT9Mi+wG5csm7nEJKQP/bAgL6oDp02dN83qVflMdRtOttptuR1icegGKxVmCm
 x7xp3pdY5fCACSz3JfI0oaoStlv9q2DXOa+2kClkr2V0Ufg6gbKDnbC4fx65859idzq0
 NrBqueTBU3AI6QhCJw7vKp/FZj3TcMVhPEtbdsKThNhVNORCJVxYMUBYzRZgMAiFbvmt
 NdKr3fo0/ppZ/Y8gfnwGkGdlOaKkdPaoecEyEAaU/st0QRoPY7I8GL7DSQCiCcT6Y5GW lg== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y5gjbg45m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 11:38:30 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44GASP97020349;
	Thu, 16 May 2024 11:38:29 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y2kd09u8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 11:38:29 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44GBcQrC9110100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 May 2024 11:38:28 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B7B75805E;
	Thu, 16 May 2024 11:38:26 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5511058051;
	Thu, 16 May 2024 11:38:25 +0000 (GMT)
Received: from [9.67.138.125] (unknown [9.67.138.125])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 May 2024 11:38:25 +0000 (GMT)
Message-ID: <db79ddf3-cf4d-4b05-b787-3e92e1236e81@linux.ibm.com>
Date: Thu, 16 May 2024 06:38:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: X25519 low-level primitives for ppc64le.
To: Michael Ellerman <mpe@ellerman.id.au>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, ltcgcw@linux.vnet.ibm.com,
        dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-2-dtsen@linux.ibm.com> <87a5kqwe59.fsf@mail.lhotse>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <87a5kqwe59.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RTapjZgpmvATb9mGScqoR56rvIfAqjqj
X-Proofpoint-ORIG-GUID: RTapjZgpmvATb9mGScqoR56rvIfAqjqj
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_05,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405160082


On 5/15/24 11:53 PM, Michael Ellerman wrote:
> Hi Danny,
>
> Danny Tsen <dtsen@linux.ibm.com> writes:
>> Use the perl output of x25519-ppc64.pl from CRYPTOGAMs and added three
>> supporting functions, x25519_fe51_sqr_times, x25519_fe51_frombytes
>> and x25519_fe51_tobytes.
> For other algorithms we have checked-in the perl script and generated
> the code at runtime. Is there a reason you've done it differently this time?

Hi Michael,

It's easier for me to read and use just assembly not mixed with perl and 
it's easier for me to debug and testing also I copied some code and made 
some modification.

>> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
>> ---
>>   arch/powerpc/crypto/curve25519-ppc64le_asm.S | 648 +++++++++++++++++++
>>   1 file changed, 648 insertions(+)
>>   create mode 100644 arch/powerpc/crypto/curve25519-ppc64le_asm.S
>>
>> diff --git a/arch/powerpc/crypto/curve25519-ppc64le_asm.S b/arch/powerpc/crypto/curve25519-ppc64le_asm.S
>> new file mode 100644
>> index 000000000000..8a018104838a
>> --- /dev/null
>> +++ b/arch/powerpc/crypto/curve25519-ppc64le_asm.S
>> @@ -0,0 +1,648 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +#
>> +# Copyright 2024- IBM Corp.  All Rights Reserved.
>   
> I'm not a lawyer, but AFAIK "All Rights Reserved" is not required and
> can be confusing - because we are not reserving all rights, we are
> granting some rights under the GPL.
>
> I also think the IBM copyright should be down below where your
> modifications are described.
Will change that.
>> +# This code is taken from CRYPTOGAMs[1] and is included here using the option
>> +# in the license to distribute the code under the GPL. Therefore this program
>> +# is free software; you can redistribute it and/or modify it under the terms of
>> +# the GNU General Public License version 2 as published by the Free Software
>> +# Foundation.
>> +#
>> +# [1] https://www.openssl.org/~appro/cryptogams/
>> +
>> +# Copyright (c) 2006-2017, CRYPTOGAMS by <appro@openssl.org>
>> +# All rights reserved.
>> +#
>> +# Redistribution and use in source and binary forms, with or without
>> +# modification, are permitted provided that the following conditions
>> +# are met:
>> +#
>> +#       * Redistributions of source code must retain copyright notices,
>> +#         this list of conditions and the following disclaimer.
>> +#
>> +#       * Redistributions in binary form must reproduce the above
>> +#         copyright notice, this list of conditions and the following
>> +#         disclaimer in the documentation and/or other materials
>> +#         provided with the distribution.
>> +#
>> +#       * Neither the name of the CRYPTOGAMS nor the names of its
>> +#         copyright holder and contributors may be used to endorse or
>> +#         promote products derived from this software without specific
>> +#         prior written permission.
>> +#
>> +# ALTERNATIVELY, provided that this notice is retained in full, this
>> +# product may be distributed under the terms of the GNU General Public
>> +# License (GPL), in which case the provisions of the GPL apply INSTEAD OF
>> +# those given above.
>> +#
>> +# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
>> +# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
>> +# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
>> +# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
>> +# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
>> +# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
>> +# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
>> +# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
>> +# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
>> +# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
>> +# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>> +
>> +# ====================================================================
>> +# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
>> +# project. The module is, however, dual licensed under OpenSSL and
>> +# CRYPTOGAMS licenses depending on where you obtain it. For further
>> +# details see https://www.openssl.org/~appro/cryptogams/.
>> +# ====================================================================
>> +
>> +#
>> +# ====================================================================
>> +# Written and Modified by Danny Tsen <dtsen@us.ibm.com>
>> +# - Added x25519_fe51_sqr_times, x25519_fe51_frombytes, x25519_fe51_tobytes
> ie. here.
>
>> +# X25519 lower-level primitives for PPC64.
>> +#
>> +
>> +#include <linux/linkage.h>
>> +
>> +.machine "any"
>   
> Please don't add new .machine directives unless they are required.
>
>> +.abiversion	2
> I'd prefer that was left to the compiler flags.

Ok.

Thanks.

-Danny

>
> cheers
>
