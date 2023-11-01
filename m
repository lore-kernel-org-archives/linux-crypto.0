Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AA9C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 05:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347606AbjKAFtE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Nov 2023 01:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376765AbjKAFtD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2023 01:49:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D646F1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 22:48:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E2EC433C8;
        Wed,  1 Nov 2023 05:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698817738;
        bh=V9HLWURTd89l/w6rZz7bQqntg5RFNATOGPPwC8zy0QE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C5gHrrqzJ6mkkOv17oZFXdzA2N+30SceNMsFu2oAnt48hDpDoxrmhmZWfPN86b5jZ
         MMkDBW3lczfb9V9ODfZ4rne3BrHD6ZUs2erhvmmAEdZbrFPuXWxIyjUEdyrMAs8SKJ
         USl+qU7OGoTKr5nZkpaJbDVRBcwAtCxuiMKjEnz3fMV8z5omIlwvfrhfqkXjDUT/G7
         aHK/ZRDZ5rcTbcalk2VvIEeB8J8ezN34l9QAnOoa3+YxwRv2kxZeZAzC6DgO6imYV6
         w89hQo15b/VT22oW2iBeWiIIxpaKQC0wGH/JCNsk9g9owfuvyxt78Z4grgvnxvGBsJ
         AoVn/1noAFp6Q==
Date:   Tue, 31 Oct 2023 22:48:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-crypto@vger.kernel.org, gilad@benyossef.com,
        samitolvanen@google.com
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when
 possible
Message-ID: <20231101054856.GA140941@sol.localdomain>
References: <20231030023351.6041-1-ebiggers@kernel.org>
 <ZUHZQ3tJH0WSV9dX@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUHZQ3tJH0WSV9dX@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 01, 2023 at 12:51:15PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > +       driver_name = crypto_ahash_driver_name(ahash);
> > +       if (v->version >= 1 /* salt prepended, not appended? */ &&
> > +           1 << v->data_dev_block_bits <= PAGE_SIZE) {
> > +               shash = crypto_alloc_shash(alg_name, 0, 0);
> 
> I'm sorry but this is disgusting.
> 
> Can't we do the same optimisation for the ahash import+finup path?

That would provide the import+finup optimization, but it would retain the
overhead of ahash compared to shash.  That overhead includes a small amount of
extra CPU time as well as the bio size being increased by
sizeof(struct ahash_request).  It's a small difference, but dm-verity
performance is really important.

Note that dm-verity also has to use an ugly and error-prone workaround to use
ahash at all, since its hash blocks can be cached in vmalloc memory; see
verity_hash_update().  shash handles vmalloc memory much more naturally, since
no translation from vmalloc address to page to linear address is needed.

I'm thinking that avoiding the extra overhead of ahash, combined with avoiding
the workaround for vmalloc memory, makes it worthwhile to use shash for the
import+export code path.  If it was just ahash vs. shash by itself, we wouldn't
bother, but the fact that we can combine the two optimizations seems attractive.

> 
> On a side note, if we're going to use shash for bulk data then we
> should reintroduce the can/cannot sleep flag.

This patch limits the use of shash to blocks of at most PAGE_SIZE (*), which is
the same as what ahash does internally.

(*) Except when the data block size is <= PAGE_SIZE but the hash block size is
    > PAGE_SIZE.  I think that's an uncommon configuration that's not worth
    worrying too much about, but it could be excluded from the shash-based code.

- Eric
