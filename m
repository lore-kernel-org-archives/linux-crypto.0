Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DE3C6FA82
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Sep 2022 08:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiIMIEB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Sep 2022 04:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiIMIEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2022 04:04:00 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A7A5A824
        for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2022 01:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663056237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DztENJwFYbyexk5Um9Y6JJ1pMp39Kmfign+57qaZVTI=;
        b=TjRKfAwzvVE9Kl0517xBIHsBBkoZmYMFYVLt8HlO01QmDd3G1nxEVojdwdKYqhJIi86UwO
        ZirMNbWoS2paX2caz3Horg/VAOKL0PTmMSHGjXIi913DKpCf/8RwbxdSkStB2nJRhv4q2O
        r6TW5b7+cWqFUESPjikGMZhhNHKkR2kLfdROcp/tj2dm2fjgSZMq5wG+vrN4WlCYiATIe7
        SMNFOwLgvq/tu6xTPUhkduso8aLeMNTKHC/Xlil4w003bZYoTW9OmpmRSDMw5WyKR2bycg
        +zTFdVI7LgSkzGbXoSTAM7y4fdDJHL5fjKtNcHGE0Bk1f78P9zFJCb8QAFoNfQ==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-561-8wSvZUqJOp6_j0iIIqcADA-1; Tue, 13 Sep 2022 04:03:54 -0400
X-MC-Unique: 8wSvZUqJOp6_j0iIIqcADA-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Tue, 13 Sep 2022 01:03:51 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH v3 1/2] crypto: inside_secure - Avoid dma map if size is zero
Date:   Tue, 13 Sep 2022 16:03:47 +0800
Message-ID: <c10f8274fafd4f6afe92d0a2716ec5a38ca02cc8.1663055663.git.pliem@maxlinear.com>
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

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
v3:
 Remove fixes tag
 Add corresponding change for dma_unmap_sg
v2:
 Add fixes tag

 .../crypto/inside-secure/safexcel_cipher.c    | 44 +++++++++++++------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypt=
o/inside-secure/safexcel_cipher.c
index d68ef16650d4..5a222c228c3b 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -642,10 +642,16 @@ static int safexcel_handle_req_result(struct safexcel=
_crypto_priv *priv, int rin
 =09safexcel_complete(priv, ring);
=20
 =09if (src =3D=3D dst) {
-=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
+=09=09if (sreq->nr_src > 0)
+=09=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src,
+=09=09=09=09     DMA_BIDIRECTIONAL);
 =09} else {
-=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
-=09=09dma_unmap_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
+=09=09if (sreq->nr_src > 0)
+=09=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src,
+=09=09=09=09     DMA_TO_DEVICE);
+=09=09if (sreq->nr_dst > 0)
+=09=09=09dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
+=09=09=09=09     DMA_FROM_DEVICE);
 =09}
=20
 =09/*
@@ -737,23 +743,29 @@ static int safexcel_send_req(struct crypto_async_requ=
est *base, int ring,
 =09=09=09=09max(totlen_src, totlen_dst));
 =09=09=09return -EINVAL;
 =09=09}
-=09=09dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
+=09=09if (sreq->nr_src > 0)
+=09=09=09dma_map_sg(priv->dev, src, sreq->nr_src,
+=09=09=09=09   DMA_BIDIRECTIONAL);
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
 =09=09=09=09totlen_dst);
-=09=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src,
-=09=09=09=09     DMA_TO_DEVICE);
-=09=09=09return -EINVAL;
+=09=09=09ret =3D -EINVAL;
+=09=09=09goto unmap;
 =09=09}
-=09=09dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
+
+=09=09if (sreq->nr_dst > 0)
+=09=09=09dma_map_sg(priv->dev, dst, sreq->nr_dst,
+=09=09=09=09   DMA_FROM_DEVICE);
 =09}
=20
 =09memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
@@ -883,12 +895,18 @@ static int safexcel_send_req(struct crypto_async_requ=
est *base, int ring,
 cdesc_rollback:
 =09for (i =3D 0; i < n_cdesc; i++)
 =09=09safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
-
+unmap:
 =09if (src =3D=3D dst) {
-=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
+=09=09if (sreq->nr_src > 0)
+=09=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src,
+=09=09=09=09     DMA_BIDIRECTIONAL);
 =09} else {
-=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
-=09=09dma_unmap_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
+=09=09if (sreq->nr_src > 0)
+=09=09=09dma_unmap_sg(priv->dev, src, sreq->nr_src,
+=09=09=09=09     DMA_TO_DEVICE);
+=09=09if (sreq->nr_dst > 0)
+=09=09=09dma_unmap_sg(priv->dev, dst, sreq->nr_dst,
+=09=09=09=09     DMA_FROM_DEVICE);
 =09}
=20
 =09return ret;
--=20
2.17.1

