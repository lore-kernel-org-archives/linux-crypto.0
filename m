From: Mathias Krause <mathias.krause@secunet.com>
Subject: [PATCH 0/5] Authenc key parsing consolidation
Date: Tue, 15 Oct 2013 13:49:29 +0200
Message-ID: <cover.1381831574.git.mathias.krause@secunet.com>
Cc: Mathias Krause <mathias.krause@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Jamie Iles <jamie@jamieiles.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:39657 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561Ab3JOLtn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Oct 2013 07:49:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series removes the code duplication of authenc key parsing by
introducing a common helper function crypto_authenc_extractkeys() in
patch 1. Patches 2 to 5 change all remaining places to use the new
helper. Patches 3 and 4 also fix potential memory corruptions by
ensuring the supplied keys won't overflow there respective buffers.

I was unable to test patches 3 to 5 as I don't have the needed hardware
for these devices -- not even a cross compiler for those architectures.

In case patches 3 and 4 are enqueued for stable, patch 1 needs to be as
well, as it's a prerequisite for those.

Please apply!

Mathias Krause (5):
  crypto: authenc - Export key parsing helper function
  crypto: authencesn - Simplify key parsing
  crypto: ixp4xx - Simplify and harden key parsing
  crypto: picoxcell - Simplify and harden key parsing
  crypto: talitos - Simplify key parsing

 crypto/authenc.c                  |   48 +++++++++++++++++++++++--------------
 crypto/authencesn.c               |   26 +++-----------------
 drivers/crypto/ixp4xx_crypto.c    |   26 +++++++-------------
 drivers/crypto/picoxcell_crypto.c |   32 ++++++------------------
 drivers/crypto/talitos.c          |   35 ++++++--------------------
 include/crypto/authenc.h          |   12 ++++++++-
 6 files changed, 70 insertions(+), 109 deletions(-)

-- 
1.7.2.5
