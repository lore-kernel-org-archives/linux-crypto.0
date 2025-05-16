Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81791205502;
	Fri, 16 May 2025 11:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747394560; cv=none; b=hmCup/CGSUNOtkgCrCzXE5XICdbe69aO7YqIJgwbcqg+8S2vta3JDBOblsXhDGQd+Ze117ZaH8CCMI0jQVZ7Slul8BlQvQWGkdCCTEdGPpr+n+9deqOfDPOYWaQHLthTsF5gtrrf/4fFZS+GJpoEJnOPmTw4lnA5rK+YIXkYWyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747394560; c=relaxed/simple;
	bh=XGogDbOEILm3N06AAw1DkScVu6xnREQYzKm/mnJRkls=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oqhjaO+OrtRi6VwY591x8qjz0GqnJMavjVCFRi78eCl+tOk+cvLcVm/oPa/eEv4zT8A0boZ7+gyK6vwzHEvq85/pGH18iXmWGW8x5cVuxWKCfDyYEPgb1nUjQnSQ3zbZu509BB+AscvN2JrQHvPmh42p0wAlc+fe43seC/hO4Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dMVYUlr0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dMVYUlr0"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E4BE140E0239;
	Fri, 16 May 2025 11:22:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gkD7PYQiGAv1; Fri, 16 May 2025 11:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1747394551; bh=VwrxsVN/udlP3VH2K1KzDlIzwERL61ifcK1TgFlzfWU=;
	h=Date:From:To:Cc:Subject:From;
	b=dMVYUlr0jLG2c2nvA9BFB7xyrNBY4tun8Cmc4CWlUh791iizHVWtbG+TZd05hPiDd
	 1bYiXWPqluG+hSIfa6DiKvk8vN+VQM13Cc1/O5V7sapDViWUvojNj3BGremhBR5ayY
	 9C+2aPF3zaudIA72o78Vx62STYyKpE/RDqcmRKu5YqXcf6TNjQB4nfF7LL6TtrdEvl
	 jnsfTZiP0YVrbdshkH/ckE/3ypJdlbBvbiJiRNDLJGFfIzCiFyEmey18EGUNsUnM8U
	 SgW11tNX8degenU357mARTlBltkP1I9U1A7CjR7wJCukY+bEVOksqHKcdrTdEnH81g
	 8NCaF2fNy5fWcbYuBG775RbOiaKG2Dkt7rD6WsMQH3rYyXuyXQPJKUCC+cgeYVgtOe
	 pid/aPR91H0zd9oJnlcTuDRLlHzMqlv+d06F6y3+hQRo3/4Ci8xGuORu2OSuKZF1mN
	 URdFHo2rM344YVSa2rkePLc7jXRSpIiYkziiXCh2/ib/XJ4df9e/t/Gtsh7W0OWIRk
	 2QjsMprsAckF3hbgCMbIBdKJxSoEwQD58guPWydBceTDmkk+RaXg7+bDrUkzUES56S
	 JqXRCbbKkt5z1IB0yPdYaQnyrI2XMvG3jHOHEnu/ZaXGQR+B+xNSYymRqzu1mr94Sv
	 lPLUZwtU+H+RSMSv0TgJBx3A=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D1B1840E016A;
	Fri, 16 May 2025 11:22:23 +0000 (UTC)
Date: Fri, 16 May 2025 13:22:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jain, Ayush <Ayush.Jain3@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: cryptodev linux-next splat
Message-ID: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

one of our linux-next tests which hotplugs a CPU fails with the below splat.

Reproducing is very easy:

# echo 0 > /sys/devices/system/cpu/cpu1/online=20
# echo 1 > /sys/devices/system/cpu/cpu1/online

Opcode bytes point to:

02:06:54 [ 3199.416779] Code: 65 c6 05 9a c8 ad 02 01 f7 47 2c 00 40 20 00 =
74 4f 65 48 c7 05 95 c8 ad 02 00 00 00 00 f6 c3 02 74 0d c7 44 24 04 80 1f =
00 00 <0f> ae 54 24 04 83 e3 01 75 47 48 8b 44 24 08 65 48 2b 05 49 97 ad
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:   65 c6 05 9a c8 ad 02    movb   $0x1,%gs:0x2adc89a(%rip)        # 0x=
2adc8a2
   7:   01=20
   8:   f7 47 2c 00 40 20 00    testl  $0x204000,0x2c(%rdi)
   f:   74 4f                   je     0x60
  11:   65 48 c7 05 95 c8 ad    movq   $0x0,%gs:0x2adc895(%rip)        # 0x=
2adc8b2
  18:   02 00 00 00 00=20
  1d:   f6 c3 02                test   $0x2,%bl
  20:   74 0d                   je     0x2f
  22:   c7 44 24 04 80 1f 00    movl   $0x1f80,0x4(%rsp)
  29:   00=20
  2a:*  0f ae 54 24 04          ldmxcsr 0x4(%rsp)               <-- trappin=
g instruction
  2f:   83 e3 01                and    $0x1,%ebx
  32:   75 47                   jne    0x7b
  34:   48 8b 44 24 08          mov    0x8(%rsp),%rax
  39:   65                      gs
  3a:   48                      rex.W
  3b:   2b                      .byte 0x2b
  3c:   05                      .byte 0x5
  3d:   49 97                   xchg   %rax,%r15
  3f:   ad                      lods   %ds:(%rsi),%eax

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:   0f ae 54 24 04          ldmxcsr 0x4(%rsp)
   5:   83 e3 01                and    $0x1,%ebx
   8:   75 47                   jne    0x51
   a:   48 8b 44 24 08          mov    0x8(%rsp),%rax
   f:   65                      gs
  10:   48                      rex.W
  11:   2b                      .byte 0x2b
  12:   05                      .byte 0x5
  13:   49 97                   xchg   %rax,%r15
  15:   ad                      lods   %ds:(%rsi),%eax

And LDMXCSR would #UD for a bunch of conditions.

Reverting cryptodev from linux-next next-20250515 this way:

$ git revert -m 1 ed18a632e45785e3392cf96b9683ca033a74b1f8

fixes the issue so I'm thinking it must be one of the patches you guys have
there.

Ideas?

Thx.

02:05:36  [ 3129.220448] systemd[1]: systemd-timedated.service: Deactivated=
 successfully.
02:05:36  [ 3129.252398] systemd[1]: systemd-hostnamed.service: Deactivated=
 successfully.
02:06:54  [ 3199.347946] smpboot: CPU 1 is now offline
02:06:54  [ 3199.375693] smpboot: Booting Node 0 Processor 1 APIC 0x2
02:06:54  [ 3199.381723] Oops: invalid opcode: 0000 [#1] SMP NOPTI
02:06:54  [ 3199.387364] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Kdump: loaded=
 Not tainted 6.15.0-rc6-next-20250515-484803582c77-1747374910702 #1 PREEMPT=
(voluntary)=20
02:06:54  [ 3199.402308] Hardware name: AMD Corporation Cinnabar/Cinnabar, =
BIOS RCB100DB 08/09/2024
02:06:54  [ 3199.411140] RIP: 0010:kernel_fpu_begin_mask+0x58/0xc0
02:06:54  [ 3199.416779] Code: 65 c6 05 9a c8 ad 02 01 f7 47 2c 00 40 20 00=
 74 4f 65 48 c7 05 95 c8 ad 02 00 00 00 00 f6 c3 02 74 0d c7 44 24 04 80 1f=
 00 00 <0f> ae 54 24 04 83 e3 01 75 47 48 8b 44 24 08 65 48 2b 05 49 97 ad
02:06:54  [ 3199.437736] RSP: 0000:ff3a2270c019fd98 EFLAGS: 00010002
02:06:54  [ 3199.443568] RAX: 0000000000000046 RBX: 0000000000000002 RCX: 0=
000000000000000
02:06:54  [ 3199.451528] RDX: 0000000000000057 RSI: ff380c5800eba000 RDI: f=
f380c5800eec280
02:06:54  [ 3199.459487] RBP: ff3a2270c019fe30 R08: 0000000000000000 R09: f=
f380c8684245078
02:06:54  [ 3199.467446] R10: 0000000000000000 R11: 0000000000000000 R12: f=
f380c5800eba000
02:06:54  [ 3199.475405] R13: 0000000000000057 R14: 00000000000015c0 R15: 0=
0000000000015c0
02:06:54  [ 3199.483364] FS:  0000000000000000(0000) GS:ff380c86d4935000(00=
00) knlGS:0000000000000000
02:06:54  [ 3199.492391] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
02:06:54  [ 3199.498801] CR2: 0000000000000000 CR3: 000000304b82a000 CR4: 0=
0000000003318b0
02:06:54  [ 3199.506761] Call Trace:
02:06:54  [ 3199.509487]  <TASK>
02:06:54  [ 3199.511825]  sha256_blocks_simd+0x23/0x50
02:06:54  [ 3199.516303]  sha256_update+0x73/0x100
02:06:54  [ 3199.520381]  sha256+0x70/0xa0
02:06:54  [ 3199.523690]  ? __smp_call_single_queue+0xb0/0x120
02:06:54  [ 3199.528939]  ? srso_alias_return_thunk+0x5/0xfbef5
02:06:54  [ 3199.534285]  ? bsearch+0x57/0x90
02:06:54  [ 3199.537884]  ? __pfx_cmp_id+0x10/0x10
02:06:54  [ 3199.541968]  __apply_microcode_amd+0xf1/0x1c0
02:06:54  [ 3199.546827]  ? srso_alias_return_thunk+0x5/0xfbef5
02:06:54  [ 3199.552169]  ? srso_alias_return_thunk+0x5/0xfbef5
02:06:54  [ 3199.557511]  ? cpu_init_exception_handling+0x1fe/0x2c0
02:06:54  [ 3199.563241]  ? srso_alias_return_thunk+0x5/0xfbef5
02:06:54  [ 3199.568584]  apply_microcode_amd+0xca/0x110
02:06:54  [ 3199.573251]  start_secondary+0x24/0x140
02:06:54  [ 3199.577531]  ? srso_alias_return_thunk+0x5/0xfbef5
02:06:54  [ 3199.582872]  common_startup_64+0x13e/0x141
02:06:54  [ 3199.587446]  </TASK>
02:06:54  [ 3199.589877] Modules linked in: iscsi_target_mod target_core_mo=
d binfmt_misc xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nft_compat =
nf_nat_tftp nf_conntrack_tftp overlay snd_seq_dummy snd_hrtimer snd_seq snd=
_seq_device snd_timer snd soundcore nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 =
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft=
_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set =
nf_tables nfnetlink sunrpc vfat fat amd_atl intel_rapl_msr intel_rapl_commo=
n amd64_edac edac_mce_amd kvm_amd ipmi_ssif kvm mlx5_ib irqbypass cdc_ether=
 ib_uverbs usbnet rapl mii wmi_bmof pcspkr dax_hmem acpi_cpufreq ib_core ac=
pi_ipmi i2c_piix4 k10temp i2c_smbus ipmi_si ipmi_devintf ipmi_msghandler i2=
c_designware_platform i2c_designware_core sch_fq_codel xfs ast drm_client_l=
ib i2c_algo_bit drm_shmem_helper mlx5_core ahci drm_kms_helper libahci mlxf=
w tls nvme ghash_clmulni_intel sha512_ssse3 drm tg3 psample pci_hyperv_intf=
 libata ccp nvme_core sp5100_tco wmi dm_mirror dm_region_hash dm_log


--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
