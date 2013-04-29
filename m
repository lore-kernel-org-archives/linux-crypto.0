From: "Christoph G. Baumann" <cb@sgoc.de>
Subject: [PATCH 0/2] crypto: added support for fsl-dcp on iMX23,28,50
Date: Mon, 29 Apr 2013 21:58:34 +0200
Message-ID: <1367265516-7814-1-git-send-email-cb@sgoc.de>
Cc: "Christoph G. Baumann" <cb@sgoc.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3D2T6i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Apr 2013 15:58:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Christoph G. Baumann" <cb@sgoc.de>

Following Shawn Guo's (maintainer of the Freescale MXS platform) I
post this patch on linux-crypto:

This patch is based on the original driver by Freescale.
The driver gives access to the DCP crypto core which can accelerate
AES and SHA operations.
It was ported to the current API and sanitized to please checkpatch.pl.

Christoph G. Baumann (2):
  crypto: added support for fsl-dcp on iMX23,28,50
  crypto: added support for fsl-dcp on iMX23,28,50

 arch/arm/boot/dts/imx28.dtsi                 |    2 +-
 drivers/staging/Kconfig                      |    2 +
 drivers/staging/Makefile                     |    1 +
 drivers/staging/crypto/Kconfig               |   15 +
 drivers/staging/crypto/Makefile              |    1 +
 drivers/staging/crypto/fsl-dcp.c             | 1790 ++++++++++++++++++++++++++
 drivers/staging/crypto/fsl-dcp.h             |  739 +++++++++++
 include/linux/fsl/fsl-dcp_bootstream_ioctl.h |   32 +
 8 files changed, 2581 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/crypto/Kconfig
 create mode 100644 drivers/staging/crypto/Makefile
 create mode 100644 drivers/staging/crypto/fsl-dcp.c
 create mode 100644 drivers/staging/crypto/fsl-dcp.h
 create mode 100644 include/linux/fsl/fsl-dcp_bootstream_ioctl.h

-- 
1.7.9.5
