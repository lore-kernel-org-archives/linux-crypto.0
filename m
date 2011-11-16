From: Varun Wadekar <vwadekar@nvidia.com>
Subject: [PATCH v6 0/2] crypto: driver for Tegra AES hardware
Date: Wed, 16 Nov 2011 14:24:37 +0530
Message-ID: <1321433679-22036-1-git-send-email-vwadekar@nvidia.com>
Cc: linux-tegra@vger.kernel.org, olof@lixom.net, ccross@android.com,
	Varun Wadekar <vwadekar@nvidia.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4227 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1KPIys (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Nov 2011 03:54:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

v6:
---
Fixed the subject line in the cover letter and removed the
'Change-Id: xxxx' lines from the commits

v5:
---
The tegra crypto driver uses the tegra_chip_uid API for the RNG
calculation. If one wants to build tegra-aes as a module, then
tegra_chip_uid needs to be exported.

I have also posted "arm: tegra: export tegra_chip_uid" to the mach-tegra
maintainers to get this patch into their tree, but for compiling the
"crypto: driver for Tegra AES hardware" patch, "arm: tegra: export tegra_chip_uid"
has to be present.

I leave it to the linux-crypto maintainers to decide how they want to
tackle this situation. In order to facilitate smooth compilation of the
actual crytpo driver patch sending the tegra_chip_uid patch as well.

v4:
---
Mentioned the dependancy on the "arm: tegra: export tegra_chip_uid"
patch

v3:
---
Add the following code from KimP in tegra_aes_handle_req

tfm = crypto_ablkcipher_reqtfm(req);
...
ctx = crypto_ablkcipher_ctx(tfm);
...
dd->ivlen = crypto_ablkcipher_ivsize(tfm); 

v2:
---
Fixed the enable/disable irq related comments from Kim Phillips and some
other cosmetic changes.

v1:
---
Fixed the compilation issues that Henning reported. The driver now
builds as a module. Use devm_* apis. Fixed other comments from StephenW
and KimP.

Henning Heinold (1):
  arm: tegra: export tegra_chip_uid

Varun Wadekar (1):
  crypto: driver for Tegra AES hardware

 arch/arm/mach-tegra/fuse.c |    2 +
 drivers/crypto/Kconfig     |   11 +
 drivers/crypto/Makefile    |    1 +
 drivers/crypto/tegra-aes.c | 1102 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/tegra-aes.h |  103 ++++
 5 files changed, 1219 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/tegra-aes.c
 create mode 100644 drivers/crypto/tegra-aes.h
