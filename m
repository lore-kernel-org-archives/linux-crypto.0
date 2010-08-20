From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 0/2] omap-aes: OMAP2/3 AES HW accelerator driver
Date: Fri, 20 Aug 2010 16:44:45 +0300
Message-ID: <cover.1282311763.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32855 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0HTNpY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Aug 2010 09:45:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This set of patches provides implementation of the driver for
OMAP2/3 AES hw accelerator.

Dmitry Kasatkin (2):
  crypto: updates to enable omap aes
  crypto: omap-aes: OMAP2/3 AES hw accelerator driver

 arch/arm/mach-omap2/clock2420_data.c |    2 +-
 arch/arm/mach-omap2/clock2430_data.c |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c |    2 +-
 arch/arm/mach-omap2/devices.c        |   71 +++
 drivers/crypto/Kconfig               |    8 +
 drivers/crypto/Makefile              |    1 +
 drivers/crypto/omap-aes.c            |  948 ++++++++++++++++++++++++++++++++++
 7 files changed, 1031 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/omap-aes.c
