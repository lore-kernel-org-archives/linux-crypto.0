Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EE7C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 08:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBPIeS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 03:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBPIeR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 03:34:17 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0DD3403E
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 00:34:15 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSZiU-00Btwv-BF; Thu, 16 Feb 2023 16:34:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 16:34:10 +0800
Date:   Thu, 16 Feb 2023 16:34:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/10] crypto: aead - Count error stats differently
Message-ID: <Y+3qgjvKoyhI7Zru@gondor.apana.org.au>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
 <Y+3C6f/W4fHtVgnM@sol.localdomain>
 <Y+3GdBy7H5/sELON@gondor.apana.org.au>
 <Y+3Nv2Me9c8KYcQU@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+3Nv2Me9c8KYcQU@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 10:31:27PM -0800, Eric Biggers wrote:
 
> I was hoping the compiler would know the pointer is non-NULL, since it's created
> through an expression like &foo->bar where bar is at nonzero offset, and foo is
> also dereferenced.  Unfortunately it does seem that's not the case, though,
> probably because of some of the compiler flags the kernel is compiled with
> (-fno-strict-aliasing and -fno-delete-null-pointer-checks, maybe?).

I'd be worried if the compiler optimised it away :)

Just because p is not NULL, it does not follow that (p + X) where
X is a small integer is also not NULL.  Sure it happens to be
true in kernel space but that's something that we'd have to explicitly
tell the compiler and I don't think there is any way for us to
communicate that through.

> Anyway, if CONFIG_CRYPTO_STATS=y is the common case, that's unfortunate.  Surely

BTW that was just a completely wild guess on my part based on how
distros operate.  I just had a quick look and it seems that Debian
at least disables this option but Fedora leaves it on.

> hardly anyone actually uses the feature, and all this stats collection for every
> crypto operation is for nothing?

I know.

> Here's a thread where someone claimed that disabling CONFIG_CRYPTO_STATS
> significantly improves performance:
> https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/44GMO5UGOXDZKFSOQMCPPHYTREUEA3ZI/

Not surprising as it's doing atomic ops on contended memory.  At
least this patch series kills two of those atomic ops.

> IMO this feature should never have been accepted.  But could we at least put the

You're more than welcome to nack such patches in future :)

> stats collection behind a static branch that defaults to off?  If someone really
> wants to collect stats, they can set a sysctl that turns on the static branch.

Yes I would certainly be open to such a patch.  Another avenue to
explore is turning the atomic ops into percpu/local ones similar
to what networking does to its counters.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
