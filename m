From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 0/5] Fix CAAM hash driver
Date: Sat, 17 Oct 2015 19:50:55 +0100
Message-ID: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43422 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbJQSvL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 14:51:11 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series fixes the CAAM hash driver, allowing it to work
with the previously merged "crypto: ahash - ensure statesize is non-
zero" patch.

This is non-trivial, because CAAM exports a huge 1600 bytes of data,
which, if we set .statesize to this, still results in the core code
rejecting the driver.  So, we need to shrink the amount of state
exported.

The first, most obvious one to get rid of is the export of the
caam_hash_ctx structure, which is shared between the socket being
exported from and imported to - copying it away and back again was
a complete no-op.

The second is that we don't need to export both pending-bytes buffers.
Only one will be in use at any time.

A problem was encountered while testing, where the size of the pending
bytes buffer was not added to the scatterlist with the correct length.
This is also fixed in this series, by patch 3.

 drivers/crypto/caam/caamhash.c | 79 +++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 20 deletions(-)

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
