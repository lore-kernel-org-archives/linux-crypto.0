Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EACAC77B7E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 09:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjFAJuI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 05:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjFAJuH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 05:50:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27B4FC
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 02:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685612961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bSBV8Q60GdSQ9cSAx/GWXvbTZ/nLQNHe8IPVOifGAA=;
        b=Xnhj9aGCw2w1hODW8A8OtB7k3hD2FQvZ5t2wrFBfm5HzqYip+5QVCNSdQURd+zH2vnhDDW
        zWPJr9/gckuMrLM28nt8/R32ATCipiGZR9gbDB9yIcUw0r5rCl1iBSye5Bv89UCB4ILlzi
        HWDurA2EMlI71vGsZBdIHsJajB73KiE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-zTh8Hej5N8mp7F5yRuUBIA-1; Thu, 01 Jun 2023 05:49:20 -0400
X-MC-Unique: zTh8Hej5N8mp7F5yRuUBIA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-75cb47e5507so7112785a.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Jun 2023 02:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685612960; x=1688204960;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2bSBV8Q60GdSQ9cSAx/GWXvbTZ/nLQNHe8IPVOifGAA=;
        b=OsGlVlg/VQgqn2tUxFLfX/hSFomfk2DjZ47C3etds4odvwG2fpPWhBNHYwOyI0E+lJ
         n6YTdB4d1RlZJHqmP9XOWDTVhA5bkiPgWMOzaIvr1vtH+5Y/wVZYph1dKjN69BzdHnhp
         PNh0hXJchSSyZ6q77JCFpMAMW6gKxPO7Gdo47SxWPOGqBbZLUlomu8JcBcBa/lV+kPFC
         XmN1YRhwUUpDeWJTkFQAuwn3s+T3x5KekgqZB3OXFLe58EjxE1EsiaCB5CsfZw4yw1W1
         LPjpH/h5YPVXxX1YB81X3+PhR4MNqtYN4XwVsfOZGIxXzAG0Coyd03e/XFJCEzTdfcl7
         zuug==
X-Gm-Message-State: AC+VfDw2wYoSgiTrkfqBkn9rTCh9v8DNLfFqR3NzjssmybzKpFOeB5Po
        iYfG7u9UjD9irojY4Hdc4uG5jf4/oAhwnpkgq4yiZ4p7GH8J/dD5C+QeeGcTG9jSaaOmP2B3nc4
        K0+sw//ylhAoiR/jSY+zIUGYON76kmHQw
X-Received: by 2002:a05:620a:17ab:b0:75b:23a1:829f with SMTP id ay43-20020a05620a17ab00b0075b23a1829fmr5373372qkb.0.1685612960365;
        Thu, 01 Jun 2023 02:49:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yBracybuX3X6v4h6rND3GfM88+X6dv2LFLqr5nImNW+d0uKGReZCHar0BcmPXwrs9IoB7eg==
X-Received: by 2002:a05:620a:17ab:b0:75b:23a1:829f with SMTP id ay43-20020a05620a17ab00b0075b23a1829fmr5373359qkb.0.1685612960126;
        Thu, 01 Jun 2023 02:49:20 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id t15-20020a05620a004f00b0075d22e15f1bsm367441qkt.129.2023.06.01.02.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 02:49:19 -0700 (PDT)
Message-ID: <bd2750e52b47af1782233e254114eb8d627f1073.camel@redhat.com>
Subject: Re: [PATCH net-next v2 08/10] crypto: af_alg: Support
 MSG_SPLICE_PAGES
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date:   Thu, 01 Jun 2023 11:49:15 +0200
In-Reply-To: <20230530141635.136968-9-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
         <20230530141635.136968-9-dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2023-05-30 at 15:16 +0100, David Howells wrote:
> Make AF_ALG sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
> spliced from the source iterator.
>=20
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-crypto@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>  crypto/af_alg.c         | 28 ++++++++++++++++++++++++++--
>  crypto/algif_aead.c     | 22 +++++++++++-----------
>  crypto/algif_skcipher.c |  8 ++++----
>  3 files changed, 41 insertions(+), 17 deletions(-)
>=20
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index fd56ccff6fed..62f4205d42e3 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -940,6 +940,10 @@ int af_alg_sendmsg(struct socket *sock, struct msghd=
r *msg, size_t size,
>  	bool init =3D false;
>  	int err =3D 0;
> =20
> +	if ((msg->msg_flags & MSG_SPLICE_PAGES) &&
> +	    !iov_iter_is_bvec(&msg->msg_iter))
> +		return -EINVAL;
> +
>  	if (msg->msg_controllen) {
>  		err =3D af_alg_cmsg_send(msg, &con);
>  		if (err)
> @@ -985,7 +989,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr=
 *msg, size_t size,
>  	while (size) {
>  		struct scatterlist *sg;
>  		size_t len =3D size;
> -		size_t plen;
> +		ssize_t plen;
> =20
>  		/* use the existing memory in an allocated page */
>  		if (ctx->merge) {
> @@ -1030,7 +1034,27 @@ int af_alg_sendmsg(struct socket *sock, struct msg=
hdr *msg, size_t size,
>  		if (sgl->cur)
>  			sg_unmark_end(sg + sgl->cur - 1);
> =20
> -		if (1 /* TODO check MSG_SPLICE_PAGES */) {
> +		if (msg->msg_flags & MSG_SPLICE_PAGES) {
> +			struct sg_table sgtable =3D {
> +				.sgl		=3D sg,
> +				.nents		=3D sgl->cur,
> +				.orig_nents	=3D sgl->cur,
> +			};
> +
> +			plen =3D extract_iter_to_sg(&msg->msg_iter, len, &sgtable,
> +						  MAX_SGL_ENTS, 0);

It looks like the above expect/supports only ITER_BVEC iterators, what
about adding a WARN_ON_ONCE(<other iov type>)?

Also, I'm keeping this series a bit more in pw to allow Herbert or
others to have a look.

Cheers,

Paolo

