From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 00/10] crypto: omap-aes: Add support for GCM mode
Date: Thu, 2 Jul 2015 10:48:30 +0530
Message-ID: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35613 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbbGBFVr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 01:21:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series does some basic cleanup and adds support for
AES GCM mode for omap aes driver.
Also adds a test case for async aead algos.

Tested on BeagelBoneBlack: http://pastebin.ubuntu.com/11808341/

Lokesh Vutla (10):
  crypto: omap-aes: Add support for lengths not aligned with
    AES_BLOCK_SIZE
  crypto: omap-aes: Fix configuring of AES mode
  crypto: aead: Add aead_request_cast() api
  crypto: omap-aes: Use BIT() macro
  crypto: omap-aes: Add support for GCM mode
  crypto: omap-aes: gcm: Handle inputs properly
  crypto: omap-aes: gcm: Add support for unaligned lengths
  crypto: omap-aes: gmc: Add algo info
  crypto: omap-aes: gcm: Add support for PIO mode
  crypto: tcrypt: Added speed tests for Async AEAD crypto alogrithms

 crypto/tcrypt.c               |  233 +++++++++++++++++++++++++
 crypto/tcrypt.h               |    1 +
 drivers/crypto/Makefile       |    3 +-
 drivers/crypto/omap-aes-gcm.c |  386 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/omap-aes.c     |  322 +++++++++++++---------------------
 drivers/crypto/omap-aes.h     |  206 ++++++++++++++++++++++
 include/linux/crypto.h        |    6 +
 7 files changed, 955 insertions(+), 202 deletions(-)
 create mode 100644 drivers/crypto/omap-aes-gcm.c
 create mode 100644 drivers/crypto/omap-aes.h

-- 
1.7.9.5
