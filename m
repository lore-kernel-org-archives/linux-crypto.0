Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF36C77B7A
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Jun 2023 08:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjFGIs5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbjFGIs4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2023 04:48:56 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6E318F;
        Wed,  7 Jun 2023 01:48:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q6oq8-0007Kf-9L; Wed, 07 Jun 2023 16:48:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jun 2023 16:48:24 +0800
Date:   Wed, 7 Jun 2023 16:48:24 +0800
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
Subject: Re: [PATCH net-next v3 10/10] crypto: af_alg/hash: Support
 MSG_SPLICE_PAGES
Message-ID: <ZIBEWBPDdkCtx8XM@gondor.apana.org.au>
References: <20230606130856.1970660-1-dhowells@redhat.com>
 <20230606130856.1970660-11-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606130856.1970660-11-dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 06, 2023 at 02:08:56PM +0100, David Howells wrote:
> Make AF_ALG sendmsg() support MSG_SPLICE_PAGES in the hashing code.  This
> causes pages to be spliced from the source iterator if possible.
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
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
> 
> Notes:
>     ver #2)
>      - Fixed some checkpatch warnings.
> 
>  crypto/af_alg.c     |  11 +++--
>  crypto/algif_hash.c | 100 +++++++++++++++++++++++++++-----------------
>  2 files changed, 70 insertions(+), 41 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
