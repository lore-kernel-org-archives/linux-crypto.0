From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv3 0/2] omap-sham: OMAP SHA1/MD5 driver
Date: Tue, 13 Apr 2010 11:08:15 +0300
Message-ID: <cover.1271145726.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: tony@atomide.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60176 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0DMIJI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 04:09:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes to v2:
- Added multi omap kernel support based on comment
- some redundant vars removed


Dmitry Kasatkin (2):
  crypto: updates omap sham device related platform code
  crypto: omap-sham - omap sha1 & md5 driver

 arch/arm/mach-omap2/clock2420_data.c       |    2 +-
 arch/arm/mach-omap2/clock2430_data.c       |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c       |    2 +-
 arch/arm/mach-omap2/devices.c              |   58 +-
 arch/arm/plat-omap/include/plat/omap34xx.h |    5 +
 drivers/crypto/Kconfig                     |    9 +
 drivers/crypto/Makefile                    |    2 +
 drivers/crypto/omap-sham.c                 | 1347 ++++++++++++++++++++++++++++
 8 files changed, 1414 insertions(+), 13 deletions(-)
 create mode 100644 drivers/crypto/omap-sham.c

