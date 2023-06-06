Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFE0C77B73
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 08:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjFFIo3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 04:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjFFIo3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 04:44:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4FCE8;
        Tue,  6 Jun 2023 01:44:27 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q6SIH-00HGuE-0X; Tue, 06 Jun 2023 16:43:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Jun 2023 16:43:57 +0800
Date:   Tue, 6 Jun 2023 16:43:57 +0800
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
Subject: Re: [PATCH net-next v2 10/10] crypto: af_alg/hash: Support
 MSG_SPLICE_PAGES
Message-ID: <ZH7xzYfwQoWZLUYa@gondor.apana.org.au>
References: <20230530141635.136968-1-dhowells@redhat.com>
 <20230530141635.136968-11-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530141635.136968-11-dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 30, 2023 at 03:16:34PM +0100, David Howells wrote:
>
> -	if (limit > sk->sk_sndbuf)
> -		limit = sk->sk_sndbuf;
> +	/* Don't limit to ALG_MAX_PAGES if the pages are all already pinned. */
> +	if (!user_backed_iter(&msg->msg_iter))
> +		max_pages = INT_MAX;
> +	else
> +		max_pages = min_t(size_t, max_pages,
> +				  DIV_ROUND_UP(sk->sk_sndbuf, PAGE_SIZE));

What's the purpose of relaxing this limit? Even if there is a reason
for this shouldn't this be in a patch by itself?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
