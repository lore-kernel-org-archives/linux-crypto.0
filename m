From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: Fix next IV issue for CTS template
Date: Fri, 17 Feb 2017 07:12:46 +0000
Message-ID: <CAKv+Gu8s6PrAv9ZMGa_TsRn2UYKoo8KhqERU0NZPjfBhMDK88Q@mail.gmail.com>
References: <1487303262-5602-1-git-send-email-Libo.Wang@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ofir.Drang@arm.com, Dennis Chen <dennis.chen@arm.com>
To: Libo.Wang@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34431 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932635AbdBQHMs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 02:12:48 -0500
Received: by mail-it0-f47.google.com with SMTP id k200so11167691itb.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2017 23:12:47 -0800 (PST)
In-Reply-To: <1487303262-5602-1-git-send-email-Libo.Wang@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Libo,

On 17 February 2017 at 03:47,  <Libo.Wang@arm.com> wrote:
> From: Libo Wang <Libo Wang@arm.com>
>
> CTS template assumes underlying CBC algorithm will carry out next IV for
> further process.But some implementations of CBC algorithm in kernel break
> this assumption, for example, some hardware crypto drivers ignore next IV
> for performance consider, inthis case, tcry cts(cbc(aes)) test case will
> fail. This patch is trying to fix it by getting next IV information ready
> before last two blocks processed.
>
> Signed-off-by: Libo Wang <libo.wang@arm.com>
> Signed-off-by: Dennis Chen <dennis.chen@arm.com>

Which algorithms in particular break this assumption? I recently fixed
some ARM accelerated software drivers for this reason. If there are
others, we should fix those rather than try to fix it in the CTS
driver.

> ---
>  crypto/cts.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/cts.c b/crypto/cts.c
> index a1335d6..712164b 100644
> --- a/crypto/cts.c
> +++ b/crypto/cts.c
> @@ -154,6 +154,7 @@ static int crypto_cts_encrypt(struct skcipher_request=
 *req)
>         unsigned int nbytes =3D req->cryptlen;
>         int cbc_blocks =3D (nbytes + bsize - 1) / bsize - 1;
>         unsigned int offset;
> +       int ret =3D 0;
>
>         skcipher_request_set_tfm(subreq, ctx->child);
>
> @@ -174,8 +175,17 @@ static int crypto_cts_encrypt(struct skcipher_reques=
t *req)
>         skcipher_request_set_crypt(subreq, req->src, req->dst,
>                                    offset, req->iv);
>
> -       return crypto_skcipher_encrypt(subreq) ?:
> -              cts_cbc_encrypt(req);
> +       /* process CBC blocks */
> +       ret =3D crypto_skcipher_encrypt(subreq);
> +       /* process last two blocks */
> +       if (!ret) {

What happens if an async driver returns -EINPROGRESS here?

> +               /* Get IVn-1 back */
> +               scatterwalk_map_and_copy(req->iv, req->dst, (offset - bsi=
ze), bsize, 0);
> +               /* Continue last two blocks */
> +               return cts_cbc_encrypt(req);
> +       }
> +
> +       return ret;
>  }
>
>  static int cts_cbc_decrypt(struct skcipher_request *req)
> @@ -248,6 +258,8 @@ static int crypto_cts_decrypt(struct skcipher_request=
 *req)
>         int cbc_blocks =3D (nbytes + bsize - 1) / bsize - 1;
>         unsigned int offset;
>         u8 *space;
> +       int ret =3D 0;
> +       u8 iv_next[bsize];
>
>         skcipher_request_set_tfm(subreq, ctx->child);
>
> @@ -277,8 +289,17 @@ static int crypto_cts_decrypt(struct skcipher_reques=
t *req)
>         skcipher_request_set_crypt(subreq, req->src, req->dst,
>                                    offset, req->iv);
>
> -       return crypto_skcipher_decrypt(subreq) ?:
> -              cts_cbc_decrypt(req);
> +       /* process last two blocks */
> +       scatterwalk_map_and_copy(iv_next, req->src, (offset - bsize), bsi=
ze, 0);
> +       ret =3D crypto_skcipher_decrypt(subreq);
> +       if (!ret) {
> +               /* Set Next IV */
> +               subreq->iv =3D iv_next;
> +               /* process last two blocks */
> +               return cts_cbc_decrypt(req);
> +       }
> +
> +       return ret;
>  }
>
>  static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
> --
> 1.8.3.1
>
> IMPORTANT NOTICE: The contents of this email and any attachments are conf=
idential and may also be privileged. If you are not the intended recipient,=
 please notify the sender immediately and do not disclose the contents to a=
ny other person, use it for any purpose, or store or copy the information i=
n any medium. Thank you.

Please configure your email client so it doesn't spit out these.
