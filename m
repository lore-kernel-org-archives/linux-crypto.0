Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7181C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jul 2022 22:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiGWWyY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Jul 2022 18:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiGWWyY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Jul 2022 18:54:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331BC11A10
        for <linux-crypto@vger.kernel.org>; Sat, 23 Jul 2022 15:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB4360A10
        for <linux-crypto@vger.kernel.org>; Sat, 23 Jul 2022 22:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F28C341C7;
        Sat, 23 Jul 2022 22:54:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fqbb6y3I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658616859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWMmAo22EYiZuPFYb8HVcCr9sF9ushmGCG7QgaQQovU=;
        b=fqbb6y3Il5eGkcJz3f/k1LkhQnUlDhN8tIBE6szPUybV0RrCcejg2NoJGzKJR2Z9Jg9vMW
        0cWPEnN5kk0CpzRMnuoARjs6lZOIVpeicHMMo/7dLzoD0VbEy7N56fBRzZOpiMIMgFTreC
        0HLh4lwbrvsR4vL27Bx9xDH4Vo4XAzI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dac4b17f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 23 Jul 2022 22:54:19 +0000 (UTC)
Date:   Sun, 24 Jul 2022 00:54:16 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, Paul Eggert <eggert@cs.ucla.edu>,
        linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Ytx8GKSZfRt+ZrEO@zx2c4.com>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Adhemerval,

Thanks for your reply.

On Sat, Jul 23, 2022 at 02:39:29PM -0300, Adhemerval Zanella Netto wrote:
> > Firstly, for what use cases does this actually help? As of recent
> > changes to the Linux kernels -- now backported all the way to 4.9! --
> > getrandom() and /dev/urandom are extremely fast and operate over per-cpu
> > states locklessly. Sure you avoid a syscall by doing that in userspace,
> > but does it really matter? Who exactly benefits from this?
> 
> Mainly performance, since glibc both export getrandom and getentropy. 

Okay so your motivation is performance. But can you tell me what your
performance goals actually are? All kernel.org stable kernels from 4.9
and upwards now have really fast per-cpu lockless implementations of
getrandom() and /dev/urandom. If your goal is performance, I would be
very, very interested to find out a circumstance where this is
insufficient.

> There were some discussion on maillist and we also decided to explicit
> state this is not a CSRNG on our documentation.

Okay that's all the more reason why this is a completely garbage
endeavor. Sorry for the strong language, but the last thing anybody
needs is another PRNG that's "half way" between being good for crypto
and not. If it's not good for crypto, people will use it anyway,
especially since you're winking at them saying, "oh but actually
chacha20 is fine technically so....", and then fast-forward a few years
when you realize you can lean on your non-crypto commitment and make
things different. Never underestimate the power of a poorly defined
function definition. If your goal isn't to make a real CSPRNG, why make
this kind of thing at all?

And it's especially ridiculous since the OpenBSD arc4random *is* used
for crypto. So now you've really muddied the waters. (And naturally the
OpenBSD arc4random was done in conjunction with their kernel
development, since the same people work on both, which isn't what's
happened here.)

So your "it's a CSPRNG wink wink but the documentation says not, so
actually we're off the hook for doing this well" is a cop-out that will
lead to trouble.

Going back to my original point: what are the performance requirements
that point toward a userspace RNG being required here? If it's not
actually necessary, then let's not do this. If it is necessary for some
legitimate widespread reason, then let's do this right, and actually
make something you're comfortable calling cryptographically secure. And
let's get this right from the beginning, so that the new interface
doesn't come with all sorts of caveats, "this is safe for glibc ≥ 
4.3.2.1 only", or whatever else.

Again, I'm not adverse to the general concept. I just haven't seen
anything really justifying adding the complexity for it. And then
assuming that justification does exist somewhere, this approach doesn't
seem to be a particularly well planned one. As soon as you find yourself
reaching for the "documentation cop-out", something has gone amiss.

> The vDSO approach would be good think and if even the kernel provides it
> I think it would feasible to wire-up arc4random to use it if the  underlying
> kernel supports it.

So if you justify the performance requirement, wouldn't it make more
sense to just back getrandom() itself with a vDSO call? So that way,
kernels with that get bits faster (but by how much, really? c'mon...),
and kernels without it have things as normal as possible.

If your concern is instances in which getrandom() can fail, I'd like to
here what those concerns are so that interface can be fixed and
improved.

> But in the end I think if we are clear about in on the documentation,
> and provide alternative when the users are aware of the limitation, I do
> not think it is bad decision.

This really strikes me as an almost comically ominous expectation.
Design interfaces that don't have dangerous pitfalls. While
documentation might somehow technically absolve you of responsibility,
it doesn't actually help make the ecosystem safer by providing optimal
interfaces that don't have cop outs.

Anyway, to reiterate:

- Can you show me some concerning performance numbers on the current
  batch of kernel.org stable kernels, and the use cases for which those
  numbers are concerning, and how widespread you think those use cases
  are?

- If this really *is* necessary for some reason, can we do it well out
  of the gate, with good coordination between kernel and userland,
  instead of half-assing it initially and covering that up with a
  documentation note?

Jason
