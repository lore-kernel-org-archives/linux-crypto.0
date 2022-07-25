Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA00C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 23:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiGYX7Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 19:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiGYX7X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 19:59:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961B527FCA
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46F94B81135
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 23:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2730C341C6;
        Mon, 25 Jul 2022 23:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658793560;
        bh=WNjsHKxZrxJu30Nh9hFxA4BLbFlFjByDPjlC0lpsORs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BF2XFs1zwAuO7H2i4MtxI+a4D2RqmQ6C5qSnfG4dzRm1OrwYZ6QV34se63sgNdJi0
         pfLT/6xny62RbbWLKf3+zufc7BZQ7yO+ZNoVbtsMn8kZ0y5olpNHpUL3Yhi8Ev+JHS
         DvPH8BipDnIC8vgYPrQAM30LrBDDu8Mf6BHr0gqj/Ikpvi/TCgw0b1L2skLyE5RoOE
         98szFyEB8ttLDOqzt+KAe0Hj8dn19FMl/MCY2YWLqEK/qQvRxUbkS6ud7FCojiktRY
         kgGINyFO/i3NK7fciLgor8YyPtJ9FboEiYTYmP8sEqb5V6FeyKpGP94wsNoKsq7bRt
         Kytk942ZidMOQ==
Date:   Mon, 25 Jul 2022 16:59:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt8uVciDQzRbyDds@sol.localdomain>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220725232810.843433-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 26, 2022 at 01:28:10AM +0200, Jason A. Donenfeld wrote:
> Rather than buffering 16 MiB of entropy in userspace (by way of
> chacha20), simply call getrandom() every time.
> 
> This approach is doubtlessly slower, for now, but trying to prematurely
> optimize arc4random appears to be leading toward all sorts of nasty
> properties and gotchas. Instead, this patch takes a much more
> conservative approach. The interface is added as a basic loop wrapper
> around getrandom(), and then later, the kernel and libc together can
> work together on optimizing that.
> 
> This prevents numerous issues in which userspace is unaware of when it
> really must throw away its buffer, since we avoid buffering all
> together. Future improvements may include userspace learning more from
> the kernel about when to do that, which might make these sorts of
> chacha20-based optimizations more possible. The current heuristic of 16
> MiB is meaningless garbage that doesn't correspond to anything the
> kernel might know about. So for now, let's just do something
> conservative that we know is correct and won't lead to cryptographic
> issues for users of this function.
> 
> This patch might be considered along the lines of, "optimization is the
> root of all evil," in that the much more complex implementation it
> replaces moves too fast without considering security implications,
> whereas the incremental approach done here is a much safer way of going
> about things. Once this lands, we can take our time in optimizing this
> properly using new interplay between the kernel and userspace.
> 
> getrandom(0) is used, since that's the one that ensures the bytes
> returned are cryptographically secure. But on systems without it, we
> fallback to using /dev/urandom. This is unfortunate because it means
> opening a file descriptor, but there's not much of a choice. Secondly,
> as part of the fallback, in order to get more or less the same
> properties of getrandom(0), we poll on /dev/random, and if the poll
> succeeds at least once, then we assume the RNG is initialized. This is a
> rough approximation, as the ancient "non-blocking pool" initialized
> after the "blocking pool", not before, but it's the best approximation
> we can do.
> 
> The motivation for including arc4random, in the first place, is to have
> source-level compatibility with existing code. That means this patch
> doesn't attempt to litigate the interface itself. It does, however,
> choose a conservative approach for implementing it.
> 
> Cc: Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
> Cc: Florian Weimer <fweimer@redhat.com>
> Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
> Cc: Paul Eggert <eggert@cs.ucla.edu>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

This looks good to me.

There are still a few bits that need to be removed/updated.  With a quick grep,
I found:

sysdeps/generic/tls-internal-struct.h:  struct arc4random_state_t *rand_state;

sysdeps/unix/sysv/linux/tls-internal.h:/* Reset the arc4random TCB state on fork.  *

NEWS: ... The functions use a pseudo-random number generator along with
NEWS: entropy from the kernel.


Also, the documentation in manual/math.texi should say that the randomness is
cryptographically secure.

- Eric
