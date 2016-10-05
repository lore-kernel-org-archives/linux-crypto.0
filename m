From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v4 0/2] Improve DMA chaining for ahash requests
Date: Wed,  5 Oct 2016 09:56:31 +0200
Message-ID: <20161005075633.12711-1-romain.perier@free-electrons.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44766 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751980AbcJEH4h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Oct 2016 03:56:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series contain performance improvement regarding ahash requests.
So far, ahash requests were systematically not chained at the DMA level.
However, in some case, like this is the case by using IPSec, some ahash
requests can be processed directly by the engine, and don't have
intermediaire partial update states.

This series firstly re-work the way outer IVs are copied from the SRAM
into the dma pool. To do so, we introduce a common dma pool for all type
of requests that contains outer results (like IV or digest). Then, for
ahash requests that can be processed directly by the engine, outer
results are copied from the SRAM into the common dma pool. These requests
are then allowed to be chained at the DMA level.


Benchmarking results with iperf throught IPSec
==============================================
		ESP			AH

Before		343 Mbits/s		492 Mbits/s
After		422 Mbits/s		577 Mbits/s
Improvement	+23%			+17%

Romain Perier (2):
  crypto: marvell - Use an unique pool to copy results of requests
  crypto: marvell - Don't break chain for computable last ahash requests

 drivers/crypto/marvell/cesa.c   |  4 ---
 drivers/crypto/marvell/cesa.h   |  5 ++--
 drivers/crypto/marvell/cipher.c |  8 +++--
 drivers/crypto/marvell/hash.c   | 65 +++++++++++++++++++++++++++++++----------
 drivers/crypto/marvell/tdma.c   | 28 +++++++++---------
 5 files changed, 70 insertions(+), 40 deletions(-)

-- 
2.9.3
