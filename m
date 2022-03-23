Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6427DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 12:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbiCWMpv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 08:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiCWMpu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 08:45:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9452874869;
        Wed, 23 Mar 2022 05:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DjpyD/h1p0D6qjtRKWnmt2z+G14e2zzEk1pSwXoVhvI=; b=cb9UTDpugoK/oh3jQLwXnBrQew
        /SeMYz75J8cQyNkVX+AZARMrK0AaZ2ULt+HUlnoFLHVYUjFYJM1LYpNXyc5GzywvPgfqIKqtSrrvT
        PkQFwIl+lbV81+Xb/VZKlOh4LpEhHplOKUD2KcAiFDGK67/1BEcaNxI4U63EDa83uFbo7UbMBJkl4
        sXEJa1ad5XpdUxWcXOyHy5bSlQkgYmNTP86EVUsKfKnRqbdq8OkVmO4mJv4rac1/Zkekr6WZzWjGQ
        odP3sZ8T+i+lHPojjgyBzOYrGbzFNpgAXB6ja2h2PO09LW/oRX6ee60cH7+bXYhne1OIkUfu0W4BR
        bbCJhwhA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nX0LA-00CXDG-Av; Wed, 23 Mar 2022 12:43:52 +0000
Date:   Wed, 23 Mar 2022 12:43:52 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Harsha <harsha.harsha@xilinx.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cacheflush.h: Add forward declaration for struct folio
Message-ID: <YjsWCMTpvKXweoJj@casper.infradead.org>
References: <Yigc4cQlTJRRZsQg@gondor.apana.org.au>
 <20220322131327.GA747088@roeck-us.net>
 <YjqVblTmjNYl3Zjc@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjqVblTmjNYl3Zjc@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 03:35:10PM +1200, Herbert Xu wrote:
> This should be fixed in cacheflush.h:
> 
> ---8<---
> The struct folio is not declared in cacheflush.h so we need to
> provide a forward declaration as otherwise users of this header
> file may get warnings.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: 522a0032af00 ("Add linux/cacheflush.h")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> diff --git a/include/linux/cacheflush.h b/include/linux/cacheflush.h
> index fef8b607f97e..a6189d21f2ba 100644
> --- a/include/linux/cacheflush.h
> +++ b/include/linux/cacheflush.h
> @@ -4,6 +4,8 @@
>  
>  #include <asm/cacheflush.h>
>  
> +struct folio;
> +
>  #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
>  #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_FOLIO
>  void flush_dcache_folio(struct folio *folio);
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
