Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8911CC76196
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 10:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjCXK16 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 06:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjCXK1z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 06:27:55 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E6F23A70;
        Fri, 24 Mar 2023 03:27:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pfee5-008FXh-Au; Fri, 24 Mar 2023 18:27:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Mar 2023 18:27:41 +0800
Date:   Fri, 24 Mar 2023 18:27:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: Demote BUG_ON() in crypto_unregister_alg() to
 a WARN_ON()
Message-ID: <ZB17HQ+kqeKKh8Ur@gondor.apana.org.au>
References: <20230313091724.20941-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230313091724.20941-1-toke@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 13, 2023 at 10:17:24AM +0100, Toke Høiland-Jørgensen wrote:
> The crypto_unregister_alg() function expects callers to ensure that any
> algorithm that is unregistered has a refcnt of exactly 1, and issues a
> BUG_ON() if this is not the case. However, there are in fact drivers that
> will call crypto_unregister_alg() without ensuring that the refcnt has been
> lowered first, most notably on system shutdown. This causes the BUG_ON() to
> trigger, which prevents a clean shutdown and hangs the system.
> 
> To avoid such hangs on shutdown, demote the BUG_ON() in
> crypto_unregister_alg() to a WARN_ON() with early return. Cc stable because
> this problem was observed on a 6.2 kernel, cf the link below.
> 
> Link: https://lore.kernel.org/r/87r0tyq8ph.fsf@toke.dk
> Cc: stable@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> v2:
>   - Return early if the WARN_ON() triggers
> 
>  crypto/algapi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
