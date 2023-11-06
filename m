Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C20C4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Nov 2023 10:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjKFKL3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Nov 2023 05:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjKFKL2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2023 05:11:28 -0500
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43D9A9
        for <linux-crypto@vger.kernel.org>; Mon,  6 Nov 2023 02:11:25 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qzwZY-00EXk2-2P; Mon, 06 Nov 2023 18:11:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Nov 2023 18:11:15 +0800
Date:   Mon, 6 Nov 2023 18:11:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-crypto@vger.kernel.org, gilad@benyossef.com,
        samitolvanen@google.com
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when
 possible
Message-ID: <ZUi7ww5BMr7V+axG@gondor.apana.org.au>
References: <20231030023351.6041-1-ebiggers@kernel.org>
 <ZUHZQ3tJH0WSV9dX@gondor.apana.org.au>
 <20231101054856.GA140941@sol.localdomain>
 <ZUMo87EMeYxiCZLX@gondor.apana.org.au>
 <20231102054008.GG1498@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102054008.GG1498@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 01, 2023 at 10:40:08PM -0700, Eric Biggers wrote:
>
> Do you have in mind making struct ahash_request specify the data by either
> scatterlist or by virtual address?  It might be possible.  It would be necessary
> to wire up all possible combinations of (SG, virt) x (ahash_alg, shash_alg),
> with the vmalloc_to_page() hack for the virt + ahash_alg case.

Yes that's what I had in mind.  We need to do something similar
for akcipher now that the top-level interface is linear only but
the drivers are still SG-based.

> Well, struct shash_desc used to have that flag, but it never did anything.  The
> few use cases like this might be more simply served by just having a helper
> function crypto_shash_update_large() that passes the data in chunks to
> crypto_shash_update().

Are you volunteering to add this interface? :)

The module signature path is really broken right now, at least on
non-preemptible kernels.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
