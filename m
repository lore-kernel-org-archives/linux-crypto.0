From: Denis B <begun.denis@gmail.com>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Thu, 19 May 2016 14:05:21 +0300
Message-ID: <CADREXsrrkx2-G1x81ss5sCS1p4TZxywdsqo4Tkzt7LX4syu+BA@mail.gmail.com>
References: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
	<DB5PR04MB130247A73997B1D4F918A945EE490@DB5PR04MB1302.eurprd04.prod.outlook.com>
	<CADREXsrd+XNv_K=T1QxETUV8Xmp4AmAeyP34Av-PtRf1g3hYnQ@mail.gmail.com>
	<DB5PR04MB1302A2B8B58216052FC55982EE4A0@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:34909 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbcESLFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 07:05:22 -0400
Received: by mail-vk0-f49.google.com with SMTP id f66so98061840vkh.2
        for <linux-crypto@vger.kernel.org>; Thu, 19 May 2016 04:05:21 -0700 (PDT)
In-Reply-To: <DB5PR04MB1302A2B8B58216052FC55982EE4A0@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

My algs struct now looks like this:

static struct crypto_alg pp_crypto_algs[] =3D {
   {
      .cra_name =3D "authenc(hmac(sha256),cbc(aes))",
      .cra_driver_name =3D "pp_crypto_cbc_hmac_sha256",
      .cra_priority =3D 1, /**TODO set to highest values after
implementing encrypt decrypt functions */
      .cra_flags =3D CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
      .cra_blocksize =3D AES_BLOCK_SIZE,
      .cra_ctxsize =3D sizeof(struct pp_crypto_aead_ctx),
      .cra_type =3D &crypto_nivaead_type,
      .cra_u =3D {
            .aead =3D {
                .setkey =3D pp_crypto_aead_setkey,
                .setauthsize =3D pp_crypto_aead_setauthsize,
                .decrypt =3D pp_crypto_aead_dec,
                .encrypt =3D pp_crypto_aead_enc,
                .givencrypt =3D NULL,
                .givdecrypt =3D NULL,
                .ivsize =3D AES_BLOCK_SIZE,
                .maxauthsize =3D SHA256_DIGEST_SIZE,
            },
      },
      .cra_init =3D pp_crypto_aead_sha256_init,
      .cra_exit =3D pp_crypto_aead_exit,
      .cra_module =3D THIS_MODULE,
   },
   {
      .cra_name =3D "authenc(hmac(sha512),cbc(aes))",
      .cra_driver_name =3D "pp_crypto_cbc_hmac_sha512",
      .cra_priority =3D 1, /**TODO set to highest values after
implementing encrypt decrypt functions */
      .cra_flags =3D CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
      .cra_blocksize =3D AES_BLOCK_SIZE,
      .cra_ctxsize =3D sizeof(struct pp_crypto_aead_ctx),
      .cra_type =3D &crypto_nivaead_type,
      .cra_u =3D {
            .aead =3D {
                .setkey =3D pp_crypto_aead_setkey,
                .decrypt =3D pp_crypto_aead_dec,
                .encrypt =3D pp_crypto_aead_enc,
                .givencrypt =3D NULL,
                .givdecrypt =3D NULL,
                .ivsize =3D AES_BLOCK_SIZE,
                .maxauthsize =3D SHA512_DIGEST_SIZE,
            },
      },
      .cra_init =3D pp_crypto_aead_sha512_init,
      .cra_exit =3D pp_crypto_aead_exit,
      .cra_module =3D THIS_MODULE,
   }
};

I issue a ping and see esp_output() getting called. After that, I'm
used to seeing pp_crypto_givaead_enc() in my driver called. Now I see:

ping: sendto: Function not implemented


Please note that I am working with kernel 3.12, where in esp4.c line
266 we have:

err =3D crypto_aead_givencrypt(req);

On Thu, May 19, 2016 at 9:44 AM, Catalin Vasile <cata.vasile@nxp.com> w=
rote:
> Inline comments
>
> ________________________________________
> From: Denis B <begun.denis@gmail.com>
> Sent: Wednesday, May 18, 2016 5:21 PM
> To: Catalin Vasile
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: IV generation in cryptographic driver in AEAD
>
> Forgive my dumbness, but in:
>
>       .cra_type =3D &crypto_aead_type,
>       .cra_u =3D {
>             .aead =3D {
>                 .setkey =3D pp_crypto_aead_setkey,
>                 .setauthsize =3D pp_crypto_aead_setauthsize,
>                 .decrypt =3D pp_crypto_aead_dec,
>                 .encrypt =3D pp_crypto_aead_enc,
>                 .givencrypt =3D pp_crypto_aead_genivencrypt,
>                 .givdecrypt =3D pp_crypto_aead_genivdecrypt,
>                 .ivsize =3D AES_BLOCK_SIZE,
>                 .maxauthsize =3D SHA256_DIGEST_SIZE,
>             },
>       },
>
> Just delete the givencrypt and givdecrypt lines (or set to NULL)?
> [Catalin Vasile]
> You need to set it to NULL. If your struct is declared globally, the =
parts
> that load your code will be set any uninitialized struct elements to =
NULL.
>
> On Wed, May 18, 2016 at 4:56 PM, Catalin Vasile <cata.vasile@nxp.com>=
 wrote:
>> Inline comments.
>>
>> ________________________________________
>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ke=
rnel.org> on behalf of Denis B <begun.denis@gmail.com>
>> Sent: Wednesday, May 18, 2016 3:06 PM
>> To: linux-crypto@vger.kernel.org
>> Subject: IV generation in cryptographic driver in AEAD
>>
>> Hello,
>>
>> In AEAD mode (or in any case, in IPSec ESP IPv4 =E2=80=93 esp4.c), i=
n kernel
>> versions prior to 4.2 the cryptographic driver is expected to genera=
te
>> an IV.
>>
>> What if my driver is unable to generate an IV?
>> [Catalin Vasile]
>> Simple: You do not implement the givcrypt() primitive. The kernel wi=
ll generate the IV in software and then call your encrypt() primitive.
>>
>> Thanks,
>> Dennis.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cryp=
to" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
