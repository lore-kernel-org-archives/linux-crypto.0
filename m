Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E60B21B9E2;
	Fri, 16 May 2025 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747395266; cv=none; b=Ionz5xdttznprYnsh9JEHsYsnB+a8QWk3/Gig6H2OYsnq2ynlW08HRceyHy8WkYTd5K1ryoX2OBC94TvGGtLei04jIJ+2glxa0S+5Gt22iXhB57JeIr4GWHzsB6lisIZ6xs4OERjkfYBcdf7HCPPPau4XnJ6Tk9Nw/YIK1H8aBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747395266; c=relaxed/simple;
	bh=teKuzN9dqE6GiOpV8Sf3xVOTYhBmLpkHkrdRiCAicKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DWTbGmlGlYSJb3H+kQjCyf0sUGTpiuXmnMPMRFhh1+0s2xU7SpgOdZZUQLvZgBwnl+2I8HmO5HHnQWeiq9gdG5b1qYSrcGSYD2bGZDKFj33iTUUahyowJ861zUQSrkez3S2dDynW+Ucn+GSOaH2yoPa+UaS8jhkVrsvx6bNdZpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mLES8tur; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mLES8tur"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=shyT/oHeqaQuD+T3lMDlpQH2XhSDj8LDWTYr35IZJco=; b=mLES8turh2PojJZU3K/EBJfuYf
	MLA7zWMPM5XpWB4rkOQ1Ee03YYUNGMUnfiomp17L3BLdN7Y0Bg1mQJ8oAwArsJSgU1xTEp2mCrUGF
	r8/jLJqI6DLQhhVTknMixF6Z3hFLLQCp3tI3HRaQYjTXzgnm5P3yFypq44TApJswYV1lwyY3LCpGs
	jPvspoYZ9m1IMd/vQXfxOWPY+Bxdj7YwlJ03jKVooX2fpiwpYNH+iH3G4+485pBPXD4DxUTNyUNoE
	wecXcX4VJz0Z7PWgxAU8qkUHyky0PbELhMbN7hDlg20Bv8/ClUkn9dN92PnmqjLC8mab/V0X0tdDk
	dgJoMG8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFtKI-006ZlJ-11;
	Fri, 16 May 2025 19:34:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 19:34:06 +0800
Date: Fri, 16 May 2025 19:34:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>
Cc: Jain@formenos.rohan.me.apana.org.au, Ayush <Ayush.Jain3@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@google.com>
Subject: Re: cryptodev linux-next splat
Message-ID: <aCcirrsFFrrRqf5A@gondor.apana.org.au>
References: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>

On Fri, May 16, 2025 at 01:22:17PM +0200, Borislav Petkov wrote:
> Hi Herbert,
>=20
> one of our linux-next tests which hotplugs a CPU fails with the below spl=
at.
>=20
> Reproducing is very easy:
>=20
> # echo 0 > /sys/devices/system/cpu/cpu1/online=20
> # echo 1 > /sys/devices/system/cpu/cpu1/online
>=20
> Opcode bytes point to:
>=20
> 02:06:54 [ 3199.416779] Code: 65 c6 05 9a c8 ad 02 01 f7 47 2c 00 40 20 0=
0 74 4f 65 48 c7 05 95 c8 ad 02 00 00 00 00 f6 c3 02 74 0d c7 44 24 04 80 1=
f 00 00 <0f> ae 54 24 04 83 e3 01 75 47 48 8b 44 24 08 65 48 2b 05 49 97 ad
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:   65 c6 05 9a c8 ad 02    movb   $0x1,%gs:0x2adc89a(%rip)        # =
0x2adc8a2
>    7:   01=20
>    8:   f7 47 2c 00 40 20 00    testl  $0x204000,0x2c(%rdi)
>    f:   74 4f                   je     0x60
>   11:   65 48 c7 05 95 c8 ad    movq   $0x0,%gs:0x2adc895(%rip)        # =
0x2adc8b2
>   18:   02 00 00 00 00=20
>   1d:   f6 c3 02                test   $0x2,%bl
>   20:   74 0d                   je     0x2f
>   22:   c7 44 24 04 80 1f 00    movl   $0x1f80,0x4(%rsp)
>   29:   00=20
>   2a:*  0f ae 54 24 04          ldmxcsr 0x4(%rsp)               <-- trapp=
ing instruction
>   2f:   83 e3 01                and    $0x1,%ebx
>   32:   75 47                   jne    0x7b
>   34:   48 8b 44 24 08          mov    0x8(%rsp),%rax
>   39:   65                      gs
>   3a:   48                      rex.W
>   3b:   2b                      .byte 0x2b
>   3c:   05                      .byte 0x5
>   3d:   49 97                   xchg   %rax,%r15
>   3f:   ad                      lods   %ds:(%rsi),%eax
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:   0f ae 54 24 04          ldmxcsr 0x4(%rsp)
>    5:   83 e3 01                and    $0x1,%ebx
>    8:   75 47                   jne    0x51
>    a:   48 8b 44 24 08          mov    0x8(%rsp),%rax
>    f:   65                      gs
>   10:   48                      rex.W
>   11:   2b                      .byte 0x2b
>   12:   05                      .byte 0x5
>   13:   49 97                   xchg   %rax,%r15
>   15:   ad                      lods   %ds:(%rsi),%eax
>=20
> And LDMXCSR would #UD for a bunch of conditions.
>=20
> Reverting cryptodev from linux-next next-20250515 this way:
>=20
> $ git revert -m 1 ed18a632e45785e3392cf96b9683ca033a74b1f8
>=20
> fixes the issue so I'm thinking it must be one of the patches you guys ha=
ve
> there.
>=20
> Ideas?

Yes probably.

So what's happened is that previously if you call sha256_update
=66rom lib/crypto it would only use the generic C code to perform
the operation.

This has now been changed to automatically use SIMD instructions
which obviously blew up in your case.

Eric, can you please take a look at this crash? It looks like
crypto_simd_usable returned true, but kernel_fpu_begin still
crashed for some reason.  One of them must be wrong :)

Thanks,

> 02:05:36  [ 3129.220448] systemd[1]: systemd-timedated.service: Deactivat=
ed successfully.
> 02:05:36  [ 3129.252398] systemd[1]: systemd-hostnamed.service: Deactivat=
ed successfully.
> 02:06:54  [ 3199.347946] smpboot: CPU 1 is now offline
> 02:06:54  [ 3199.375693] smpboot: Booting Node 0 Processor 1 APIC 0x2
> 02:06:54  [ 3199.381723] Oops: invalid opcode: 0000 [#1] SMP NOPTI
> 02:06:54  [ 3199.387364] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Kdump: load=
ed Not tainted 6.15.0-rc6-next-20250515-484803582c77-1747374910702 #1 PREEM=
PT(voluntary)=20
> 02:06:54  [ 3199.402308] Hardware name: AMD Corporation Cinnabar/Cinnabar=
, BIOS RCB100DB 08/09/2024
> 02:06:54  [ 3199.411140] RIP: 0010:kernel_fpu_begin_mask+0x58/0xc0
> 02:06:54  [ 3199.416779] Code: 65 c6 05 9a c8 ad 02 01 f7 47 2c 00 40 20 =
00 74 4f 65 48 c7 05 95 c8 ad 02 00 00 00 00 f6 c3 02 74 0d c7 44 24 04 80 =
1f 00 00 <0f> ae 54 24 04 83 e3 01 75 47 48 8b 44 24 08 65 48 2b 05 49 97 ad
> 02:06:54  [ 3199.437736] RSP: 0000:ff3a2270c019fd98 EFLAGS: 00010002
> 02:06:54  [ 3199.443568] RAX: 0000000000000046 RBX: 0000000000000002 RCX:=
 0000000000000000
> 02:06:54  [ 3199.451528] RDX: 0000000000000057 RSI: ff380c5800eba000 RDI:=
 ff380c5800eec280
> 02:06:54  [ 3199.459487] RBP: ff3a2270c019fe30 R08: 0000000000000000 R09:=
 ff380c8684245078
> 02:06:54  [ 3199.467446] R10: 0000000000000000 R11: 0000000000000000 R12:=
 ff380c5800eba000
> 02:06:54  [ 3199.475405] R13: 0000000000000057 R14: 00000000000015c0 R15:=
 00000000000015c0
> 02:06:54  [ 3199.483364] FS:  0000000000000000(0000) GS:ff380c86d4935000(=
0000) knlGS:0000000000000000
> 02:06:54  [ 3199.492391] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 02:06:54  [ 3199.498801] CR2: 0000000000000000 CR3: 000000304b82a000 CR4:=
 00000000003318b0
> 02:06:54  [ 3199.506761] Call Trace:
> 02:06:54  [ 3199.509487]  <TASK>
> 02:06:54  [ 3199.511825]  sha256_blocks_simd+0x23/0x50
> 02:06:54  [ 3199.516303]  sha256_update+0x73/0x100
> 02:06:54  [ 3199.520381]  sha256+0x70/0xa0
> 02:06:54  [ 3199.523690]  ? __smp_call_single_queue+0xb0/0x120
> 02:06:54  [ 3199.528939]  ? srso_alias_return_thunk+0x5/0xfbef5
> 02:06:54  [ 3199.534285]  ? bsearch+0x57/0x90
> 02:06:54  [ 3199.537884]  ? __pfx_cmp_id+0x10/0x10
> 02:06:54  [ 3199.541968]  __apply_microcode_amd+0xf1/0x1c0
> 02:06:54  [ 3199.546827]  ? srso_alias_return_thunk+0x5/0xfbef5
> 02:06:54  [ 3199.552169]  ? srso_alias_return_thunk+0x5/0xfbef5
> 02:06:54  [ 3199.557511]  ? cpu_init_exception_handling+0x1fe/0x2c0
> 02:06:54  [ 3199.563241]  ? srso_alias_return_thunk+0x5/0xfbef5
> 02:06:54  [ 3199.568584]  apply_microcode_amd+0xca/0x110
> 02:06:54  [ 3199.573251]  start_secondary+0x24/0x140
> 02:06:54  [ 3199.577531]  ? srso_alias_return_thunk+0x5/0xfbef5
> 02:06:54  [ 3199.582872]  common_startup_64+0x13e/0x141
> 02:06:54  [ 3199.587446]  </TASK>
> 02:06:54  [ 3199.589877] Modules linked in: iscsi_target_mod target_core_=
mod binfmt_misc xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nft_compa=
t nf_nat_tftp nf_conntrack_tftp overlay snd_seq_dummy snd_hrtimer snd_seq s=
nd_seq_device snd_timer snd soundcore nft_fib_inet nft_fib_ipv4 nft_fib_ipv=
6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct n=
ft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_se=
t nf_tables nfnetlink sunrpc vfat fat amd_atl intel_rapl_msr intel_rapl_com=
mon amd64_edac edac_mce_amd kvm_amd ipmi_ssif kvm mlx5_ib irqbypass cdc_eth=
er ib_uverbs usbnet rapl mii wmi_bmof pcspkr dax_hmem acpi_cpufreq ib_core =
acpi_ipmi i2c_piix4 k10temp i2c_smbus ipmi_si ipmi_devintf ipmi_msghandler =
i2c_designware_platform i2c_designware_core sch_fq_codel xfs ast drm_client=
_lib i2c_algo_bit drm_shmem_helper mlx5_core ahci drm_kms_helper libahci ml=
xfw tls nvme ghash_clmulni_intel sha512_ssse3 drm tg3 psample pci_hyperv_in=
tf libata ccp nvme_core sp5100_tco wmi dm_mirror dm_region_hash dm_log

--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
