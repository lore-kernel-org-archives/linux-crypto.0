Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA58F7D3F4
	for <linux-crypto@vger.kernel.org>; Fri, 16 May 2025 07:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747381095; cv=none; b=uv0NIhxW43BxmApy5BiDYmAnopdzLxhBOwO9J5dV68G5+mA964Ob/qEUaQbupBCxEniLpdf7yKjIG3tg/fVc4RopQeVkZhzLe6bXNSUIQqtqY/JDzZOcCRa+lUCd7EB2WT4PG+ANINV0vr6eyFGyTy9OItZ/pdrHqT6wKYiVzLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747381095; c=relaxed/simple;
	bh=+5EtMnSgJDq5j+inC/rWi8PU7ump+ZAdxp9mH3MFPBI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=U4iX8ihudgATe25JnJ+R65j+ksZHJTGe9Mv/AytZ7fNGdHZTVO/o1Vnn0UzR5BEd1uP+eOAUxSrH3UIGu5ziDtUO2EFL3S6WsfZN21qirmOAQcCWVSU7RgI9sU5BG6zXfp1RI9yRU0pyqc8cnUJiDQvdOyL4QL/vE3CPzV58Po0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TlgBwWxI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TlgBwWxI"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G5v6sG014517;
	Fri, 16 May 2025 07:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=pGs9i2VjjCds/lSX9n0vz7/dO/7tGAtoyxfOfykNYbU=; b=TlgBwWxIKIUd
	G09yS3n+2vmmPUMhKXf6zYPgIXuJ/2UPa6Lu+iaARFY5Uxa2m6drxopbzAI9eOaL
	3EUIvEk7jVL1z/DyBFmVaKSlfEtyTZcgusQydAj+/3WiVp5rbhlIVxnWdDBi29aj
	rlG1MXQOHhti+j65eI51qtxuqQQB7I7QX+gArpQt7gomlxUhLbGheyRE74m3HPQS
	cCWKz31LCrkNfrICQFWIaeMrn5tRZa5WML8oV+UKVRbfjbaOgw43pV+HKp0D0Zhs
	d8xiJ5hC08B/K/vP5dbZkidhF9zYD921RZ5bengmRs1K7cqqkZjBxCTx3ZNSqrK8
	2HvQDZhOvQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46nhg343xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 07:38:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54G6BJrc021414;
	Fri, 16 May 2025 07:38:01 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfrxdc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 07:38:01 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54G7c0nB23069222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 07:38:00 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 135C35805A;
	Fri, 16 May 2025 07:38:00 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB60C5803F;
	Fri, 16 May 2025 07:37:59 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 May 2025 07:37:59 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 16 May 2025 09:37:59 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
        Holger Dengler
 <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org,
        Eric Biggers
 <ebiggers@kernel.org>
Subject: Re: CI found regression in s390 paes-ctr in linux-next
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <ee7489d9b2452e08584318419317f62b@linux.ibm.com>
References: <ee7489d9b2452e08584318419317f62b@linux.ibm.com>
Message-ID: <9a6ec8ae5c7ff550b663f54189d93a67@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Cf0I5Krl c=1 sm=1 tr=0 ts=6826eb5a cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=efXaeZOgJe7DhkAKwAMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDA3MCBTYWx0ZWRfX17ALmxwgRI3D uCqrU86hJ6EtvPKy0lq3a4AjVmsZD2dd+gyzhWG5/mKduPA35AvnanKdhGgSWSjoxeJLyjGqgvv iMMZSw0ixs/WbIYDBe0cQv/83Wohbm2LHAeCPO+hqN2B8JO9aMyeSsTFYEmp/t7KAIpF3QVlbH3
 /SHSYEL8+jNqbMnWvMDFibzH9jGVaqlCmP6jAstOj8qe1Pfga7rhZVCv4k5CkaUMZ0S8LH4626O K5QcWPAWCdN8p0oKIs/NLIhq1xhQ9SrTo6CBMSJ/Mh8qfzCE8szIm2ZxGg5UywSCwtMW2TYaz9v +ePSV1+E6fE8txqdnoREwps1PC4GbhQCG3xdSDUyxlgy9j9IdUP5WQjC4WUvvm/6XQXLnpeKDk8
 xNYs26AkB3MvDmFe58KbXJV5+4A+nXF5WW4rDe+qINXcjA00lUbOXrsygf35xklmEl6psVpA
X-Proofpoint-GUID: fAcJTjWkC_jdarJ5QNtgsSjem5qsFSJh
X-Proofpoint-ORIG-GUID: fAcJTjWkC_jdarJ5QNtgsSjem5qsFSJh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_03,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505160070

On 2025-05-14 15:38, Harald Freudenberger wrote:
> The nightly CI run stumbled over an selftest failure for the paes ctr
> algorithm in the linux next kernel.
> With commit
> 698de822780f crypto: testmgr - make it easier to enable the full set of 
> tests
> the "Enable extra run-time crypto self tests" are always enabled and
> there is no way to disable
> these tests via kernel config any more.
> However, the paes-ctr selftest now fails with these extra tests.
> We could have seen this already when we would have enabled these
> additional test - however, we didn't.
> 
> Investigating...
> 
> have a nice day
> Harald Freudenberger

I've appended a fix for this finding. However, as the reworked PAES is 
already on the way in the s390
feature branch and will be merged into the next kernel merge window, 
there is no need to apply this
fix to the upstream kernel. Maybe for stable kernels the fix should be 
integrated.

---------- cut here 
----------------------------------------------------------------------------

 From 8d20802095ee6c9855112fa5201d253874b49240 Mon Sep 17 00:00:00 2001
 From: Harald Freudenberger <freude@linux.ibm.com>
Date: Thu, 15 May 2025 17:19:08 +0200
Subject: [PATCH] s390/crypto: Fix extended selftest finding with paes 
ctr mode

With enabling the extended crypto selftests there occurs a
failure for protected key aes with counter mode:

kernel: alg: skcipher: ctr-paes-s390 encryption failed on test vector
   4; expected_error=0, actual_error=-22, cfg="random:
   inplace_one_sglist use_final nosimd src_divs=[<reimport>50.0%@+4,
   <flush,nosimd>48.1%>
kernel: alg: self-tests for ctr(paes) using ctr-paes-s390 failed 
(rc=-22)
kernel: ------------[ cut here ]------------
kernel: alg: self-tests for ctr(paes) using ctr-paes-s390 failed 
(rc=-22)
kernel: WARNING: CPU: 10 PID: 4928 at crypto/testmgr.c:5808 
alg_test+0x530/0x660
kernel: Modules linked in: paes_s390 kvm mlx5_ib ib_uverbs ib_core
   mlx5_vdpa vdpa vringh vhost_iotlb nft_fib_inet nft_fib_ipv4
   nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
   nft_reject nf>
kernel: CPU: 10 UID: 0 PID: 4928 Comm: cryptomgr_test Not tainted 
6.15.0-hf-next-20250514 #1 PREEMPT
kernel: Hardware name: IBM 9175 ME1 705 (LPAR)
kernel: Krnl PSW : 0704d00180000000 000002c28b5d0e74 
(alg_test+0x534/0x660)
kernel:            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 
RI:0 EA:3
kernel: Krnl GPRS: 000002c280000001 0000000000000002 0000000000000041 
0000000000000000
kernel:            0000000000000002 0000024280000002 ffffffffffffffea 
000002c28b5d06c0
kernel:            000002c2ffffffea 000001ba4cacca80 0000000000000005 
000001ba4cacca00
kernel:            000001ba23278100 000002c28c284538 000002c28b5d0e70 
000002429b16fca0
kernel: Krnl Code: 000002c28b5d0e64: c020005fae5c    larl 
%r2,000002c28c1c6b1c
                    000002c28b5d0e6a: c0e5ffad3e73    brasl 
%r14,000002c28ab78b50
                   #000002c28b5d0e70: af000000        mc 0,0
                   >000002c28b5d0e74: a7f4fe17        brc 
15,000002c28b5d0aa2
                    000002c28b5d0e78: ec51000100d8    ahik %r5,%r1,1
                    000002c28b5d0e7e: a7f4ff6a        brc 
15,000002c28b5d0d52
                    000002c28b5d0e82: a768ffff        lhi %r6,-1
                    000002c28b5d0e86: a7f4fdb2        brc 
15,000002c28b5d09ea
kernel: Call Trace:
kernel:  [<000002c28b5d0e74>] alg_test+0x534/0x660
kernel: ([<000002c28b5d0e70>] alg_test+0x530/0x660)
kernel:  [<000002c28b5c9064>] cryptomgr_test+0x34/0x60
kernel:  [<000002c28abb2254>] kthread+0x164/0x2d0
kernel:  [<000002c28ab1d4c0>] __ret_from_fork+0x40/0x2f0
kernel:  [<000002c28bc98c3a>] ret_from_fork+0xa/0x30
kernel: INFO: lockdep is turned off.
kernel: Last Breaking-Event-Address:
kernel:  [<000002c28ab78c94>] __warn_printk+0x144/0x150
kernel: irq event stamp: 0
kernel: hardirqs last  enabled at (0): [<0000000000000000>] 0x0
kernel: hardirqs last disabled at (0): [<000002c28ab76ce0>] 
copy_process+0x8b0/0x18c0
kernel: softirqs last  enabled at (0): [<000002c28ab76ce0>] 
copy_process+0x8b0/0x18c0
kernel: softirqs last disabled at (0): [<0000000000000000>] 0x0
kernel: ---[ end trace 0000000000000000 ]---

Investigation reveals that skcipher_walk_done() returns -22 (EINVAL)
caused by a wrong bytes-remaining argument. This only happens when
the very last block of the en/decrypt operation is not AES_BLOCK_SIZE
padded.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
  arch/s390/crypto/paes_s390.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 511093713a6f..8e92a7710294 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -874,7 +874,7 @@ static int ctr_paes_crypt(struct skcipher_request 
*req)
                 }
                 memcpy(walk.dst.virt.addr, buf, nbytes);
                 crypto_inc(walk.iv, AES_BLOCK_SIZE);
-               rc = skcipher_walk_done(&walk, nbytes);
+               rc = skcipher_walk_done(&walk, 0);
         }

         return rc;
-- 
2.43.0


