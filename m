From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v2 0/6] Fix CAAM hash driver
Date: Sun, 18 Oct 2015 17:50:47 +0100
Message-ID: <20151018165046.GA7997@n2100.arm.linux.org.uk>
References: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45339 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbbJRQvD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:51:03 -0400
Content-Disposition: inline
In-Reply-To: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
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
This is also fixed in this series, by patch 3.  This bug was introduced
by a prior commit trying to fix a tcrypt error.  However, the change is
wrong, but I have to question whether the test was correct or not - the
backtrace contains a function "test_ahash_pnum" which doesn't seem to
exist in mainline, nor does it seem to exist in any previous mainline
kernel.

Version 2 of this series addresses a mismerge in patch 5 of the
original series, and adds further information to patch 3.

Further testing with tcrypt showed up a problem identified by the
DMA API debugging (different to the original one referred to in
patch 3) where we leak DMA mappings.

 drivers/crypto/caam/caamhash.c | 101 +++++++++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 30 deletions(-)

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
