Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C147C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 13:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiGYNoF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 09:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiGYNoE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 09:44:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7CD14087
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 06:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C29F611A0
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 13:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A566AC341C8;
        Mon, 25 Jul 2022 13:44:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XQBx4LOT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658756640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AG11N0Y5v/Ga0BAI+4g6BjVFtpxQXboL806YdotF2JQ=;
        b=XQBx4LOTDp1Gyd76UisM1cYsW3HzIMhdRk+CRDggLJCLFxFsT5h9fW+49KQ5FVZj+MWZzy
        EsM5bwAgsQtwlMv/2vL6GchkXCUfPzT+zdaK7YoKxTlse7+9MxlqwCJOqZmcXXv/9tT1Tb
        WPacpp93BBSwYY0qI/ltsSu17HRw2FM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 32291690 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 25 Jul 2022 13:43:59 +0000 (UTC)
Date:   Mon, 25 Jul 2022 15:43:57 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>,
        Yann Droneaud <ydroneaud@opteya.com>, Michael@phoronix.com,
        linux-crypto@vger.kernel.org, jann@thejh.net
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Yt6eHfnlEN8ViWrA@zx2c4.com>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com>
 <Yt54x7uWnsL3eZSx@zx2c4.com>
 <87v8rlqscj.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87v8rlqscj.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Florian,

On Mon, Jul 25, 2022 at 02:39:24PM +0200, Florian Weimer wrote:
> Below you suggest to use GRND_INSECURE to avoid deadlocks during
> booting.  It's documented in the UAPI header as “Return
> non-cryptographic random bytes”.  I assume it's broadly equivalent to
> reading from /dev/urandom (which we need to support for backwards
> compatibility, and currently use to avoid blocking).  This means that we
> cannot really document the resulting bits as cryptographically strong
> from an application perspective because the kernel is not willing to
> make this commitment.
> Regarding the technical aspect, GRND_INSECURE is somewhat new-ish, but
> as I wrote above, it's UAPI documentation is a bit scary.  Maybe it
> would be possible to clarify this in the manual pages a bit?  I *assume*
> that if we are willing to read from /dev/urandom, we can use
> GRND_INSECURE right away to avoid that fallback path on sufficiently new
> kernels.  But it would be nice to have confirmation.

getrandom(GRND_INSECURE) is the same as getrandom(0), except before the
RNG is seeded, in which case the former will return ~garbage randomness
while the latter will block. The only current difference between
getrandom(GRND_INSECURE) and /dev/urandom is the latter will try for a
second to do the jitter entropy thing if the RNG isn't seeded yet.

I agree that the documentation around this is really bad. Actually, so
much of the documentation is out of date or confusing. Thanks for the
kick on this: I really do need to rewrite that / clean it up.

So with my random.c maintainer hat on: getrandom(GRND_INSECURE) will
return the same "quality" randomness as getrandom(0), except before
the RNG is initialized. I'll fix up the docs for that, but feel free to
refer to this statement ahead of that if you need.

Code-wise, the only relevant branch related to GRND_INSECURE is:

	if (!crng_ready() && !(flags & GRND_INSECURE)) {
		if (flags & GRND_NONBLOCK)
			return -EAGAIN;
		ret = wait_for_random_bytes();
		if (unlikely(ret))
			return ret;
	}

That means: if it's not ready, and you didn't pass _INSECURE, and you
didn't pass _NONBLOCK, then wait for the RNG to be ready, and error out
if that's interrupted by a signal. Other than that one block, it
continues on to do the same thing as getrandom(0).

With that said, however, I think it'd be nice if you used only blocking
randomness, and shove the initialization problem at init systems and
bootloaders and such. In 5.20, for example, there'll be an x86 boot
protocol for GRUB and kexec and hypervisors and such to pass a seed, and
since a long time, there exists a device tree attribute for the same.
Proliferating "unsafe" /dev/urandom-style usage doesn't seem good for
the ecosystem at large. And I'm in general interest in seeing progress
on decades long initialization-time seeding concerns.

> > Sort of both, as I don't think it's wise to commit to the former without
> > a good idea of the full ideal space of the latter, and very clearly from
> > reading that discussion, that hasn't been explored.
> 
> But we are only concerned with the application interface.  Do we really
> expect that to be different from arc4random_buf and its variants?
> 
> The interface between glibc and the kernel can be changed without
> impacting applications.

I feel like you missed the whole thrust of my argument, in which I
caution against shipping something that's known-broken, particularly
when it pertains to something sensitive like generating secret keys.

Regarding the application interface: it's still unclear what's best
until we start trying to see what the implementation would look like.
Just to pick something floating around in my head now since reading your
last email: there seems to be some question about whether arc4random
should block or not. If it's used for crypto, it probably should. But
maybe you want an interface that doesn't. Perhaps that discussion leads
naturally to exposing a flag. Or not! And then there are related
questions about what the return value should be, if any. The point is
that the devil is often in the details with these things, and I worry
about putting the cart before the horse here.

> >> > You miss out on this with arc4random, and if that information _is_ to be
> >> > exported to userspace somehow in the future, it would be awfully nice to
> >> > design the userspace interface alongside the kernel one.
> >> 
> >> What is the kernel interface you are talking about?  From an interface
> >> standpoint, arc4random_buf and getrandom are very similar, with the main
> >> difference is that arc4random_buf cannot report failure (except by
> >> terminating the process).
> >
> > Referring to information above about reseeding. So in this case it would
> > be some form of a generation counter most likely. There's also been some
> > discussion about exporting some aspect of the vmgenid counter to
> > userspace.
> 
> We don't need any of that in userspace if the staging buffer is managed
> by the kernel, which is why the thread-specific data donation is so
> attractive as an approach.  The kernel knows where all these buffers are
> located and can invalidate them as needed.

There still might be a need for userspace to have that information, for
network protocol implementations that need to drop their ephemeral keys
on a virtual machine fork, for example. But that's kind of a different
discussion. For the purposes of a vDSO'd getrandom(), I agree that the
kernel managing a buffer that's just an opaque blob to userspace is
probably the best option.

> I tried to de-escalate here, and clearly that didn't work.  The context
> here is that historically, working with the “random” kernel maintainers
> has been very difficult for many groups of people.  Many of us are tired
> of those non-productive discussions.  I forgot that this has recently
> changed on the kernel side.  I understand that it's taking years to
> overcome these perceptions.  glibc is still struggling with this, too.

Oh, I see what you're getting at. Yea, sure, things are potentially
different now. I'm eager to work on this, so if you're finding things
that are lacking, I'm all ears for fixing them.

> I had some patches with AT_RANDOM fallback, including overwriting
> AT_RANDOM with output from the seeded PRNG.  It's certainly messy.  I
> probably didn't bother to post these patches given how bizarre the whole
> thing was.  I did have fallback to CPU instructions, but that turned out
> to be unworkable due to bugs in suspend on AMD CPUs (kernel or firmware,
> unclear).

Yea, it's kind of tricky as other things might be using AT_RANDOM also
and then you have a whole race issue and domain separation and whatnot.
The thing in systemd isn't really good for crypto -- no forward secrecy
and such -- but it's ostensibly better than random().

> The ChaCha20 generator we currently have in the tree may not be
> required, true.  But this doesn't make what we have today “broken”, it's
> merely overly complicated.  And replacing that with a straight buffer
> from getrandom does not change the external interface, so we can do this
> any time we want.

Whether you use chacha20 in a fast key erasure construction, or you
buffer lots of bytes of getrandom() that you overwrite with zeros as you
use doesn't really matter in the sense that these are both just forms of
buffering. With the chacha20 one, you're reseeding after 16 megs, but of
course the state is smaller, but that doesn't matter. For purposes here,
we may as well treat that as buffering 16 megs of getrandom() output. My
concern with this buffering is that userspace doesn't know when to
invalidate the buffer. So a userspace that's using arc4random() for
crypto will potentially be missing something *important* that a
userspace who used getrandom() instead would have.

When I brought this up with Adhemerval, his reply was that it doesn't
matter anyway because arc4random() is going to be documented as not for
cryptography. So it sounded like the author of it finds it worse too. So
yikes.

The whole point is that you shouldn't ship something sensitive that is
worse than what it will potentially replace, right out of the gate. Slow
down and get the thing right, and then ship it.

> Not completely, no, but we can cover many cases.  I do not currently see
> a way around that if we want to promote arc4random_uniform(limit) as a
> replacement for random() % limit.

I agree that the rejection sampling is the most useful function being
added. Let's say, just for the sake of argument, that you instead added
`getrandom_u{64,32,16,8}_uniform(u_type limit, unsigned long flags)`
that expanded to doing `getrandom(&integer, flags)` and then rejection
sampling on that in a loop like usual. It wouldn't be super great, so
the first optimization would be to observe that the cost of 32 bytes and
the cost of 4 bytes is the same, so you just grab 32 bytes at a time,
which basically guarantees you'll get a good number when rejection
sampling.  Alright, fine, but then maybe you want to use it for
shuffling, and then we have your syscall overhead measurements. But
that's where the vDSO approach comes into play for making it fast. Old
systems would have something work that's still safe. New systems would
have something work that's safe and fast. Nobody gets something less
safe. (As a sidenote, notice how my hypothetical API gives larger types
than arc4random_uniform's fixed u32, just sayin'.)

Now, spitballing new APIs is kind of besides the point here, as there
are 100 different ways to bikeshed that, but what I'm trying to suggest
is that there's a way of adding what you want to libc without reducing
the quality of it for users, right from the beginning. So why not start
out conservatively?

Or, if you insist on providing these functions t o d a y, and won't heed
my warnings about designing the APIs alongside the implementations, then
just make them thin wrappers over getrandom(0) *without* doing fancy
buffering, and then optimizations later can improve it. That would be
the incremental approach, which wouldn't harm potential users. It also
wouldn't shut the door on doing the buffering: if the kernel
optimization improvements go nowhere, and you decide it's a lost cause,
you can always change the way it works later, and make that decision
then.

Jason
