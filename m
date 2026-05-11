Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F213B27FE;
	Mon, 11 May 2026 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778486677; cv=none; b=lADsSK2dCV4kQdNhGUUMOK/OQm2ehG6Sm9QsLrRf1C9CA0IJbXct6PWYvIq/KlBARNAftv6ya1suF1SmjAkn6je9I0MiUYnCY2b9OpP9I6iGtwRzz/Bf6pRagTkx3y6CZf3umri1q2LPCv8KWSCa8Jvs1oFzdRy0k2UgDe4W57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778486677; c=relaxed/simple;
	bh=TJLzP7tErJWmSpzX5DtZsMxeS5dJnezzONFNst/OhCQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lvxBAFWantnmnBEIqHButyDIt+oJoaSfgdJUEqq7uU1O2/wNbS9p76xUcpZOFQzZzpKhedPiakXfN0nrHqlzxJTB1YCXsw1ogWt+0GJ8tyzPlWSNbaBF0+CIVl4App9KkrwcYaUNYPujyHvgFu29WFP8s/qKvAi+LKnKkuwi88k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.44.161] (unknown [185.238.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id ECC6C4C4019BA7;
	Mon, 11 May 2026 10:03:54 +0200 (CEST)
Message-ID: <b507beef-3e1c-46d7-a434-d0235dace30b@molgen.mpg.de>
Date: Mon, 11 May 2026 10:03:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: powernv_rng_read: Oops: Kernel access of bad area, sig: 11 [#1]
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Michael Ellerman <mpe@ellerman.id.au>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 LKML <linux-kernel@vger.kernel.org>
References: <a159e81a-ccfd-440f-af68-6a56cca09cb2@molgen.mpg.de>
 <0c06bc14-9459-44d5-9e28-b0b78c0fbe36@linux.ibm.com>
 <6f58b950-a997-4dd6-a1a2-95eb72009151@molgen.mpg.de>
Content-Language: en-US
In-Reply-To: <6f58b950-a997-4dd6-a1a2-95eb72009151@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Madhavan, dear Jason,


Am 11.05.26 um 09:00 schrieb Paul Menzel:

> Am 07.05.26 um 04:40 schrieb Madhavan Srinivasan:
>>
>> On 5/6/26 7:31 PM, Paul Menzel wrote:
> 
>>> After a long while, on the 8335-GCA POWER8 (raw) 0x4d0200 
>>> opal:skiboot-5.4.8-5787ad3 PowerNV, I built Linux from Linus’ master 
>>> branch and rebooted via kexec.
>>>
>>> ```
>>> [    0.000000] Linux version 7.1.0-rc2+ (pmenzel@flughafenberlinbrandenburgwillybrandt.molgen.mpg.de) (gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37) #3 SMP PREEMPT Wed May  6 08:50:58 CEST 2026
>>> […]
>>> [   17.901992] Kernel attempted to read user page (0) - exploit attempt? (uid: 0)
>>> [   17.902011] BUG: Kernel NULL pointer dereference on read at 0x00000000
>>> [   17.902018] Faulting instruction address: 0xc0000000000e7138
>>> [   17.902027] Oops: Kernel access of bad area, sig: 11 [#1]
>>> [   17.902034] LE PAGE_SIZE=64K MMU=Hash  SMP NR_CPUS=2048 NUMA PowerNV
>>> [   17.902045] Modules linked in: powernv_rng(+) bnx2x ofpart ibmpowernv bfq mdio cmdlinepart powernv_flash ipmi_powernv ipmi_devintf mtd ipmi_msghandler at24(+) vmx_crypto opal_prd sch_fq_codel nfsd parport_pc ppdev auth_rpcgss nfs_acl lp lockd grace parport sunrpc autofs4 btrfs xor libblake2b raid6_pq ast drm_shmem_helper drm_client_lib i2c_algo_bit drm_kms_helper drm ahci drm_panel_orientation_quirks libahci
>>> [   17.902185] CPU: 147 UID: 0 PID: 2626 Comm: hwrng Not tainted 7.1.0-rc2+ #3 PREEMPTLAZY
>>> [   17.902197] Hardware name: 8335-GCA POWER8 (raw) 0x4d0200 opal:skiboot-5.4.8-5787ad3 PowerNV
>>> [   17.902204] NIP:  c0000000000e7138 LR: c00800001ec8013c CTR: c0000000000e70fc
>>> [   17.902212] REGS: c000000092913c50 TRAP: 0300   Not tainted (7.1.0-rc2+)
>>> [   17.902222] MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 44420220  XER: 20000000
>>> [   17.902269] CFAR: c00800001ec8026c DAR: 0000000000000000 DSISR: 40000000 IRQMASK: 0
>>>                GPR00: c00800001ec8013c c000000092913ef0 c000000001c18100 c00000002222d900
>>>                GPR04: c00000002222d900 0000000000000080 0000000000000001 0000000000000000
>>>                GPR08: 0000000000000000 c000000002212000 c0000000951e1780 c00800001ec80258
>>>                GPR12: c0000000000e70fc c00000ffff6fd700 c0000000001d11c0 c00000001b99b9c0
>>>                GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>>>                GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>>>                GPR24: 0000000000000000 c000000002fe6a58 0000000000000000 0000000000000000
>>>                GPR28: c000000002fe6a20 0000000000000010 000000000000000f c00000002222d900
>>> [   17.902406] NIP [c0000000000e7138] pnv_get_random_long+0x3c/0x114
>>> [   17.902426] LR [c00800001ec8013c] powernv_rng_read+0x78/0xc4 [powernv_rng]
>>> [   17.902444] Call Trace:
>>> [   17.902448] [c000000092913ef0] [c000000092913f30] 0xc000000092913f30 (unreliable)
>>> [   17.902463] [c000000092913f30] [c000000000decd58] hwrng_fillfn+0xd4/0x3dc
>>> [   17.902484] [c000000092913f90] [c0000000001d1328] kthread+0x170/0x1a4
>>> [   17.902498] [c000000092913fe0] [c00000000000d030] start_kernel_thread+0x14/0x18
>>> [   17.902513] Code: 60000000 7d2000a6 71290010 418200bc e94d0908 812a0000 39290001 912a0000 e90d0030 3d220060 39299f00 7d08482a <e9280000> 7c0004ac e8e90000 0c070000
>>> [   17.902569] ---[ end trace 0000000000000000 ]---
>>> [   18.008801] pstore: backend (nvram) writing error (-1)
>>>
>>> [   18.015458] note: hwrng[2626] exited with irqs disabled
>>> [   18.015483] note: hwrng[2626] exited with preempt_count 1
>>> ```
>>>
>>> Please find the output of `dmesg` attached.
>>
>> This is from my yesterday's boot test log in my P8, did not see this 
>> fail.
>>
>> root@ltcppm1:~# uname -a
>> Linux ltcppm1.ltc.tadn.ibm.com 7.1.0-rc2-00021-gf583bd5f64d4 #1 SMP 
>> PREEMPT Wed May  6 00:55:45 EDT 2026 ppc64le GNU/Linux
>> root@ltcppm1:~# dmesg
>> [    0.000000] [      T0] random: crng init done
>> [    0.000000] [      T0] hash-mmu: Page sizes from device-tree:
>> [    0.000000] [      T0] hash-mmu: base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
>> [    0.000000] [      T0] hash-mmu: base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
>> [    0.000000] [      T0] hash-mmu: base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
>> [    0.000000] [      T0] hash-mmu: base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
>> [    0.000000] [      T0] hash-mmu: base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
>> [    0.000000] [      T0] hash-mmu: base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
>> [    0.000000] [      T0] hash-mmu: base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
>> [    0.000000] [      T0] Enabling pkeys with max key count 32
>> [    0.000000] [      T0] Activating Kernel Userspace Access Prevention
>> [    0.000000] [      T0] Activating Kernel Userspace Execution Prevention
>> [    0.000000] [      T0] hash-mmu: Page orders: linear mapping = 24, virtual = 16, io = 16, vmemmap = 24
>> [    0.000000] [      T0] hash-mmu: Using 1TB segments
>> [    0.000000] [      T0] hash-mmu: Initializing hash mmu with SLB
>> [    0.000000] [      T0] Linux version 7.1.0-rc2-00021-gf583bd5f64d4 (root@ltcppm1.ltc.tadn.ibm.com) (gcc (GCC) 16.1.1 20260501 (Red Hat 16.1.1-1), GNU ld version 2.46-1.fc44) #1 SMP PREEMPT Wed May  6 
>> 00:55:45 EDT 2026
>> [    0.000000] [      T0] OF: reserved mem: 0x0000000039c00000..0x000000003b6801ff (27136 KiB) map non-reusable ibm,firmware-allocs-memory@39c00000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000000800000000..0x0000000800e801ff (14848 KiB) map non-reusable ibm,firmware-allocs-memory@800000000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001000000000..0x0000001000dc01ff (14080 KiB) map non-reusable ibm,firmware-allocs-memory@1000000000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001800000000..0x0000001800e801ff (14848 KiB) map non-reusable ibm,firmware-allocs-memory@1800000000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000000030000000..0x00000000302fffff (3072 KiB) map non-reusable ibm,firmware-code@30000000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000000031000000..0x0000000031bfffff (12288 KiB) map non-reusable ibm,firmware-data@31000000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000000030300000..0x0000000030ffffff (13312 KiB) map non-reusable ibm,firmware-heap@30300000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000000031c00000..0x0000000033fdffff (36736 KiB) map non-reusable ibm,firmware-stacks@31c00000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001ffd510000..0x0000001ffd69ffff (1600 KiB) map non-reusable ibm,hbrt-code-image@1ffd510000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001ffd6a0000..0x0000001ffd6fffff (384 KiB) map non-reusable ibm,hbrt-target-image@1ffd6a0000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001ffd700000..0x0000001ffd7fffff (1024 KiB) map non-reusable ibm,hbrt-vpd-image@1ffd700000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001ffda00000..0x0000001ffdafffff (1024 KiB) map non-reusable ibm,slw-image@1ffda00000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001ffde00000..0x0000001ffdefffff (1024 KiB) map non-reusable ibm,slw-image@1ffde00000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001ffe200000..0x0000001ffe2fffff (1024 KiB) map non-reusable ibm,slw-image@1ffe200000
>> [    0.000000] [      T0] OF: reserved mem: 0x0000001ffe600000..0x0000001ffe6fffff (1024 KiB) map non-reusable ibm,slw-image@1ffe600000
>> [    0.000000] [      T0] Found initrd at 0xc000000006a40000:0xc00000000815ae9e
>> [    0.000000] [      T0] Hardware name: 8247-22L POWER8E (raw) 0x4b0201 opal:skiboot-v5.4.12 PowerNV
>> [    0.000000] [      T0] printk: legacy bootconsole [udbg0] enabled
>> [    0.000000] [      T0] CPU maps initialized for 8 threads per core
>> [    0.000000] [      T0]  (thread shift is 3)
>>>> But I my opal version 5.4.12.
>>
>> Thanks for reporting the issue, will have an look at it.
> 
> I bisected it to a change between 5.19-rc3 and 5.19-rc4, and merge 
> commit 8100775d59a6 (Merge tag 'powerpc-5.19-3' of git://git.kernel.org/ 
> pub/scm/linux/kernel/git/powerpc/linux) [1] indeed has rng related changes
> 
>>  - Three fixes to wire up our various RNGs earlier in boot so they're
>>    available for use in the initial seeding in random_init().

I confirmed, that commit f3eac426657d (powerpc/powernv: wire up rng 
during setup_arch) [2] introduced the Oops.


>> [    0.000000] [      T0] Allocated 4608 bytes for 160 pacas
>> [    0.000000] [      T0] 
>> -----------------------------------------------------
>>
>> .......
>>
>> [   37.407674] [    T900] audit: type=1130 audit(1778043621.931:10): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=lvm2-monitor comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
>> terminal=? res=success'
>> [   37.413015] [    T900] audit: type=1130 audit(1778043621.937:11): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
>> [   38.448156] [   T2286] powernv_rng: Registered powernv hwrng.
>> [   38.575227] [   T2264] tg3 0005:09:00.1 enP5p9s0f1: renamed from eth1
>> [   38.582176] [   T2223] tg3 0005:09:00.2 enP5p9s0f2: renamed from eth2
>> ........
>>
>> ////cpuinfo output
>>
>> processor    : 159
>>
>> cpu        : POWER8E (raw), altivec supported
>> clock        : 2061.000000MHz
>> revision    : 2.1 (pvr 004b 0201)
>>
>> timebase    : 512000000
>> platform    : PowerNV
>> model        : 8247-22L
>> machine        : PowerNV 8247-22L
>> firmware    : OPAL
>> MMU        : Hash
>>
>>
>> But my system opal version 5.4.12.
>> Thanks for reporting the issue, will have an look at it.
> 
> Thank you.


Kind regards,

Paul


> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8100775d59a6789c3c6c309de26fac52f129cba8
[2]: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f3eac426657d985b97c92fa5f7ae1d43f04721f3
