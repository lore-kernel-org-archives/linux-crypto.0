Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B20C7EE23
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Jun 2023 08:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbjFGIlI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238524AbjFGIlH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2023 04:41:07 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01907173A;
        Wed,  7 Jun 2023 01:41:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q6oia-00075p-Kc; Wed, 07 Jun 2023 16:40:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jun 2023 16:40:36 +0800
Date:   Wed, 7 Jun 2023 16:40:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 05/10] crypto: af_alg: Pin pages rather than
 ref'ing if appropriate
Message-ID: <ZIBChFDNAIstvS6l@gondor.apana.org.au>
References: <20230606130856.1970660-1-dhowells@redhat.com>
 <20230606130856.1970660-6-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606130856.1970660-6-dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 06, 2023 at 02:08:51PM +0100, David Howells wrote:
> Convert AF_ALG to use iov_iter_extract_pages() instead of
> iov_iter_get_pages().  This will pin pages or leave them unaltered rather
> than getting a ref on them as appropriate to the iterator.
> 
> The pages need to be pinned for DIO-read rather than having refs taken on
> them to prevent VM copy-on-write from malfunctioning during a concurrent
> fork() (the result of the I/O would otherwise end up only visible to the
> child process and not the parent).
> 
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
>  crypto/af_alg.c         | 10 +++++++---
>  include/crypto/if_alg.h |  1 +
>  2 files changed, 8 insertions(+), 3 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
