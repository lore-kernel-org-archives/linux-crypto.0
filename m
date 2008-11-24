From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 1/4] crypto: Add partial decompression support to the
 CRYPTO API
Date: Mon, 24 Nov 2008 17:12:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811241711510.9844@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
 <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au>
 <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51144 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753205AbYKXQMj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 11:12:39 -0500
In-Reply-To: <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current CRYPTO API supports one-shot (de)compression only, i.e. the=
 whole
data buffer to be (de)compressed must be passed at once, and the whole
(de)compressed data buffer will be received at once.
In several use-cases (e.g. compressed file systems that store files in =
big
compressed blocks), this workflow is not suitable. Hence the CRYPTO API=
 cannot
be used.

To solve this, add the following operations that support partial
(de)compression:
  - crypto_compress_{init,update,final}() for compression,
  - crypto_decompress_{init,update,final}() for decompression.

All these methods take a struct comp_request, which was mimicked after =
the
z_stream object in zlib, and contains buffer pointer and length pairs f=
or input
and output.

Issues:
  - Some underlying (de)compression implementations do not support part=
ial
    (de)compression.  This is the case for e.g. LZO, which is already s=
upported
    by a crypto module. While one-shot (de)compression can easily be
    implemented on top of a partial (de)compression API, the inverse is=
 not
    true.
    Hence there should be a way to ask for a "one-shot" vs. "partial"
    decompression module at crypto_alloc_comp() time.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/compress.c      |   45 +++++++++++++++++++++++++++
 include/linux/crypto.h |   79 ++++++++++++++++++++++++++++++++++++++++=
+++++++++
 2 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/crypto/compress.c b/crypto/compress.c
index 1ee3570..9dbe6f6 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -33,13 +33,56 @@ static int crypto_decompress(struct crypto_tfm *tfm=
,
 	                                                   dlen);
 }
=20
+static int crypto_compress_init(struct crypto_tfm *tfm,
+				struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_compress.coa_compress_init(tfm, req);
+}
+
+static int crypto_compress_update(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_compress.coa_compress_update(tfm, req);
+}
+
+static int crypto_compress_final(struct crypto_tfm *tfm,
+				 struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_compress.coa_compress_final(tfm, req);
+}
+
+static int crypto_decompress_init(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_compress.coa_decompress_init(tfm, req);
+}
+
+static int crypto_decompress_update(struct crypto_tfm *tfm,
+				    struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_compress.coa_decompress_update(tfm, req);
+}
+
+static int crypto_decompress_final(struct crypto_tfm *tfm,
+				   struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_compress.coa_decompress_final(tfm, req);
+}
+
 int crypto_init_compress_ops(struct crypto_tfm *tfm)
 {
 	struct compress_tfm *ops =3D &tfm->crt_compress;
=20
 	ops->cot_compress =3D crypto_compress;
 	ops->cot_decompress =3D crypto_decompress;
-=09
+
+	ops->cot_compress_init =3D crypto_compress_init;
+	ops->cot_compress_update =3D crypto_compress_update;
+	ops->cot_compress_final =3D crypto_compress_final;
+	ops->cot_decompress_init =3D crypto_decompress_init;
+	ops->cot_decompress_update =3D crypto_decompress_update;
+	ops->cot_decompress_final =3D crypto_decompress_final;
+
 	return 0;
 }
=20
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 3d2317e..cef556e 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -180,6 +180,13 @@ struct aead_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
=20
+struct comp_request {
+	const void *next_in;		/* next input byte */
+	void *next_out;			/* next output byte */
+	unsigned int avail_in;		/* bytes available at next_in */
+	unsigned int avail_out;		/* bytes available at next_out */
+};
+
 struct blkcipher_desc {
 	struct crypto_blkcipher *tfm;
 	void *info;
@@ -294,10 +301,24 @@ struct hash_alg {
 };
=20
 struct compress_alg {
+	/* one shot */
 	int (*coa_compress)(struct crypto_tfm *tfm, const u8 *src,
 			    unsigned int slen, u8 *dst, unsigned int *dlen);
 	int (*coa_decompress)(struct crypto_tfm *tfm, const u8 *src,
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
+	/* partial */
+	int (*coa_compress_init)(struct crypto_tfm *tfm,
+				 struct comp_request *req);
+	int (*coa_compress_update)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*coa_compress_final)(struct crypto_tfm *tfm,
+				  struct comp_request *req);
+	int (*coa_decompress_init)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*coa_decompress_update)(struct crypto_tfm *tfm,
+				     struct comp_request *req);
+	int (*coa_decompress_final)(struct crypto_tfm *tfm,
+				    struct comp_request *req);
 };
=20
 struct rng_alg {
@@ -443,12 +464,26 @@ struct ahash_tfm {
 };
=20
 struct compress_tfm {
+	/* one shot */
 	int (*cot_compress)(struct crypto_tfm *tfm,
 	                    const u8 *src, unsigned int slen,
 	                    u8 *dst, unsigned int *dlen);
 	int (*cot_decompress)(struct crypto_tfm *tfm,
 	                      const u8 *src, unsigned int slen,
 	                      u8 *dst, unsigned int *dlen);
+	/* partial */
+	int (*cot_compress_init)(struct crypto_tfm *tfm,
+				 struct comp_request *req);
+	int (*cot_compress_update)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*cot_compress_final)(struct crypto_tfm *tfm,
+				 struct comp_request *req);
+	int (*cot_decompress_init)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*cot_decompress_update)(struct crypto_tfm *tfm,
+				     struct comp_request *req);
+	int (*cot_decompress_final)(struct crypto_tfm *tfm,
+				    struct comp_request *req);
 };
=20
 struct rng_tfm {
@@ -1323,6 +1358,7 @@ static inline struct compress_tfm *crypto_comp_cr=
t(struct crypto_comp *tfm)
 	return &crypto_comp_tfm(tfm)->crt_compress;
 }
=20
+/* one shot */
 static inline int crypto_comp_compress(struct crypto_comp *tfm,
                                        const u8 *src, unsigned int sle=
n,
                                        u8 *dst, unsigned int *dlen)
@@ -1339,5 +1375,48 @@ static inline int crypto_comp_decompress(struct =
crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
=20
+/* partial */
+static inline int crypto_comp_compress_init(struct crypto_comp *tfm,
+					    struct comp_request *req)
+{
+	return crypto_comp_crt(tfm)->cot_compress_init(crypto_comp_tfm(tfm),
+						       req);
+}
+
+static inline int crypto_comp_compress_update(struct crypto_comp *tfm,
+					    struct comp_request *req)
+{
+	return crypto_comp_crt(tfm)->cot_compress_update(crypto_comp_tfm(tfm)=
,
+							 req);
+}
+
+static inline int crypto_comp_compress_final(struct crypto_comp *tfm,
+					    struct comp_request *req)
+{
+	return crypto_comp_crt(tfm)->cot_compress_final(crypto_comp_tfm(tfm),
+							req);
+}
+
+static inline int crypto_comp_decompress_init(struct crypto_comp *tfm,
+					      struct comp_request *req)
+{
+	return crypto_comp_crt(tfm)->cot_decompress_init(crypto_comp_tfm(tfm)=
,
+							 req);
+}
+
+static inline int crypto_comp_decompress_update(struct crypto_comp *tf=
m,
+					      struct comp_request *req)
+{
+	return crypto_comp_crt(tfm)->cot_decompress_update(crypto_comp_tfm(tf=
m),
+							   req);
+}
+
+static inline int crypto_comp_decompress_final(struct crypto_comp *tfm=
,
+					      struct comp_request *req)
+{
+	return crypto_comp_crt(tfm)->cot_decompress_final(crypto_comp_tfm(tfm=
),
+							  req);
+}
+
 #endif	/* _LINUX_CRYPTO_H */
=20

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
