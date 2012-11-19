From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 0/7] crypto: omap-aes updates
Date: Mon, 19 Nov 2012 12:03:45 -0700
Message-ID: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:35733 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab2KSTD5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 14:03:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

This series updates the crypto omap-aes driver and supporting
infrastructure.

Notes:

a) Based on omap-sham patches recently submitted, XXX

b) Since these patches will likely go though the OMAP tree (and not
   through the crypto tree), it would be nice if the crypto guy(s)
   would ACK or NACK patches 4-7 which modify the
   drivers/crypto/omap-sham.c driver.

c) These have only been tested on an omap2420 h4 and an am37x evm.

d) Many thanks to Jon Hunter for testing on his omap2420 h4.

Mark A. Greer (7):
  ARM: OMAP2xxx: hwmod: Convert AES crypto devcie data to hwmod
  ARM: OMAP3xxx: hwmod: Convert AES crypto device data to hwmod
  ARM: OMAP2+: Remove unnecessary message when no AES IP is present
  crypto: omap-aes: Remove cpu_is/omap_type check from driver
  crypto: omap-aes: Convert to use pm_runtime API
  crypto: omap-aes: Add code to use dmaengine API
  crypto: omap-aes: Remove usage of private DMA API

 arch/arm/mach-omap2/clock2430_data.c               |   1 +
 arch/arm/mach-omap2/clock3xxx_data.c               |   1 +
 arch/arm/mach-omap2/devices.c                      |  75 +-------
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   1 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   1 +
 .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c |  18 ++
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  38 ++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  62 +++++++
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |   2 +
 drivers/crypto/omap-aes.c                          | 202 ++++++++++++---------
 10 files changed, 251 insertions(+), 150 deletions(-)

-- 
1.7.12
