Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73DCECAAD3
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 02:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiIFCwA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 22:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiIFCv5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 22:51:57 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BA7647C8
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 19:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1662432716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NM+t79PpSUp/lFULvglYSiTQcuVObzQmfn1c1iAY8wg=;
        b=kclRZgCBhlKIN3/VD2yp9d1XaQYFzsRO4rSGIDRjANXMqTIsJ4IpyIttAN0MQFtkaTs3A/
        T+sc9EhGJNgo/Y7NXt54hfck44LHdK1t2pgYSg2Cs8MXVAvm58LrpYSuZSOuDlHnJOwoEd
        PU4Z44Z8m7jdnmNNCAkMkxH+jCtzfHVTKAXea9JEXHJVeKa3pdUYYqM22JRm94wGwzh3d7
        gMjrKK1ScVJ4s1xrfqHh7cNO6RJn3x4QQPnBh4MgzYhuk/P5Jc0JZrKvoNC02A82Nr7qjU
        JLQ2hFqXEDA/32v6ejyHDZBXSUb+i1e80d58jhM5/ESFEPkbRei+GI5IVZbENA==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-622-hP6gg1kfOxK7O267I44RQg-1; Mon, 05 Sep 2022 22:51:55 -0400
X-MC-Unique: hP6gg1kfOxK7O267I44RQg-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 5 Sep 2022 19:51:53 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH v2 1/2] crypto: inside_secure - Avoid dma map if size is zero
Date:   Tue, 6 Sep 2022 10:51:49 +0800
Message-ID: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From commit d03c54419274 ("dma-mapping: disallow .map_sg
operations from returning zero on error"), dma_map_sg()
produces warning if size is 0. This results in visible
warnings if crypto length is zero.
To avoid that, we avoid calling dma_map_sg if size is zero.

Fixes: d03c54419274 ("dma-mapping: disallow .map_sg operations from returni=
ng zero on error")
Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
v2:
 Add fixes tag

 drivers/crypto/inside-secure/safexcel_cipher.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypt=
o/inside-secure/safexcel_cipher.c
index d68ef16650d4..3775497775e0 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -737,14 +737,17 @@ static int safexcel_send_req(struct crypto_async_requ=
est *base, int ring,
 =09=09=09=09max(totlen_src, totlen_dst));
 =09=09=09return -EINVAL;
 =09=09}
-=09=09dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
+=09=09if (sreq->nr_src > 0)
+=09=09=09dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
 =09} else {
 =09=09if (unlikely(totlen_src && (sreq->nr_src <=3D 0))) {
 =09=09=09dev_err(priv->dev, "Source buffer not large enough (need %d bytes=
)!",
 =09=09=09=09totlen_src);
 =09=09=09return -EINVAL;
 =09=09}
-=09=09dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
+
+=09=09if (sreq->nr_src > 0)
+=09=09=09dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
=20
 =09=09if (unlikely(totlen_dst && (sreq->nr_dst <=3D 0))) {
 =09=09=09dev_err(priv->dev, "Dest buffer not large enough (need %d bytes)!=
",
@@ -753,7 +756,9 @@ static int safexcel_send_req(struct crypto_async_reques=
t *base, int ring,
 =09=09=09=09     DMA_TO_DEVICE);
 =09=09=09return -EINVAL;
 =09=09}
-=09=09dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
+
+=09=09if (sreq->nr_dst > 0)
+=09=09=09dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
 =09}
=20
 =09memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
--=20
2.17.1

