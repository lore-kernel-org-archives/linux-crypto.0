From: Sergey Mironov <ierton@gmail.com>
Subject: Re: Bug in geode-aes.c ?
Date: Thu, 12 Nov 2009 11:36:42 +0300
Message-ID: <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
	 <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:34834 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZKLIgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Nov 2009 03:36:38 -0500
Received: by fxm21 with SMTP id 21so1939447fxm.21
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2009 00:36:42 -0800 (PST)
In-Reply-To: <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2009/11/12 Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>:
> * Sergey Mironov | 2009-11-10 17:00:31 [+0300]:
>
>> 116 static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *ke=
y,
>> 117 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int len)
>> 118 {
>>...
>>
>>/** BUG? Should it be 'op->fallback.cip' instead of 'op->fallback.blk=
' ? =A0**/
>>
>> 138 =A0 =A0 =A0 =A0 op->fallback.blk->base.crt_flags &=3D ~CRYPTO_TF=
M_REQ_MASK;
>> 139 =A0 =A0 =A0 =A0 op->fallback.blk->base.crt_flags |=3D (tfm->crt_=
flags &
>>CRYPTO_TFM_REQ_MASK);
>>
>>...
>>
>> 144 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tfm->crt_flags |=3D
>>(op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
>> 145 =A0 =A0 =A0 =A0 }
>> 146 =A0 =A0 =A0 =A0 return ret;
>
> Yup, good catch. It has to be cip instead of blk. I've copy/pasted it
> and the same bug is in s390's crypto driver. No one noticed it becaus=
e
> both structs are equal, just the name / type is different.
> Do you mind sending a patch?
>
> Sebastian
>

Hi. Ok, here is geode-patch
--=20
 Sergey


=46rom 0a61b446585324a3041ef0a138515ef936a14eb7 Mon Sep 17 00:00:00 200=
1
=46rom: Sergey Mironov <ierton@gmail.com>
Date: Thu, 12 Nov 2009 11:30:02 +0300
Subject: [PATCH] Fixed typo bugs in geod-aes.c


Signed-off-by: Sergey Mironov <ierton@gmail.com>
---
 drivers/crypto/geode-aes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..03e71b1 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -135,8 +135,8 @@ static int geode_setkey_cip(struct crypto_tfm
*tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |=3D (tfm->crt_flags & CRYPTO_TFM_RE=
Q_MASK);
+	op->fallback.cip->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MASK;
+	op->fallback.cip->base.crt_flags |=3D (tfm->crt_flags & CRYPTO_TFM_RE=
Q_MASK);

 	ret =3D crypto_cipher_setkey(op->fallback.cip, key, len);
 	if (ret) {
@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm=
)

 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
+		return PTR_ERR(op->fallback.cip);
 	}

 	return 0;
--=20
1.6.4.4
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
