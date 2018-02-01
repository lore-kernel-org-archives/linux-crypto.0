From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/3] crypto: sha3-generic - Use __optimize to support old compilers
Date: Thu, 1 Feb 2018 17:30:23 +0000
Message-ID: <CAKv+Gu85sNC=5U2tgbEQ3ivEo0jVpundzkT-bGz50s0O-1PqHw@mail.gmail.com>
References: <1517480520-4465-1-git-send-email-geert@linux-m68k.org> <1517480520-4465-3-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Li <sparse@chrisli.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:37670 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbeBARaY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 12:30:24 -0500
Received: by mail-io0-f195.google.com with SMTP id f89so20009436ioj.4
        for <linux-crypto@vger.kernel.org>; Thu, 01 Feb 2018 09:30:24 -0800 (PST)
In-Reply-To: <1517480520-4465-3-git-send-email-geert@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1 February 2018 at 10:22, Geert Uytterhoeven <geert@linux-m68k.org> wrot=
e:
> With gcc-4.1.2:
>
>     crypto/sha3_generic.c:39: warning: =E2=80=98__optimize__=E2=80=99 att=
ribute directive ignored
>
> Use the newly introduced __optimize macro to fix this.
>
> Fixes: 83dee2ce1ae791c3 ("crypto: sha3-generic - rewrite KECCAK transform=
 to help the compiler optimize")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/sha3_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
> index a965b9d8055983af..c409cd87fea5decd 100644
> --- a/crypto/sha3_generic.c
> +++ b/crypto/sha3_generic.c
> @@ -35,7 +35,7 @@ static const u64 keccakf_rndc[24] =3D {
>
>  /* update the state with given number of rounds */
>
> -static void __attribute__((__optimize__("O3"))) keccakf(u64 st[25])
> +static void __optimize("O3") keccakf(u64 st[25])
>  {
>         u64 t[5], tt, bc[5];
>         int round;
> --
> 2.7.4
>
