From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 05/18] crypto: talitos - fix use of sg_link_tbl_len
Date: Fri,  6 Oct 2017 15:04:41 +0200 (CEST)
Message-ID: <40cffda4ea4e6ca69cd9df95f4d049dfe7d514d1.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:53323 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752418AbdJFNEn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 09:04:43 -0400
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sg_link_tbl_len shall be used instead of cryptlen, otherwise
SECs which perform HW CICV verification will fail.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b7184f305867..cf5c9701b898 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1232,8 +1232,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			sg_link_tbl_len += authsize;
 	}
 
-	ret = talitos_sg_map(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
-			     sg_count, areq->assoclen, tbl_off);
+	ret = talitos_sg_map(dev, areq->src, sg_link_tbl_len, edesc,
+			     &desc->ptr[4], sg_count, areq->assoclen, tbl_off);
 
 	if (ret > 1) {
 		tbl_off += ret;
-- 
2.13.3
