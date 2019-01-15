Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50718 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfAONnd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 08:43:33 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] bug fixes and cleanups
Date: Tue, 15 Jan 2019 15:43:10 +0200
Message-Id: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Assorted bug fixes and cleanups

Gilad Ben-Yossef (3):
  crypto: ccree: unmap buffer before copying IV
  crypto: ccree: shared irq lines are not a bug
  crypto: ccree: don't copy zero size ciphertext

Hadar Gat (4):
  crypto: ccree: improve error handling
  crypto: ccree: add error message
  crypto: ccree: fix free of unallocated mlli buffer
  crypto: ccree: remove legacy leftover

 drivers/crypto/ccree/cc_buffer_mgr.c | 87 ++++++++++++++--------------
 drivers/crypto/ccree/cc_cipher.c     |  6 +-
 drivers/crypto/ccree/cc_driver.c     |  6 +-
 drivers/crypto/ccree/cc_driver.h     |  2 -
 4 files changed, 50 insertions(+), 51 deletions(-)

-- 
2.20.1
