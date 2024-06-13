Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B95F5E093;
	Thu, 13 Jun 2024 21:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718312529; cv=none; b=OmLlWcfVaggRnvPAX5zdHl+M3kT5vlG5AaSYqIgvmjmiTKfsirnpmUnqhm/FHK8mHlaEPTnxl42vQJE+PJUGj5LErNjEIRJVAr8kC3hqER65aPY/U05al3hPRcf6yyMjDicc9+29Jp/sImfRUTakmqYT939Ralam2pBgWMCckwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718312529; c=relaxed/simple;
	bh=tKKbvIQnbh8zC0WAL8G2kdw+/LvCwuvF07750GhqBKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D0IeikPH8hI5md2l3uNSq7pME49ZeCKe0uRS+RSfgtPce1Rd8RWRy+U02Senc3wOr92WlPZIhy7YmbfNl5FJLya1T88/KsG+87FeFKc8XvMpVmgQfuO63AEtTFoiP6ME02LcK39DUPOv+lxnS3dSGd8Wro97ZwN/+MwCiZDi5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Bm8a/hfl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bm8a/hfl"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DIPlKK014063;
	Thu, 13 Jun 2024 21:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=5
	tB0kKxM/8miz+1cTCoKSmpeuL/sXgmtHyzkza/6UvU=; b=Bm8a/hflZzg30PdAM
	ch4nzLgKbof2T7Tky8MR2lyDsRGPsdJ57LRuaghLShLNywMbutgULs1quzWQr3Oc
	p2AFgeHMziWjoW9RFPMcO1Bw2oa1DDgaqR0AKTbMxzz3+9h9EM/EdPe9vJg3NhBO
	pmSf4/i+NoWBleodGTXvg7TsTfchKe3mi4oGuSPHuvR5J44Mxa9bgdoCcLOQsYp9
	0FScCMxUItLXnt0qFGiVJQwxT+9BHtBnSzdsiFiSL5XEfWFtqvIHK/Fn5CFg/8Am
	00p5SDv6o7gmRY3ZCxfESZf0QAe6RiJhjzB6fOJ2RKZVbavPVMOjgYei3AX0M6F3
	T5/eg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yr5mwgd93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 21:02:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45DJB2cP020048;
	Thu, 13 Jun 2024 21:02:00 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn34nkgc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 21:02:00 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45DL1vtc57409836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 21:01:59 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70F895805D;
	Thu, 13 Jun 2024 21:01:57 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1DFB35806A;
	Thu, 13 Jun 2024 21:01:57 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Jun 2024 21:01:57 +0000 (GMT)
Message-ID: <619bc2de-b18a-4939-a652-9ca886bf6349@linux.ibm.com>
Date: Thu, 13 Jun 2024 17:01:56 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Warning at crypto/testmgr.c:5900, while booting to OS
To: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>, jarkko@kernel.org,
        herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <25d1a371-a4be-41d9-a3ad-f97bd9348dbc@linux.vnet.ibm.com>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <25d1a371-a4be-41d9-a3ad-f97bd9348dbc@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KdLeemf1U9qvcVrUgWoki3kt4v-FLDko
X-Proofpoint-GUID: KdLeemf1U9qvcVrUgWoki3kt4v-FLDko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_13,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=789 impostorscore=0 bulkscore=0
 adultscore=0 clxscore=1015 spamscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406130150



On 6/12/24 02:46, Venkat Rao Bagalkote wrote:
> Greetings!!!
> 
> Observing Kernel Warnings while booting to OS at crypto/testmgr.c:5900.
> 
> Traces:
> 
> [    0.682613] alg: akcipher: verify test failed. err -129
> [    0.682620] alg: akcipher: test 1 failed for ecdsa-nist-p521-generic, 
> err=-129
> [    0.682626] alg: self-tests for ecdsa-nist-p521 using 
> ecdsa-nist-p521-generic failed (rc=-129)
> [    0.682628] ------------[ cut here ]------------
> [    0.682634] alg: self-tests for ecdsa-nist-p521 using 
> ecdsa-nist-p521-generic failed (rc=-129)
> [    0.682645] WARNING: CPU: 8 PID: 221 at crypto/testmgr.c:5900 
> alg_test.part.0+0xc88/0xe18
> [    0.682653] Modules linked in:
> [    0.682656] CPU: 8 PID: 221 Comm: cryptomgr_test Not tainted 
> 6.10.0-rc3-next-20240611-auto #1
> [    0.682659] Hardware name: IBM,8375-42A POWER9 (raw) 0x4e0202 
> 0xf000005 of:IBM,FW950.A0 (VL950_144) hv:phyp pSeries
> [    0.682660] NIP:  c0000000007bf48c LR: c0000000007bf488 CTR: 
> c00000000103ef20
> [    0.682662] REGS: c00000005dc3fb60 TRAP: 0700   Not tainted  
> (6.10.0-rc3-next-20240611-auto)
> [    0.682664] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  
> CR: 28008241  XER: 00000005
> [    0.682672] CFAR: c00000000016361c IRQMASK: 0
>                 GPR00: c0000000007bf488 c00000005dc3fe00 
> c000000001583800 0000000000000052
>                 GPR04: 0000000000000000 c00000005dc3fc10 
> c00000005dc3fc08 0000000000000000
>                 GPR08: c000000002797d38 0000000000000000 
> 0000000000000001 0000000000000001
>                 GPR12: c000000002a57e18 c00000000f7c6700 
> c0000000001a185c c00000000679a180
>                 GPR16: 0000000000000000 0000000000000000 
> 0000000000000000 0000000000000000
>                 GPR20: 0000000000000000 0000000000000000 
> 000000000000007d 000000000000007d
>                 GPR24: ffffffffffffff7f c00000000e29d040 
> 0000000000001f40 0000000000000006
>                 GPR28: 0000000000000400 ffffffffffffff7f 
> c00000000e29d080 c00000000e29d000
> [    0.682700] NIP [c0000000007bf48c] alg_test.part.0+0xc88/0xe18
> [    0.682703] LR [c0000000007bf488] alg_test.part.0+0xc84/0xe18
> [    0.682707] Call Trace:
> [    0.682708] [c00000005dc3fe00] [c0000000007bf488] 
> alg_test.part.0+0xc84/0xe18 (unreliable)
> [    0.682713] [c00000005dc3ff60] [c0000000007b7ac4] 
> cryptomgr_test+0x34/0x64
> [    0.682717] [c00000005dc3ff90] [c0000000001a198c] kthread+0x138/0x140
> [    0.682721] [c00000005dc3ffe0] [c00000000000df98] 
> start_kernel_thread+0x14/0x18
> [    0.682724] Code: 60000000 7f7adb78 4bfffe00 60000000 60000000 
> 3c62ffe7 7fe5fb78 7fc4f378 7fa6eb78 3863fd20 4b9a4111 60000000 
> <0fe00000> 4bfff7ec 60000000 60000000
> [    0.682735] ---[ end trace 0000000000000000 ]---
> 
> This issue is being caused by the patch: 
> 2fd2a82ccbfc106aec314db6c4bda5e24fd32a22.

Thanks for the commit. I see the issue also on ppc64 but not on x86_64. 
It's an off-by one issue in c6ab5c915da460c not clearing the most 
significant digit when insufficient bytes are provided.

> 
> After reverting the above patch, issue is not seen.
> 
> Regards,
> Venkat.
> 
