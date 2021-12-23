Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C54FC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Dec 2021 15:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbhLWPIz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 10:08:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33992 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244140AbhLWPIy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 10:08:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FB6FB820DF
        for <linux-crypto@vger.kernel.org>; Thu, 23 Dec 2021 15:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89D1C36AE9;
        Thu, 23 Dec 2021 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640272132;
        bh=L0neBsXa4ISXxSYsAtGedGlvIbNxLScXQRMbC2+75so=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t3V/KtWQWWLA23t9KAoU68AOfV6XBdTYhk8cd995SQ+kFXnKoDcod8M3Vq5M0Rc77
         vmmcjz9+i6EnSHA5gd0yVWLTvcbZHsfeIR4jE/Et3ofqonPJMbHqWBlh25He/SC7O6
         9zTApiBl58XhLcD2nFF72gS8oXMB8cCFmjxrwt4T8WrQoT3YWHMwc52u2wbsr+I1yh
         V2TZtqhhl3ebuEt+QrWwwiZU2SHVV1mOi9j0/A+Y1JfKLffMmu+8BEZod1wnXXRwS3
         Q6rfEJw0t9QUeEpKv0bolaRS3fGAMlQILNRfeWqZTtXTdvgCHlMvwFZm3p10SQ8dpE
         a6StOmhSdMjzg==
Date:   Thu, 23 Dec 2021 09:08:46 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YcSQ/hhu9Lwr4OSC@quark>
References: <YcN4S7NIV9F0XXPP@pevik>
 <YcOh6jij1s6KA2ee@gondor.apana.org.au>
 <YcOlw1UJizlngAEG@quark>
 <YcOnRRRYbV/MrRhO@gondor.apana.org.au>
 <YcOqoGOLfNTZh/ZF@quark>
 <YcQxeW/hzS7cCUCs@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcQxeW/hzS7cCUCs@pevik>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 23, 2021 at 09:21:13AM +0100, Petr Vorel wrote:
> Hi Herbert, Eric,
> 
> [ Cc Cyril ]
> 
> > On Thu, Dec 23, 2021 at 09:31:33AM +1100, Herbert Xu wrote:
> > > On Wed, Dec 22, 2021 at 04:25:07PM -0600, Eric Biggers wrote:
> 
> > > > Isn't it just an implementation detail that !fips_allowed is handled by the
> > > > self-test?  Wouldn't it make more sense to report ENOENT for such algorithms?
> 
> > > ELIBBAD does not necessarily mean !fips_allowed, it could also
> > > mean a specific implementation (or hardware) failed the self-test.
> Herbert, Thanks for confirmation this was intended.
> 
> > > Yes, we could change ELIBBAD to something else in the case of
> > > !fips_allowed, but it's certainly not a trivial change.
> 
> > > Please give a motivation for this.
> 
> > > Thanks,
> 
> > Some of the LTP tests check for ENOENT to determine whether an algorithm is
> > intentionally unavailable, as opposed to it failing due to some other error.
> > There is code in the kernel that does this same check too, e.g.
> > fs/crypto/keysetup.c and block/blk-crypto-fallback.c.
> 
> > The way that ELIBBAD is overloaded to mean essentially the same thing as ENOENT,
> > but only in some cases, is not expected.
> 
> > It would be more logical for ELIBBAD to be restricted to actual test failures.
> 
> > If it is too late to change, then fine, but it seems like a bug to me.
> 
> Not sure if it's a bug or not. With ENOENT everybody would understand missing
> algorithm (no fix needed in the software). OTOH ELIBBAD allow to distinguish the
> reason (algorithm was there, but disabled).

Being able to distinguish between those reasons doesn't seem to be important,
whereas being able to distinguish between a self-test failure and an algorithm
being disabled is important.

- Eric
