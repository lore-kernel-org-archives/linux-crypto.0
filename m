From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 0/7] crypto: talitos - implementation of AEAD for SEC1
Date: Mon,  6 Jun 2016 13:20:31 +0200 (CEST)
Message-ID: <cover.1464390094.git.christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:48161 "EHLO pegase1.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbcFFNDk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jun 2016 09:03:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This set of patches provides the implementation of AEAD for
talitos SEC1.

Changes in v2:
* Fixed compilation issue introduced by later cosmetic changes
requested by checkpatch script
* split "making mapping helpers more generic" in two parts
to better see the changes done after the move.
* reworked the DMA sync associated with mapping in order to not
spend time syncing several times

Christophe Leroy (7):
  crypto: talitos - using helpers for all talitos_ptr operations
  crypto: talitos - move mapping helpers before IPSEC functions
  crypto: talitos - making mapping helpers more generic
  crypto: talitos - Implement AEAD for SEC1 using HMAC_SNOOP_NO_AFEU
  crypto: talitos - sg_to_link_tbl() not used anymore, remove it
  crypto: talitos - implement cra_priority
  crypto: talitos - templates for AEAD using HMAC_SNOOP_NO_AFEU

 drivers/crypto/talitos.c | 672 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 426 insertions(+), 246 deletions(-)

-- 
2.1.0
