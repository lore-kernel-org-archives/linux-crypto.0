Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46555C6FD1C
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Mar 2023 06:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjCYGBL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Mar 2023 02:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCYGBK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2023 02:01:10 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974D719685;
        Fri, 24 Mar 2023 23:01:08 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pfwx2-008XUY-Ph; Sat, 25 Mar 2023 14:00:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 25 Mar 2023 14:00:28 +0800
Date:   Sat, 25 Mar 2023 14:00:28 +0800
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
Message-ID: <ZB6N/H27oeWqouyb@gondor.apana.org.au>
References: <ZBPTC9WPYQGhFI30@gondor.apana.org.au>
 <3763055.1679676470@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3763055.1679676470@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 24, 2023 at 04:47:50PM +0000, David Howells wrote:
>
> I must be missing something, I think.  What's particularly optimal about the
> code in hash_sendpage() but not hash_sendmsg()?  Is it that the former uses
> finup/digest, but the latter ony does update+final?

A lot of hardware hashes can't perform partial updates, so they
will always fall back to software unless you use finup/digest.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
