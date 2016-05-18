From: Denis B <begun.denis@gmail.com>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Wed, 18 May 2016 17:21:35 +0300
Message-ID: <CADREXsrd+XNv_K=T1QxETUV8Xmp4AmAeyP34Av-PtRf1g3hYnQ@mail.gmail.com>
References: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
	<DB5PR04MB130247A73997B1D4F918A945EE490@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34729 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbcEROVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 10:21:38 -0400
Received: by mail-vk0-f53.google.com with SMTP id c189so63091131vkb.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2016 07:21:36 -0700 (PDT)
In-Reply-To: <DB5PR04MB130247A73997B1D4F918A945EE490@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46orgive my dumbness, but in:

      .cra_type =3D &crypto_aead_type,
      .cra_u =3D {
            .aead =3D {
                .setkey =3D pp_crypto_aead_setkey,
                .setauthsize =3D pp_crypto_aead_setauthsize,
                .decrypt =3D pp_crypto_aead_dec,
                .encrypt =3D pp_crypto_aead_enc,
                .givencrypt =3D pp_crypto_aead_genivencrypt,
                .givdecrypt =3D pp_crypto_aead_genivdecrypt,
                .ivsize =3D AES_BLOCK_SIZE,
                .maxauthsize =3D SHA256_DIGEST_SIZE,
            },
      },

Just delete the givencrypt and givdecrypt lines (or set to NULL)?

On Wed, May 18, 2016 at 4:56 PM, Catalin Vasile <cata.vasile@nxp.com> w=
rote:
> Inline comments.
>
> ________________________________________
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> on behalf of Denis B <begun.denis@gmail.com>
> Sent: Wednesday, May 18, 2016 3:06 PM
> To: linux-crypto@vger.kernel.org
> Subject: IV generation in cryptographic driver in AEAD
>
> Hello,
>
> In AEAD mode (or in any case, in IPSec ESP IPv4 =E2=80=93 esp4.c), in=
 kernel
> versions prior to 4.2 the cryptographic driver is expected to generat=
e
> an IV.
>
> What if my driver is unable to generate an IV?
> [Catalin Vasile]
> Simple: You do not implement the givcrypt() primitive. The kernel wil=
l generate the IV in software and then call your encrypt() primitive.
>
> Thanks,
> Dennis.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
