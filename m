From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv4 0/2] omap-sham: OMAP SHA1/MD5 driver
Date: Wed, 28 Apr 2010 17:18:05 +0300
Message-ID: <cover.1272464135.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:46733 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0D1OSa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Apr 2010 10:18:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes to v4:
- concurrent requests support via queue
- hmac
- shash support removed

Dmitry Kasatkin (2):
  crypto: updates omap sham device related platform code
  crypto: omap-sham - omap sha1 & md5 driver

 arch/arm/mach-omap2/clock2420_data.c       |    2 +-
 arch/arm/mach-omap2/clock2430_data.c       |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c       |    2 +-
 arch/arm/mach-omap2/devices.c              |   58 ++-
 arch/arm/plat-omap/include/plat/omap34xx.h |    5 +
 drivers/crypto/Kconfig                     |    9 +
 drivers/crypto/Makefile                    |    2 +
 drivers/crypto/omap-sham.c                 | 1259 ++++++++++++++++++++++++++++
 8 files changed, 1326 insertions(+), 13 deletions(-)
 create mode 100644 drivers/crypto/omap-sham.c

