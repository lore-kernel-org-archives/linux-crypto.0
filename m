From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 6/6] crypto: talitos - sparse fix
Date: Wed, 16 Jul 2008 18:22:30 -0500
Message-ID: <20080716182230.0a33d01b.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:39718 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247AbYGPXXP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 19:23:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a81265b..681c15f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -848,7 +848,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 
 	/* adjust (decrease) last one (or two) entry's len to cryptlen */
 	link_tbl_ptr--;
-	while (link_tbl_ptr->len <= (-cryptlen)) {
+	while (be16_to_cpu(link_tbl_ptr->len) <= (-cryptlen)) {
 		/* Empty this entry, and move to previous one */
 		cryptlen += be16_to_cpu(link_tbl_ptr->len);
 		link_tbl_ptr->len = 0;
-- 
1.5.6

