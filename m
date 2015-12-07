From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH RFC 00/13] Further iMX CAAM updates
Date: Mon, 7 Dec 2015 19:11:35 +0000
Message-ID: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60499 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbbLGTLs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:11:48 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Here are further imx-caam updates that I've had since before the
previous merge window.  Please review and (I guess) if Freescale
folk can provide acks etc that would be nice.  Thanks.

 drivers/crypto/caam/caamhash.c | 415 +++++++++++++++++++++++------------------
 drivers/crypto/caam/intern.h   |   1 -
 drivers/crypto/caam/jr.c       |  25 +--
 3 files changed, 246 insertions(+), 195 deletions(-)


-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
