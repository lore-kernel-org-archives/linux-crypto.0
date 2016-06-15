From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 0/7] Chain crypto requests together at the DMA level
Date: Wed, 15 Jun 2016 21:15:27 +0200
Message-ID: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52748 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbcFOTQf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 15:16:35 -0400
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



Romain Perier (7):
  crypto: marvell: Add a macro constant for the size of the crypto queue
  crypto: marvell: Check engine is not already running when enabling a
    req
  crypto: marvell: Copy IV vectors by DMA transfers for acipher requests
  crypto: marvell: Moving the tdma chain out of mv_cesa_tdma_req
  crypto: marvell: Adding a complete operation for async requests
  crypto: marvell: Adding load balancing between engines
  crypto: marvell: Add support for chaining crypto requests in TDMA mode

 drivers/crypto/marvell/cesa.c   | 142 ++++++++++++++++++++++++++++++----------
 drivers/crypto/marvell/cesa.h   | 103 +++++++++++++++++++++++------
 drivers/crypto/marvell/cipher.c | 141 +++++++++++++++++++++++----------------
 drivers/crypto/marvell/hash.c   | 126 +++++++++++++++++------------------
 drivers/crypto/marvell/tdma.c   | 120 +++++++++++++++++++++++++++++++--
 5 files changed, 452 insertions(+), 180 deletions(-)

-- 
2.7.4
