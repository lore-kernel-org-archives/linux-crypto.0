Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F7AC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 11:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiGYLEt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 07:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiGYLEs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 07:04:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7066155
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 04:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2583DB80E4C
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 11:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63A5C341C6;
        Mon, 25 Jul 2022 11:04:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KTFbbW5n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658747082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+G6qcGVQDvCtKH2P/3qEMEd4T0g3JsXXyEwuf9qXIk=;
        b=KTFbbW5ncXg0aT9viFLVGw/zUyqWur+YWJVgylNH4WUUNTYCg/5IPzaCnETSDWe15ZsBxR
        cRm5KsL32IXie5hH0MUq4EUbd8VNq7KwnTGIvIGM0k1SqfhfpRaNtZeJAgy+UfmFTHDPwS
        ft2usfj30oyWgXsJ4GQ+FxmoEXdwnJo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8b945e37 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 25 Jul 2022 11:04:42 +0000 (UTC)
Date:   Mon, 25 Jul 2022 13:04:39 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Yt54x7uWnsL3eZSx@zx2c4.com>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bktdsdrk.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Florian,

On Mon, Jul 25, 2022 at 12:11:27PM +0200, Florian Weimer wrote:
> > I really wonder whether this is a good idea, whether this is something
> > that glibc wants, and whether it's a design worth committing to in the
> > long term.
> 
> Do you object to the interface, or the implementation?
> 
> The implementation can be improved easily enough at a later date.

Sort of both, as I don't think it's wise to commit to the former without
a good idea of the full ideal space of the latter, and very clearly from
reading that discussion, that hasn't been explored.

In particular, Adhemerval has said you won't be committing to making
arc4random suitable for crypto, going so far as to mention it's not a
CSPRNG in the documentation. As I described in my reply to him (please
read that), the "documentation cop-out" will lead to tears inevitably.
Not only is that dangerous and bad to do alone, but it severely muddies
the waters with what other operating systems suggest about its permitted
use cases.

Here's that email for reference:
https://lore.kernel.org/linux-crypto/Ytx8GKSZfRt+ZrEO@zx2c4.com/

If you're going to ship an interface that people *will* use for
sensitive things -- especially considering Paul's comment about the intent
being "source code compatibility" -- then you must not ship it knowingly
broken by design. There's no amount of documentation papering that makes
this okay. Until you know how to implement it well, don't ship the
interface. And maybe in the process of trying to implement it well,
you'll find something suboptimal about the interface that can be
fixed.

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

So maybe we should look into vDSO'ing getrandom(), if this is a problem
for real use cases, and you find that these sorts of things are
widespread in real code?

> > You miss out on this with arc4random, and if that information _is_ to be
> > exported to userspace somehow in the future, it would be awfully nice to
> > design the userspace interface alongside the kernel one.
> 
> What is the kernel interface you are talking about?  From an interface
> standpoint, arc4random_buf and getrandom are very similar, with the main
> difference is that arc4random_buf cannot report failure (except by
> terminating the process).

Referring to information above about reseeding. So in this case it would
be some form of a generation counter most likely. There's also been some
discussion about exporting some aspect of the vmgenid counter to
userspace.

> > Seen from this perspective, going with OpenBSD's older paradigm might be
> > rather limiting. Why not work together, between the kernel and libc, to
> > see if we can come up with something better, before settling on an
> > interface with semantics that are hard to walk back later?
> 
> Historically, kernel developers were not interested in solving some of
> the hard problems (especially early seeding) that prevent the use of
> getrandom during early userspace stages.

I really don't know what you're talking about here. I understood you up
until the opening parenthesis, and initially thought to reply, "but I am
interested! let's work together" or something, but then you mentioned
getrandom()'s issues with early userspace, and I became confused. If you
use getrandom(GRND_INSECURE), it won't block and you'll get bytes even
before the rng has seeded. If you use getrandom(0), the kernel's RNG
will use jitter to seed itself ASAP so it doesn't block forever (on
platforms where that's possible, anyhow). Both of these qualities mostly
predate my heavy involvement. So your statement confuses me. But with
that said, if you do find some lack of interest on something you think
is important, please give me a try, and maybe you'll have better luck. I
very much am interested in solving longstanding problems in this domain.

> > As-is, it's hard to recommend that anybody really use these functions.
> > Just keep using getrandom(2), which has mostly favorable semantics.
> 
> Some applications still need to run in configurations where getrandom is
> not available (either because the kernel is too old, or because it has
> been disabled via seccomp).

I don't quite understand this. People without getrandom() typically
fallback to using /dev/urandom. "But what if FD in derp derp mountns
derp rlimit derp explosion derp?!" Yes, sure, which is why getrandom()
came about. But doesn't arc4random() fallback to using /dev/urandom in
this exact same way? I don't see how arc4random() really changes the
equation here, except that maybe I should amend my statement to say,
"Just keep using getrandom(2) or /dev/urandom, which has mostly
favorable semantics." (After all, I didn't see any wild-n-crazy fallback
to AT_RANDOM like what systemd does with random-util.c:
https://github.com/systemd/systemd/blob/main/src/basic/random-util.c )

Seen in that sense, as I wrote to Paul, if you're after arc4random for
source code compatibility -- or because you simply like its non-failing
interface and want to commit to that no matter the costs whatsoever --
then you could start by making that a light shim around getrandom()
(falling back to /dev/urandom, I guess), and then we can look into ways
of accelerating getrandom() for new kernels. This way you don't ship
something broken out of the gate, and there's still room for
improvement. Though I would still note that committing to the interface
early like this comes with some concern.

> The performance numbers suggest that we benefit from buffering in user
> space.

The question is whether it's safe and advisable to buffer this way in
userspace. Does userspace have the right information now of when to
discard the buffer and get a new one? I suspect it does not.

> But that's an implementation detail, and something we can revisit later.

No, these are not mere implementation details. When Adhemerval is
talking about warning people in the documentation that this shouldn't be
used for crypto, that should be a wake up call that something is really
off here. Don't ship things you know are broken, and then call that an
"implementation detail" that can be hedged with "documentation".

If a new function, extra_deluxe_memset(), occasionally wrote a 0x41
somewhere unexpected, you'd laugh if somebody called that a mere
implementation detail and suggested you just slap a warning in the
documentation and call it a day.

Jason
