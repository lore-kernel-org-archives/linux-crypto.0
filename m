Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB2BC77B7A
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 09:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbjFFJbC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbjFFJa6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 05:30:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5375EE64;
        Tue,  6 Jun 2023 02:30:54 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q6T1N-00HHlY-27; Tue, 06 Jun 2023 17:30:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Jun 2023 17:30:33 +0800
Date:   Tue, 6 Jun 2023 17:30:33 +0800
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
Message-ID: <ZH78uQsrUz4fxZmm@gondor.apana.org.au>
References: <ZH7xzYfwQoWZLUYa@gondor.apana.org.au>
 <20230530141635.136968-1-dhowells@redhat.com>
 <20230530141635.136968-11-dhowells@redhat.com>
 <1845449.1686043495@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1845449.1686043495@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 06, 2023 at 10:24:55AM +0100, David Howells wrote:
>
> If the iov_iter is a user-backed type (IOVEC or UBUF) then it's not relaxed.
> max_pages is ALG_MAX_PAGES here (actually, I should just move that here so
> that it's clearer).

Even if it's kernel memory they can't be freed during the hashing
operation, which could be long if the amount is large (or the algo
is slow).

The reason for the limit here is to stop a malicious user from
pinning an unlimited amount of memory by doing a hashing operation,
IOW a DoS attack.

So I think we should keep the limit as is.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
