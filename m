Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:40199 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeJUPTT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 11:19:19 -0400
Received: by mail-io1-f67.google.com with SMTP id w16-v6so25296139iom.7
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2018 00:06:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181019230153.28201-1-dbaryshkov@gmail.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun, 21 Oct 2018 09:05:58 +0200
Message-ID: <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(+ James)

On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> crypto_cfb_decrypt_segment() incorrectly XOR'ed generated keystream with
> IV, rather than with data stream, resulting in incorrect decryption.
> Test vectors will be added in the next patch.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  crypto/cfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/cfb.c b/crypto/cfb.c
> index a0d68c09e1b9..fd4e8500e121 100644
> --- a/crypto/cfb.c
> +++ b/crypto/cfb.c
> @@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct skcipher_walk *walk,
>
>         do {
>                 crypto_cfb_encrypt_one(tfm, iv, dst);
> -               crypto_xor(dst, iv, bsize);
> +               crypto_xor(dst, src, bsize);
>                 iv = src;
>
>                 src += bsize;
> --
> 2.19.1
>
