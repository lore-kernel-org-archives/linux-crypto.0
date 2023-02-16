Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F86CC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 06:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBPGbe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 01:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBPGbe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 01:31:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5933D0A4
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 22:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B804B825BC
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 06:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E27C433D2;
        Thu, 16 Feb 2023 06:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676529089;
        bh=h832o51QR/Ud3vH12RN8s1z1mVWC6jqFVyYEFwJNs1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M48DF+ioUpXXerMKpE7+ODEa1rcH8ATW+FikxsLXaL4SbqntyzCrAs5c4Vjpva1hN
         JcP2hNOKNwX4WLRXMyU2RV5uNMzQQ+BROsCW2XfUsxR0wmDEInl8IhYu5DJtXG9NLK
         FitNbba9aMgmS01L+Mj/WoIjN5wnX0C9wF8G4idqAOeOvqB/OQ3+Hga2Ci+4+tzVA5
         OFy+y6zsPdydz+xW5i+6yXdLPQ/WCF9Zkx+p8v+uH1ixW0JMF4Ef4HS33+8NuMEKxS
         bPg0Ak62JmJdZ6msytxG8FGkoHooqX8Pp3mFIpsExU/Y9bYr0+j0jAFdYnVrzhn6EJ
         yxwmol+WtwcrA==
Date:   Wed, 15 Feb 2023 22:31:27 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/10] crypto: aead - Count error stats differently
Message-ID: <Y+3Nv2Me9c8KYcQU@sol.localdomain>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
 <Y+3C6f/W4fHtVgnM@sol.localdomain>
 <Y+3GdBy7H5/sELON@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+3GdBy7H5/sELON@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 16, 2023 at 02:00:20PM +0800, Herbert Xu wrote:
> > > +	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> > > +		memset(istat, 0, sizeof(*istat));
> > > +
> > 
> > Above is another place that can just do 'if (istat)'.
> 
> As I mentioned before, this would create an unnecessary branch
> when STATS are enabled (which would presumably be the common case).
> 

I was hoping the compiler would know the pointer is non-NULL, since it's created
through an expression like &foo->bar where bar is at nonzero offset, and foo is
also dereferenced.  Unfortunately it does seem that's not the case, though,
probably because of some of the compiler flags the kernel is compiled with
(-fno-strict-aliasing and -fno-delete-null-pointer-checks, maybe?).

Anyway, if CONFIG_CRYPTO_STATS=y is the common case, that's unfortunate.  Surely
hardly anyone actually uses the feature, and all this stats collection for every
crypto operation is for nothing?

Here's a thread where someone claimed that disabling CONFIG_CRYPTO_STATS
significantly improves performance:
https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/44GMO5UGOXDZKFSOQMCPPHYTREUEA3ZI/

IMO this feature should never have been accepted.  But could we at least put the
stats collection behind a static branch that defaults to off?  If someone really
wants to collect stats, they can set a sysctl that turns on the static branch.

- Eric
