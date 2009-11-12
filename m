From: Sergey Mironov <ierton@gmail.com>
Subject: Re: Bug in geode-aes.c ?
Date: Thu, 12 Nov 2009 11:43:20 +0300
Message-ID: <aa09d86e0911120043y4da7379dwef4a613f840df8ca@mail.gmail.com>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
	 <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
	 <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64026 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZKLInQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Nov 2009 03:43:16 -0500
Received: by bwz27 with SMTP id 27so1930688bwz.21
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2009 00:43:20 -0800 (PST)
In-Reply-To: <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2009/11/12 Sergey Mironov <ierton@gmail.com>:
> 2009/11/12 Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>:
>> * Sergey Mironov | 2009-11-10 17:00:31 [+0300]:
>>
>>> 116 static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *k=
ey,
>>> 117 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int len)
>>> 118 {
>>>...
>>>
>>>/** BUG? Should it be 'op->fallback.cip' instead of 'op->fallback.bl=
k' ? =A0**/
>>>
>>> 138 =A0 =A0 =A0 =A0 op->fallback.blk->base.crt_flags &=3D ~CRYPTO_T=
=46M_REQ_MASK;
>>> 139 =A0 =A0 =A0 =A0 op->fallback.blk->base.crt_flags |=3D (tfm->crt=
_flags &
>>>CRYPTO_TFM_REQ_MASK);
>>>
>>>...
>>>
>>> 144 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tfm->crt_flags |=3D
>>>(op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
>>> 145 =A0 =A0 =A0 =A0 }
>>> 146 =A0 =A0 =A0 =A0 return ret;
>>
>> Yup, good catch. It has to be cip instead of blk. I've copy/pasted i=
t
>> and the same bug is in s390's crypto driver. No one noticed it becau=
se
>> both structs are equal, just the name / type is different.
>> Do you mind sending a patch?
>>
>> Sebastian
>>
>
> Hi. Ok, here is geode-patch
> --
> =A0Sergey
>
>
> From 0a61b446585324a3041ef0a138515ef936a14eb7 Mon Sep 17 00:00:00 200=
1
> From: Sergey Mironov <ierton@gmail.com>
> Date: Thu, 12 Nov 2009 11:30:02 +0300
> Subject: [PATCH] Fixed typo bugs in geod-aes.c
>
>
> Signed-off-by: Sergey Mironov <ierton@gmail.com>
> ---
> =A0drivers/crypto/geode-aes.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
> index 4801162..03e71b1 100644
> --- a/drivers/crypto/geode-aes.c
> +++ b/drivers/crypto/geode-aes.c
> @@ -135,8 +135,8 @@ static int geode_setkey_cip(struct crypto_tfm
> *tfm, const u8 *key,
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * The requested key size is not supported by HW, do a=
 fallback
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 op->fallback.blk->base.crt_flags &=3D ~CRYPTO_TFM_REQ_M=
ASK;
> - =A0 =A0 =A0 op->fallback.blk->base.crt_flags |=3D (tfm->crt_flags &=
 CRYPTO_TFM_REQ_MASK);
> + =A0 =A0 =A0 op->fallback.cip->base.crt_flags &=3D ~CRYPTO_TFM_REQ_M=
ASK;
> + =A0 =A0 =A0 op->fallback.cip->base.crt_flags |=3D (tfm->crt_flags &=
 CRYPTO_TFM_REQ_MASK);
>
> =A0 =A0 =A0 =A0ret =3D crypto_cipher_setkey(op->fallback.cip, key, le=
n);
> =A0 =A0 =A0 =A0if (ret) {
> @@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *t=
fm)
>
> =A0 =A0 =A0 =A0if (IS_ERR(op->fallback.cip)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "Error allocating fall=
back algo %s\n", name);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(op->fallback.blk);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(op->fallback.cip);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return 0;
> --
> 1.6.4.4
>

I can't find any "s390" reference in my tree. Probably, i have not got
this branch in my local copy.
--=20
Sergey
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
