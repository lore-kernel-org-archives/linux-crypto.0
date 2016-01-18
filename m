From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: slab-out-of-bounds in skcipher_recvmsg
Date: Mon, 18 Jan 2016 16:06:39 +0100
Message-ID: <CACT4Y+Zr02Jnv-DZUyg_Cx5rBHmzDM=NjLBb7CApJattcS4J9g@mail.gmail.com>
References: <CACT4Y+aV1=uesWfTpws2gJL7t1bmKwn+xevcjvn7-F8X12X_dA@mail.gmail.com>
 <20160118104610.GA31194@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35378 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbcARPHA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 10:07:00 -0500
Received: by mail-wm0-f44.google.com with SMTP id r129so55001714wmr.0
        for <linux-crypto@vger.kernel.org>; Mon, 18 Jan 2016 07:06:59 -0800 (PST)
In-Reply-To: <20160118104610.GA31194@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 18, 2016 at 11:46 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Fri, Jan 15, 2016 at 07:22:04PM +0100, Dmitry Vyukov wrote:
>> Hello,
>>
>> The following program causes slab-out-of-bounds in skcipher_recvmsg:
>
> Thanks for the report.  This patch should fix it.


Fixes the issue for me. Thanks!

Tested-by: Dmitry Vyukov <dvyukov@google.com>


> ---8<---
> Subject: crypto: algif_skcipher - Load TX SG list after waiting
>
> We need to load the TX SG list in sendmsg(2) after waiting for
> incoming data, not before.
>
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index dfff8b0..df86fb4 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -647,13 +647,6 @@ static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
>
>         lock_sock(sk);
>         while (msg_data_left(msg)) {
> -               sgl = list_first_entry(&ctx->tsgl,
> -                                      struct skcipher_sg_list, list);
> -               sg = sgl->sg;
> -
> -               while (!sg->length)
> -                       sg++;
> -
>                 if (!ctx->used) {
>                         err = skcipher_wait_for_data(sk, flags);
>                         if (err)
> @@ -674,6 +667,13 @@ static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
>                 if (!used)
>                         goto free;
>
> +               sgl = list_first_entry(&ctx->tsgl,
> +                                      struct skcipher_sg_list, list);
> +               sg = sgl->sg;
> +
> +               while (!sg->length)
> +                       sg++;
> +
>                 skcipher_request_set_crypt(&ctx->req, sg, ctx->rsgl.sg, used,
>                                            ctx->iv);
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
