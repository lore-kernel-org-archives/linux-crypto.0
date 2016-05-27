From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 0/6] crypto: talitos - implementation of AEAD for SEC1
Date: Fri, 27 May 2016 11:32:32 +0200 (CEST)
Message-ID: <cover.1464330501.git.christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.arm@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This set of patches provides the implementation of AEAD for
talitos SEC1.

Christophe Leroy (6):
  crypto: talitos - using helpers for all talitos_ptr operations
  crypto: talitos - making mapping helpers more generic
  crypto: talitos - Implement AEAD for SEC1 using HMAC_SNOOP_NO_AFEU
  crypto: talitos - sg_to_link_tbl() not used anymore, remove it
  crypto: talitos - implement cra_priority
  crypto: talitos - templates for AEAD using HMAC_SNOOP_NO_AFEU

 drivers/crypto/talitos.c | 657 +++++++++++++++++++++++++++++------------------
 1 file changed, 410 insertions(+), 247 deletions(-)

-- 
2.1.0
