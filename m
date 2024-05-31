Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F985200B7;
	Fri, 31 May 2024 21:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717189831; cv=none; b=j5nI2NzZDyJ1AdgtgmOBrsOmfFsJdFX5S/FZN50qTMXntIkQJh8tnMbu3km+ZymDm56WGRtTlQ166fY+Q2QnhS+qBtnk50e7Pp9AAa8bgE9LFgd2nReGhqG7DkxioW9z4ArliVfPTMpYtpqsO3Q4G7/Rypkz92gimxLc0j8DLis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717189831; c=relaxed/simple;
	bh=MPXXnKDh2aZ6B2laaAKBhfY3JjGwgsV8usQmQv+N7Gw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FI3b1poGoCXQCx1bCw2uszGz8/ZpkI3eYHUXsUHXMlc2alZ5khEwamxsCP0L0NhULx5att7wzON+oklakPcQkuDCFhakbkHW/9j6bh985MwXZN2PBr/yVwjiciqtOENKvkESg38j7K0gCmAEbj6C3iaDfBPsAbA0Llf0kco+4sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hO0+5HwC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hO0+5HwC"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44VKjlQs003440;
	Fri, 31 May 2024 21:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=rA8cLUV+37eItOYNc5h1LCYPwTbIyEdRLeqhTlQuMEs=;
 b=hO0+5HwC7D139vrOI1ZibjPY1kt2/Tqj0mRtxNt1v5MS4ojs4hQ1Sh4KfQYn1CW21voF
 VdgkrLDShVQj+K6KL2ULpme4OR3m7dYKGmK5yk4XfsCnTK+JNetD4HglxBLVOWG9yQYe
 YUCeU71n26KLYuUm2YeOSNQRn6znQubjE/twiiigw1GCIw2ImozuY8/j02r8dur3XNLM
 17o5xs3dFtZtYC5YjzaxxScDlWVyyHDU/B5COBMWPLikhFTNM+JzVMEua8wfIW89oOEJ
 zgOcItZH+z4vFZHdj/+UOLAu4F0EpuzBAIuCwKi9n68ARJ+YC56cWqUZ3FFXzhRzXyZM bQ== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yfnd103a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 21:10:10 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44VJZ1uq002437;
	Fri, 31 May 2024 21:10:09 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ydpb123f6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 21:10:09 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44VLA68811797172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 21:10:08 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADAE658071;
	Fri, 31 May 2024 21:10:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B11E958076;
	Fri, 31 May 2024 21:10:05 +0000 (GMT)
Received: from [9.67.180.145] (unknown [9.67.180.145])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 May 2024 21:10:05 +0000 (GMT)
Message-ID: <cc3c8213-cf64-4eb5-9508-8d80b1ce6333@linux.ibm.com>
Date: Fri, 31 May 2024 16:10:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] crypto: X25519 supports for ppc64le
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240516151957.2215-1-dtsen@linux.ibm.com>
 <Zlmkgisql2NxPcXi@gondor.apana.org.au>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <Zlmkgisql2NxPcXi@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0-CDeAQI6eP4-dv1vUzumlx09OVAU8yg
X-Proofpoint-ORIG-GUID: 0-CDeAQI6eP4-dv1vUzumlx09OVAU8yg
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_14,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 phishscore=0 spamscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405310161

Thanks Herbert.


On 5/31/24 5:20 AM, Herbert Xu wrote:
> On Thu, May 16, 2024 at 11:19:54AM -0400, Danny Tsen wrote:
>> This patch series provide X25519 support for ppc64le with a new module
>> curve25519-ppc64le.
>>
>> The implementation is based on CRYPTOGAMs perl output from x25519-ppc64.pl.
>> (see https://github.com/dot-asm/cryptogams/)
>> Modified and added 4 supporting functions.
>>
>> This patch has passed the selftest by running modprobe
>> curve25519-ppc64le.
>>
>> Danny Tsen (3):
>>    X25519 low-level primitives for ppc64le.
>>    X25519 core functions for ppc64le
>>    Update Kconfig and Makefile for ppc64le x25519.
>>
>>   arch/powerpc/crypto/Kconfig                   |  11 +
>>   arch/powerpc/crypto/Makefile                  |   2 +
>>   arch/powerpc/crypto/curve25519-ppc64le-core.c | 299 ++++++++
>>   arch/powerpc/crypto/curve25519-ppc64le_asm.S  | 671 ++++++++++++++++++
>>   4 files changed, 983 insertions(+)
>>   create mode 100644 arch/powerpc/crypto/curve25519-ppc64le-core.c
>>   create mode 100644 arch/powerpc/crypto/curve25519-ppc64le_asm.S
>>
>> -- 
>> 2.31.1
> All applied.  Thanks.
