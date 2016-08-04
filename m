From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 0/2] crypto: caam - authenc fixes
Date: Thu, 4 Aug 2016 20:02:45 +0300
Message-ID: <1470330167-31534-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0066.outbound.protection.outlook.com ([104.47.33.66]:22719
	"EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758721AbcHDRTJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 13:19:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The first patch fixes a few typos in the encrypt shared descriptor
used by echainiv(authenc) algorithms.

Second patch fixes the case when .setkey is called before .setauthsize,
avoiding creating authenc descriptors with zero authsize.

Both patches are also being sent to -stable for v4.3+ kernels.

Thanks,
Horia

Horia Geantă (2):
  crypto: caam - fix echainiv(authenc) encrypt shared descriptor
  crypto: caam - defer aead_set_sh_desc in case of zero authsize

 drivers/crypto/caam/caamalg.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.4.4
