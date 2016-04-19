From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/2] crypto: talitos - fix AEAD tcrypt tests
Date: Tue, 19 Apr 2016 20:33:48 +0300
Message-ID: <1461087228-19359-3-git-send-email-horia.geanta@nxp.com>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
 <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, Jonas Eymann <J.Eymann@gmx.net>,
	"David S. Miller" <davem@davemloft.net>, <stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

After conversion to new AEAD interface, tcrypt tests fail as follows:

[...]
[    1.145414] alg: aead: Test 1 failed on encryption for authenc-hmac-=
sha1-cbc-aes-talitos
[    1.153564] 00000000: 53 69 6e 67 6c 65 20 62 6c 6f 63 6b 20 6d 73 6=
7
[    1.160041] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0
[    1.166509] 00000020: 00 00 00 00
[...]

=46ix them by providing the correct cipher in & cipher out pointers,
i.e. must skip over associated data in src and dst S/G.

While here, fix a problem with the HW S/G table index usage:
tbl_off must be updated after the pointer to the table entries is set.

Cc: <stable@vger.kernel.org> # 4.3+
=46ixes: aeb4c132f33d ("crypto: talitos - Convert to new AEAD interface=
")
Reported-by: Jonas Eymann <J.Eymann@gmx.net>
Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 drivers/crypto/talitos.c | 46 ++++++++++++++++++++++++++++++----------=
------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 35198804d6d3..aae05547b924 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -63,6 +63,14 @@ static void to_talitos_ptr(struct talitos_ptr *ptr, =
dma_addr_t dma_addr,
 		ptr->eptr =3D upper_32_bits(dma_addr);
 }
=20
+static void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
+			     struct talitos_ptr *src_ptr, bool is_sec1)
+{
+	dst_ptr->ptr =3D src_ptr->ptr;
+	if (!is_sec1)
+		dst_ptr->eptr =3D src_ptr->eptr;
+}
+
 static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned int l=
en,
 			       bool is_sec1)
 {
@@ -1083,21 +1091,20 @@ static int ipsec_esp(struct talitos_edesc *edes=
c, struct aead_request *areq,
 	sg_count =3D dma_map_sg(dev, areq->src, edesc->src_nents ?: 1,
 			      (areq->src =3D=3D areq->dst) ? DMA_BIDIRECTIONAL
 							   : DMA_TO_DEVICE);
-
 	/* hmac data */
 	desc->ptr[1].len =3D cpu_to_be16(areq->assoclen);
 	if (sg_count > 1 &&
 	    (ret =3D sg_to_link_tbl_offset(areq->src, sg_count, 0,
 					 areq->assoclen,
 					 &edesc->link_tbl[tbl_off])) > 1) {
-		tbl_off +=3D ret;
-
 		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
 			       sizeof(struct talitos_ptr), 0);
 		desc->ptr[1].j_extent =3D DESC_PTR_LNKTBL_JUMP;
=20
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
+
+		tbl_off +=3D ret;
 	} else {
 		to_talitos_ptr(&desc->ptr[1], sg_dma_address(areq->src), 0);
 		desc->ptr[1].j_extent =3D 0;
@@ -1126,11 +1133,13 @@ static int ipsec_esp(struct talitos_edesc *edes=
c, struct aead_request *areq,
 	if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
 		sg_link_tbl_len +=3D authsize;
=20
-	if (sg_count > 1 &&
-	    (ret =3D sg_to_link_tbl_offset(areq->src, sg_count, areq->assocle=
n,
-					 sg_link_tbl_len,
-					 &edesc->link_tbl[tbl_off])) > 1) {
-		tbl_off +=3D ret;
+	if (sg_count =3D=3D 1) {
+		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src) +
+			       areq->assoclen, 0);
+	} else if ((ret =3D sg_to_link_tbl_offset(areq->src, sg_count,
+						areq->assoclen, sg_link_tbl_len,
+						&edesc->link_tbl[tbl_off])) >
+		   1) {
 		desc->ptr[4].j_extent |=3D DESC_PTR_LNKTBL_JUMP;
 		to_talitos_ptr(&desc->ptr[4], edesc->dma_link_tbl +
 					      tbl_off *
@@ -1138,8 +1147,10 @@ static int ipsec_esp(struct talitos_edesc *edesc=
, struct aead_request *areq,
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len,
 					   DMA_BIDIRECTIONAL);
-	} else
-		to_talitos_ptr(&desc->ptr[4], sg_dma_address(areq->src), 0);
+		tbl_off +=3D ret;
+	} else {
+		copy_talitos_ptr(&desc->ptr[4], &edesc->link_tbl[tbl_off], 0);
+	}
=20
 	/* cipher out */
 	desc->ptr[5].len =3D cpu_to_be16(cryptlen);
@@ -1151,11 +1162,13 @@ static int ipsec_esp(struct talitos_edesc *edes=
c, struct aead_request *areq,
=20
 	edesc->icv_ool =3D false;
=20
-	if (sg_count > 1 &&
-	    (sg_count =3D sg_to_link_tbl_offset(areq->dst, sg_count,
+	if (sg_count =3D=3D 1) {
+		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst) +
+			       areq->assoclen, 0);
+	} else if ((sg_count =3D
+			sg_to_link_tbl_offset(areq->dst, sg_count,
 					      areq->assoclen, cryptlen,
-					      &edesc->link_tbl[tbl_off])) >
-	    1) {
+					      &edesc->link_tbl[tbl_off])) > 1) {
 		struct talitos_ptr *tbl_ptr =3D &edesc->link_tbl[tbl_off];
=20
 		to_talitos_ptr(&desc->ptr[5], edesc->dma_link_tbl +
@@ -1178,8 +1191,9 @@ static int ipsec_esp(struct talitos_edesc *edesc,=
 struct aead_request *areq,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
=20
 		edesc->icv_ool =3D true;
-	} else
-		to_talitos_ptr(&desc->ptr[5], sg_dma_address(areq->dst), 0);
+	} else {
+		copy_talitos_ptr(&desc->ptr[5], &edesc->link_tbl[tbl_off], 0);
+	}
=20
 	/* iv out */
 	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
--=20
2.4.4
