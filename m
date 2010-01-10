From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: ixp4xx_crypto: simplyfy the code a bit.
Date: Sun, 10 Jan 2010 18:37:57 +0100
Message-ID: <m3aawl3loq.fsf@intrepid.localdomain>
References: <m34omu3rf7.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:33315 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab0AJRh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2010 12:37:59 -0500
In-Reply-To: <m34omu3rf7.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Sun, 10 Jan 2010 16:35:38 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_cry=
pto.c
index 2ae7148..a28df93 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -104,7 +104,7 @@ struct buffer_desc {
 	u16 buf_len;
 #endif
 	u32 phys_addr;
-	u32 __reserved[4];
+	u32 __reserved[5];
 	struct buffer_desc *next;
 	enum dma_data_direction dir;
 };
@@ -120,7 +120,7 @@ struct crypt_ctl {
 	u8 mode;		/* NPE_OP_*  operation mode */
 #endif
 	u8 iv[MAX_IVLEN];	/* IV for CBC mode or CTR IV for CTR mode */
-	u32 icv_rev_aes;	/* icv or rev aes */
+	u32 icv_rev_aes;	/* address to store icv or rev aes */
 	u32 src_buf;
 	u32 dst_buf;
 #ifdef __ARMEB__
@@ -429,8 +429,8 @@ static int init_ixp_crypto(void)
 	int ret =3D -ENODEV;
 	u32 msg[2] =3D { 0, 0 };
=20
-	if (! ( ~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
-				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
+	if (!(ixp4xx_read_feature_bits() &
+	      (IXP4XX_FEATURE_HASH | IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES)=
)) {
 		printk(KERN_ERR "ixp_crypto: No HW crypto available\n");
 		return ret;
 	}
@@ -442,15 +442,11 @@ static int init_ixp_crypto(void)
 		ret =3D npe_load_firmware(npe_c, npe_name(npe_c), dev);
 		if (ret)
 			return ret;
-		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
-			goto npe_error;
-	} else {
-		if (npe_send_message(npe_c, msg, "STATUS_MSG"))
-			goto npe_error;
+	} else if (npe_send_message(npe_c, msg, "STATUS_MSG"))
+		goto npe_error;
=20
-		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
-			goto npe_error;
-	}
+	if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
+		goto npe_error;
=20
 	switch ((msg[1]>>16) & 0xff) {
 	case 3:
@@ -1120,7 +1116,7 @@ static int aead_setauthsize(struct crypto_aead *t=
fm, unsigned int authsize)
 {
 	int max =3D crypto_aead_alg(tfm)->maxauthsize >> 2;
=20
-	if ((authsize>>2) < 1 || (authsize>>2) > max || (authsize & 3))
+	if ((authsize >> 2) < 1 || (authsize >> 2) > max || (authsize & 3))
 		return -EINVAL;
 	return aead_setup(tfm, authsize);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
