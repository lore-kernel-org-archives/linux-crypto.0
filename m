Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48907C74A5B
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 02:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCQCl4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 22:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCQClz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 22:41:55 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCC7457E2;
        Thu, 16 Mar 2023 19:41:19 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pd00p-005aCC-Pa; Fri, 17 Mar 2023 10:40:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Mar 2023 10:40:11 +0800
Date:   Fri, 17 Mar 2023 10:40:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     willy@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dhowells@redhat.com,
        viro@zeniv.linux.org.uk, hch@infradead.org, axboe@kernel.dk,
        jlayton@kernel.org, brauner@kernel.org,
        torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 23/28] algif: Remove hash_sendpage*()
Message-ID: <ZBPTC9WPYQGhFI30@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316152618.711970-24-dhowells@redhat.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:
> Remove hash_sendpage*() and use hash_sendmsg() as the latter seems to just
> use the source pages directly anyway.

...

> -       if (!(flags & MSG_MORE)) {
> -               if (ctx->more)
> -                       err = crypto_ahash_finup(&ctx->req);
> -               else
> -                       err = crypto_ahash_digest(&ctx->req);

You've just removed the optimised path from user-space to
finup/digest.  You need to add them back to sendmsg if you
want to eliminate sendpage.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
