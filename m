From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 0/2] crypto: driver for Tegra AES hardware
Date: Fri, 18 Nov 2011 11:12:31 +0530
Message-ID: <1321594953-13390-1-git-send-email-vwadekar@nvidia.com>
Cc: linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

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

v7:
---
Changed the memset/memcpy logic for copying of the key. Now memset and
memcpy work on mutually exclusive addresses.

v6:
---
Fixed the subject line in the cover letter and removed the
'Change-Id: xxxx' lines from the commits

v5:
---
Specifically mention the dependancy between "arm: tegra: export tegra_chip_uid"
and "crypto: driver for Tegra AES hardware"

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
