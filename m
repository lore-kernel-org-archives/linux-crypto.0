From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v3 0/3] crypto: sahara - SHA1/256 support
Date: Fri, 24 Oct 2014 16:20:55 +0200
Message-ID: <1414160458-6548-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39793 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaJXOVN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:21:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

Changes since v2:
	- added a patch to fix a bug with the spinlock
	- save the context in the request
	- made the code threadsafe

Regards,
Steffen

Steffen Trumtrar (3):
  crypto: sahara - initialize spinlock
  crypto: sahara - add support for i.MX53
  crypto: sahara - add support for SHA1/256

 .../devicetree/bindings/crypto/fsl-imx-sahara.txt  |   2 +-
 drivers/crypto/sahara.c                            | 731 ++++++++++++++++++++-
 2 files changed, 709 insertions(+), 24 deletions(-)

-- 
2.1.1
