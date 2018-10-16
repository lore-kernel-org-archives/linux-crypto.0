Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:36414 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbeJPV0K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 17:26:10 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Ofir Drang <Ofir.Drang@arm.com>, Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] crypto: ccree: add CryptoCell 713 baseline support
Date: Tue, 16 Oct 2018 14:35:30 +0100
Message-Id: <1539696935-4433-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add first batch of patches for support of Arm TrustZone CryptoCell 713.

Gilad Ben-Yossef (3):
  crypto: ccree: add support for CryptoCell 713
  crypto: ccree: add dt bindings for ccree 713
  crypto: ccree: add SM4 support

 .../devicetree/bindings/crypto/arm-cryptocell.txt  |  5 +-
 drivers/crypto/Kconfig                             |  3 +-
 drivers/crypto/ccree/cc_cipher.c                   | 66 ++++++++++++++++++++++
 drivers/crypto/ccree/cc_driver.c                   | 23 +++++---
 drivers/crypto/ccree/cc_driver.h                   |  5 +-
 drivers/crypto/ccree/cc_hw_queue_defs.h            |  3 +
 6 files changed, 92 insertions(+), 13 deletions(-)

-- 
2.7.4
