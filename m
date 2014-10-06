From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v2 0/2] crypto: sahara - SHA1/256 support
Date: Mon,  6 Oct 2014 16:43:43 +0200
Message-ID: <1412606625-828-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50237 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaJFOoS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2014 10:44:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

This series adds support for the SAHARA crypto module on i.MX53 in 1/2
and than adds support for SHA1/256 in 2/2.

Changes since last version:
	- save the hash state in the sahara request struct
	- fixed the hash remainder calculation

Regards,
Steffen

Steffen Trumtrar (2):
  crypto: sahara - add support for i.MX53
  crypto: sahara - add support for SHA1/256

 .../devicetree/bindings/crypto/fsl-imx-sahara.txt  |   2 +-
 drivers/crypto/sahara.c                            | 706 ++++++++++++++++++++-
 2 files changed, 684 insertions(+), 24 deletions(-)

-- 
2.1.0
