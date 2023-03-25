Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342F5C6FD1F
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Mar 2023 09:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjCYJVv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Mar 2023 05:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjCYJVv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2023 05:21:51 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BCF9763;
        Sat, 25 Mar 2023 02:21:48 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pg05D-008ZpO-Qx; Sat, 25 Mar 2023 17:21:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 25 Mar 2023 17:21:07 +0800
Date:   Sat, 25 Mar 2023 17:21:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     willy@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, viro@zeniv.linux.org.uk,
        hch@infradead.org, axboe@kernel.dk, jlayton@kernel.org,
        brauner@kernel.org, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 23/28] algif: Remove hash_sendpage*()
Message-ID: <ZB69A2xf/UfP9bX2@gondor.apana.org.au>
References: <ZB6N/H27oeWqouyb@gondor.apana.org.au>
 <ZBPTC9WPYQGhFI30@gondor.apana.org.au>
 <3763055.1679676470@warthog.procyon.org.uk>
 <3792017.1679730254@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3792017.1679730254@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 25, 2023 at 07:44:14AM +0000, David Howells wrote:
>
> Okay.  Btw, how much of a hard limit is ALG_MAX_PAGES?  Multipage folios can
> exceed the current limit (16 pages, 64K) in size.  Is it just to prevent too
> much memory being pinned at once?

Yes, we don't want user-space to be able to pin an unlimited
amount of memory.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
