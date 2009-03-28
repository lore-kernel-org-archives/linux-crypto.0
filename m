From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 5/5] crypto: talitos - avoid unnecessary decrypt check
Date: Fri, 27 Mar 2009 22:57:54 -0500
Message-ID: <20090327225754.06f8732a.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Lee Nipper <lee.nipper@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:44991 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbZC1Dqb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 23:46:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

the ICV check bit only gets set in decrypt entry points

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 1cc1c41..c70775f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1010,8 +1010,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	} else {
 		sg_link_tbl_len = cryptlen;
 
-		if ((edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV) &&
-			(edesc->desc.hdr & DESC_HDR_MODE0_ENCRYPT) == 0)
+		if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
 			sg_link_tbl_len = cryptlen + authsize;
 
 		sg_count = sg_to_link_tbl(areq->src, sg_count, sg_link_tbl_len,
-- 
1.6.1.3

