Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBEAC00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 15:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbiGZPV1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiGZPV1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 11:21:27 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [IPv6:2a01:e0c:1:1599::13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5436925287
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 08:21:25 -0700 (PDT)
Received: from [IPV6:2a01:e35:39f2:1220:a31f:dd28:d78d:59ef] (unknown [IPv6:2a01:e35:39f2:1220:a31f:dd28:d78d:59ef])
        by smtp4-g21.free.fr (Postfix) with ESMTPS id 476BF19F730;
        Tue, 26 Jul 2022 17:21:19 +0200 (CEST)
Message-ID: <9f280b52-995e-559c-3ecf-d4b9119c7af7@opteya.com>
Date:   Tue, 26 Jul 2022 17:21:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] arc4random: simplify design for better safety
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org
Cc:     Florian Weimer <fweimer@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220726133049.1145913-1-Jason@zx2c4.com>
From:   Yann Droneaud <ydroneaud@opteya.com>
Organization: OPTEYA
In-Reply-To: <20220726133049.1145913-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le 26/07/2022 à 15:30, Jason A. Donenfeld via Libc-alpha a écrit :
> Rather than buffering 16 MiB of entropy in userspace (by way of
> chacha20), simply call getrandom() every time.


I dislike the wording because

1) the current buffer is only 512 bytes, not 16MiBytes;
2) implementation reads only 48 bytes of "fresh" entropy from 
getrandom() each 16MiBytes generated.

I'm thinking "stirring" or "streaming" would better describe what's 
happening:

"Rather than stirring 16MiB of random data in userspace before reseeding"


> This approach is doubtlessly slower, for now, but trying to prematurely
> optimize arc4random appears to be leading toward all sorts of nasty
> properties and gotchas. Instead, this patch takes a much more
> conservative approach. The interface is added as a basic loop wrapper
> around getrandom(), and then later, the kernel and libc together can
> work together on optimizing that.
>
> This prevents numerous issues in which userspace is unaware of when it
> really must throw away its buffer, since we avoid buffering all
> together.


I believe the cloned virtual machine issue should be explicitly 
described as a major blocker in the commit message.


> Future improvements may include userspace learning more from
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
> after the "blocking pool", not before, and it may not port back to all
> ancient kernels, but it does to a decent swath of them, so generally
> it's the best approximation we can do.
>
> The motivation for including arc4random, in the first place, is to have
> source-level compatibility with existing code. That means this patch
> doesn't attempt to litigate the interface itself. It does, however,
> choose a conservative approach for implementing it.


Sure arc4random() interface is inherited from *BSD, thus we're not free 
to improve it. But arc4random() is already here in glibc git, thus I 
think the paragraph is of dubious value in the commit message and can be 
removed.


> Cc: Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
> Cc: Florian Weimer <fweimer@redhat.com>
> Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
> Cc: Paul Eggert <eggert@cs.ucla.edu>
> Cc: Mark Harris <mark.hsj@gmail.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>   LICENSES                                      |  23 -
>   NEWS                                          |   4 +-
>   include/stdlib.h                              |   3 -
>   manual/math.texi                              |  13 +-
>   stdlib/Makefile                               |   2 -
>   stdlib/arc4random.c                           | 205 ++-----
>   stdlib/arc4random.h                           |  48 --
>   stdlib/chacha20.c                             | 191 ------
>   stdlib/tst-arc4random-chacha20.c              | 167 -----
>   sysdeps/aarch64/Makefile                      |   4 -
>   sysdeps/aarch64/chacha20-aarch64.S            | 314 ----------
>   sysdeps/aarch64/chacha20_arch.h               |  40 --
>   sysdeps/generic/tls-internal-struct.h         |   1 -
>   sysdeps/generic/tls-internal.c                |  10 -
>   sysdeps/mach/hurd/_Fork.c                     |   2 -
>   sysdeps/mach/hurd/kernel-features.h           |   1 +
>   sysdeps/nptl/_Fork.c                          |   2 -
>   .../powerpc/powerpc64/be/multiarch/Makefile   |   4 -
>   .../powerpc64/be/multiarch/chacha20-ppc.c     |   1 -
>   .../powerpc64/be/multiarch/chacha20_arch.h    |  42 --
>   sysdeps/powerpc/powerpc64/power8/Makefile     |   5 -
>   .../powerpc/powerpc64/power8/chacha20-ppc.c   | 256 --------
>   .../powerpc/powerpc64/power8/chacha20_arch.h  |  37 --
>   sysdeps/s390/s390-64/Makefile                 |   6 -
>   sysdeps/s390/s390-64/chacha20-s390x.S         | 573 ------------------
>   sysdeps/s390/s390-64/chacha20_arch.h          |  45 --
>   sysdeps/unix/sysv/linux/Makefile              |   3 +-
>   sysdeps/unix/sysv/linux/Versions              |   1 +
>   sysdeps/unix/sysv/linux/kernel-features.h     |   7 +
>   sysdeps/unix/sysv/linux/not-cancel.h          |   6 +
>   .../sysv/linux/ppoll_nocancel.c}              |  19 +-
>   sysdeps/unix/sysv/linux/tls-internal.c        |  10 -
>   sysdeps/unix/sysv/linux/tls-internal.h        |   1 -
>   sysdeps/x86_64/Makefile                       |   7 -
>   sysdeps/x86_64/chacha20-amd64-avx2.S          | 328 ----------
>   sysdeps/x86_64/chacha20-amd64-sse2.S          | 311 ----------
>   sysdeps/x86_64/chacha20_arch.h                |  55 --
>   37 files changed, 89 insertions(+), 2658 deletions(-)
>   delete mode 100644 stdlib/arc4random.h
>   delete mode 100644 stdlib/chacha20.c
>   delete mode 100644 stdlib/tst-arc4random-chacha20.c
>   delete mode 100644 sysdeps/aarch64/chacha20-aarch64.S
>   delete mode 100644 sysdeps/aarch64/chacha20_arch.h
>   delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/Makefile
>   delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/chacha20-ppc.c
>   delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/chacha20_arch.h
>   delete mode 100644 sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c
>   delete mode 100644 sysdeps/powerpc/powerpc64/power8/chacha20_arch.h
>   delete mode 100644 sysdeps/s390/s390-64/chacha20-s390x.S
>   delete mode 100644 sysdeps/s390/s390-64/chacha20_arch.h
>   rename sysdeps/{generic/chacha20_arch.h => unix/sysv/linux/ppoll_nocancel.c} (62%)
>   delete mode 100644 sysdeps/x86_64/chacha20-amd64-avx2.S
>   delete mode 100644 sysdeps/x86_64/chacha20-amd64-sse2.S
>   delete mode 100644 sysdeps/x86_64/chacha20_arch.h
>
> diff --git a/manual/math.texi b/manual/math.texi
> index 141695cc30..6d69bbff66 100644
> --- a/manual/math.texi
> +++ b/manual/math.texi
> @@ -1993,17 +1993,10 @@ This section describes the random number functions provided as a GNU
>   extension, based on OpenBSD interfaces.
>   
>   @Theglibc{} uses kernel entropy obtained either through @code{getrandom}
> -or by reading @file{/dev/urandom} to seed and periodically re-seed the
> -internal state.  A per-thread data pool is used, which allows fast output
> -generation.
> +or by reading @file{/dev/urandom} to seed.
>   
> -Although these functions provide higher random quality than ISO, BSD, and
> -SVID functions, these still use a Pseudo-Random generator and should not
> -be used in cryptographic contexts.
> -
> -The internal state is cleared and reseeded with kernel entropy on @code{fork}
> -and @code{_Fork}.  It is not cleared on either a direct @code{clone} syscall
> -or when using @theglibc{} @code{syscall} function.
> +These functions provide higher random quality than ISO, BSD, and SVID
> +functions, and may be used in cryptographic contexts.

+ "provided getrandom() and /dev/urandom() could be used in such 
context." ;)


Thanks for the improvements, can't wait for a vDSO getrandom() optimized 
for reading 1,2,4,8 bytes :)


Regards.


-- 

Yann Droneaud

OPTEYA


