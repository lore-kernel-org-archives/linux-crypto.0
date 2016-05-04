From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 0/7] crypto: caam - add support for LS1043A SoC
Date: Wed, 4 May 2016 20:16:02 +0300
Message-ID: <1462382162-11839-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
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
Received: from mail-bl2on0096.outbound.protection.outlook.com ([65.55.169.96]:36245
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753548AbcEDRa5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 13:30:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

[Patches 1-3 add io{read,write}64[be] accessors (generic, arm64, ppc64)=
,
such that CAAM's accessors in regs.h are simplified a bit.
Patch 7 adds crypto node for LS1043A platform.
Let me know if it's ok to go with these through the cryptodev-2.6 tree.=
]

This is a follow-up on the following RFC patch set:
crypto: caam - Revamp I/O accessors
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg15878.html

There are platforms such as LS1043A (or LS1012A) where core endianness
does not match CAAM/SEC endianness (LE vs. BE).
Add support in caam driver for these cases.

Current patch set detects device endianness at runtime (as opposed to
compile-time endianness), in order to support multiplatform kernels.
Detection of device endianness is not device-tree based.
Instead, SSTA ("SEC STAtus") register has a property such that
reading it in any endianness and masking it properly, it's possible
to deduce device endianness.

The performance drop due to the runtime detection is < 1.0%.
(An alternative implementation using function pointers has been tried,
but lead to a bigger performance drop.)

Thanks,
Horia

Cristian Stoica (1):
  crypto: caam - fix offset field in hw sg entries

Horia Geant=C4=83 (6):
  asm-generic/io.h: add io{read,write}64 accessors
  arm64: add io{read,write}64be accessors
  powerpc: add io{read,write}64 accessors
  crypto: caam - handle core endianness !=3D caam endianness
  crypto: caam - add ARCH_LAYERSCAPE to supported architectures
  arm64: dts: ls1043a: add crypto node

 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts |   4 +
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi    |  43 ++++++
 arch/arm64/include/asm/io.h                       |   4 +-
 arch/powerpc/kernel/iomap.c                       |  24 ++++
 drivers/crypto/caam/Kconfig                       |   6 +-
 drivers/crypto/caam/caamhash.c                    |   5 +-
 drivers/crypto/caam/ctrl.c                        | 125 +++++++++++---=
----
 drivers/crypto/caam/desc.h                        |   9 +-
 drivers/crypto/caam/desc_constr.h                 |  44 ++++---
 drivers/crypto/caam/jr.c                          |  22 ++--
 drivers/crypto/caam/pdb.h                         | 137 ++++++++++++++=
+-----
 drivers/crypto/caam/regs.h                        | 151 ++++++++++++++=
+-------
 drivers/crypto/caam/sg_sw_sec4.h                  |  17 +--
 include/asm-generic/io.h                          |  63 +++++++++
 include/asm-generic/iomap.h                       |   8 ++
 15 files changed, 490 insertions(+), 172 deletions(-)

--=20
2.4.4
