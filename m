Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5372BCF4C;
	Thu,  7 May 2026 02:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778121677; cv=none; b=i0SF4ARtsqNNqPlT/mkx1yemkV4LjasH9hWyuZNtvPvWX5DGusqeorFmLQtuNeCIy73VQp28isORaZM03sDacL/DzBuBoUToSaGtgbJoDcs60xaYlTBTluhXOYgA0+LqOIE2QevZo2+j2RpcSSJqG6HxDbroqaVQNYTxQSe7Zp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778121677; c=relaxed/simple;
	bh=IXxgboq6PrSIz0s2hoN4pwjRgo186Uke/J52FCAbNi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EewzafPTJPorRI/6dnhJO/OdF7kcDsyz3zBcNvTowtz1NcZpzoUAh9yZwR0PaR5/DZ9yZ3lK/gVNCab7SqSXRV5dTsK0icdnBhPf2y78FzIZ2yBgVYhgqG6G6EzE4OFSt82jsYrPZMjLqu2EeMEhTgj+SD4iuZIgERfbN5DhlZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KxPgcyZQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KxPgcyZQ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6471MWl83769724;
	Thu, 7 May 2026 02:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=U5VzgV
	sOh7KJ44Pr3XlHOAiHMWRYvMItvzRoqCBAiNw=; b=KxPgcyZQs5E8p3Dd0i9kPK
	zWcCoXiQW+SK/pq7ZMkwbEuuYxZIuADLZ+n2fwXELqWHQufRYsanCFFgT5+M70LW
	cU7utZEh0UCb17TaFQM5ZIGFXzD3Auu+43Y/Giz+C3gjQ7ePQPUllvO6AI670s2D
	3GwOq5sBBm7szxHU7OMdNu17CnuhPkb1L+UR7E7fEQVs5Xr4fUQ988aKAUzHFu0C
	3U03vaz1kzEamDQW4UV4P3tW9jirvVue3asBBCTGXEz6GbZi7Satf6ARYyExjdwd
	9oeT2uC5qvSkXZ65sEInQXoLuWmx+VBRKCQ0qPNT9syoKOGDmZyeXAM6sMuEwWHg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w6k0ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 02:40:50 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6472dXY8021945;
	Thu, 7 May 2026 02:40:50 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw97fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 02:40:50 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6472eMiD21889688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 02:40:22 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8107D5805F;
	Thu,  7 May 2026 02:40:49 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71F5D5805A;
	Thu,  7 May 2026 02:40:38 +0000 (GMT)
Received: from [9.43.90.101] (unknown [9.43.90.101])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 May 2026 02:40:37 +0000 (GMT)
Message-ID: <0c06bc14-9459-44d5-9e28-b0b78c0fbe36@linux.ibm.com>
Date: Thu, 7 May 2026 08:10:35 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: powernv_rng_read: Oops: Kernel access of bad area, sig: 11 [#1]
To: Paul Menzel <pmenzel@molgen.mpg.de>, Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
References: <a159e81a-ccfd-440f-af68-6a56cca09cb2@molgen.mpg.de>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <a159e81a-ccfd-440f-af68-6a56cca09cb2@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69fbfbb2 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=fnPWOy_s-l-Ne9MUvmsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 6Gb0D3i0IHOugLg_EnMdglSH6maFg_e2
X-Proofpoint-GUID: 6Gb0D3i0IHOugLg_EnMdglSH6maFg_e2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDAyNCBTYWx0ZWRfX0RscZMYeTmlx
 vtxqnFUygAQVRTRCOMEBNCmEIc+BtYObxz/Y4cja0ER4LqlM6y8eC4FgIkI1VbsBGY3d/8IcjbO
 0VHcSgeWpmEbTjTpZqhBLKaFeJp0GUpnqRcJ0QVFdWA9iaiarsLJ2sir5JxpZ9oUrA3Q+k7hZzZ
 GZEXhc2ztt6mxH6vPQR3JSDQ7GFZu7xfptqOtKQ6ZkVL65dYVGnr5m1cPHs/3rDM4HQneNJo6Ng
 ihmAGUqnkDxaMqe6LqljMh9XNv8NO2cwJ+llYXb3mCfLsDvUioqXDWSNeD2Ut6aXj5+GLGIJZSr
 ygSsYMYK/jdEMyoVT9LnxIxQA+FfoLUufrtP2iBaJnnSrJhC4d+PPBMBnfqMh22xGVwUSaO0b1j
 lc6fYhl77P3ecImyNBqS072kvsImNhkqh++ODaggmaYkgEtKcwf2tVVNNxqyDC3NAbS/ArziTjm
 +J+o6ViIKuICkg2a8mQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070024


On 5/6/26 7:31 PM, Paul Menzel wrote:
> Dear Linux folks,
>
>
> After a long while, on the 8335-GCA POWER8 (raw) 0x4d0200 
> opal:skiboot-5.4.8-5787ad3 PowerNV, I built Linux from Linus’ master 
> branch and rebooted via kexec.
>
> ```
> [    0.000000] Linux version 7.1.0-rc2+ 
> (pmenzel@flughafenberlinbrandenburgwillybrandt.molgen.mpg.de) (gcc 
> (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 
> 2.37) #3 SMP PREEMPT Wed May  6 08:50:58 CEST 2026
> […]
> [   17.901992] Kernel attempted to read user page (0) - exploit 
> attempt? (uid: 0)
> [   17.902011] BUG: Kernel NULL pointer dereference on read at 0x00000000
> [   17.902018] Faulting instruction address: 0xc0000000000e7138
> [   17.902027] Oops: Kernel access of bad area, sig: 11 [#1]
> [   17.902034] LE PAGE_SIZE=64K MMU=Hash  SMP NR_CPUS=2048 NUMA PowerNV
> [   17.902045] Modules linked in: powernv_rng(+) bnx2x ofpart 
> ibmpowernv bfq mdio cmdlinepart powernv_flash ipmi_powernv 
> ipmi_devintf mtd ipmi_msghandler at24(+) vmx_crypto opal_prd 
> sch_fq_codel nfsd parport_pc ppdev auth_rpcgss nfs_acl lp lockd grace 
> parport sunrpc autofs4 btrfs xor libblake2b raid6_pq ast 
> drm_shmem_helper drm_client_lib i2c_algo_bit drm_kms_helper drm ahci 
> drm_panel_orientation_quirks libahci
> [   17.902185] CPU: 147 UID: 0 PID: 2626 Comm: hwrng Not tainted 
> 7.1.0-rc2+ #3 PREEMPTLAZY
> [   17.902197] Hardware name: 8335-GCA POWER8 (raw) 0x4d0200 
> opal:skiboot-5.4.8-5787ad3 PowerNV
> [   17.902204] NIP:  c0000000000e7138 LR: c00800001ec8013c CTR: 
> c0000000000e70fc
> [   17.902212] REGS: c000000092913c50 TRAP: 0300   Not tainted 
> (7.1.0-rc2+)
> [   17.902222] MSR:  900000000280b033 
> <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 44420220  XER: 20000000
> [   17.902269] CFAR: c00800001ec8026c DAR: 0000000000000000 DSISR: 
> 40000000 IRQMASK: 0
>                GPR00: c00800001ec8013c c000000092913ef0 
> c000000001c18100 c00000002222d900
>                GPR04: c00000002222d900 0000000000000080 
> 0000000000000001 0000000000000000
>                GPR08: 0000000000000000 c000000002212000 
> c0000000951e1780 c00800001ec80258
>                GPR12: c0000000000e70fc c00000ffff6fd700 
> c0000000001d11c0 c00000001b99b9c0
>                GPR16: 0000000000000000 0000000000000000 
> 0000000000000000 0000000000000000
>                GPR20: 0000000000000000 0000000000000000 
> 0000000000000000 0000000000000000
>                GPR24: 0000000000000000 c000000002fe6a58 
> 0000000000000000 0000000000000000
>                GPR28: c000000002fe6a20 0000000000000010 
> 000000000000000f c00000002222d900
> [   17.902406] NIP [c0000000000e7138] pnv_get_random_long+0x3c/0x114
> [   17.902426] LR [c00800001ec8013c] powernv_rng_read+0x78/0xc4 
> [powernv_rng]
> [   17.902444] Call Trace:
> [   17.902448] [c000000092913ef0] [c000000092913f30] 
> 0xc000000092913f30 (unreliable)
> [   17.902463] [c000000092913f30] [c000000000decd58] 
> hwrng_fillfn+0xd4/0x3dc
> [   17.902484] [c000000092913f90] [c0000000001d1328] kthread+0x170/0x1a4
> [   17.902498] [c000000092913fe0] [c00000000000d030] 
> start_kernel_thread+0x14/0x18
> [   17.902513] Code: 60000000 7d2000a6 71290010 418200bc e94d0908 
> 812a0000 39290001 912a0000 e90d0030 3d220060 39299f00 7d08482a 
> <e9280000> 7c0004ac e8e90000 0c070000
> [   17.902569] ---[ end trace 0000000000000000 ]---
> [   18.008801] pstore: backend (nvram) writing error (-1)
>
> [   18.015458] note: hwrng[2626] exited with irqs disabled
> [   18.015483] note: hwrng[2626] exited with preempt_count 1
> ```
>
> Please find the output of `dmesg` attached.

This is from my yesterday's  boot test log in my P8, did not see this fail.

root@ltcppm1:~# uname -a
Linux ltcppm1.ltc.tadn.ibm.com 7.1.0-rc2-00021-gf583bd5f64d4 #1 SMP 
PREEMPT Wed May  6 00:55:45 EDT 2026 ppc64le GNU/Linux
root@ltcppm1:~# dmesg
[    0.000000] [      T0] random: crng init done
[    0.000000] [      T0] hash-mmu: Page sizes from device-tree:
[    0.000000] [      T0] hash-mmu: base_shift=12: shift=12, 
sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
[    0.000000] [      T0] hash-mmu: base_shift=12: shift=16, 
sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
[    0.000000] [      T0] hash-mmu: base_shift=12: shift=24, 
sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
[    0.000000] [      T0] hash-mmu: base_shift=16: shift=16, 
sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
[    0.000000] [      T0] hash-mmu: base_shift=16: shift=24, 
sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
[    0.000000] [      T0] hash-mmu: base_shift=24: shift=24, 
sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
[    0.000000] [      T0] hash-mmu: base_shift=34: shift=34, 
sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
[    0.000000] [      T0] Enabling pkeys with max key count 32
[    0.000000] [      T0] Activating Kernel Userspace Access Prevention
[    0.000000] [      T0] Activating Kernel Userspace Execution Prevention
[    0.000000] [      T0] hash-mmu: Page orders: linear mapping = 24, 
virtual = 16, io = 16, vmemmap = 24
[    0.000000] [      T0] hash-mmu: Using 1TB segments
[    0.000000] [      T0] hash-mmu: Initializing hash mmu with SLB
[    0.000000] [      T0] Linux version 7.1.0-rc2-00021-gf583bd5f64d4 
(root@ltcppm1.ltc.tadn.ibm.com) (gcc (GCC) 16.1.1 20260501 (Red Hat 
16.1.1-1), GNU ld version 2.46-1.fc44) #1 SMP PREEMPT Wed May  6 
00:55:45 EDT 2026
[    0.000000] [      T0] OF: reserved mem: 
0x0000000039c00000..0x000000003b6801ff (27136 KiB) map non-reusable 
ibm,firmware-allocs-memory@39c00000
[    0.000000] [      T0] OF: reserved mem: 
0x0000000800000000..0x0000000800e801ff (14848 KiB) map non-reusable 
ibm,firmware-allocs-memory@800000000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001000000000..0x0000001000dc01ff (14080 KiB) map non-reusable 
ibm,firmware-allocs-memory@1000000000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001800000000..0x0000001800e801ff (14848 KiB) map non-reusable 
ibm,firmware-allocs-memory@1800000000
[    0.000000] [      T0] OF: reserved mem: 
0x0000000030000000..0x00000000302fffff (3072 KiB) map non-reusable 
ibm,firmware-code@30000000
[    0.000000] [      T0] OF: reserved mem: 
0x0000000031000000..0x0000000031bfffff (12288 KiB) map non-reusable 
ibm,firmware-data@31000000
[    0.000000] [      T0] OF: reserved mem: 
0x0000000030300000..0x0000000030ffffff (13312 KiB) map non-reusable 
ibm,firmware-heap@30300000
[    0.000000] [      T0] OF: reserved mem: 
0x0000000031c00000..0x0000000033fdffff (36736 KiB) map non-reusable 
ibm,firmware-stacks@31c00000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001ffd510000..0x0000001ffd69ffff (1600 KiB) map non-reusable 
ibm,hbrt-code-image@1ffd510000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001ffd6a0000..0x0000001ffd6fffff (384 KiB) map non-reusable 
ibm,hbrt-target-image@1ffd6a0000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001ffd700000..0x0000001ffd7fffff (1024 KiB) map non-reusable 
ibm,hbrt-vpd-image@1ffd700000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001ffda00000..0x0000001ffdafffff (1024 KiB) map non-reusable 
ibm,slw-image@1ffda00000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001ffde00000..0x0000001ffdefffff (1024 KiB) map non-reusable 
ibm,slw-image@1ffde00000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001ffe200000..0x0000001ffe2fffff (1024 KiB) map non-reusable 
ibm,slw-image@1ffe200000
[    0.000000] [      T0] OF: reserved mem: 
0x0000001ffe600000..0x0000001ffe6fffff (1024 KiB) map non-reusable 
ibm,slw-image@1ffe600000
[    0.000000] [      T0] Found initrd at 
0xc000000006a40000:0xc00000000815ae9e
[    0.000000] [      T0] Hardware name: 8247-22L POWER8E (raw) 0x4b0201 
opal:skiboot-v5.4.12 PowerNV
[    0.000000] [      T0] printk: legacy bootconsole [udbg0] enabled
[    0.000000] [      T0] CPU maps initialized for 8 threads per core
[    0.000000] [      T0]  (thread shift is 3)But I my opal version 5.4.12.

Thanks for reporting the issue, will have an look at it.


[    0.000000] [      T0] Allocated 4608 bytes for 160 pacas
[    0.000000] [      T0] 
-----------------------------------------------------

.......

[   37.407674] [    T900] audit: type=1130 audit(1778043621.931:10): 
pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-monitor 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[   37.413015] [    T900] audit: type=1130 audit(1778043621.937:11): 
pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-sysctl 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[   38.448156] [   T2286] powernv_rng: Registered powernv hwrng.
[   38.575227] [   T2264] tg3 0005:09:00.1 enP5p9s0f1: renamed from eth1
[   38.582176] [   T2223] tg3 0005:09:00.2 enP5p9s0f2: renamed from eth2
........

////cpuinfo output

processor    : 159

cpu        : POWER8E (raw), altivec supported
clock        : 2061.000000MHz
revision    : 2.1 (pvr 004b 0201)

timebase    : 512000000
platform    : PowerNV
model        : 8247-22L
machine        : PowerNV 8247-22L
firmware    : OPAL
MMU        : Hash


But my system opal version 5.4.12.
Thanks for reporting the issue, will have an look at it.

Maddy


>
>
> Kind regards,
>
> Paul
