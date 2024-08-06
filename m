Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466201C578E
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 13:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722949349; cv=none; b=paGL8E2Tkv8zzxUrYh4isypQij0voiOG4MNR11oKCqYD2AsgLQerHjwfEpUqjt8D3ICHxx6RKnzCxz8vFGUKRJE8oW+SXZK3UoRMRN/ZQYV8SFND6cKnfpqgPalB8gVOJWxotLjqOZGpJtUKsKWrig01tDnqcy4e9qcHACM+8ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722949349; c=relaxed/simple;
	bh=QIZqyc+I8RFslPCQTD1BtN/Inqm96G5peDLal06r5D8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=HWMIppKtCvEveMET2Mx/5j9HbwRlw32OJpLAtjVifrbrwvFo4Z41jwDKutkQuzTlcM4KDeeskxrNMAaPDJsGzOal97yG+Zy9jrv/SzV5nIFE3V/qf3h3WTjJEnRM87/zxSUjUaWyrtrwrtUmhWU44Y5TTwN+sXJNPCbtC3auGpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bgQphaFS; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bgQphaFS"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240806130223euoutp012c1d7c27cb6a735371f26c50e05f22d9~pJUydekF90765607656euoutp01j
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 13:02:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240806130223euoutp012c1d7c27cb6a735371f26c50e05f22d9~pJUydekF90765607656euoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722949343;
	bh=Lb/5UzI+07WJdSlW9RPzOwZ2h2A+sulIeTSbgEZxUgM=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=bgQphaFSXL/2OtAaLMwY2+1anc4Skz+yTMqsxTMmtI+Zzx7X/BoICsHQ8QiMh5a/M
	 zzlIqF0Ca9VczBkatgBvXqtpwRsMybdwRZnjhqYF2zadYYBy1K0XZOUVqQPpf/Y8eo
	 mTT9CsaO2ue3furffhotrNxgn0zc8mO7h8XSaVSo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240806130223eucas1p2a8ae07ada81e178b5442e0dcbfd2de07~pJUyQ5e_A2768327683eucas1p2v;
	Tue,  6 Aug 2024 13:02:23 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 97.67.09624.EDE12B66; Tue,  6
	Aug 2024 14:02:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240806130222eucas1p11900a61c4922bc5cad1ac3c464a0b159~pJUxw_U4P0397703977eucas1p1g;
	Tue,  6 Aug 2024 13:02:22 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240806130222eusmtrp23778000324d1c284e3e0b44ac97dba0e~pJUxwGMPy0338103381eusmtrp2U;
	Tue,  6 Aug 2024 13:02:22 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-e8-66b21ede8bab
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id B0.1D.08810.EDE12B66; Tue,  6
	Aug 2024 14:02:22 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240806130222eusmtip17c7d19166bffb1a1f69c9c17faabec13~pJUxbq9k01872218722eusmtip1C;
	Tue,  6 Aug 2024 13:02:22 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Tue, 6 Aug 2024 14:02:21 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Tue, 6 Aug
	2024 14:02:21 +0100
From: Daniel Gomez <da.gomez@samsung.com>
To: Jia He <justin.he@arm.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Andy Polyakov
	<appro@cryptogams.org>, "David S. Miller" <davem@davemloft.net>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: arm64/poly1305 - move data to rodata section
Thread-Topic: [PATCH v2] crypto: arm64/poly1305 - move data to rodata
	section
Thread-Index: AQHa5//zJkuz2mMGX0eEFIkrDDjbXrIaIPoA
Date: Tue, 6 Aug 2024 13:02:20 +0000
Message-ID: <hedfv2cny4wk4izuhvkur56xnrmclakxedfr5yzo5vl34ac35i@siwozxxr4u7a>
In-Reply-To: <qd2jxjle5zf6u4vyu5x32wjhzj4t5cxrc7dbi46inhlhjxhw4s@llhfvho4l2e6>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6E56B73BFD29041968D3A657FEB55DF@scsc.local>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7djPc7r35TalGby7xWQx90krk8X7ZT2M
	FnPOt7BYdL+SsXh64g+7xabH11gt7t/7yWRxedccNouWO6YOnB5r5q1h9HgwcQOLx5aVN5k8
	th1Q9di0qpPNY/OSeo/Pm+QC2KO4bFJSczLLUov07RK4Mj7NfMJYMFu74vnNBtYGxikqXYwc
	HBICJhK/dpl3MXJxCAmsYJRY8vYWI4TzhVHi8/7PTBDOZ0aJFxsXAzmcYB0HX25gBLGFBJYz
	Shx/Zw5X1HpnOQuEc5pRYva/WYxwgz/PbwNrZxPQlNh3chM7iC0iICfxou8jG0gRs8ACZonu
	i5fYQBLCAj4SM/Z/ZIEo8pd4+3ALK4RtJDFryXQwm0VARaJ/6wowm1fAV2L3q6lgN3EK+EnM
	vDcdbBmjgKzEo5W/wJYxC4hL3HoyH+oHQYlFs/cwQ9hiEv92PWSDsHUkzl5/wghhG0hsXbqP
	BcJWlOg4dpMNYo6OxILdn6BsS4kT7+cyQdjaEssWvmaGuEdQ4uTMJ+CgkBB4xinR++E91AIX
	iZ+b3kAtEJZ4dXwL+wRGnVlI7puFZMcsJDtmIdkxC8mOBYysqxjFU0uLc9NTiw3zUsv1ihNz
	i0vz0vWS83M3MQKT2Ol/xz/tYJz76qPeIUYmDsZDjBIczEoivF2lG9KEeFMSK6tSi/Lji0pz
	UosPMUpzsCiJ86qmyKcKCaQnlqRmp6YWpBbBZJk4OKUamJINU3d8sNydyztPUW21y09Vb7HH
	/TcD7s9fz3/OyMNiEVPsuautJxQ37o1XYri40PGvcI93suDP78YrzsxcLiZ1MfzfHqUbsv2H
	yiZkfIt7w1TLo7OsL0OBZ+VPviL5lxUxD78nMjb0G230/Tn9xrLs4gLRlMi4JCaNUCmbb+v9
	6tZ92BY5O7j0wLLznip13zssXtxvErsn8VtLSHDKFxOfG3HOWQsWMs6dpHd+2uYXy16E8axu
	KuHsz0rqv3PLct7RV6ws0/5bTP22g19RcGboorqX9VvXO2+r4Za5Ib3cW0l9Y9c9kZfte+sU
	+P6IRQhI3Vg279GUa3eFXttqeF294HOJ37cloSl5Oz/bPiWW4oxEQy3mouJEAMZPABHRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t/xu7r35DalGTw8KW0x90krk8X7ZT2M
	FnPOt7BYdL+SsXh64g+7xabH11gt7t/7yWRxedccNouWO6YOnB5r5q1h9HgwcQOLx5aVN5k8
	th1Q9di0qpPNY/OSeo/Pm+QC2KP0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxM
	lfTtbFJSczLLUov07RL0Mj7NfMJYMFu74vnNBtYGxikqXYycHBICJhIHX25g7GLk4hASWMoo
	sa+jhx0iISOx8ctVVghbWOLPtS42EFtI4COjxI7pkRANpxkl1n54yAbhrGCUODJtBVgHm4Cm
	xL6Tm8AmiQjISbzo+whWxCywgFmi++IlsFHCAj4SM/Z/ZIEo8pU4vfIXVIORxKwl08EGsQio
	SPRvhRjKC1Sz+9VURogzqiWu9PxnBrE5BfwkZt6bzgRiMwrISjyCmsMsIC5x68l8JogXBCSW
	7DnPDGGLSrx8/A/qNR2Js9efMELYBhJbl+5jgbAVJTqO3WSDmKMjsWD3JyjbUuLE+7lMELa2
	xLKFr5khbhOUODnzCcsERplZSFbPQtI+C0n7LCTts5C0L2BkXcUoklpanJueW2yoV5yYW1ya
	l66XnJ+7iRGYoLYd+7l5B+O8Vx/1DjEycTAeYpTgYFYS4e0q3ZAmxJuSWFmVWpQfX1Sak1p8
	iNEUGHYTmaVEk/OBKTKvJN7QzMDU0MTM0sDU0sxYSZzXs6AjUUggPbEkNTs1tSC1CKaPiYNT
	qoHppESFol/sBdmk8h2aLk7X+/bL28TpR977w9p+1CTuzeektDCGdqGXL50FWcqmcSXc0fL2
	9tkwMUvhhoXRqRrlw4knvz0seH+W/3vBa5UCM/vODE75o3onrzLt8v0Z0hbH9+7ujEVls5KY
	NFqstlueWrmbye5SRfl1u/jvBxbJXt/mxXLojPud18nX7hmtkLQK2ePX+ZK55XXvg06DTOuu
	U/e2xywtZy+U79edt17BykFk5vTNjl5eHrzf67V9F3KtLj27VGftvGh/w/sz2tlsv5+/einY
	55uv0JyFrE+b+/k/9zpc4ar484ida2fRna+SfOdS3bjOm7qeEs/e++V0nrXQ8gli0x49TGgp
	ZVRiKc5INNRiLipOBAARjeDv2QMAAA==
X-CMS-MailID: 20240806130222eucas1p11900a61c4922bc5cad1ac3c464a0b159
X-Msg-Generator: CA
X-RootMTR: 20240806130222eucas1p11900a61c4922bc5cad1ac3c464a0b159
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240806130222eucas1p11900a61c4922bc5cad1ac3c464a0b159
References: <20240806055444.528932-1-justin.he@arm.com>
	<qd2jxjle5zf6u4vyu5x32wjhzj4t5cxrc7dbi46inhlhjxhw4s@llhfvho4l2e6>
	<CGME20240806130222eucas1p11900a61c4922bc5cad1ac3c464a0b159@eucas1p1.samsung.com>

On Tue, Aug 06, 2024 at 02:55:45PM GMT, Daniel Gomez wrote:
> On Tue, Aug 06, 2024 at 05:54:44AM GMT, Jia He wrote:
>=20
> Hi Jia,
>=20
> > When objtool gains support for ARM in the future, it may encounter issu=
es
> > disassembling the following data in the .text section:
> > > .Lzeros:
> > > .long   0,0,0,0,0,0,0,0
> > > .asciz  "Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
> > > .align  2
> >=20
> > Move it to .rodata which is a more appropriate section for read-only da=
ta.
> >=20
> > There is a limit on how far the label can be from the instruction, henc=
e
> > use "adrp" and low 12bits offset of the label to avoid the compilation
> > error.
> >=20
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> > v2:
> >   - use adrp+offset to avoid compilation error(kernel test bot and Andy=
)
> > v1: https://lkml.org/lkml/2024/8/2/616
> >=20
> >  arch/arm64/crypto/poly1305-armv8.pl | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/arm64/crypto/poly1305-armv8.pl b/arch/arm64/crypto/po=
ly1305-armv8.pl
> > index cbc980fb02e3..22c9069c0650 100644
> > --- a/arch/arm64/crypto/poly1305-armv8.pl
> > +++ b/arch/arm64/crypto/poly1305-armv8.pl
> > @@ -473,7 +473,8 @@ poly1305_blocks_neon:
> >  	subs	$len,$len,#64
> >  	ldp	x9,x13,[$inp,#48]
> >  	add	$in2,$inp,#96
> > -	adr	$zeros,.Lzeros
> > +	adrp	$zeros,.Lzeros
> > +	add	$zeros,$zeros,#:lo12:.Lzeros
> > =20
> >  	lsl	$padbit,$padbit,#24
> >  	add	x15,$ctx,#48
> > @@ -885,10 +886,13 @@ poly1305_blocks_neon:
> >  	ret
> >  .size	poly1305_blocks_neon,.-poly1305_blocks_neon
> > =20
> > +.pushsection .rodata
> >  .align	5
> >  .Lzeros:
> >  .long	0,0,0,0,0,0,0,0
> >  .asciz	"Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
> > +.popsection
> > +
>=20
> I'm getting the following error with next-20240806

To clarify my report: the error below disappears when this patch is reverte=
d.

>=20
> make LLVM=3D1 ARCH=3Darm64 allyesconfig
> make LLVM=3D1 ARCH=3Darm64 -j$(nproc)
>=20
> ld.lld: error: vmlinux.a(arch/arm64/crypto/poly1305-core.o):(function pol=
y1305_blocks_neon: .text+0x3d4): relocation R_AARCH64_ADR_PREL_LO21 out of =
range: 269166444 is not in [-1048576, 1048575]
>=20
> Full debug error with log context:
>=20
> ...
> + grep -q ^CONFIG_DEBUG_INFO_BTF=3Dy include/config/auto.conf
> + strip_debug=3D1
> + vmlinux_link .tmp_vmlinux1
> + local output=3D.tmp_vmlinux1
> + local objs
> + local libs
> + local ld
> + local ldflags
> + local ldlibs
> + info LD .tmp_vmlinux1
> + printf   %-7s %s\n LD .tmp_vmlinux1
>   LD      .tmp_vmlinux1
> + shift
> + is_enabled CONFIG_LTO_CLANG
> + grep -q ^CONFIG_LTO_CLANG=3Dy include/config/auto.conf
> + is_enabled CONFIG_X86_KERNEL_IBT
> + grep -q ^CONFIG_X86_KERNEL_IBT=3Dy include/config/auto.conf
> + objs=3Dvmlinux.a
> + libs=3D./drivers/firmware/efi/libstub/lib.a
> + is_enabled CONFIG_MODULES
> + grep -q ^CONFIG_MODULES=3Dy include/config/auto.conf
> + objs=3Dvmlinux.a .vmlinux.export.o
> + objs=3Dvmlinux.a .vmlinux.export.o init/version-timestamp.o
> + [ arm64 =3D um ]
> + wl=3D
> + ld=3Dld.lld
> + ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X=
 -shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-8=
43419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derr=
or
> + ldlibs=3D
> + ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X=
 -shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-8=
43419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derr=
or --script=3D./arch/arm64/kernel/vmlinux.lds
> + [ -n 1 ]
> + ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X=
 -shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-8=
43419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derr=
or --script=3D./arch/arm64/kernel/vmlinux.lds --strip-debug
> + is_enabled CONFIG_VMLINUX_MAP
> + grep -q ^CONFIG_VMLINUX_MAP=3Dy include/config/auto.conf
> + ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X=
 -shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-8=
43419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derr=
or --script=3D./arch/arm64/kernel/vmlinux.lds --strip-debug -Map=3D.tmp_vml=
inux1.map
> + ld.lld -EL -maarch64elf -z norelro -z noexecstack --no-undefined -X -sh=
ared -Bsymbolic -z notext --no-apply-dynamic-relocs --fix-cortex-a53-843419=
 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derror --=
script=3D./arch/arm64/kernel/vmlinux.lds --strip-debug -Map=3D.tmp_vmlinux1=
.map -o .tmp_vmlinux1 --whole-archive vmlinux.a .vmlinux.export.o init/vers=
ion-timestamp.o --no-whole-archive --start-group ./drivers/firmware/efi/lib=
stub/lib.a --end-group .tmp_vmlinux0.kallsyms.o
> ld.lld: error: vmlinux.a(arch/arm64/crypto/poly1305-core.o):(function pol=
y1305_blocks_neon: .text+0x3d4): relocation R_AARCH64_ADR_PREL_LO21 out of =
range: 269166444 is not in [-1048576, 1048575]
> make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
> make[1]: *** [/home/dagomez/src/linux-next/Makefile:1156: vmlinux] Error =
2
> make: *** [Makefile:224: __sub-make] Error 2
>=20
> Any suggestion how to fix this?
>=20
> Daniel
>=20
> >  .align	2
> >  #if !defined(__KERNEL__) && !defined(_WIN64)
> >  .comm	OPENSSL_armcap_P,4,4
> > --=20
> > 2.34.1
> > =
