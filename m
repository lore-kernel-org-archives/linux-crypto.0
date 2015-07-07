From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH v2 0/7] crypto: omap-aes: Add support for GCM mode
Date: Tue, 7 Jul 2015 21:01:42 +0530
Message-ID: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series does some basic cleanup and adds support for
AES GCM mode for omap aes driver.

Changes since v1:
- Switched GCM to new AEAD interface

Lokesh Vutla (7):
  crypto: omap-aes: Fix CTR mode
  crypto: omap-aes: Increase priority of hw accelerator
  crypto: omap-aes: Fix configuring of AES mode
  crypto: omap-aes: Use BIT() macro
  crypto: aead: Add aead_request_cast() api
  crypto: omap-aes: Add support for GCM mode
  crypto: tcrypt: Fix AEAD speed tests

 crypto/tcrypt.c                |  65 ++++---
 drivers/crypto/Kconfig         |   1 +
 drivers/crypto/Makefile        |   3 +-
 drivers/crypto/omap-aes-gcm.c  | 376 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/omap-aes.c      | 346 ++++++++++++++++---------------------
 drivers/crypto/omap-aes.h      | 212 +++++++++++++++++++++++
 include/crypto/internal/aead.h |   6 +
 7 files changed, 788 insertions(+), 221 deletions(-)
 create mode 100644 drivers/crypto/omap-aes-gcm.c
 create mode 100644 drivers/crypto/omap-aes.h

-- 
1.9.1
