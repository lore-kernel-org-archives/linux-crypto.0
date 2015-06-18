From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: caam - Set last bit on src SG list
Date: Thu, 18 Jun 2015 14:25:56 +0800
Message-ID: <E1Z5TGu-0007R7-73@gondolin.me.apana.org.au>
References: <20150618061734.GA28418@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	ruchika.gupta@freescale.com, cristian.stoica@freescale.com,
	NiteshNarayanLal@freescale.com, jinyanjiang@gmail.com,
	Tudor Ambarus <tudor.ambarus@freescale.com>,
	horia.geanta@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55459 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbbFRG2l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:28:41 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z5TJW-0005ci-Va
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2015 16:28:39 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.80)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1Z5TJW-0007Ss-Br
	for linux-crypto@vger.kernel.org; Thu, 18 Jun 2015 14:28:38 +0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The new aead_edesc_alloc left out the bit indicating the last
entry on the source SG list.  This patch fixes it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 789c385..daca933 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2624,7 +2624,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	sec4_sg_index = 0;
 	if (!all_contig) {
-		sg_to_sec4_sg(req->src, src_nents,
+		sg_to_sec4_sg_last(req->src, src_nents,
 			      edesc->sec4_sg + sec4_sg_index, 0);
 		sec4_sg_index += src_nents;
 	}
