Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8101EC54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Sep 2022 08:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiIMIEC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Sep 2022 04:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiIMIEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2022 04:04:00 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4D85A827
        for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2022 01:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663056238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WM5cqy+9Ns5GuSrNJSHIBJHDUQ5kjQYvfAKgXmLQal4=;
        b=IPm/Rj/je9aGcJw8PPz/Qy/xxSfSjw3N+hPr4kQPQrUem77A2bNkpkGlQnX0baRcrzMrGw
        77h9tQhm7422GxauUNqBczrMhY+DGd7Twu7vbGbTPvRXtsjk9yOvrXnbXn043IzAvW1EFN
        E2HSTZd2DaHqgPkl8yo4Jp8jhi1zFkj4gXP5sXArxpFcTpkDnq0f1naDLrSmSVetx9XhkC
        JcgewLASfliO4cGJI3h9eBKIrir83+rQvard9ohoVwKNgHGMRcjgRxzgd0p/ulgzgEsnG4
        xWrcZ5cCkp2ULykRfFW/3neRJnvy6D+Gbvq017/aPBNlWZxoNajPZBa2EnISoQ==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-561-pDVeeK3oNae_pI_gkQOHgw-2; Tue, 13 Sep 2022 04:03:56 -0400
X-MC-Unique: pDVeeK3oNae_pI_gkQOHgw-2
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Tue, 13 Sep 2022 01:03:53 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH v3 2/2] crypto: inside-secure - Replace generic aes with libaes
Date:   Tue, 13 Sep 2022 16:03:48 +0800
Message-ID: <4c3eb0b45a4e0adbcff0a724709ef9971e8554cb.1663055663.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <c10f8274fafd4f6afe92d0a2716ec5a38ca02cc8.1663055663.git.pliem@maxlinear.com>
References: <c10f8274fafd4f6afe92d0a2716ec5a38ca02cc8.1663055663.git.pliem@maxlinear.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 363a90c2d517 ("crypto: safexcel/aes - switch to
library version of key expansion routine") removed
CRYPTO_AES in the config. However, some portions of codes
still rely on generic AES cipher (e.g. refer to
safexcel_aead_gcm_cra_init(), safexcel_xcbcmac_cra_init()).
This causes transform allocation failure for those algos,
if CRYPTO_AES is not manually enabled.

To resolve that, we replace all existing AES cipher
dependent codes with their AES library counterpart.

Fixes: 363a90c2d517 ("crypto: safexcel/aes - switch to library version of k=
ey expansion routine")
Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
v3:
 Rework patch to replace generic aes with libaes instead
v2:
 Add fixes tag

 .../crypto/inside-secure/safexcel_cipher.c    | 16 +----
 drivers/crypto/inside-secure/safexcel_hash.c  | 59 ++++++-------------
 2 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypt=
o/inside-secure/safexcel_cipher.c
index 5a222c228c3b..32a37e3850c5 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -63,7 +63,6 @@ struct safexcel_cipher_ctx {
 =09u32 hash_alg;
 =09u32 state_sz;
=20
-=09struct crypto_cipher *hkaes;
 =09struct crypto_aead *fback;
 };
=20
@@ -2607,15 +2606,8 @@ static int safexcel_aead_gcm_setkey(struct crypto_ae=
ad *ctfm, const u8 *key,
 =09ctx->key_len =3D len;
=20
 =09/* Compute hash key by encrypting zeroes with cipher key */
-=09crypto_cipher_clear_flags(ctx->hkaes, CRYPTO_TFM_REQ_MASK);
-=09crypto_cipher_set_flags(ctx->hkaes, crypto_aead_get_flags(ctfm) &
-=09=09=09=09CRYPTO_TFM_REQ_MASK);
-=09ret =3D crypto_cipher_setkey(ctx->hkaes, key, len);
-=09if (ret)
-=09=09return ret;
-
 =09memset(hashkey, 0, AES_BLOCK_SIZE);
-=09crypto_cipher_encrypt_one(ctx->hkaes, (u8 *)hashkey, (u8 *)hashkey);
+=09aes_encrypt(&aes, (u8 *)hashkey, (u8 *)hashkey);
=20
 =09if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 =09=09for (i =3D 0; i < AES_BLOCK_SIZE / sizeof(u32); i++) {
@@ -2644,15 +2636,11 @@ static int safexcel_aead_gcm_cra_init(struct crypto=
_tfm *tfm)
 =09ctx->xcm =3D EIP197_XCM_MODE_GCM;
 =09ctx->mode =3D CONTEXT_CONTROL_CRYPTO_MODE_XCM; /* override default */
=20
-=09ctx->hkaes =3D crypto_alloc_cipher("aes", 0, 0);
-=09return PTR_ERR_OR_ZERO(ctx->hkaes);
+=09return 0;
 }
=20
 static void safexcel_aead_gcm_cra_exit(struct crypto_tfm *tfm)
 {
-=09struct safexcel_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
-
-=09crypto_free_cipher(ctx->hkaes);
 =09safexcel_aead_cra_exit(tfm);
 }
=20
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/=
inside-secure/safexcel_hash.c
index 2124416742f8..103fc551d2af 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -30,7 +30,7 @@ struct safexcel_ahash_ctx {
 =09bool fb_init_done;
 =09bool fb_do_setkey;
=20
-=09struct crypto_cipher *kaes;
+=09struct crypto_aes_ctx *aes;
 =09struct crypto_ahash *fback;
 =09struct crypto_shash *shpre;
 =09struct shash_desc *shdesc;
@@ -824,7 +824,7 @@ static int safexcel_ahash_final(struct ahash_request *a=
req)
 =09=09=09result[i] =3D swab32(ctx->base.ipad.word[i + 4]);
 =09=09}
 =09=09areq->result[0] ^=3D 0x80;=09=09=09// 10- padding
-=09=09crypto_cipher_encrypt_one(ctx->kaes, areq->result, areq->result);
+=09=09aes_encrypt(ctx->aes, areq->result, areq->result);
 =09=09return 0;
 =09} else if (unlikely(req->hmac &&
 =09=09=09    (req->len =3D=3D req->block_sz) &&
@@ -2083,37 +2083,26 @@ static int safexcel_xcbcmac_setkey(struct crypto_ah=
ash *tfm, const u8 *key,
 =09=09=09=09 unsigned int len)
 {
 =09struct safexcel_ahash_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm)=
);
-=09struct crypto_aes_ctx aes;
 =09u32 key_tmp[3 * AES_BLOCK_SIZE / sizeof(u32)];
 =09int ret, i;
=20
-=09ret =3D aes_expandkey(&aes, key, len);
+=09ret =3D aes_expandkey(ctx->aes, key, len);
 =09if (ret)
 =09=09return ret;
=20
 =09/* precompute the XCBC key material */
-=09crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
-=09crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
-=09=09=09=09CRYPTO_TFM_REQ_MASK);
-=09ret =3D crypto_cipher_setkey(ctx->kaes, key, len);
-=09if (ret)
-=09=09return ret;
-
-=09crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + 2 * AES_BLOCK_SIZE=
,
-=09=09"\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1");
-=09crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp,
-=09=09"\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2");
-=09crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + AES_BLOCK_SIZE,
-=09=09"\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
+=09aes_encrypt(ctx->aes, (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
+=09=09    "\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1");
+=09aes_encrypt(ctx->aes, (u8 *)key_tmp,
+=09=09    "\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2");
+=09aes_encrypt(ctx->aes, (u8 *)key_tmp + AES_BLOCK_SIZE,
+=09=09    "\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
 =09for (i =3D 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
 =09=09ctx->base.ipad.word[i] =3D swab32(key_tmp[i]);
=20
-=09crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
-=09crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
-=09=09=09=09CRYPTO_TFM_REQ_MASK);
-=09ret =3D crypto_cipher_setkey(ctx->kaes,
-=09=09=09=09   (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
-=09=09=09=09   AES_MIN_KEY_SIZE);
+=09ret =3D aes_expandkey(ctx->aes,
+=09=09=09    (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
+=09=09=09    AES_MIN_KEY_SIZE);
 =09if (ret)
 =09=09return ret;
=20
@@ -2121,7 +2110,6 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahas=
h *tfm, const u8 *key,
 =09ctx->key_sz =3D AES_MIN_KEY_SIZE + 2 * AES_BLOCK_SIZE;
 =09ctx->cbcmac =3D false;
=20
-=09memzero_explicit(&aes, sizeof(aes));
 =09return 0;
 }
=20
@@ -2130,15 +2118,15 @@ static int safexcel_xcbcmac_cra_init(struct crypto_=
tfm *tfm)
 =09struct safexcel_ahash_ctx *ctx =3D crypto_tfm_ctx(tfm);
=20
 =09safexcel_ahash_cra_init(tfm);
-=09ctx->kaes =3D crypto_alloc_cipher("aes", 0, 0);
-=09return PTR_ERR_OR_ZERO(ctx->kaes);
+=09ctx->aes =3D kmalloc(sizeof(*ctx->aes), GFP_KERNEL);
+=09return PTR_ERR_OR_ZERO(ctx->aes);
 }
=20
 static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
 {
 =09struct safexcel_ahash_ctx *ctx =3D crypto_tfm_ctx(tfm);
=20
-=09crypto_free_cipher(ctx->kaes);
+=09kfree(ctx->aes);
 =09safexcel_ahash_cra_exit(tfm);
 }
=20
@@ -2178,31 +2166,23 @@ static int safexcel_cmac_setkey(struct crypto_ahash=
 *tfm, const u8 *key,
 =09=09=09=09unsigned int len)
 {
 =09struct safexcel_ahash_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm)=
);
-=09struct crypto_aes_ctx aes;
 =09__be64 consts[4];
 =09u64 _const[2];
 =09u8 msb_mask, gfmask;
 =09int ret, i;
=20
-=09ret =3D aes_expandkey(&aes, key, len);
+=09/* precompute the CMAC key material */
+=09ret =3D aes_expandkey(ctx->aes, key, len);
 =09if (ret)
 =09=09return ret;
=20
 =09for (i =3D 0; i < len / sizeof(u32); i++)
-=09=09ctx->base.ipad.word[i + 8] =3D swab32(aes.key_enc[i]);
-
-=09/* precompute the CMAC key material */
-=09crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
-=09crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
-=09=09=09=09CRYPTO_TFM_REQ_MASK);
-=09ret =3D crypto_cipher_setkey(ctx->kaes, key, len);
-=09if (ret)
-=09=09return ret;
+=09=09ctx->base.ipad.word[i + 8] =3D swab32(ctx->aes->key_enc[i]);
=20
 =09/* code below borrowed from crypto/cmac.c */
 =09/* encrypt the zero block */
 =09memset(consts, 0, AES_BLOCK_SIZE);
-=09crypto_cipher_encrypt_one(ctx->kaes, (u8 *)consts, (u8 *)consts);
+=09aes_encrypt(ctx->aes, (u8 *)consts, (u8 *)consts);
=20
 =09gfmask =3D 0x87;
 =09_const[0] =3D be64_to_cpu(consts[1]);
@@ -2234,7 +2214,6 @@ static int safexcel_cmac_setkey(struct crypto_ahash *=
tfm, const u8 *key,
 =09}
 =09ctx->cbcmac =3D false;
=20
-=09memzero_explicit(&aes, sizeof(aes));
 =09return 0;
 }
=20
--=20
2.17.1

