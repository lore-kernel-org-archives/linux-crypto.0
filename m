From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 13:19:19 +0100
Message-ID: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
	swarren@nvidia.com, shawn.guo@linaro.org, gcembed@gmail.com,
	arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org
To: kernel@pengutronix.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52782 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3BUMTd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 07:19:33 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so7146753wgb.8
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2013 04:19:31 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series of patches provide AES-ECB and AES-CBC support
for the SAHARA2 cryptographic accelerator which is inside the i.MX27 SoC.
It is expected that more algorithms will be supported in the future.

For testing, a Visstrim M10 board has been used and the code related
to this platform has been included too.

[PATCH 1/3] i.MX27: Add platform support for SAHARA2.
[PATCH 2/3] crypto: sahara: Add driver for SAHARA2 accelerator.
[PATCH 3/3] Visstrim M10: Add support for SAHARA2 module.
