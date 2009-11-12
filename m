From: Sergey Mironov <ierton@gmail.com>
Subject: Re: Bug in geode-aes.c ?
Date: Thu, 12 Nov 2009 13:18:53 +0300
Message-ID: <aa09d86e0911120218w3e1b640m91772d1859018ea9@mail.gmail.com>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
	 <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
	 <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
	 <20091112091807.GC22434@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37971 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZKLKSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Nov 2009 05:18:48 -0500
Received: by bwz27 with SMTP id 27so2018882bwz.21
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2009 02:18:53 -0800 (PST)
In-Reply-To: <20091112091807.GC22434@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2009/11/12 Sebastian Andrzej Siewior <sebastian@breakpoint.cc>:
> >From 0a61b446585324a3041ef0a138515ef936a14eb7 Mon Sep 17 00:00:00 20=
01
>>From: Sergey Mironov <ierton@gmail.com>
>>Date: Thu, 12 Nov 2009 11:30:02 +0300
>>Subject: [PATCH] Fixed typo bugs in geod-aes.c
>
> On a second look could you please add something like:
>
> crypto/geode: access fallback.cip cipher fallback mode
>
> |The fallback code in cipher mode touch the union fallback.blk instea=
d
> |of fallback.cip. This is wrong because we use the cipher and not the
> |blockcipher. This did not show any side effects yet because both typ=
es /
> |structs contain the same element right now.
>
>
>>Signed-off-by: Sergey Mironov <ierton@gmail.com>
>>---
>> drivers/crypto/geode-aes.c | =A0 =A06 +++---
>> 1 files changed, 3 insertions(+), 3 deletions(-)
>>
>>diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
>>index 4801162..03e71b1 100644
>>--- a/drivers/crypto/geode-aes.c
>>+++ b/drivers/crypto/geode-aes.c
>>@@ -135,8 +135,8 @@ static int geode_setkey_cip(struct crypto_tfm
>>*tfm, const u8 *key,
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* The requested key size is not supported by HW, do a=
 fallback
>> =A0 =A0 =A0 =A0*/
>>- =A0 =A0 =A0op->fallback.blk->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MA=
SK;
>>- =A0 =A0 =A0op->fallback.blk->base.crt_flags |=3D (tfm->crt_flags & =
CRYPTO_TFM_REQ_MASK);
>>+ =A0 =A0 =A0op->fallback.cip->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MA=
SK;
>>+ =A0 =A0 =A0op->fallback.cip->base.crt_flags |=3D (tfm->crt_flags & =
CRYPTO_TFM_REQ_MASK);
>>
>> =A0 =A0 =A0 ret =3D crypto_cipher_setkey(op->fallback.cip, key, len)=
;
>> =A0 =A0 =A0 if (ret) {
>>@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *t=
fm)
>>
>> =A0 =A0 =A0 if (IS_ERR(op->fallback.cip)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "Error allocating fallba=
ck algo %s\n", name);
>>- =A0 =A0 =A0 =A0 =A0 =A0 =A0return PTR_ERR(op->fallback.blk);
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0return PTR_ERR(op->fallback.cip);
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 return 0;
>
> Sebastian
>

Here is similar patch for aes_s390:
--
Sergey

=46rom 335b39e0c55a1dba13cda3e8222947f2cb4120ed Mon Sep 17 00:00:00 200=
1
=46rom: Sergey Mironov <ierton@gmail.com>
Date: Thu, 12 Nov 2009 13:10:05 +0300
Subject: [PATCH 2/2] aes_s390: access fallback.cip cipher fallback mode

|The fallback code in cipher mode touch the union fallback.blk instead
|of fallback.cip. This is wrong because we use the cipher and not the
|blockcipher. This did not show any side effects yet because both types=
 /
|structs contain the same element right now.

Signed-off-by: Sergey Mironov <ierton@gmail.com>
---
 arch/s390/crypto/aes_s390.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index e33f32b..6f0f8b9 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -75,14 +75,14 @@ static int setkey_fallback_cip(struct crypto_tfm
*tfm, const u8 *in_key,
 	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
 	int ret;

-	sctx->fallback.blk->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MASK;
-	sctx->fallback.blk->base.crt_flags |=3D (tfm->crt_flags &
+	sctx->fallback.cip->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MASK;
+	sctx->fallback.cip->base.crt_flags |=3D (tfm->crt_flags &
 			CRYPTO_TFM_REQ_MASK);

 	ret =3D crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
 	if (ret) {
 		tfm->crt_flags &=3D ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |=3D (sctx->fallback.blk->base.crt_flags &
+		tfm->crt_flags |=3D (sctx->fallback.cip->base.crt_flags &
 				CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
@@ -170,7 +170,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm=
)

 	if (IS_ERR(sctx->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(sctx->fallback.blk);
+		return PTR_ERR(sctx->fallback.cip);
 	}

 	return 0;
--=20
1.6.4.4
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
