Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B38C636CC
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Feb 2023 21:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjBDVB4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Feb 2023 16:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDVBz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Feb 2023 16:01:55 -0500
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 04 Feb 2023 13:01:54 PST
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98FC01D93E
        for <linux-crypto@vger.kernel.org>; Sat,  4 Feb 2023 13:01:54 -0800 (PST)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id OPY6pZlWT5naBOPY6pVbEa; Sat, 04 Feb 2023 21:54:22 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 04 Feb 2023 21:54:22 +0100
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Gonglei <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH] virtio-crypto: Do not use GFP_ATOMIC when not needed
Date:   Sat,  4 Feb 2023 21:54:08 +0100
Message-Id: <00f487d16bf9fc5ce215c44bed3f11df5adf266a.1675544037.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no need to use GFP_ATOMIC here. GFP_KERNEL is already used for
another memory allocation just the line after.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative ! ! !

Maybe it is the other memory allocation that should use GFP_ATOMIC.

Review with care !
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index b2979be613b8..6963344f6a3a 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -116,7 +116,7 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 	struct virtio_crypto_session_input *input;
 	struct virtio_crypto_ctrl_request *vc_ctrl_req;
 
-	pkey = kmemdup(key, keylen, GFP_ATOMIC);
+	pkey = kmemdup(key, keylen, GFP_KERNEL);
 	if (!pkey)
 		return -ENOMEM;
 
-- 
2.34.1

