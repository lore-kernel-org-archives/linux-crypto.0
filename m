Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0D71C57AF
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 12:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948959; cv=none; b=GqcXkd3iZW0PVmp4hB1/AlcfosfcTm2Ygl3XXwFStmXI3aw5ZzWZy2PdhZEyxn57Yil+SuefMQ4S7f1s0WSwGPBeaISUc04tdw7C5frQLXRvx3LbNw3sgoW+Co4a+qf/uor7hqCDvrOzLOxhAGLYrck7yOr2RkNOqe73gP/huGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948959; c=relaxed/simple;
	bh=mAMLzpif1gNdzNGhe8KuRzYGSz6pOT3BstJuxee6FTQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=N7FINLckqG2aOeORVwUgeU66xDw1EFyjAr8HcwacHw/CMC70geL9GPSCuWAyAIteMzv7wq2m4OcCrsIzNcbkwpZbk+z9yE8AW6Y62gJ4Z6tIEG1cN+2QmKbohLJZJVQaaXt2h9/eDcmB/OHi1FRBJi/zpQy8nF9v0E9sVftkYNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LRcv+Vhl; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LRcv+Vhl"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240806125548euoutp010b65b027b2a6e4a97e29496a12d62c10~pJPCkd7HA3146131461euoutp01j
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 12:55:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240806125548euoutp010b65b027b2a6e4a97e29496a12d62c10~pJPCkd7HA3146131461euoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722948948;
	bh=esju4BJcQQlBYz+5tBGpKzvVnAuDBBZmMHM2QWKITuM=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=LRcv+Vhl2IaTdj/QJ4R/EkiU8hq1humWgJuCPShFC2ZXfgEaRY+JV84mAqQ2eFDQu
	 jLU8v7s67w1ckdP3mv5J8s+j5G0I/z2gYux3ArY4ST+/PpWsE8+DaEQj5INzZJQlUY
	 mb30jNlyaC06vc+ndBVs3u33tAL9ZWh+yk98rRFE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240806125547eucas1p2debf066641f75a76910c5e13cc385027~pJPCHLMub0165701657eucas1p2I;
	Tue,  6 Aug 2024 12:55:47 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id A5.F5.09624.35D12B66; Tue,  6
	Aug 2024 13:55:47 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381~pJPBl8O3v0169001690eucas1p2D;
	Tue,  6 Aug 2024 12:55:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240806125547eusmtrp125c4d13f21cad7079d555451ace1e42c~pJPBlWbfB2935529355eusmtrp1K;
	Tue,  6 Aug 2024 12:55:47 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-63-66b21d5331e3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 36.87.09010.35D12B66; Tue,  6
	Aug 2024 13:55:47 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240806125546eusmtip213e82826fb0451768400eb0b5684c4eb~pJPBG9Xrq1165611656eusmtip2U;
	Tue,  6 Aug 2024 12:55:46 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Tue, 6 Aug 2024 13:55:45 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Tue, 6 Aug
	2024 13:55:45 +0100
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
Thread-Index: AQHa5//zJkuz2mMGX0eEFIkrDDjbXg==
Date: Tue, 6 Aug 2024 12:55:45 +0000
Message-ID: <qd2jxjle5zf6u4vyu5x32wjhzj4t5cxrc7dbi46inhlhjxhw4s@llhfvho4l2e6>
In-Reply-To: <20240806055444.528932-1-justin.he@arm.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-ID: <965179E67335EA4DB3E7CEA505837BDE@scsc.local>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7djPc7rBspvSDC6e17WY+6SVyeL9sh5G
	iznnW1gsul/JWDw98YfdYtPja6wW9+/9ZLK4vGsOm0XLHVMHTo8189YwejyYuIHFY8vKm0we
	2w6oemxa1cnmsXlJvcfnTXIB7FFcNimpOZllqUX6dglcGStfzmEtaNWoaP/h2MDYp9TFyMkh
	IWAi0bh8FmMXIxeHkMAKRokLy/YzQzhfGCWuL17NDlIlJPCZUWLlPDmYji/He6A6ljNKPHrw
	B8oBKrrbvJ0dwjnNKLGn4Rsz3OA7czYygvSzCWhK7Du5CWyuiICcxIu+j2wgRcwCC5glui9e
	YgNJCAv4SMzY/5EFoshf4u3DLaxdjBxAtp7E9HdWIGEWARWJc68eMIHYvAK+EquONoPN5xSw
	kFh+cwWYzSggK/Fo5S+wXcwC4hK3nsxngvhBUGLR7D3MELaYxL9dD9kgbB2Js9efMELYBhJb
	l+5jgbAVJTqO3WSDmKMjsWD3JyjbUuLg6TnMELa2xLKFr5kh7hGUODnzCQvIXxICrzglVnx8
	ALXYRWLZqn6oxcISr45vYZ/AqDMLyX2zkOyYhWTHLCQ7ZiHZsYCRdRWjeGppcW56arFhXmq5
	XnFibnFpXrpecn7uJkZgCjv97/inHYxzX33UO8TIxMF4iFGCg1lJhLerdEOaEG9KYmVValF+
	fFFpTmrxIUZpDhYlcV7VFPlUIYH0xJLU7NTUgtQimCwTB6dUA5P7Y6l10Yu1m83u8suZV77Y
	G9syvV5HYYaP7cTDB+1Yv69P3c8gOXXOWu930bdvP5gQe/1GVqSV+bWJ5xj4Zu2u9nFcl8cp
	bXVrTfi93+2PZgbMVO3h731g7dU8f63x5RezMy5n/Zq0RNopJ5N9urwKx4TT9Us4n63fYPrg
	9cGMu5uYnha01l9VeGO49dyLXQ9NpDyLP9+W3+M/PfnLhPePF0T0Fq5UjFbuZjE6dUnmd6ao
	i6jdqbszbrVU6K7qiGpyX3ZkamHe7tef2gKkFm1f+XyDTtaDeVs5OY1K2VN/fxS/F/ntZkBQ
	FdOj72zXbBOPNcicfHY14mEx//vqN2ecVRJKJIKZQx+m2Xq92LxOiaU4I9FQi7moOBEAMUZd
	h9ADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/xe7rBspvSDFZPYLOY+6SVyeL9sh5G
	iznnW1gsul/JWDw98YfdYtPja6wW9+/9ZLK4vGsOm0XLHVMHTo8189YwejyYuIHFY8vKm0we
	2w6oemxa1cnmsXlJvcfnTXIB7FF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkam
	Svp2NimpOZllqUX6dgl6GStfzmEtaNWoaP/h2MDYp9TFyMkhIWAi8eV4D2MXIxeHkMBSRonT
	vyeyQyRkJDZ+ucoKYQtL/LnWxQZiCwl8ZJRoPKoK0XCaUaJtyhIWCGcFo8SLb9MYQarYBDQl
	9p3cBDZJREBO4kXfRzaQImaBBcwS3RcvgY0SFvCRmLH/IwtEka/E6ZW/gBo4gGw9ienvrEDC
	LAIqEudePWACsXmBSlYdbWaEuMJcYsHCLrD5nAIWEstvrgCLMwrISjwCG8MJtEtc4taT+UwQ
	HwhILNlznhnCFpV4+fgf1Gc6EmevP2GEsA0kti7dxwJhK0p0HLvJBjFHR2LB7k9QtqXEwdNz
	mCFsbYllC18zQ9wmKHFy5hOWCYwys5CsnoWkfRaS9llI2mchaV/AyLqKUSS1tDg3PbfYSK84
	Mbe4NC9dLzk/dxMjMDltO/Zzyw7Gla8+6h1iZOJgPMQowcGsJMLbVbohTYg3JbGyKrUoP76o
	NCe1+BCjKTDsJjJLiSbnA9NjXkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2ampBahFM
	HxMHp1QDkwsba4b2tqyJ7T8P87502xLP1J7mt88vl3vydYeD5xqWNnkllcRmyeRlzW9UO/TY
	3Sa+PIVnx6/7XA92zvYSDHu/YNe1C1xPPhcc0jpepZ5kK3bivdG+h9pvDmUVhDhV+2xP+mo5
	46OR6IbCGHbfWvG8mWeq3H5tEzyxUHKiu2b7n21r+IQliqQ3LIne25F48ZzxuezFdROmioRe
	ZEwo32X3rPXSrbzTV2+sFr5hNP+0xY6Trs75nnXXtpppO5gubU2rSN8btqPtbmNKGfepf0/N
	cnxWPcoNN7ORdtz0letp+ZrnBb3vlr+9y1rk9vRevo9mXW7xv4jtNqwfugrKJrRbde/3/flI
	b2Pp49YVSizFGYmGWsxFxYkAIn85V9cDAAA=
X-CMS-MailID: 20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381
X-Msg-Generator: CA
X-RootMTR: 20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381
References: <20240806055444.528932-1-justin.he@arm.com>
	<CGME20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381@eucas1p2.samsung.com>

On Tue, Aug 06, 2024 at 05:54:44AM GMT, Jia He wrote:

Hi Jia,

> When objtool gains support for ARM in the future, it may encounter issues
> disassembling the following data in the .text section:
> > .Lzeros:
> > .long   0,0,0,0,0,0,0,0
> > .asciz  "Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
> > .align  2
>=20
> Move it to .rodata which is a more appropriate section for read-only data=
.
>=20
> There is a limit on how far the label can be from the instruction, hence
> use "adrp" and low 12bits offset of the label to avoid the compilation
> error.
>=20
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
> v2:
>   - use adrp+offset to avoid compilation error(kernel test bot and Andy)
> v1: https://lkml.org/lkml/2024/8/2/616
>=20
>  arch/arm64/crypto/poly1305-armv8.pl | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/crypto/poly1305-armv8.pl b/arch/arm64/crypto/poly=
1305-armv8.pl
> index cbc980fb02e3..22c9069c0650 100644
> --- a/arch/arm64/crypto/poly1305-armv8.pl
> +++ b/arch/arm64/crypto/poly1305-armv8.pl
> @@ -473,7 +473,8 @@ poly1305_blocks_neon:
>  	subs	$len,$len,#64
>  	ldp	x9,x13,[$inp,#48]
>  	add	$in2,$inp,#96
> -	adr	$zeros,.Lzeros
> +	adrp	$zeros,.Lzeros
> +	add	$zeros,$zeros,#:lo12:.Lzeros
> =20
>  	lsl	$padbit,$padbit,#24
>  	add	x15,$ctx,#48
> @@ -885,10 +886,13 @@ poly1305_blocks_neon:
>  	ret
>  .size	poly1305_blocks_neon,.-poly1305_blocks_neon
> =20
> +.pushsection .rodata
>  .align	5
>  .Lzeros:
>  .long	0,0,0,0,0,0,0,0
>  .asciz	"Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
> +.popsection
> +

I'm getting the following error with next-20240806

make LLVM=3D1 ARCH=3Darm64 allyesconfig
make LLVM=3D1 ARCH=3Darm64 -j$(nproc)

ld.lld: error: vmlinux.a(arch/arm64/crypto/poly1305-core.o):(function poly1=
305_blocks_neon: .text+0x3d4): relocation R_AARCH64_ADR_PREL_LO21 out of ra=
nge: 269166444 is not in [-1048576, 1048575]

Full debug error with log context:

...
+ grep -q ^CONFIG_DEBUG_INFO_BTF=3Dy include/config/auto.conf
+ strip_debug=3D1
+ vmlinux_link .tmp_vmlinux1
+ local output=3D.tmp_vmlinux1
+ local objs
+ local libs
+ local ld
+ local ldflags
+ local ldlibs
+ info LD .tmp_vmlinux1
+ printf   %-7s %s\n LD .tmp_vmlinux1
  LD      .tmp_vmlinux1
+ shift
+ is_enabled CONFIG_LTO_CLANG
+ grep -q ^CONFIG_LTO_CLANG=3Dy include/config/auto.conf
+ is_enabled CONFIG_X86_KERNEL_IBT
+ grep -q ^CONFIG_X86_KERNEL_IBT=3Dy include/config/auto.conf
+ objs=3Dvmlinux.a
+ libs=3D./drivers/firmware/efi/libstub/lib.a
+ is_enabled CONFIG_MODULES
+ grep -q ^CONFIG_MODULES=3Dy include/config/auto.conf
+ objs=3Dvmlinux.a .vmlinux.export.o
+ objs=3Dvmlinux.a .vmlinux.export.o init/version-timestamp.o
+ [ arm64 =3D um ]
+ wl=3D
+ ld=3Dld.lld
+ ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X -=
shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-843=
419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derror
+ ldlibs=3D
+ ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X -=
shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-843=
419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derror=
 --script=3D./arch/arm64/kernel/vmlinux.lds
+ [ -n 1 ]
+ ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X -=
shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-843=
419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derror=
 --script=3D./arch/arm64/kernel/vmlinux.lds --strip-debug
+ is_enabled CONFIG_VMLINUX_MAP
+ grep -q ^CONFIG_VMLINUX_MAP=3Dy include/config/auto.conf
+ ldflags=3D-EL  -maarch64elf -z norelro -z noexecstack --no-undefined -X -=
shared -Bsymbolic -z notext  --no-apply-dynamic-relocs --fix-cortex-a53-843=
419 --build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derror=
 --script=3D./arch/arm64/kernel/vmlinux.lds --strip-debug -Map=3D.tmp_vmlin=
ux1.map
+ ld.lld -EL -maarch64elf -z norelro -z noexecstack --no-undefined -X -shar=
ed -Bsymbolic -z notext --no-apply-dynamic-relocs --fix-cortex-a53-843419 -=
-build-id=3Dsha1 -X --pack-dyn-relocs=3Drelr --orphan-handling=3Derror --sc=
ript=3D./arch/arm64/kernel/vmlinux.lds --strip-debug -Map=3D.tmp_vmlinux1.m=
ap -o .tmp_vmlinux1 --whole-archive vmlinux.a .vmlinux.export.o init/versio=
n-timestamp.o --no-whole-archive --start-group ./drivers/firmware/efi/libst=
ub/lib.a --end-group .tmp_vmlinux0.kallsyms.o
ld.lld: error: vmlinux.a(arch/arm64/crypto/poly1305-core.o):(function poly1=
305_blocks_neon: .text+0x3d4): relocation R_AARCH64_ADR_PREL_LO21 out of ra=
nge: 269166444 is not in [-1048576, 1048575]
make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
make[1]: *** [/home/dagomez/src/linux-next/Makefile:1156: vmlinux] Error 2
make: *** [Makefile:224: __sub-make] Error 2

Any suggestion how to fix this?

Daniel

>  .align	2
>  #if !defined(__KERNEL__) && !defined(_WIN64)
>  .comm	OPENSSL_armcap_P,4,4
> --=20
> 2.34.1
> =
