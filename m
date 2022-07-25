Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE282C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 15:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiGYPJu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 11:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiGYPJt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 11:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F3F12D16
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 08:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA13DB80DD9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 15:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F6FC341C6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 15:09:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=libc.org header.i=@libc.org header.b="g3Wc9Oro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libc.org; s=20210105;
        t=1658761783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2G53n7Ktyz6kfbdkBKhDUYHtHX7Slv7amsXeN/sQtH0=;
        b=g3Wc9OroUarJIBAYUc0ueLkeBTdoroNZ5UKTTpyxqxmNFbQOu/QjNJd09ZSq0lZFEOpXt+
        nLHRGHyzQ40sQ7BYOjphH0S2gPMevyzlWM51wQGnbXlCCXtEAypUmhbwxgSWTDk5EO6oJy
        OZ2XUCyYBfmGtfSjc0xMxhq4tG5Mo30=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 443b10df (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 15:09:43 +0000 (UTC)
Date:   Mon, 25 Jul 2022 10:56:32 -0400
From:   Rich Felker <dalias@libc.org>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Michael@phoronix.com,
        linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <20220725145628.GE7074@brightrain.aerifal.cx>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bktdsdrk.fsf@oldenburg.str.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 12:11:27PM +0200, Florian Weimer via Libc-alpha wrote:
> * Jason A. Donenfeld via Libc-alpha:
> 
> > I really wonder whether this is a good idea, whether this is something
> > that glibc wants, and whether it's a design worth committing to in the
> > long term.
> 
> Do you object to the interface, or the implementation?

That was *exactly* my first question too.

> The implementation can be improved easily enough at a later date.
> 
> > Firstly, for what use cases does this actually help? As of recent
> > changes to the Linux kernels -- now backported all the way to 4.9! --
> > getrandom() and /dev/urandom are extremely fast and operate over per-cpu
> > states locklessly. Sure you avoid a syscall by doing that in userspace,
> > but does it really matter? Who exactly benefits from this?
> 
> getrandom may be fast for bulk generation.  It's not that great for
> generating a few bits here and there.  For example, shuffling a
> 1,000-element array takes 18 microseconds with arc4random_uniform in
> glibc, and 255 microseconds with the naïve getrandom-based
> implementation (with slightly biased results; measured on an Intel
> i9-10900T, Fedora's kernel-5.18.11-100.fc35.x86_64).
> 
> > You miss out on this with arc4random, and if that information _is_ to be
> > exported to userspace somehow in the future, it would be awfully nice to
> > design the userspace interface alongside the kernel one.
> 
> What is the kernel interface you are talking about?  From an interface
> standpoint, arc4random_buf and getrandom are very similar, with the main
> difference is that arc4random_buf cannot report failure (except by
> terminating the process).
> 
> > Seen from this perspective, going with OpenBSD's older paradigm might be
> > rather limiting. Why not work together, between the kernel and libc, to
> > see if we can come up with something better, before settling on an
> > interface with semantics that are hard to walk back later?
> 
> Historically, kernel developers were not interested in solving some of
> the hard problems (especially early seeding) that prevent the use of
> getrandom during early userspace stages.
> 
> > As-is, it's hard to recommend that anybody really use these functions.
> > Just keep using getrandom(2), which has mostly favorable semantics.
> 
> Some applications still need to run in configurations where getrandom is
> not available (either because the kernel is too old, or because it has
> been disabled via seccomp).
> 
> > Yes, I get it: it's fun to make a random number generator, and so lots
> > of projects figure out some way to make yet another one somewhere
> > somehow. But the tendency to do so feels like a weird computer tinkerer
> > disease rather something that has ever helped the overall ecosystem.
> 
> The performance numbers suggest that we benefit from buffering in user
> space.  It might not be necessary to implement expansion in userspace.
> getrandom (or /dev/urandom) with a moderately-sized buffer could be
> sufficient.

FWIW I'd rather have a few kB of shareable entropy-expansion .text in
userspace than a few kB per process (or even per thread? >_<) of
nonshareable data any day.

> But that's an implementation detail, and something we can revisit later.
> If we vDSO acceleration for getrandom (maybe using the userspace
> thread-specific data donation we discussed for rseq), we might
> eventually do way with the buffering in glibc.  Again this is an
> implementation detail we can change easily enough.

Exactly.

FWIW I've been kinda waiting to see what glibc would do on this after
the posix_random proposal failed, before considering much what we
should do in musl, but the value I see in either is not as an
optimization but as honoring a well-known interface so we have fewer
applications doing their own stupid YOLO stuff trying to get secure
entropy and botching it. So far the best we have is getentropy but it
fails on old kernels. At some point musl will probably implement both
arc4random and getentropy with secure fallback process for old
kernels -- certainly the fallback is needed for meeting the arc4random
contract and I'd like it on both places.

Rich
