From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v4 0/4] crypto: sahara - SHA support
Date: Mon,  1 Dec 2014 13:26:30 +0100
Message-ID: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37786 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbaLAM0s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 07:26:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

This series adds support for
	- i.MX53 support
	- SHA1/256
to the SAHARA driver.

- Version 4 is a major overhaul of the previous versions.
  The tasklet/watchdog implementation of the driver is replaced by a kthread
  and completions. This makes sure, that only one request is queued into
  the device and makes sure that the requests from user-space processes are
  correctly enqueued into the queue. This means, that the queue is responsible
  for sequentializing accesses from userspace.

- The request is now saved into the sahara_sha_reqctx

Regards,
Steffen

Steffen Trumtrar (4):
  crypto: sahara - fix spinlock initialization
  crypto: sahara - add support for i.MX53
  crypto: sahara - replace tasklets with kthread
  crypto: sahara - add support for SHA1/256

 .../devicetree/bindings/crypto/fsl-imx-sahara.txt  |   2 +-
 drivers/crypto/sahara.c                            | 794 ++++++++++++++++++---
 2 files changed, 704 insertions(+), 92 deletions(-)

-- 
2.1.3
