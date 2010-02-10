From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: Re: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in cipher.c
Date: Wed, 10 Feb 2010 03:21:26 +0100
Message-ID: <2d460de71002091821h7b6e99b0gb8f134355f64c65a@mail.gmail.com>
References: <1265765446-24958-1-git-send-email-richih.mailinglist@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44628 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0BJCV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 21:21:28 -0500
In-Reply-To: <1265765446-24958-1-git-send-email-richih.mailinglist@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Obviously, this should have been named

CRYPTO: Fix checkpatch errors & warnings in compress.c

Should I re-send the patch or is it less noise & hassle if I just leave
it this way?


Richard

On Wed, Feb 10, 2010 at 02:30, Richard Hartmann
<richih.mailinglist@gmail.com> wrote:
>
> Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
> ---
> =C2=A0crypto/compress.c | =C2=A0 =C2=A04 ++--
> =C2=A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/compress.c b/crypto/compress.c
> index 1ee3570..c33f076 100644
> --- a/crypto/compress.c
> +++ b/crypto/compress.c
> @@ -7,7 +7,7 @@
> =C2=A0*
> =C2=A0* This program is free software; you can redistribute it and/or=
 modify it
> =C2=A0* under the terms of the GNU General Public License as publishe=
d by the Free
> - * Software Foundation; either version 2 of the License, or (at your=
 option)
> + * Software Foundation; either version 2 of the License, or (at your=
 option)
> =C2=A0* any later version.
> =C2=A0*
> =C2=A0*/
> @@ -39,7 +39,7 @@ int crypto_init_compress_ops(struct crypto_tfm *tfm=
)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ops->cot_compress =3D crypto_compress;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ops->cot_decompress =3D crypto_decompress;
> -
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
> --
> 1.6.6.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
