From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [PATCH 00/11] Further iMX CAAM updates
Date: Mon, 8 Aug 2016 18:04:01 +0100
Message-ID: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57464 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbcHHREQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:04:16 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a re-post (with hopefully bugs fixed from December's review).
Untested, because AF_ALG appears to be broken in 4.8-rc1.  Maybe
someone can provide some hints how to test using tcrypt please?

Here are further imx-caam updates that I've had since before the
previous merge window.  Please review and (I guess) if Freescale
folk can provide acks etc that would be nice.  Thanks.

 drivers/crypto/caam/caamhash.c | 540 ++++++++++++++++++++++-------------------
 drivers/crypto/caam/intern.h   |   1 -
 drivers/crypto/caam/jr.c       |  25 +-
 3 files changed, 305 insertions(+), 261 deletions(-)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
