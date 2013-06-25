From: Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/6] Various ux500 crypto updates
Date: Tue, 25 Jun 2013 10:54:43 +0200
Message-ID: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Fabio Baltieri <fabio.baltieri@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51915 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FYIzH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Jun 2013 04:55:07 -0400
Received: by mail-ea0-f176.google.com with SMTP id z15so6547813ead.21
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2013 01:55:05 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

these are some fixes to issue pointed out by sparse and dmaengine API
udpates on the recently enabled ux500 hw crypto drivers.

These are based on recent linux-next, and can probably be applied on an
architecture specific branch with your ack, or just skip to the next
merge window.

Thanks,
Fabio


Fabio Baltieri (6):
  crypto: ux500/hash: use readl on iomem addresses
  crypto: ux500/hash: add missing static qualifiers
  crypto: ux500/crypt: add missing __iomem qualifiers
  crypto: ux500: use dmaengine_device_control API
  crypto: ux500: use dmaengine_prep_slave_sg API
  crypto: ux500: use dmaengine_submit API

 drivers/crypto/ux500/cryp/cryp.c      |  4 ++--
 drivers/crypto/ux500/cryp/cryp_core.c | 26 +++++++++++++-------------
 drivers/crypto/ux500/hash/hash_core.c | 33 ++++++++++++++++-----------------
 3 files changed, 31 insertions(+), 32 deletions(-)

-- 
1.8.2
