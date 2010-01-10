From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: ixp4xx_crypto: Fix possible NULL ptr dereference.
Date: Sun, 10 Jan 2010 18:37:25 +0100
Message-ID: <m3eilx3lpm.fsf@intrepid.localdomain>
References: <m34omu3rf7.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:38136 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab0AJRh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2010 12:37:28 -0500
In-Reply-To: <m34omu3rf7.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Sun, 10 Jan 2010 16:35:38 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index f8f6515..2ae7148 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -786,10 +786,8 @@ static struct buffer_desc *chainup_buffers(struct =
device *dev,
 		nbytes -=3D len;
 		ptr =3D page_address(sg_page(sg)) + sg->offset;
 		next_buf =3D dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
-		if (!next_buf) {
-			buf =3D NULL;
-			break;
-		}
+		if (!next_buf)
+			return NULL;
 		sg_dma_address(sg) =3D dma_map_single(dev, ptr, len, dir);
 		buf->next =3D next_buf;
 		buf->phys_next =3D next_buf_phys;
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
