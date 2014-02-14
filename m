From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 0/2] Introduce omap-des driver for OMAP SoCs
Date: Fri, 14 Feb 2014 10:48:41 -0600
Message-ID: <1392396521-24326-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Linux OMAP List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Joel Fernandes <joelf@ti.com>
To: <herbert@gondor.apana.org.au>, <rnayak@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Here are revised patches for omap-des driver addressing review comments at:
https://lkml.org/lkml/2013/8/30/116

Joel Fernandes (2):
  crypto: omap-des: Add omap-des driver for OMAP4/AM43xx
  crypto: omap-des: Add config and build options

 drivers/crypto/Kconfig    |   11 +
 drivers/crypto/Makefile   |    1 +
 drivers/crypto/omap-des.c | 1218 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1230 insertions(+)
 create mode 100644 drivers/crypto/omap-des.c

-- 
1.7.9.5
