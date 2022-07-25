Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44340C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 12:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiGYMkN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 08:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbiGYMjm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 08:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14CD71581A
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 05:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658752771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxn8fNWza/kOfi94lcpabW9YrbbQrqEyUBf7rBmD7zI=;
        b=E4bTUSQ0u9AOxUn9LwsMb6LnIu3PjGtMJk+X2ABO6qNW/O9rA810DeXd5EXLZsg4qctpQA
        fzLGkH5Z9dEuAF0rzPJ+TuNUmeX8d6nz6axKXxSKBg2AAQDtm+h/PnzEkKLzOFyVTYR7IU
        KJs2hPFrCE38MbPTizp+ZJob/3PlG38=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-7c4goAEqObKkS5jDxlGLDA-1; Mon, 25 Jul 2022 08:39:28 -0400
X-MC-Unique: 7c4goAEqObKkS5jDxlGLDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 160843C10142;
        Mon, 25 Jul 2022 12:39:28 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DAC02166B2A;
        Mon, 25 Jul 2022 12:39:26 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Yann Droneaud <ydroneaud@opteya.com>, Michael@phoronix.com,
        linux-crypto@vger.kernel.org, jann@thejh.net
Subject: Re: arc4random - are you sure we want these?
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
        <87bktdsdrk.fsf@oldenburg.str.redhat.com> <Yt54x7uWnsL3eZSx@zx2c4.com>
Date:   Mon, 25 Jul 2022 14:39:24 +0200
In-Reply-To: <Yt54x7uWnsL3eZSx@zx2c4.com> (Jason A. Donenfeld via Libc-alpha's
        message of "Mon, 25 Jul 2022 13:04:39 +0200")
Message-ID: <87v8rlqscj.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Jason A. Donenfeld via Libc-alpha:

> Hi Florian,
>
> On Mon, Jul 25, 2022 at 12:11:27PM +0200, Florian Weimer wrote:
>> > I really wonder whether this is a good idea, whether this is something
>> > that glibc wants, and whether it's a design worth committing to in the
>> > long term.
>>=20
>> Do you object to the interface, or the implementation?
>>=20
>> The implementation can be improved easily enough at a later date.
>
> Sort of both, as I don't think it's wise to commit to the former without
> a good idea of the full ideal space of the latter, and very clearly from
> reading that discussion, that hasn't been explored.

But we are only concerned with the application interface.  Do we really
expect that to be different from arc4random_buf and its variants?

The interface between glibc and the kernel can be changed without
impacting applications.

> In particular, Adhemerval has said you won't be committing to making
> arc4random suitable for crypto, going so far as to mention it's not a
> CSPRNG in the documentation.

Below you suggest to use GRND_INSECURE to avoid deadlocks during
booting.  It's documented in the UAPI header as =E2=80=9CReturn
non-cryptographic random bytes=E2=80=9D.  I assume it's broadly equivalent =
to
reading from /dev/urandom (which we need to support for backwards
compatibility, and currently use to avoid blocking).  This means that we
cannot really document the resulting bits as cryptographically strong
from an application perspective because the kernel is not willing to
make this commitment.

>> > Firstly, for what use cases does this actually help? As of recent
>> > changes to the Linux kernels -- now backported all the way to 4.9! --
>> > getrandom() and /dev/urandom are extremely fast and operate over per-c=
pu
>> > states locklessly. Sure you avoid a syscall by doing that in userspace,
>> > but does it really matter? Who exactly benefits from this?
>>=20
>> getrandom may be fast for bulk generation.  It's not that great for
>> generating a few bits here and there.  For example, shuffling a
>> 1,000-element array takes 18 microseconds with arc4random_uniform in
>> glibc, and 255 microseconds with the na=C3=AFve getrandom-based
>> implementation (with slightly biased results; measured on an Intel
>> i9-10900T, Fedora's kernel-5.18.11-100.fc35.x86_64).
>
> So maybe we should look into vDSO'ing getrandom(), if this is a problem
> for real use cases, and you find that these sorts of things are
> widespread in real code?

We can investigate that, but it doesn't change the application
interface.

>> > You miss out on this with arc4random, and if that information _is_ to =
be
>> > exported to userspace somehow in the future, it would be awfully nice =
to
>> > design the userspace interface alongside the kernel one.
>>=20
>> What is the kernel interface you are talking about?  From an interface
>> standpoint, arc4random_buf and getrandom are very similar, with the main
>> difference is that arc4random_buf cannot report failure (except by
>> terminating the process).
>
> Referring to information above about reseeding. So in this case it would
> be some form of a generation counter most likely. There's also been some
> discussion about exporting some aspect of the vmgenid counter to
> userspace.

We don't need any of that in userspace if the staging buffer is managed
by the kernel, which is why the thread-specific data donation is so
attractive as an approach.  The kernel knows where all these buffers are
located and can invalidate them as needed.

>> > Seen from this perspective, going with OpenBSD's older paradigm might =
be
>> > rather limiting. Why not work together, between the kernel and libc, to
>> > see if we can come up with something better, before settling on an
>> > interface with semantics that are hard to walk back later?
>>=20
>> Historically, kernel developers were not interested in solving some of
>> the hard problems (especially early seeding) that prevent the use of
>> getrandom during early userspace stages.
>
> I really don't know what you're talking about here. I understood you up
> until the opening parenthesis, and initially thought to reply, "but I am
> interested! let's work together" or something, but then you mentioned
> getrandom()'s issues with early userspace, and I became confused. If you
> use getrandom(GRND_INSECURE), it won't block and you'll get bytes even
> before the rng has seeded. If you use getrandom(0), the kernel's RNG
> will use jitter to seed itself ASAP so it doesn't block forever (on
> platforms where that's possible, anyhow). Both of these qualities mostly
> predate my heavy involvement. So your statement confuses me. But with
> that said, if you do find some lack of interest on something you think
> is important, please give me a try, and maybe you'll have better luck. I
> very much am interested in solving longstanding problems in this domain.

I tried to de-escalate here, and clearly that didn't work.  The context
here is that historically, working with the =E2=80=9Crandom=E2=80=9D kernel=
 maintainers
has been very difficult for many groups of people.  Many of us are tired
of those non-productive discussions.  I forgot that this has recently
changed on the kernel side.  I understand that it's taking years to
overcome these perceptions.  glibc is still struggling with this, too.

Regarding the technical aspect, GRND_INSECURE is somewhat new-ish, but
as I wrote above, it's UAPI documentation is a bit scary.  Maybe it
would be possible to clarify this in the manual pages a bit?  I *assume*
that if we are willing to read from /dev/urandom, we can use
GRND_INSECURE right away to avoid that fallback path on sufficiently new
kernels.  But it would be nice to have confirmation.

>> > As-is, it's hard to recommend that anybody really use these functions.
>> > Just keep using getrandom(2), which has mostly favorable semantics.
>>=20
>> Some applications still need to run in configurations where getrandom is
>> not available (either because the kernel is too old, or because it has
>> been disabled via seccomp).
>
> I don't quite understand this. People without getrandom() typically
> fallback to using /dev/urandom. "But what if FD in derp derp mountns
> derp rlimit derp explosion derp?!" Yes, sure, which is why getrandom()
> came about. But doesn't arc4random() fallback to using /dev/urandom in
> this exact same way? I don't see how arc4random() really changes the
> equation here, except that maybe I should amend my statement to say,
> "Just keep using getrandom(2) or /dev/urandom, which has mostly
> favorable semantics." (After all, I didn't see any wild-n-crazy fallback
> to AT_RANDOM like what systemd does with random-util.c:
> https://github.com/systemd/systemd/blob/main/src/basic/random-util.c )

I had some patches with AT_RANDOM fallback, including overwriting
AT_RANDOM with output from the seeded PRNG.  It's certainly messy.  I
probably didn't bother to post these patches given how bizarre the whole
thing was.  I did have fallback to CPU instructions, but that turned out
to be unworkable due to bugs in suspend on AMD CPUs (kernel or firmware,
unclear).

> Seen in that sense, as I wrote to Paul, if you're after arc4random for
> source code compatibility -- or because you simply like its non-failing
> interface and want to commit to that no matter the costs whatsoever --
> then you could start by making that a light shim around getrandom()
> (falling back to /dev/urandom, I guess), and then we can look into ways
> of accelerating getrandom() for new kernels. This way you don't ship
> something broken out of the gate, and there's still room for
> improvement. Though I would still note that committing to the interface
> early like this comes with some concern.

The ChaCha20 generator we currently have in the tree may not be
required, true.  But this doesn't make what we have today =E2=80=9Cbroken=
=E2=80=9D, it's
merely overly complicated.  And replacing that with a straight buffer
from getrandom does not change the external interface, so we can do this
any time we want.

>> The performance numbers suggest that we benefit from buffering in user
>> space.
>
> The question is whether it's safe and advisable to buffer this way in
> userspace. Does userspace have the right information now of when to
> discard the buffer and get a new one? I suspect it does not.

Not completely, no, but we can cover many cases.  I do not currently see
a way around that if we want to promote arc4random_uniform(limit) as a
replacement for random() % limit.

>> But that's an implementation detail, and something we can revisit later.
>
> No, these are not mere implementation details. When Adhemerval is
> talking about warning people in the documentation that this shouldn't be
> used for crypto, that should be a wake up call that something is really
> off here. Don't ship things you know are broken, and then call that an
> "implementation detail" that can be hedged with "documentation".

Again, given the issues around GRND_INSECURE (the reason why it exists),
we do not have much choice on the glibc side.  And these issues will be
there for the foreseeable future, whether glibc provides arc4random or
not.

Thanks,
Florian

