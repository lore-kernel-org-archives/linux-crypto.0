Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CA2C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 22:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241831AbhLVWp4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 17:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhLVWpz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 17:45:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD337C061574
        for <linux-crypto@vger.kernel.org>; Wed, 22 Dec 2021 14:45:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BAC061D0D
        for <linux-crypto@vger.kernel.org>; Wed, 22 Dec 2021 22:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39118C36AE8;
        Wed, 22 Dec 2021 22:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640213154;
        bh=i80v199yjXCe64MfBbYiIxvAaVJerN1loZyvqagvTRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gfCkQdK+S4I1OXz/ji8CCkeJNrg29Hp+sQaL3Td/EJeuwtJa8zvJ2g+dqsp/4s034
         ixyZ5m6E4F2M57lbTRA00LLM3ek4jpNh1ug38y0GhtaIk0Mol91u+QAxUg1CYrYthl
         poFWG61+teKhsxY8PqscFrzxc/PpG4XWLhwyJqxfiOrAhjgCilTj1E8FHTHaBGdHBS
         k/SFoKY9Ee6ceanuSeyma0yADwP4UWwZTJ2gnu5ecWIEJg+Y3mO4icRJI+/7VWExZn
         CoTKwY+JEsLqaHAfeei+dbbN4L/aNhfxCWDpKTtWhvrxWefEVphCTMDrhVjK5kxH8x
         Lsq+dNRlxRd3Q==
Date:   Wed, 22 Dec 2021 16:45:52 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Petr Vorel <pvorel@suse.cz>, linux-crypto@vger.kernel.org
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YcOqoGOLfNTZh/ZF@quark>
References: <YcN4S7NIV9F0XXPP@pevik>
 <YcOh6jij1s6KA2ee@gondor.apana.org.au>
 <YcOlw1UJizlngAEG@quark>
 <YcOnRRRYbV/MrRhO@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcOnRRRYbV/MrRhO@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 23, 2021 at 09:31:33AM +1100, Herbert Xu wrote:
> On Wed, Dec 22, 2021 at 04:25:07PM -0600, Eric Biggers wrote:
> >
> > Isn't it just an implementation detail that !fips_allowed is handled by the
> > self-test?  Wouldn't it make more sense to report ENOENT for such algorithms?
> 
> ELIBBAD does not necessarily mean !fips_allowed, it could also
> mean a specific implementation (or hardware) failed the self-test.
> 
> Yes, we could change ELIBBAD to something else in the case of
> !fips_allowed, but it's certainly not a trivial change.
> 
> Please give a motivation for this.
> 
> Thanks,

Some of the LTP tests check for ENOENT to determine whether an algorithm is
intentionally unavailable, as opposed to it failing due to some other error.
There is code in the kernel that does this same check too, e.g.
fs/crypto/keysetup.c and block/blk-crypto-fallback.c.

The way that ELIBBAD is overloaded to mean essentially the same thing as ENOENT,
but only in some cases, is not expected.

It would be more logical for ELIBBAD to be restricted to actual test failures.

If it is too late to change, then fine, but it seems like a bug to me.

- Eric
