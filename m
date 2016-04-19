From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 0/2] crypto: talitos - fix conversion to new AEAD interface
Date: Tue, 19 Apr 2016 20:33:46 +0300
Message-ID: <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, Jonas Eymann <J.Eymann@gmx.net>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0063.outbound.protection.outlook.com ([207.46.100.63]:14686
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933138AbcDSRs0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2016 13:48:26 -0400
In-Reply-To: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jonas Eymann reports a crash and some failures of AED algorithms
with kernel 4.4.6, all easily reproducible with tcrypt.

These have to do with the onversion to the new AEAD interface:
aeb4c132f33d crypto: talitos - Convert to new AEAD interface

Problems occur for 4.3+ kernels, sending patches to -stable.

(*) Proper fix for hash algorithms registration failures
(implementation of import/export functionality) will be added separatel=
y.

Thannks,
Horia

Horia Geant=C4=83 (1):
  crypto: talitos - fix AEAD tcrypt tests

Jonas Eymann (1):
  crypto: talitos - fix crash in talitos_cra_init()

 drivers/crypto/talitos.c | 87 +++++++++++++++++++++++++++++++---------=
--------
 1 file changed, 57 insertions(+), 30 deletions(-)

--=20
2.4.4
