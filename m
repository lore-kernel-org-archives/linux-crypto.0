Return-Path: <SRS0=phSf=Q6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD571C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 13:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A6CA20665
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 13:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfBWN6w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Feb 2019 08:58:52 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17561 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727987AbfBWN6v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Feb 2019 08:58:51 -0500
X-IronPort-AV: E=Sophos;i="5.58,403,1544482800"; 
   d="scan'208";a="370609507"
Received: from palace.lip6.fr ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES128-SHA256; 23 Feb 2019 14:58:44 +0100
From:   Julia Lawall <Julia.Lawall@lip6.fr>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] crypto: add missing of_node_put after of_device_is_available
Date:   Sat, 23 Feb 2019 14:20:39 +0100
Message-Id: <1550928043-14889-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550928043-14889-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1550928043-14889-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add an of_node_put when a tested device node is not available.

The semantic patch that fixes this problem is as follows
(http://coccinelle.lip6.fr):

// <smpl>
@@
identifier f;
local idexpression e;
expression x;
@@

e = f(...);
... when != of_node_put(e)
    when != x = e
    when != e = x
    when any
if (<+...of_device_is_available(e)...+>) {
  ... when != of_node_put(e)
(
  return e;
|
+ of_node_put(e);
  return ...;
)
}
// </smpl>

Fixes: 5343e674f32fb ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/crypto/amcc/crypto4xx_trng.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -u -p a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -80,8 +80,10 @@ void ppc4xx_trng_probe(struct crypto4xx_
 
 	/* Find the TRNG device node and map it */
 	trng = of_find_matching_node(NULL, ppc4xx_trng_match);
-	if (!trng || !of_device_is_available(trng))
+	if (!trng || !of_device_is_available(trng)) {
+		of_node_put(trng);
 		return;
+	}
 
 	dev->trng_base = of_iomap(trng, 0);
 	of_node_put(trng);

