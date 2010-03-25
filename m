From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv2 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Thu, 25 Mar 2010 16:00:21 +0200
Message-ID: <cover.1269524804.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: tony@atomide.com, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:42288 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0CYOHH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Mar 2010 10:07:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
was not ported to new crypto APIs and removed from the source tree.

This driver implements async and sync crypto API.

Changes to v1 patches
- device registration moved to platform code
- multi device instances supported
- omap-sha1-md5 name changed to omap-sham match omap spec
- standard clock name "ick" in use
- style fixes

Dmitry Kasatkin (2):
  crypto: updates omap sham device related platform code
  crypto: omap-sham - omap sha1 & md5 driver

 arch/arm/mach-omap2/clock2420_data.c       |    2 +-
 arch/arm/mach-omap2/clock2430_data.c       |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c       |    2 +-
 arch/arm/mach-omap2/devices.c              |   26 +-
 arch/arm/plat-omap/include/plat/omap34xx.h |    5 +
 drivers/crypto/Kconfig                     |    9 +
 drivers/crypto/Makefile                    |    2 +
 drivers/crypto/omap-sham.c                 | 1358 ++++++++++++++++++++++++++++
 8 files changed, 1401 insertions(+), 5 deletions(-)
 create mode 100644 drivers/crypto/omap-sham.c

