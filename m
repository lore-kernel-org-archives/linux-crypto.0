From: Christian Hohnstaedt <chohnstaedt@innominate.com>
Subject: Re: ixp4xx_crypto: Fix possible NULL ptr dereference.
Date: Mon, 11 Jan 2010 11:07:10 +0100
Message-ID: <20100111100710.GB3056@elara.bln.innominate.local>
References: <m34omu3rf7.fsf@intrepid.localdomain>
 <m3eilx3lpm.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:50293 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0AKKHN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2010 05:07:13 -0500
Content-Disposition: inline
In-Reply-To: <m3eilx3lpm.fsf@intrepid.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 10, 2010 at 06:37:25PM +0100, Krzysztof Halasa wrote:
> Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>
>=20
> diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_c=
rypto.c
> index f8f6515..2ae7148 100644
> --- a/drivers/crypto/ixp4xx_crypto.c
> +++ b/drivers/crypto/ixp4xx_crypto.c
> @@ -786,10 +786,8 @@ static struct buffer_desc *chainup_buffers(struc=
t device *dev,
>  		nbytes -=3D len;
>  		ptr =3D page_address(sg_page(sg)) + sg->offset;
>  		next_buf =3D dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
> -		if (!next_buf) {
> -			buf =3D NULL;
> -			break;
> -		}
> +		if (!next_buf)
> +			return NULL;

This leaves buf->next uninitialized, but
free_buf_chain() iterates over buf->next.

We need:

	if (!next_buf) {
		buf->next =3D NULL;
		return NULL;
	}

Or get rid of next_buf and next_buf_phys:

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index b8cc714..c961b0f 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -794,21 +794,15 @@ static struct buffer_desc *chainup_buffers(struct=
 device *dev,
 {
 	for (;nbytes > 0; sg =3D scatterwalk_sg_next(sg)) {
 		unsigned len =3D min(nbytes, sg->length);
-		struct buffer_desc *next_buf;
-		u32 next_buf_phys;
 		void *ptr;
=20
 		nbytes -=3D len;
 		ptr =3D page_address(sg_page(sg)) + sg->offset;
-		next_buf =3D dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
-		if (!next_buf) {
-			buf =3D NULL;
-			break;
-		}
+		buf->next =3D dma_pool_alloc(buffer_pool, flags, &buf->phys_next);
+		if (!buf->next)
+			return NULL;
 		sg_dma_address(sg) =3D dma_map_single(dev, ptr, len, dir);
-		buf->next =3D next_buf;
-		buf->phys_next =3D next_buf_phys;
-		buf =3D next_buf;
+		buf =3D buf->next;
=20
 		buf->phys_addr =3D sg_dma_address(sg);
 		buf->buf_len =3D len;


Christian Hohnstaedt

--=20
Christian Hohnstaedt / Project Manager Hardware and Manufacturing

Innominate Security Technologies AG / protecting industrial networks
tel: +49.30.921028.208 / fax: +49.30.921028.020
Rudower Chaussee 13, D-12489 Berlin / http://www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Volker Bibelhausen
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
