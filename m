From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCHv2 00/10] add 842 hw compression for PowerNV platform
Date: Wed,  6 May 2015 12:50:56 -0400
Message-ID: <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33058 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbEFQwd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 12:52:33 -0400
In-Reply-To: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IBM PowerPC processors starting at version P7+ contain a NX coprocessor
that provides various hw-accelerated functions, one of which is memory
compression to the IBM "842" compression format.  This NX-842 coprocessor
is already supported on the pSeries platform, by the nx-842.c driver and
the crypto compression interface at crypto/842.c.  This patch set adds
support for NX-842 on the PowerNV (Non-Virtualized) platform, as well as
adding a full software 842 compression/decompression implementation.

Quick summary of changes: the current 842 crypto compression interface uses
only the 842 hardware on pSeries platforms, and can handle only page-sized
and page-aligned uncompressed buffers.  These patches add a full software
842 impementation, change the crypto/ directory 842 interface to a
software only implementation, add a 842 hardware crypto compression
interface that can handle any size and alignment buffers, add a
driver for 842 hardware on PowerNV platforms, and create a common
interface for both 842 hardware platform drivers.

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
more common location.

The existing crypto/842.c interface is in the wrong place, since crypto/
should only contain software implementations; so lib/842/ is added
containing a reference (i.e. rather slow) implementation in software
of both 842 compression and 842 decompression.  The crypto/842.c interface
is changed to use only that software implementation.

The hardware 842 crypto compression interface is moved to
drivers/crypto/nx/nx-842-crypto.c.  It is also modified to be able to
handle any alignment/length input or output buffer; currently it is only
able to handle page-size and page-aligned (uncompressed) buffers, due to
restrictions in the pSeries 842 hardware driver.

Note that several of these patches have changed significantly since the
last patch series; I didn't list specific differences since there are
so many.

Dan Streetman (10):
  powerpc: export of_get_ibm_chip_id function
  powerpc: Add ICSWX instruction
  lib: add software 842 compression/decompression
  crypto: change 842 alg to use software
  drivers/crypto/nx: rename nx-842.c to nx-842-pseries.c
  drivers/crypto/nx: add NX-842 platform frontend driver
  drivers/crypto/nx: add nx842 constraints
  drivers/crypto/nx: add PowerNV platform NX-842 driver
  drivers/crypto/nx: simplify pSeries nx842 driver
  drivers/crypto/nx: add hardware 842 crypto comp alg

 MAINTAINERS                           |    5 +-
 arch/powerpc/include/asm/icswx.h      |  184 ++++
 arch/powerpc/include/asm/ppc-opcode.h |   13 +
 arch/powerpc/kernel/prom.c            |    1 +
 crypto/842.c                          |  175 +---
 crypto/Kconfig                        |    7 +-
 drivers/crypto/Kconfig                |   10 +-
 drivers/crypto/nx/Kconfig             |   55 +-
 drivers/crypto/nx/Makefile            |    6 +
 drivers/crypto/nx/nx-842-crypto.c     |  603 ++++++++++++
 drivers/crypto/nx/nx-842-powernv.c    |  625 +++++++++++++
 drivers/crypto/nx/nx-842-pseries.c    | 1128 +++++++++++++++++++++++
 drivers/crypto/nx/nx-842.c            | 1623 +++------------------------------
 drivers/crypto/nx/nx-842.h            |  131 +++
 include/linux/nx842.h                 |   21 +-
 include/linux/sw842.h                 |   12 +
 lib/842/842.h                         |  127 +++
 lib/842/842_compress.c                |  626 +++++++++++++
 lib/842/842_debugfs.h                 |   52 ++
 lib/842/842_decompress.c              |  405 ++++++++
 lib/842/Makefile                      |    2 +
 lib/Kconfig                           |    6 +
 lib/Makefile                          |    2 +
 23 files changed, 4138 insertions(+), 1681 deletions(-)
 create mode 100644 arch/powerpc/include/asm/icswx.h
 create mode 100644 drivers/crypto/nx/nx-842-crypto.c
 create mode 100644 drivers/crypto/nx/nx-842-powernv.c
 create mode 100644 drivers/crypto/nx/nx-842-pseries.c
 create mode 100644 drivers/crypto/nx/nx-842.h
 create mode 100644 include/linux/sw842.h
 create mode 100644 lib/842/842.h
 create mode 100644 lib/842/842_compress.c
 create mode 100644 lib/842/842_debugfs.h
 create mode 100644 lib/842/842_decompress.c
 create mode 100644 lib/842/Makefile

-- 
2.1.0
