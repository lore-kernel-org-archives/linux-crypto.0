From: Catalin Vasile <cata.vasile@nxp.com>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Thu, 19 May 2016 06:44:30 +0000
Message-ID: <DB5PR04MB1302A2B8B58216052FC55982EE4A0@DB5PR04MB1302.eurprd04.prod.outlook.com>
References: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
	<DB5PR04MB130247A73997B1D4F918A945EE490@DB5PR04MB1302.eurprd04.prod.outlook.com>,<CADREXsrd+XNv_K=T1QxETUV8Xmp4AmAeyP34Av-PtRf1g3hYnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Denis B <begun.denis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0063.outbound.protection.outlook.com ([157.56.112.63]:27776
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753303AbcESISf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 04:18:35 -0400
In-Reply-To: <CADREXsrd+XNv_K=T1QxETUV8Xmp4AmAeyP34Av-PtRf1g3hYnQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Inline comments

________________________________________
=46rom: Denis B <begun.denis@gmail.com>
Sent: Wednesday, May 18, 2016 5:21 PM
To: Catalin Vasile
Cc: linux-crypto@vger.kernel.org
Subject: Re: IV generation in cryptographic driver in AEAD

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
[Catalin Vasile]
You need to set it to NULL. If your struct is declared globally, the pa=
rts
that load your code will be set any uninitialized struct elements to NU=
LL.

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
> In AEAD mode (or in any case, in IPSec ESP IPv4 =96 esp4.c), in kerne=
l
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
