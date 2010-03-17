From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 17 Mar 2010 15:12:49 +0200
Message-ID: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
was not ported to new crypto APIs and removed from the source tree.

This driver implements async and sync crypto API.

It still contains pr_debug() for debugging purpose.
Will be remove for integration.

Dmitry Kasatkin (2):
  sec: omap sha1 & md5 driver
  sec: Makefile/Kconfig update for omap sha1 md5 driver

 drivers/crypto/Kconfig         |    9 +
 drivers/crypto/Makefile        |    2 +
 drivers/crypto/omap-sha1-md5.c | 1449 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1460 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/omap-sha1-md5.c

