Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5931C7EE2C
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 09:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjFFJBP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbjFFJBM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 05:01:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8D9E51
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 02:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686042022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nE77/PGW00ePiumkpu3hzk+sXBS9GQxpADNCUK4kjrY=;
        b=HM1Ezd7Y2lHfQrTqWoPwgdsd1+AEZt4dfd7+/hssj9OAC6PLAe+t94T2aSAjGa6KLv6Gb0
        9dlQmvuJNDuTmzPKD0iSwtiJ2Xo0sepTburBr0c9LWbogkLZdLb79bBbK6PL8AqUyBuow1
        A4BbB5s3uBWy7YY/HEgyCa0ZoHCsvAw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-JcuDZBGCNcmYK1LaRWEuXQ-1; Tue, 06 Jun 2023 05:00:21 -0400
X-MC-Unique: JcuDZBGCNcmYK1LaRWEuXQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7e6648625so2817165e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 06 Jun 2023 02:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042005; x=1688634005;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nE77/PGW00ePiumkpu3hzk+sXBS9GQxpADNCUK4kjrY=;
        b=QdxUk7J8HHIXcWclc1lr7uQ6oPMsod5R03goIid7nWesKAAIk4/gRyqr0/6fx9AJiH
         4eqjYfxu1LcTWbEkWP/7Ad6bNe3RIOTqx+5COaEk5+AtJ7CRJhK9hD/KlZerQmkxf7hj
         AL4tmzMzUO9EV2Vu1Xb80yCBqf1b9vgAQQsyymw0yko8H4KKSvKoY334kpORaLiy2yuX
         luHlvkf4hnm2lJFsFTL2ebSvDnre+a80yRyXGoNtpWguM+k+lBpjoJZGWyD8TUMPRCQJ
         MaQ7LurzSTn3Gnn/Cdislxl1wH99s6OQWdHUETznEsQBij3lMzWTzuM6MTVFtsBwtplH
         THyQ==
X-Gm-Message-State: AC+VfDz9kcrkPQJubZ2YkuxLmv1kuprmTW2tbzfTOwHmaCggdRv68fP4
        zQGqdi34o7sN8KmDSGk2szpHeHwQSV4Yq4rGCXgn+WU+1DimAh2Hw5+PLgiNWcWVMUVBc+U0kwe
        rTvlxV9MUoSzmhNiSyjy3556p
X-Received: by 2002:a05:600c:1c26:b0:3f7:3a2f:35ec with SMTP id j38-20020a05600c1c2600b003f73a2f35ecmr2121570wms.2.1686042005100;
        Tue, 06 Jun 2023 02:00:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4nMW2ZxYmp2BjKFt0zgPi8AR01qUkYolCtDK0fOgYD9ytZTIMSa1sHbzT24zAhoWWsDDQWaw==
X-Received: by 2002:a05:600c:1c26:b0:3f7:3a2f:35ec with SMTP id j38-20020a05600c1c2600b003f73a2f35ecmr2121536wms.2.1686042004812;
        Tue, 06 Jun 2023 02:00:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id f18-20020a1cc912000000b003f4e3ed98ffsm13282106wmb.35.2023.06.06.02.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 02:00:04 -0700 (PDT)
Message-ID: <9eb5ab9385ba4af322f5bb9e8c9112414ab7027b.camel@redhat.com>
Subject: Re: [PATCH net-next v2 01/10] Drop the netfs_ prefix from
 netfs_extract_iter_to_sg()
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
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date:   Tue, 06 Jun 2023 11:00:02 +0200
In-Reply-To: <20230530141635.136968-2-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
         <20230530141635.136968-2-dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2023-05-30 at 15:16 +0100, David Howells wrote:
> Rename netfs_extract_iter_to_sg() and its auxiliary functions to drop the
> netfs_ prefix.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: Steve French <sfrench@samba.org>
> cc: Shyam Prasad N <nspmangalore@gmail.com>
> cc: Rohith Surabattula <rohiths.msft@gmail.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: linux-crypto@vger.kernel.org
> cc: linux-cachefs@redhat.com
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>=20
> Notes:
>     ver #2:
>      - Put the "netfs_" prefix removal first to shorten lines and avoid
>        checkpatch 80-char warnings.
>=20
>  fs/cifs/smb2ops.c     |  4 +--
>  fs/cifs/smbdirect.c   |  2 +-

This patch does not apply anymore to net-next as the cifs contents have
been moved into fs/smb/client.

You need at least to rebase the series on top of commit
38c8a9a52082579090e34c033d439ed2cd1a462d.

Thanks!

Paolo

