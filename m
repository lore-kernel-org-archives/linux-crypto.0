Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF089C4167B
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Nov 2023 05:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348567AbjKBFkN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 01:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348472AbjKBFkM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 01:40:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44753116
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 22:40:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64B4C433C9;
        Thu,  2 Nov 2023 05:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698903609;
        bh=Vc50y+ilngpLAjJrj+ek3spiWbd5yxysMlqquUorDrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZtLwpA51+YEB/qeOsXEQjiO6eXm6+5fLMz9rqtZEMgySbUjGcViwN/cz5GoBhfJ5
         qc5MM2rIZ0hj3SRPA7SNjU5gi9HeLnHp3LhiIVHR715l1z9fEoDY3p63HgjUiM0uMP
         G2Y3R8lQ+FwIcimkJ2X9Ms6zAlwtyg80c7h1ccMEB+kdYnvz2xa6c6fnbZeNviIYhg
         OeAFvevrp2szhzMSIxRln3T4P2aw2za4Uqls7x4xnDkEYRWVlFkWRoaR+jpk75B38O
         8k5TkmIOY4AqB+APIWGiKE8q3f/oXopVbmNeGHa28WuDbPo7fC1AdO/oEpv9Zz01Gq
         sz2x5Rn033oSA==
Date:   Wed, 1 Nov 2023 22:40:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-crypto@vger.kernel.org, gilad@benyossef.com,
        samitolvanen@google.com
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when
 possible
Message-ID: <20231102054008.GG1498@sol.localdomain>
References: <20231030023351.6041-1-ebiggers@kernel.org>
 <ZUHZQ3tJH0WSV9dX@gondor.apana.org.au>
 <20231101054856.GA140941@sol.localdomain>
 <ZUMo87EMeYxiCZLX@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUMo87EMeYxiCZLX@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 02, 2023 at 12:43:31PM +0800, Herbert Xu wrote:
> On Tue, Oct 31, 2023 at 10:48:56PM -0700, Eric Biggers wrote:
> >
> > Note that dm-verity also has to use an ugly and error-prone workaround to use
> > ahash at all, since its hash blocks can be cached in vmalloc memory; see
> > verity_hash_update().  shash handles vmalloc memory much more naturally, since
> > no translation from vmalloc address to page to linear address is needed.
> 
> So why not drop ahash and always use shash? Does anybody care about
> offload for dm-verity?

I'd love to do that; it's what I did in fsverity.  Someone did intentionally
convert dm-verity from shash to ahash in 2017, though; see commit d1ac3ff008fb.
So we'd be reverting that.  Maybe there are people who'd still care.  Maybe not.
I haven't yet gotten any complaints about switching fsverity to shash in v6.5
(and I only used ahash originally because of the precedent of dm-verity).

> Alternatively, we could incorporate this into ahash itself.  Then
> you could have an optimised code path that does not do SGs if the
> underlying algorithm is shash.
> 
> I really do not wish to see this ahash/shash paradigm proliferate.

Do you have in mind making struct ahash_request specify the data by either
scatterlist or by virtual address?  It might be possible.  It would be necessary
to wire up all possible combinations of (SG, virt) x (ahash_alg, shash_alg),
with the vmalloc_to_page() hack for the virt + ahash_alg case.

> OK.  But we do still have the module signature verification code
> path and I think that one still needs the can-sleep flag.

Well, struct shash_desc used to have that flag, but it never did anything.  The
few use cases like this might be more simply served by just having a helper
function crypto_shash_update_large() that passes the data in chunks to
crypto_shash_update().

- Eric
