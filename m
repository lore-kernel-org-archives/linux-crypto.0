Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C637C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Nov 2023 04:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjKBEnn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 00:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjKBEnm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 00:43:42 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4395A6
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 21:43:36 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qyPYC-00DSL0-8z; Thu, 02 Nov 2023 12:43:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Nov 2023 12:43:31 +0800
Date:   Thu, 2 Nov 2023 12:43:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-crypto@vger.kernel.org, gilad@benyossef.com,
        samitolvanen@google.com
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when
 possible
Message-ID: <ZUMo87EMeYxiCZLX@gondor.apana.org.au>
References: <20231030023351.6041-1-ebiggers@kernel.org>
 <ZUHZQ3tJH0WSV9dX@gondor.apana.org.au>
 <20231101054856.GA140941@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101054856.GA140941@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 31, 2023 at 10:48:56PM -0700, Eric Biggers wrote:
>
> Note that dm-verity also has to use an ugly and error-prone workaround to use
> ahash at all, since its hash blocks can be cached in vmalloc memory; see
> verity_hash_update().  shash handles vmalloc memory much more naturally, since
> no translation from vmalloc address to page to linear address is needed.

So why not drop ahash and always use shash? Does anybody care about
offload for dm-verity?

Alternatively, we could incorporate this into ahash itself.  Then
you could have an optimised code path that does not do SGs if the
underlying algorithm is shash.

I really do not wish to see this ahash/shash paradigm proliferate.

> > On a side note, if we're going to use shash for bulk data then we
> > should reintroduce the can/cannot sleep flag.
> 
> This patch limits the use of shash to blocks of at most PAGE_SIZE (*), which is
> the same as what ahash does internally.
> 
> (*) Except when the data block size is <= PAGE_SIZE but the hash block size is
>     > PAGE_SIZE.  I think that's an uncommon configuration that's not worth
>     worrying too much about, but it could be excluded from the shash-based code.

OK.  But we do still have the module signature verification code
path and I think that one still needs the can-sleep flag.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
