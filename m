From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH v2 0/8] crypto: caam - add support for LS1043A SoC
Date: Mon, 16 May 2016 15:49:27 +0000
Message-ID: <AM2PR04MB067320109DD38D223BEB6C4598770@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rob Herring <robh+dt@kernel.org>,
	Olof Johansson <olof@lixom.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0100.outbound.protection.outlook.com ([157.56.112.100]:36480
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753892AbcEPPtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 11:49:32 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/5/2016 6:34 PM, Horia Geant=E3 wrote:
> v2:
> As suggested by Arnd, patch 1 fixes io{read,write}{16,32}be accessors
> to prevent the case when {read,write}{w,l} are overriden by arch-spec=
ific
> ones having barriers, while the BE accessors previously mentioned are=
 not
> (thus behaving differently, having no barriers).
>=20
> Hi,
>=20
> [Patches 2-4 add io{read,write}64[be] accessors (generic, arm64, ppc6=
4),
> such that CAAM's accessors in regs.h are simplified a bit.
> Patch 8 adds crypto node for LS1043A platform.
> Let me know if it's ok to go with these through the cryptodev-2.6 tre=
e.]
>=20
Herbert,

Could you apply the patch set, but without patch 8/8 I guess - since DT
maintainers haven't ack-ed it?

I assume it's too late for 4.7, however applying the patches would solv=
e
dependencies b/w on-going caam development.

Thanks,
Horia


> This is a follow-up on the following RFC patch set:
> crypto: caam - Revamp I/O accessors
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg15878.ht=
ml
>=20
> There are platforms such as LS1043A (or LS1012A) where core endiannes=
s
> does not match CAAM/SEC endianness (LE vs. BE).
> Add support in caam driver for these cases.
>=20
> Current patch set detects device endianness at runtime (as opposed to
> compile-time endianness), in order to support multiplatform kernels.
> Detection of device endianness is not device-tree based.
> Instead, SSTA ("SEC STAtus") register has a property such that
> reading it in any endianness and masking it properly, it's possible
> to deduce device endianness.
>=20
> The performance drop due to the runtime detection is < 1.0%.
> (An alternative implementation using function pointers has been tried=
,
> but lead to a bigger performance drop.)
>=20
> Thanks,
> Horia
>=20
> Cristian Stoica (1):
>   crypto: caam - fix offset field in hw sg entries
>=20
> Horia Geant=E3 (7):
>   asm-generic/io.h: allow barriers in io{read,write}{16,32}be
>   asm-generic/io.h: add io{read,write}64 accessors
>   arm64: add io{read,write}64be accessors
>   powerpc: add io{read,write}64 accessors
>   crypto: caam - handle core endianness !=3D caam endianness
>   crypto: caam - add ARCH_LAYERSCAPE to supported architectures
>   arm64: dts: ls1043a: add crypto node
>=20
>  arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts |   4 +
>  arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi    |  43 ++++++
>  arch/arm64/include/asm/io.h                       |   4 +-
>  arch/powerpc/kernel/iomap.c                       |  24 ++++
>  drivers/crypto/caam/Kconfig                       |   6 +-
>  drivers/crypto/caam/caamhash.c                    |   5 +-
>  drivers/crypto/caam/ctrl.c                        | 125 +++++++++++-=
------
>  drivers/crypto/caam/desc.h                        |   9 +-
>  drivers/crypto/caam/desc_constr.h                 |  44 ++++---
>  drivers/crypto/caam/jr.c                          |  22 ++--
>  drivers/crypto/caam/pdb.h                         | 137 ++++++++++++=
+++-----
>  drivers/crypto/caam/regs.h                        | 151 ++++++++++++=
+++-------
>  drivers/crypto/caam/sg_sw_sec4.h                  |  17 +--
>  include/asm-generic/io.h                          |  71 +++++++++-
>  include/asm-generic/iomap.h                       |   8 ++
>  15 files changed, 494 insertions(+), 176 deletions(-)
>=20
