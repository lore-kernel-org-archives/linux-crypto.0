Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA4923765;
	Wed, 12 Jun 2024 06:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718174839; cv=none; b=XnrpNUg0Sy9udEFSpz6WFm7/u2VANmbx/lE62l8raJvXMrPj/VnfsN1b6+ku949VESfl9rtCIoEIrW3tpPCQ1ngjeVDVmHADJAt47G2rXBeNYDw+yn5JycJ+QIV11sKmxmwrQzwFnisELRRBTNvlVR9qjpLpPl4gKoWvc7xvd4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718174839; c=relaxed/simple;
	bh=jlAqUR1bqatexd66hutKRK9rioff+o75gJr0IPUByYY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=QfwfVuPPugFVv2U4zkmywI35fuud93AEKnudFi3j9ZB6XwP9/fjB64ixR65/sxU3jrzaKFJAT6zwJ7oR5oPU6utkn5xGLmuIhSFMLPFr1++t47LEZq97xgoPYeBn0OMtfXGjF6OHJjlwVWjQDt/fetPW3eFRDntoa/oqQACk/NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dohF42k1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dohF42k1"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C5wcJr012927;
	Wed, 12 Jun 2024 06:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:to:cc:from:subject:content-type
	:content-transfer-encoding; s=pp1; bh=Fe0DMuZ4tBaDVLrimBojVhwsRW
	KMxr9qqIM3qPDtuT8=; b=dohF42k1JTMYRMwk9+o646WcvWF6g/7UO6peUhUHG5
	aaIDEXISSsMj3pOVie3ah0MzPwJSnMDuV3Czozq7snPQaTMxyxoKJUYQh5iqvCum
	MLPQ810A5ZVDXmBB2da7JSYDIwtnuNOtepnNjWNzStP6TMW+TXQWGCqolwvWvcv2
	DCCXrviBekulfOvM4sORx+RvPljJyvilhCaqPNBO/BC5mlpo9ZXA6jWv4FDulnPq
	1L25RfDD2JtiEhGM8r4adJjE/R7Y9iLAwALf4aroB/8jIAse2JKr14JpEaJrp45R
	3NCG5tj0kjjfZanzy9JQOgeI5s0GkLTtV5L+7kY2tW2Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yq60dr3h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 06:47:09 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45C5X1KT003878;
	Wed, 12 Jun 2024 06:47:09 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn2mpu46e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 06:47:09 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45C6l6bs23331448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 06:47:08 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6115058068;
	Wed, 12 Jun 2024 06:47:02 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36F6358066;
	Wed, 12 Jun 2024 06:47:00 +0000 (GMT)
Received: from [9.43.12.40] (unknown [9.43.12.40])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Jun 2024 06:46:59 +0000 (GMT)
Message-ID: <25d1a371-a4be-41d9-a3ad-f97bd9348dbc@linux.vnet.ibm.com>
Date: Wed, 12 Jun 2024 12:16:58 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: stefanb@linux.ibm.com, jarkko@kernel.org, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
From: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Subject: Warning at crypto/testmgr.c:5900, while booting to OS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W-sp5Sej73Q8VZm5zFlRYP2438V-qTaP
X-Proofpoint-ORIG-GUID: W-sp5Sej73Q8VZm5zFlRYP2438V-qTaP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_02,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=460 suspectscore=0
 phishscore=0 clxscore=1011 impostorscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406120044

Greetings!!!

Observing Kernel Warnings while booting to OS at crypto/testmgr.c:5900.

Traces:

[    0.682613] alg: akcipher: verify test failed. err -129
[    0.682620] alg: akcipher: test 1 failed for ecdsa-nist-p521-generic, err=-129
[    0.682626] alg: self-tests for ecdsa-nist-p521 using ecdsa-nist-p521-generic failed (rc=-129)
[    0.682628] ------------[ cut here ]------------
[    0.682634] alg: self-tests for ecdsa-nist-p521 using ecdsa-nist-p521-generic failed (rc=-129)
[    0.682645] WARNING: CPU: 8 PID: 221 at crypto/testmgr.c:5900 alg_test.part.0+0xc88/0xe18
[    0.682653] Modules linked in:
[    0.682656] CPU: 8 PID: 221 Comm: cryptomgr_test Not tainted 6.10.0-rc3-next-20240611-auto #1
[    0.682659] Hardware name: IBM,8375-42A POWER9 (raw) 0x4e0202 0xf000005 of:IBM,FW950.A0 (VL950_144) hv:phyp pSeries
[    0.682660] NIP:  c0000000007bf48c LR: c0000000007bf488 CTR: c00000000103ef20
[    0.682662] REGS: c00000005dc3fb60 TRAP: 0700   Not tainted  (6.10.0-rc3-next-20240611-auto)
[    0.682664] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 28008241  XER: 00000005
[    0.682672] CFAR: c00000000016361c IRQMASK: 0
                GPR00: c0000000007bf488 c00000005dc3fe00 c000000001583800 0000000000000052
                GPR04: 0000000000000000 c00000005dc3fc10 c00000005dc3fc08 0000000000000000
                GPR08: c000000002797d38 0000000000000000 0000000000000001 0000000000000001
                GPR12: c000000002a57e18 c00000000f7c6700 c0000000001a185c c00000000679a180
                GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
                GPR20: 0000000000000000 0000000000000000 000000000000007d 000000000000007d
                GPR24: ffffffffffffff7f c00000000e29d040 0000000000001f40 0000000000000006
                GPR28: 0000000000000400 ffffffffffffff7f c00000000e29d080 c00000000e29d000
[    0.682700] NIP [c0000000007bf48c] alg_test.part.0+0xc88/0xe18
[    0.682703] LR [c0000000007bf488] alg_test.part.0+0xc84/0xe18
[    0.682707] Call Trace:
[    0.682708] [c00000005dc3fe00] [c0000000007bf488] alg_test.part.0+0xc84/0xe18 (unreliable)
[    0.682713] [c00000005dc3ff60] [c0000000007b7ac4] cryptomgr_test+0x34/0x64
[    0.682717] [c00000005dc3ff90] [c0000000001a198c] kthread+0x138/0x140
[    0.682721] [c00000005dc3ffe0] [c00000000000df98] start_kernel_thread+0x14/0x18
[    0.682724] Code: 60000000 7f7adb78 4bfffe00 60000000 60000000 3c62ffe7 7fe5fb78 7fc4f378 7fa6eb78 3863fd20 4b9a4111 60000000 <0fe00000> 4bfff7ec 60000000 60000000
[    0.682735] ---[ end trace 0000000000000000 ]---

This issue is being caused by the patch: 2fd2a82ccbfc106aec314db6c4bda5e24fd32a22.

After reverting the above patch, issue is not seen.

Regards,
Venkat.

