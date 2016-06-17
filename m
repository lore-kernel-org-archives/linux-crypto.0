From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 00/10] Chain crypto requests together at the DMA level
Date: Fri, 17 Jun 2016 13:23:59 +0200
Message-ID: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47959 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753128AbcFQLYd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 07:24:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Cryptographic Engines and Security Accelerators (CESA) supports
the TDMA chained mode support. When this mode is enabled and crypto
requests are chained at the DMA level, multiple crypto requests can be
handled by the hardware engine without requiring any software
intervention. This approach limits the number of interrupts generated
by the engines thus improving its throughput and making the whole system
behave nicely under heavy crypto load.

Benchmarking results with dmcrypt
=================================
		I/O read	I/O write
Before		81.7 MB/s	31.7 MB/s
After		129  MB/s	39.8 MB/s

Improvement	+57.8 %		+25.5 %

Romain Perier (10):
  crypto: marvell: Add a macro constant for the size of the crypto queue
  crypto: marvell: Check engine is not already running when enabling a
    req
  crypto: marvell: Fix wrong type check in dma functions
  crypto: marvell: Copy IV vectors by DMA transfers for acipher requests
  crypto: marvell: Move tdma chain out of mv_cesa_tdma_req and remove it
  crypto: marvell: Add a complete operation for async requests
  crypto: marvell: Move SRAM I/O operations to step functions
  crypto: marvell: Add load balancing between engines
  crypto: marvell: Add support for chaining crypto requests in TDMA mode
  crypto: marvell: Increase the size of the crypto queue

 drivers/crypto/marvell/cesa.c   | 142 +++++++++++++++++++++++++++---------
 drivers/crypto/marvell/cesa.h   | 120 +++++++++++++++++++++---------
 drivers/crypto/marvell/cipher.c | 157 ++++++++++++++++++++++++----------------
 drivers/crypto/marvell/hash.c   | 150 ++++++++++++++++++--------------------
 drivers/crypto/marvell/tdma.c   | 132 +++++++++++++++++++++++++++++++--
 5 files changed, 483 insertions(+), 218 deletions(-)

-- 
2.7.4
