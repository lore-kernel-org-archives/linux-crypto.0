From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v3 0/8] crypto: caam - add support for LS1043A SoC
Date: Thu, 19 May 2016 18:06:45 +0300
Message-ID: <1463670405-1059-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawnguo@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Olof Johansson <olof@lixom.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0066.outbound.protection.outlook.com ([157.56.110.66]:8349
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754041AbcESPWy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 11:22:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

v3:
-DT maintainers - please ack patch 8/8 "arm64: dts: ls1043a: add crypto=
 node"
(to go into kernel 4.8 via crypto tree)
-Fixed typo in pdb.h: s/be32/__be32
-Appended Acks (from v2) into commit messages
-Tested that current patch set works on top of RSA support being added =
by
Tudor Ambarus:
[PATCH v6 0/3] crypto: caam - add support for RSA algorithm
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg19085.html

v2:
As suggested by Arnd, patch 1 fixes io{read,write}{16,32}be accessors
to prevent the case when {read,write}{w,l} are overriden by arch-specif=
ic
ones having barriers, while the BE accessors previously mentioned are n=
ot
(thus behaving differently, having no barriers).

Hi,

[Patches 2-4 add io{read,write}64[be] accessors (generic, arm64, ppc64)=
,
such that CAAM's accessors in regs.h are simplified a bit.
Patch 8 adds crypto node for LS1043A platform.
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

Horia Geant=C4=83 (7):
  asm-generic/io.h: allow barriers in io{read,write}{16,32}be
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
 include/asm-generic/io.h                          |  71 +++++++++-
 include/asm-generic/iomap.h                       |   8 ++
 15 files changed, 494 insertions(+), 176 deletions(-)

--=20
2.4.4
