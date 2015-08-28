From: Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 0/3] crypto: Fix module autoload for OF platform drivers
Date: Fri, 28 Aug 2015 18:42:45 +0200
Message-ID: <20150828164245.GA5023@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37782 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbH1Qms (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 12:42:48 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series add the missing MODULE_DEVICE_TABLE() for OF to eport
that information so modules have the correct aliases built-in
and autoloading works correctly.

A longer explanation by Javier Canillas can be found here:
https://lkml.org/lkml/2015/7/30/519

Thanks,
Luis

Luis de Bethencourt (3):
  crypto: amcc: Fix module autoload for OF platform driver
  crypto: picoxcell: Fix module autoload for OF platform driver
  crypto: ux500: Fix module autoload for OF platform drivers

 drivers/crypto/amcc/crypto4xx_core.c  | 1 +
 drivers/crypto/picoxcell_crypto.c     | 1 +
 drivers/crypto/ux500/cryp/cryp_core.c | 1 +
 drivers/crypto/ux500/hash/hash_core.c | 1 +
 4 files changed, 4 insertions(+)

-- 
2.4.6
