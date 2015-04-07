From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 00/10] crypto: at91: add support for SAMA5D4 and fix related bugs
Date: Tue, 7 Apr 2015 17:45:01 +0800
Message-ID: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32248 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbbDGJqu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 05:46:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The series of patches add crypto driver for SAMA5D4 and 
fix some bugs about Atmel crypto driver:
 - Add new IP version for AES and SHA.
 - The spinlock is not initialized before using.
 - Fix sg list management to avoid crash if there is a zero length sg in list.
 - The max burst size in DMA configuration is out of range.
 - The result of AES periodically goes wrong with performance test in OpenSSH.
 - Fix a hangup issue in driver's internal buffer process.

The patches were made from herbert/crypto-2.6.git repository, and tested on a
SAMA5D4EK board and also did regression tests on SAMA5D3EK.

Leilei Zhao (9):
  crypto: atmel-aes: add new version
  crypto: atmel-sha: add new version
  crypto: atmel-sha: fix sg list management
  crypto: atmel-sha: initialize spinlock in probe
  crypto: atmel-sha: correct the max burst size
  crypto: atmel-tdes: initialize spinlock in probe
  crypto: atmel-aes: initialize spinlock in probe
  crypto: atmel-aes: sync the buf used in DMA or CPU
  crypto: atmel-aes: correct usage of dma_sync_* API

Ludovic Desroches (1):
  crypto: atmel-sha: correct the way data are split

 drivers/crypto/atmel-aes.c  |   24 +++++++++++++++++++-----
 drivers/crypto/atmel-sha.c  |   35 ++++++++++++++++++++++++-----------
 drivers/crypto/atmel-tdes.c |    1 +
 3 files changed, 44 insertions(+), 16 deletions(-)

-- 
1.7.9.5
