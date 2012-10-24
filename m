From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v2 0/7] crypto: omap-sham updates
Date: Tue, 23 Oct 2012 19:36:00 -0700
Message-ID: <1351046167-4882-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Changes since v1:
	- Removed the check of CM_IDLEST to see if the module exists
	  and instead add the hwmod data for all omap2's and omap3 GP's.
	- Placed new sha_ick clk entries after the 'omap-sham' entry
	  in the clockxxx_data.c files
	- Removed cpu_is_xxx() checks in
	  arch/arm/mach-omap2/devices.c:omap_init_sham()
	- Rebased on the latest k.o. kernel


This series updates the crypto omap-sham driver and supporting
infrastructure.

Notes:

a) Based on current k.o. 2d1f4c8 (Merge branch 'drm-fixes' of
	git://people.freedesktop.org/~airlied/linux)

b) Since these patches will likely go though the OMAP tree (and not
   through the crypto tree), it would be nice if the crypto guy(s)
   would ACK or NACK patches 5-7 which modify the
   drivers/crypto/omap-sham.c driver.

c) These have only been tested on an omap2420 h4 and an am37x evm.  If you
   have different hardware available and a few minutes, please test them.
   A quick and easy test is to enable tcrypt as a module
   (CONFIG_CRYPTO_TEST=m), boot, then run 'modprobe tcrypt sec=2 mode=403'.
   'CONFIG_CRYPTO_SHA1' and 'CONFIG_CRYPTO_DEV_OMAP_SHAM' also have to be
   enabled.  A quick 'grep omap-sham /proc/interrupts' will tell you if
   the omap-sham driver was really used.

d) To test these patches, you will likely need...
   i) The patch included here:
	   http://marc.info/?l=kernel-janitors&m=134910841909057&w=2
   ii) This patch from linux-omap/master:
	   27615a9 (ARM: OMAP: Trivial driver changes to remove include
			   plat/cpu.h)
   iii) This patch from Paul Walmsley:
	   http://www.spinics.net/lists/linux-omap/msg79436.html

e) If you prefer, a version you can test is available at
   git@github.com:mgreeraz/linux-mag.git mag/wip/crypto/test

f) There is a reduction in DMA performance after switching to dmaengine
   (see http://www.spinics.net/lists/linux-omap/msg79855.html)

g) Many thanks to Jon Hunter for testing on his omap2420 h4.

Mark A. Greer (7):
  ARM: OMAP2xxx: hwmod: Convert SHAM crypto device data to hwmod
  ARM: OMAP2xxx: hwmod: Add DMA information for SHAM module
  ARM: OMAP3xxx: hwmod: Convert SHAM crypto device data to hwmod
  ARM: OMAP2+: Remove unnecessary message when no SHA IP is present
  crypto: omap-sham: Convert to use pm_runtime API
  crypto: omap-sham: Add code to use dmaengine API
  crypto: omap_sham: Remove usage of private DMA API

 arch/arm/mach-omap2/clock2420_data.c               |   1 +
 arch/arm/mach-omap2/clock2430_data.c               |   1 +
 arch/arm/mach-omap2/clock3xxx_data.c               |   1 +
 arch/arm/mach-omap2/devices.c                      |  81 +++------
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   1 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   1 +
 .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c |  18 ++
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  43 +++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  60 +++++++
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |   2 +
 drivers/crypto/omap-sham.c                         | 192 +++++++++++----------
 11 files changed, 250 insertions(+), 151 deletions(-)

-- 
1.7.12


