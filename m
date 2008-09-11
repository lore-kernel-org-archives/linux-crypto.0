From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2.6.27] crypto: talitos - avoid consecutive packets going
 out with same IV
Date: Thu, 11 Sep 2008 11:27:18 -0500
Message-ID: <20080911112718.1ba65892.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, Lee.Nipper@freescale.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:39114 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYIKQ2A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Sep 2008 12:28:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

the SEC's h/w IV out implementation DMAs the trailing encrypted payload
block of the last encryption to ctx->iv.  Since the last encryption may
still be pending completion, we can sufficiently prevent successive
packets from being transmitted with the same IV by xoring with sequence
number.

also initialize alg_list earlier to prevent oopsing on a failed probe.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
---
 drivers/crypto/talitos.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index ee827a7..b6ad3ac 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1157,6 +1157,8 @@ static int aead_authenc_givencrypt(
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
 	memcpy(req->giv, ctx->iv, crypto_aead_ivsize(authenc));
+	/* avoid consecutive packets going out with same IV */
+	*(__be64 *)req->giv ^= cpu_to_be64(req->seq);
 
 	return ipsec_esp(edesc, areq, req->giv, req->seq,
 			 ipsec_esp_encrypt_done);
@@ -1449,6 +1451,8 @@ static int talitos_probe(struct of_device *ofdev,
 
 	priv->ofdev = ofdev;
 
+	INIT_LIST_HEAD(&priv->alg_list);
+
 	tasklet_init(&priv->done_task, talitos_done, (unsigned long)dev);
 	tasklet_init(&priv->error_task, talitos_error, (unsigned long)dev);
 
@@ -1575,8 +1579,6 @@ static int talitos_probe(struct of_device *ofdev,
 	}
 
 	/* register crypto algorithms the device supports */
-	INIT_LIST_HEAD(&priv->alg_list);
