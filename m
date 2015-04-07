From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 00/11] add 842 hw compression for PowerNV platform
Date: Tue,  7 Apr 2015 13:34:19 -0400
Message-ID: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38115 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbbDGRfB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 13:35:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IBM PowerPC processors starting at version P7+ contain a NX coprocessor that
provides various hw-accelerated functions, one of which is memory compression
to the IBM "842" compression format.  This NX-842 coprocessor is already
supported on the pSeries platform, by the nx-842.c driver and the crypto
compression interface at crypto/842.c.  This patch set adds support for NX-842
on the PowerNV (Non-Virtualized) platform.

The existing pSeries platform NX-842 driver could not be re-used for the
PowerNV platform driver, as there are fundamentally different interfaces;
on pSeries the system hypervisor (pHyp) provides the interface and manages
communication with the coprocessor, while on PowerNV the kernel talks directly
to the coprocessor using the ICSWX instruction.  The data structures used to
describe each compression or decompression request to the coprocessor are
also different between pHyp's interface and direct communication with ICSWX.
So, different drivers for pSeries and PowerNV are required.  Adding the new
PowerNV driver but keeping the interface to the drivers the same required
adding a new common frontend interface, to which only one of the platform
drivers will connect (based on what platform the kernel is currently running
on), and moving some functionality out of the existing pSeries driver into a
more common location.  Also, the crypto/842.c interface to the NX-842 hw
driver is modified to be able to handle any alignment or length input or
output buffer; currently with the pSeries driver only page-size and
page-aligned (uncompressed) buffers are possible.

The result is a crypto 842 interface that allows using any input and output
buffers (i.e. any alignment and length) to communicate with the NX-842
hardware on either the pSeries or PowerNV platforms, as well as a generic
842 software decompressor that the crypto 842 interface falls back to if the
NX-842 hardware fails and/or returns error during decompression.

Finally, this also adds a generic crypto compression selftest module, that
can verify correct compression/decompression cycles using variable alignment
and length buffers, multiple threads, and can calculate the throughput.

Dan Streetman (11):
  powerpc: export of_get_ibm_chip_id function
  powerpc: Add ICSWX instruction
  crypto: add software 842 decompression
  drivers/crypto/nx: move nx-842.c to nx-842-pseries.c
  drivers/crypto/nx: add NX-842 platform frontend driver
  drivers/crypto/nx: add nx842 constraints
  drivers/crypto/nx: add PowerNV platform NX-842 driver
  drivers/crypto/nx: simplify pSeries nx842 driver
  crypto: remove LZO fallback from crypto 842
  crypto: rewrite crypto 842 to use nx842 constraints
  crypto: add crypto compression sefltest

 MAINTAINERS                           |    5 +-
 arch/powerpc/include/asm/icswx.h      |  184 ++++
 arch/powerpc/include/asm/ppc-opcode.h |   13 +
 arch/powerpc/kernel/prom.c            |    1 +
 crypto/842.c                          |  495 ++++++++--
 crypto/Kconfig                        |   13 +-
 crypto/Makefile                       |    1 +
 crypto/comp_selftest.c                |  928 +++++++++++++++++++
 drivers/crypto/Kconfig                |    6 +-
 drivers/crypto/nx/Kconfig             |   43 +-
 drivers/crypto/nx/Makefile            |    4 +
 drivers/crypto/nx/nx-842-powernv.c    |  623 +++++++++++++
 drivers/crypto/nx/nx-842-pseries.c    | 1126 +++++++++++++++++++++++
 drivers/crypto/nx/nx-842.c            | 1623 +++------------------------------
 drivers/crypto/nx/nx-842.h            |  131 +++
 include/linux/nx842.h                 |   17 +-
 include/linux/sw842.h                 |    7 +
 lib/842/842_decompress.c              |  413 +++++++++
 lib/842/Makefile                      |    1 +
 lib/Kconfig                           |    3 +
 lib/Makefile                          |    1 +
 21 files changed, 4001 insertions(+), 1637 deletions(-)
 create mode 100644 arch/powerpc/include/asm/icswx.h
 create mode 100644 crypto/comp_selftest.c
 create mode 100644 drivers/crypto/nx/nx-842-powernv.c
 create mode 100644 drivers/crypto/nx/nx-842-pseries.c
 create mode 100644 drivers/crypto/nx/nx-842.h
 create mode 100644 include/linux/sw842.h
 create mode 100644 lib/842/842_decompress.c
 create mode 100644 lib/842/Makefile

-- 
2.1.0
