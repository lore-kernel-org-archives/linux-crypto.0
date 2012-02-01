From: "devendra.aaru" <devendra.aaru@gmail.com>
Subject: Re: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized to 0
Date: Wed, 1 Feb 2012 05:43:50 -0500
Message-ID: <CAHdPZaP4aArSh7G15KhP2ombW8Zs2L4osQ0xi0W829oBZSuTtg@mail.gmail.com>
References: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Jesper Juhl <jj@chaosbits.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57717 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2BAKnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Feb 2012 05:43:50 -0500
In-Reply-To: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 29, 2012 at 5:39 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> We declare 'exact' without initializing it and then do:
>
> [...]
> =A0 =A0 =A0 =A0if (strlen(p->cru_driver_name))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exact =3D 1;
>
> =A0 =A0 =A0 =A0if (priority && !exact)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> [...]
>
> If the first 'if' is not true, then the second will test an
> uninitialized 'exact'.

not needed . as the cru_driver_name will always be present :).
> As far as I can tell, what we want is for 'exact' to be initialized t=
o
> 0 (zero/false).
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> =A0crypto/crypto_user.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> =A0Compile tested only.
>
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index 16f8693..36a2af7 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -304,7 +304,7 @@ static int crypto_del_alg(struct sk_buff *skb, st=
ruct nlmsghdr *nlh,
> =A0static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nl=
h,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct nlattr **at=
trs)
> =A0{
> - =A0 =A0 =A0 int exact;
> + =A0 =A0 =A0 int exact =3D 0;
> =A0 =A0 =A0 =A0const char *name;
> =A0 =A0 =A0 =A0struct crypto_alg *alg;
> =A0 =A0 =A0 =A0struct crypto_user_alg *p =3D nlmsg_data(nlh);
> --
> 1.7.8.4
>
>
> --
> Jesper Juhl <jj@chaosbits.net> =A0 =A0 =A0 http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
