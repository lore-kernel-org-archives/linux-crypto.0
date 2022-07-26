Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB75C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiGZLyd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbiGZLyc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:54:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ED332ECB
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B094CE18B3
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 11:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D732C341C0;
        Tue, 26 Jul 2022 11:54:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pHl5iOCG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658836465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RCcDm1inqscdCZ0kuiwrUcRWiQAtJpqFQW8qiaALFfM=;
        b=pHl5iOCGhWtD4KuiVcMrv1y/hdC9HZQfUywi8E7ogNYIpcWR4VA41SPwWdb5oL4PIqe2xn
        JC2LRZalDvcZ/DtJ3vvaNzihA3qEgcJC6NvE4/ZvfbKT4Psve7YR4jm6D1H6pm7/aza+3j
        ZrzFf05sQ3VQm4h4T381XHFMN6DloMI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ecf83883 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 11:54:25 +0000 (UTC)
Date:   Tue, 26 Jul 2022 13:54:23 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/V78eyHIG/kms3@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <9c576e6b-77c9-88c5-50a3-a43665ea5e93@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c576e6b-77c9-88c5-50a3-a43665ea5e93@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Adhemerval,

Thanks for your review.

On Tue, Jul 26, 2022 at 08:33:23AM -0300, Adhemerval Zanella Netto wrote:
> Ther are some missing pieces, like sysdeps/unix/sysv/linux/tls-internal.h comment,
> sysdeps/generic/tls-internal-struct.h generic piece (it is used on hurd build),
> maybe also change the NEWS to state this is not a CSPRNG, and we definitely need
> to update the manual. Some comments below.

I think Eric already pointed those out, and they're fixed in v3 now.
PTAL.

> > +  static bool have_getrandom = true, seen_initialized = false;
> > +  int fd;
> 
> I think it should reasonable to assume that getrandom syscall will be always
> supported and using arc4random in an enviroment with filtered getrandom does
> not make much sense.  We are trying to avoid add this static syscall checks
> where possible,

I don't know glibc's requirements for kernels, though I do know that
it'd be nice to not have to write this fallback code in every program I
write and just use libc's thing. So in that sense, having the fallback
to /dev/urandom makes arc4random_buf a lot more useful. But with that
said, yea, maybe we shouldn't care about old kernels? getrandom is now
quite old and the stable kernels on kernel.org all have it.

From my perspective, I don't have a strongly developed opinion on what
makes sense for glibc. If Florian agrees with you, I'll send a v+1 with
the fallback code removed. If it's contentious, maybe the fallback code
should stay in and we can slate it for removal on another day, when the
minimum glibc kernel version gets raised or something like that.

> also plain load/store to se the static have_getrandom
> is strickly a race-condition, although it should not really matter (we use
> relaxed load/store in such optimization (check
> sysdeps/unix/sysv/linux/mips/mips64/getdents64.c).

I was aware of the race but figured it didn't matter, since two racing
threads will both set it to the same result eventually. But I didn't
know about the convention of using those relaxed wrapper functions.
Thanks for the tip. I'll do that for v4.

> Also, does it make sense to fallback if we build for a kernel that should
> always support getrandom?

I guess only if syscall filtering is a concern. But if not, then maybe
yea? We could do this in a follow-up commit, or I could do this in v4.
Would `#if __LINUX_KERNEL_VERSION >` be the right mechanism to use here?
If so, I think the way I'd implement that would be:

diff --git a/stdlib/arc4random.c b/stdlib/arc4random.c
index 978bf9287f..a33d9ff2c5 100644
--- a/stdlib/arc4random.c
+++ b/stdlib/arc4random.c
@@ -44,8 +44,10 @@ __arc4random_buf (void *p, size_t n)
     {
       ssize_t l;

+#if __LINUX_KERNEL_VERSION < something
       if (!atomic_load_relaxed (&have_getrandom))
 	break;
+#endif

       l = __getrandom_nocancel (p, n, 0);
       if (l > 0)
@@ -60,11 +62,13 @@ __arc4random_buf (void *p, size_t n)
 	arc4random_getrandom_failure (); /* Weird, should never happen. */
       else if (l == -EINTR)
 	continue; /* Interrupted by a signal; keep going. */
+#if __LINUX_KERNEL_VERSION < something
       else if (l == -ENOSYS)
 	{
 	  atomic_store_relaxed (&have_getrandom, false);
 	  break; /* No syscall, so fallback to /dev/urandom. */
 	}
+#endif
       arc4random_getrandom_failure (); /* Unknown error, should never happen. */
     }

And then arc4random_getrandom_failure() being a noreturn function would
make gcc optimize out the rest.

Does that seem like a good approach?

> > +      l = __getrandom_nocancel (p, n, 0);
> 
> Do we need to worry about a potentially uncancellable blocking call here? I guess
> using GRND_NONBLOCK does not really help.

No, generally not. Also, keep in mind that getrandom(0) will trigger
jitter entropy if the kernel isn't already initialized.

> 
> > +      if (l > 0)
> > +	{
> > +	  if ((size_t) l == n)
> 
> Do we need the cast here?

Generally it's frowned upon to have implicit signed conversion, right? l
is signed while n is unsigned.

> 
> > +	    return; /* Done reading, success. */
> 
> Minor style issue: use double space before period.

I was really confused by this, and then opened up some other files and
saw you meant *after* period. :) Will do for v4.

> As Florian said we will need a non cancellable poll here.  Since you are setting
> the timeout as undefined, I think it would be simple to just add a non cancellable
> wrapper as:
> 
>   int __ppoll_noncancel_notimeout (struct pollfd *fds, nfds_t nfds)
>   {
>   #ifndef __NR_ppoll_time64
>   # define __NR_ppoll_time64 __NR_ppoll
>   #endif
>      return INLINE_SYSCALL_CALL (__NR_ppoll_time64, fds, nfds, NULL, NULL, 0);
>   }
> 
> So we don't need to handle the timeout for 64-bit time_t wrappers.

Oh that sounds like a good solution to the time64 situation. I'll do
that for v4... BUT, I already implemented possibly the wrong solution
for v3. Could you take a look at what I did there and confirm that it's
wrong? If so, then I'll do exactly what you suggested here.

Thanks again for the review,
Jason
