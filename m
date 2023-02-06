Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B61C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 11:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjBFLeV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Feb 2023 06:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjBFLdv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2023 06:33:51 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DBF1E1EB;
        Mon,  6 Feb 2023 03:33:44 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydb-007zgc-0p; Mon, 06 Feb 2023 18:22:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:15 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:15 +0800
Subject: [PATCH 2/17] net: macsec: Add scaffolding to change completion function signature
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Message-Id: <E1pOydb-007zgc-0p@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds temporary scaffolding so that the Crypto API
completion function can take a void * instead of crypto_async_request.
Once affected users have been converted this can be removed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/net/macsec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index bf8ac7a3ded7..b7d9d487ccd2 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -528,9 +528,9 @@ static void count_tx(struct net_device *dev, int ret, int len)
 	}
 }
 
-static void macsec_encrypt_done(struct crypto_async_request *base, int err)
+static void macsec_encrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct net_device *dev = skb->dev;
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct macsec_tx_sa *sa = macsec_skb_cb(skb)->tx_sa;
@@ -835,9 +835,9 @@ static void count_rx(struct net_device *dev, int len)
 	u64_stats_update_end(&stats->syncp);
 }
 
-static void macsec_decrypt_done(struct crypto_async_request *base, int err)
+static void macsec_decrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct net_device *dev = skb->dev;
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct macsec_rx_sa *rx_sa = macsec_skb_cb(skb)->rx_sa;
