Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7CFC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 11:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbjHKL33 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbjHKL32 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 07:29:28 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AEFE62;
        Fri, 11 Aug 2023 04:29:28 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUQKU-00248s-Uf; Fri, 11 Aug 2023 19:29:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 19:29:19 +0800
Date:   Fri, 11 Aug 2023 19:29:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Decrement struct key.usage in
 alg_set_by_key_serial()
Message-ID: <ZNYbj9nWKbhXwMwj@gondor.apana.org.au>
References: <20230801135709.2218855-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801135709.2218855-1-fred@cloudflare.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 01, 2023 at 08:57:09AM -0500, Frederick Lawler wrote:
> Calls to lookup_user_key() require a corresponding key_put() to
> decrement the usage counter. Once it reaches zero, we schedule key GC.
> Therefore decrement struct key.usage in alg_set_by_key_serial().
> 
> Fixes: 7984ceb134bf ("crypto: af_alg - Support symmetric encryption via keyring keys")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> ---
> This is rebased ontop of Linus's 6.5-rc1. Original patch was introduced in 6.2.
> ---
>  crypto/af_alg.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
