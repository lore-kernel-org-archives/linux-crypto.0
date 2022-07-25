Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4560BC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 23:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiGYX23 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 19:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbiGYX22 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 19:28:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE7826AC8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F51B81017
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 23:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF19C341C8;
        Mon, 25 Jul 2022 23:28:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="signature verification failed" (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GoWB/xIH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658791697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uV5VrxWcC2hH6MO4Tk6VYP+mr1aAJ+h4lCHQZumZvIQ=;
        b=GoWB/xIHFLHi9ch8oOBVeh8sK3NqPH9rEvYEJn7Hgk00dt24NRq6bWNmRzxhboXlaq5C9+
        wnAYOGNOh3E0CF76Drw1PtAxuTC0w+XLWo6fpyuH71u7eVTDaq2+5vnon9zpPwVfjBDOe4
        jtjYBoLur+2KujJXUhlLZLhTbNIDV4g=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 64839b40 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 25 Jul 2022 23:28:16 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     libc-alpha@sourceware.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: [PATCH v2] arc4random: simplify design for better safety
Date:   Tue, 26 Jul 2022 01:28:10 +0200
Message-Id: <20220725232810.843433-1-Jason@zx2c4.com>
In-Reply-To: <20220725225728.824128-1-Jason@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rather than buffering 16 MiB of entropy in userspace (by way of
chacha20), simply call getrandom() every time.

This approach is doubtlessly slower, for now, but trying to prematurely
optimize arc4random appears to be leading toward all sorts of nasty
properties and gotchas. Instead, this patch takes a much more
conservative approach. The interface is added as a basic loop wrapper
around getrandom(), and then later, the kernel and libc together can
work together on optimizing that.

This prevents numerous issues in which userspace is unaware of when it
really must throw away its buffer, since we avoid buffering all
together. Future improvements may include userspace learning more from
the kernel about when to do that, which might make these sorts of
chacha20-based optimizations more possible. The current heuristic of 16
MiB is meaningless garbage that doesn't correspond to anything the
kernel might know about. So for now, let's just do something
conservative that we know is correct and won't lead to cryptographic
issues for users of this function.

This patch might be considered along the lines of, "optimization is the
root of all evil," in that the much more complex implementation it
replaces moves too fast without considering security implications,
whereas the incremental approach done here is a much safer way of going
about things. Once this lands, we can take our time in optimizing this
properly using new interplay between the kernel and userspace.

getrandom(0) is used, since that's the one that ensures the bytes
returned are cryptographically secure. But on systems without it, we
fallback to using /dev/urandom. This is unfortunate because it means
opening a file descriptor, but there's not much of a choice. Secondly,
as part of the fallback, in order to get more or less the same
properties of getrandom(0), we poll on /dev/random, and if the poll
succeeds at least once, then we assume the RNG is initialized. This is a
rough approximation, as the ancient "non-blocking pool" initialized
after the "blocking pool", not before, but it's the best approximation
we can do.

The motivation for including arc4random, in the first place, is to have
source-level compatibility with existing code. That means this patch
doesn't attempt to litigate the interface itself. It does, however,
choose a conservative approach for implementing it.

Cc: Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
Cc: Paul Eggert <eggert@cs.ucla.edu>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 LICENSES                                      |  23 -
 include/stdlib.h                              |   3 -
 stdlib/Makefile                               |   2 -
 stdlib/arc4random.c                           | 204 ++-----
 stdlib/arc4random.h                           |  48 --
 stdlib/chacha20.c                             | 191 ------
 stdlib/tst-arc4random-chacha20.c              | 167 -----
 sysdeps/aarch64/Makefile                      |   4 -
 sysdeps/aarch64/chacha20-aarch64.S            | 314 ----------
 sysdeps/aarch64/chacha20_arch.h               |  40 --
 sysdeps/generic/chacha20_arch.h               |  24 -
 sysdeps/generic/tls-internal.c                |  10 -
 sysdeps/mach/hurd/_Fork.c                     |   2 -
 sysdeps/nptl/_Fork.c                          |   2 -
 .../powerpc/powerpc64/be/multiarch/Makefile   |   4 -
 .../powerpc64/be/multiarch/chacha20-ppc.c     |   1 -
 .../powerpc64/be/multiarch/chacha20_arch.h    |  42 --
 sysdeps/powerpc/powerpc64/power8/Makefile     |   5 -
 .../powerpc/powerpc64/power8/chacha20-ppc.c   | 256 --------
 .../powerpc/powerpc64/power8/chacha20_arch.h  |  37 --
 sysdeps/s390/s390-64/Makefile                 |   6 -
 sysdeps/s390/s390-64/chacha20-s390x.S         | 573 ------------------
 sysdeps/s390/s390-64/chacha20_arch.h          |  45 --
 sysdeps/unix/sysv/linux/tls-internal.c        |  10 -
 sysdeps/x86_64/Makefile                       |   7 -
 sysdeps/x86_64/chacha20-amd64-avx2.S          | 328 ----------
 sysdeps/x86_64/chacha20-amd64-sse2.S          | 311 ----------
 sysdeps/x86_64/chacha20_arch.h                |  55 --
 28 files changed, 53 insertions(+), 2661 deletions(-)
 delete mode 100644 stdlib/arc4random.h
 delete mode 100644 stdlib/chacha20.c
 delete mode 100644 stdlib/tst-arc4random-chacha20.c
 delete mode 100644 sysdeps/aarch64/chacha20-aarch64.S
 delete mode 100644 sysdeps/aarch64/chacha20_arch.h
 delete mode 100644 sysdeps/generic/chacha20_arch.h
 delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/Makefile
 delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/chacha20-ppc.c
 delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/chacha20_arch.h
 delete mode 100644 sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c
 delete mode 100644 sysdeps/powerpc/powerpc64/power8/chacha20_arch.h
 delete mode 100644 sysdeps/s390/s390-64/chacha20-s390x.S
 delete mode 100644 sysdeps/s390/s390-64/chacha20_arch.h
 delete mode 100644 sysdeps/x86_64/chacha20-amd64-avx2.S
 delete mode 100644 sysdeps/x86_64/chacha20-amd64-sse2.S
 delete mode 100644 sysdeps/x86_64/chacha20_arch.h

diff --git a/LICENSES b/LICENSES
index cd04fb6e84..530893b1dc 100644
--- a/LICENSES
+++ b/LICENSES
@@ -389,26 +389,3 @@ Copyright 2001 by Stephen L. Moshier <moshier@na-net.ornl.gov>
  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, see
  <https://www.gnu.org/licenses/>.  */
-
-sysdeps/aarch64/chacha20-aarch64.S, sysdeps/x86_64/chacha20-amd64-sse2.S,
-sysdeps/x86_64/chacha20-amd64-avx2.S, and
-sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c, and
-sysdeps/s390/s390-64/chacha20-s390x.S imports code from libgcrypt,
-with the following notices:
-
-Copyright (C) 2017-2019 Jussi Kivilinna <jussi.kivilinna@iki.fi>
-
-This file is part of Libgcrypt.
-
-Libgcrypt is free software; you can redistribute it and/or modify
-it under the terms of the GNU Lesser General Public License as
-published by the Free Software Foundation; either version 2.1 of
-the License, or (at your option) any later version.
-
-Libgcrypt is distributed in the hope that it will be useful,
-but WITHOUT ANY WARRANTY; without even the implied warranty of
-MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU Lesser General Public License for more details.
-
-You should have received a copy of the GNU Lesser General Public
-License along with this program; if not, see <https://www.gnu.org/licenses/>.
diff --git a/include/stdlib.h b/include/stdlib.h
index cae7f7cdf8..db51f4a4f6 100644
--- a/include/stdlib.h
+++ b/include/stdlib.h
@@ -152,9 +152,6 @@ __typeof (arc4random_uniform) __arc4random_uniform;
 libc_hidden_proto (__arc4random_uniform);
 extern void __arc4random_buf_internal (void *buffer, size_t len)
      attribute_hidden;
-/* Called from the fork function to reinitialize the internal cipher state
-   in child process.  */
-extern void __arc4random_fork_subprocess (void) attribute_hidden;
 
 extern double __strtod_internal (const char *__restrict __nptr,
 				 char **__restrict __endptr, int __group)
diff --git a/stdlib/Makefile b/stdlib/Makefile
index a900962685..f7b25c1981 100644
--- a/stdlib/Makefile
+++ b/stdlib/Makefile
@@ -246,7 +246,6 @@ tests := \
   # tests
 
 tests-internal := \
-  tst-arc4random-chacha20 \
   tst-strtod1i \
   tst-strtod3 \
   tst-strtod4 \
@@ -256,7 +255,6 @@ tests-internal := \
   # tests-internal
 
 tests-static := \
-  tst-arc4random-chacha20 \
   tst-secure-getenv \
   # tests-static
 
diff --git a/stdlib/arc4random.c b/stdlib/arc4random.c
index 65547e79aa..80c55cde63 100644
--- a/stdlib/arc4random.c
+++ b/stdlib/arc4random.c
@@ -1,4 +1,4 @@
-/* Pseudo Random Number Generator based on ChaCha20.
+/* Pseudo Random Number Generator
    Copyright (C) 2022 Free Software Foundation, Inc.
    This file is part of the GNU C Library.
 
@@ -16,61 +16,14 @@
    License along with the GNU C Library; if not, see
    <https://www.gnu.org/licenses/>.  */
 
-#include <arc4random.h>
 #include <errno.h>
 #include <not-cancel.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <sys/poll.h>
 #include <sys/mman.h>
 #include <sys/param.h>
 #include <sys/random.h>
-#include <tls-internal.h>
-
-/* arc4random keeps two counters: 'have' is the current valid bytes not yet
-   consumed in 'buf' while 'count' is the maximum number of bytes until a
-   reseed.
-
-   Both the initial seed and reseed try to obtain entropy from the kernel
-   and abort the process if none could be obtained.
-
-   The state 'buf' improves the usage of the cipher calls, allowing to call
-   optimized implementations (if the architecture provides it) and minimize
-   function call overhead.  */
-
-#include <chacha20.c>
-
-/* Called from the fork function to reset the state.  */
-void
-__arc4random_fork_subprocess (void)
-{
-  struct arc4random_state_t *state = __glibc_tls_internal ()->rand_state;
-  if (state != NULL)
-    {
-      explicit_bzero (state, sizeof (*state));
-      /* Force key init.  */
-      state->count = -1;
-    }
-}
-
-/* Return the current thread random state or try to create one if there is
-   none available.  In the case malloc can not allocate a state, arc4random
-   will try to get entropy with arc4random_getentropy.  */
-static struct arc4random_state_t *
-arc4random_get_state (void)
-{
-  struct arc4random_state_t *state = __glibc_tls_internal ()->rand_state;
-  if (state == NULL)
-    {
-      state = malloc (sizeof (struct arc4random_state_t));
-      if (state != NULL)
-	{
-	  /* Force key initialization on first call.  */
-	  state->count = -1;
-	  __glibc_tls_internal ()->rand_state = state;
-	}
-    }
-  return state;
-}
 
 static void
 arc4random_getrandom_failure (void)
@@ -78,106 +31,70 @@ arc4random_getrandom_failure (void)
   __libc_fatal ("Fatal glibc error: cannot get entropy for arc4random\n");
 }
 
-static void
-arc4random_rekey (struct arc4random_state_t *state, uint8_t *rnd, size_t rndlen)
+void
+__arc4random_buf (void *p, size_t n)
 {
-  chacha20_crypt (state->ctx, state->buf, state->buf, sizeof state->buf);
+  static bool have_getrandom = true, seen_initialized = false;
+  int fd;
 
-  /* Mix optional user provided data.  */
-  if (rnd != NULL)
-    {
-      size_t m = MIN (rndlen, CHACHA20_KEY_SIZE + CHACHA20_IV_SIZE);
-      for (size_t i = 0; i < m; i++)
-	state->buf[i] ^= rnd[i];
-    }
-
-  /* Immediately reinit for backtracking resistance.  */
-  chacha20_init (state->ctx, state->buf, state->buf + CHACHA20_KEY_SIZE);
-  explicit_bzero (state->buf, CHACHA20_KEY_SIZE + CHACHA20_IV_SIZE);
-  state->have = sizeof (state->buf) - (CHACHA20_KEY_SIZE + CHACHA20_IV_SIZE);
-}
-
-static void
-arc4random_getentropy (void *rnd, size_t len)
-{
-  if (__getrandom_nocancel (rnd, len, GRND_NONBLOCK) == len)
+  if (n == 0)
     return;
 
-  int fd = TEMP_FAILURE_RETRY (__open64_nocancel ("/dev/urandom",
-						  O_RDONLY | O_CLOEXEC));
-  if (fd != -1)
+  for (;;)
     {
-      uint8_t *p = rnd;
-      uint8_t *end = p + len;
-      do
-	{
-	  ssize_t ret = TEMP_FAILURE_RETRY (__read_nocancel (fd, p, end - p));
-	  if (ret <= 0)
-	    arc4random_getrandom_failure ();
-	  p += ret;
-	}
-      while (p < end);
+      ssize_t l;
 
-      if (__close_nocancel (fd) == 0)
-	return;
-    }
-  arc4random_getrandom_failure ();
-}
+      if (!have_getrandom)
+	break;
 
-/* Check if the thread context STATE should be reseed with kernel entropy
-   depending of requested LEN bytes.  If there is less than requested,
-   the state is either initialized or reseeded, otherwise the internal
-   counter subtract the requested length.  */
-static void
-arc4random_check_stir (struct arc4random_state_t *state, size_t len)
-{
-  if (state->count <= len || state->count == -1)
-    {
-      uint8_t rnd[CHACHA20_KEY_SIZE + CHACHA20_IV_SIZE];
-      arc4random_getentropy (rnd, sizeof rnd);
-
-      if (state->count == -1)
-	chacha20_init (state->ctx, rnd, rnd + CHACHA20_KEY_SIZE);
-      else
-	arc4random_rekey (state, rnd, sizeof rnd);
-
-      explicit_bzero (rnd, sizeof rnd);
-
-      /* Invalidate the buf.  */
-      state->have = 0;
-      memset (state->buf, 0, sizeof state->buf);
-      state->count = CHACHA20_RESEED_SIZE;
+      l = __getrandom_nocancel (p, n, 0);
+      if (l > 0)
+	{
+	  if ((size_t) l == n)
+	    return; /* Done reading, success. */
+	  p = (uint8_t *) p + l;
+	  n -= l;
+	  continue; /* Interrupted by a signal; keep going. */
+	}
+      else if (l == 0)
+	arc4random_getrandom_failure (); /* Weird, should never happen. */
+      else if (errno == ENOSYS)
+	{
+	  have_getrandom = false;
+	  break; /* No syscall, so fallback to /dev/urandom. */
+	}
+      arc4random_getrandom_failure (); /* Unknown error, should never happen. */
     }
-  else
-    state->count -= len;
-}
 
-void
-__arc4random_buf (void *buffer, size_t len)
-{
-  struct arc4random_state_t *state = arc4random_get_state ();
-  if (__glibc_unlikely (state == NULL))
+  if (!seen_initialized)
     {
-      arc4random_getentropy (buffer, len);
-      return;
+      struct pollfd pfd = { .events = POLLIN };
+      pfd.fd = TEMP_FAILURE_RETRY (
+	  __open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
+      if (pfd.fd < 0)
+	arc4random_getrandom_failure ();
+      if (__poll (&pfd, 1, -1) < 0)
+	arc4random_getrandom_failure ();
+      if (__close_nocancel (pfd.fd) < 0)
+	arc4random_getrandom_failure ();
+      seen_initialized = true;
     }
 
-  arc4random_check_stir (state, len);
-  while (len > 0)
+  fd = TEMP_FAILURE_RETRY (
+      __open64_nocancel ("/dev/urandom", O_RDONLY | O_CLOEXEC | O_NOCTTY));
+  if (fd < 0)
+    arc4random_getrandom_failure ();
+  do
     {
-      if (state->have > 0)
-	{
-	  size_t m = MIN (len, state->have);
-	  uint8_t *ks = state->buf + sizeof (state->buf) - state->have;
-	  memcpy (buffer, ks, m);
-	  explicit_bzero (ks, m);
-	  buffer += m;
-	  len -= m;
-	  state->have -= m;
-	}
-      if (state->have == 0)
-	arc4random_rekey (state, NULL, 0);
+      ssize_t l = TEMP_FAILURE_RETRY (__read_nocancel (fd, p, n));
+      if (l <= 0)
+	arc4random_getrandom_failure ();
+      p = (uint8_t *) p + l;
+      n -= l;
     }
+  while (n);
+  if (__close_nocancel (fd) < 0)
+    arc4random_getrandom_failure ();
 }
 libc_hidden_def (__arc4random_buf)
 weak_alias (__arc4random_buf, arc4random_buf)
@@ -186,22 +103,7 @@ uint32_t
 __arc4random (void)
 {
   uint32_t r;
-
-  struct arc4random_state_t *state = arc4random_get_state ();
-  if (__glibc_unlikely (state == NULL))
-    {
-      arc4random_getentropy (&r, sizeof (uint32_t));
-      return r;
-    }
-
-  arc4random_check_stir (state, sizeof (uint32_t));
-  if (state->have < sizeof (uint32_t))
-    arc4random_rekey (state, NULL, 0);
-  uint8_t *ks = state->buf + sizeof (state->buf) - state->have;
-  memcpy (&r, ks, sizeof (uint32_t));
-  memset (ks, 0, sizeof (uint32_t));
-  state->have -= sizeof (uint32_t);
-
+  __arc4random_buf (&r, sizeof (r));
   return r;
 }
 libc_hidden_def (__arc4random)
diff --git a/stdlib/arc4random.h b/stdlib/arc4random.h
deleted file mode 100644
index cd39389c19..0000000000
--- a/stdlib/arc4random.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/* Arc4random definition used on TLS.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#ifndef _CHACHA20_H
-#define _CHACHA20_H
-
-#include <stddef.h>
-#include <stdint.h>
-
-/* Internal ChaCha20 state.  */
-#define CHACHA20_STATE_LEN	16
-#define CHACHA20_BLOCK_SIZE	64
-
-/* Maximum number bytes until reseed (16 MB).  */
-#define CHACHA20_RESEED_SIZE	(16 * 1024 * 1024)
-
-/* Internal arc4random buffer, used on each feedback step so offer some
-   backtracking protection and to allow better used of vectorized
-   chacha20 implementations.  */
-#define CHACHA20_BUFSIZE        (8 * CHACHA20_BLOCK_SIZE)
-
-_Static_assert (CHACHA20_BUFSIZE >= CHACHA20_BLOCK_SIZE + CHACHA20_BLOCK_SIZE,
-		"CHACHA20_BUFSIZE < CHACHA20_BLOCK_SIZE + CHACHA20_BLOCK_SIZE");
-
-struct arc4random_state_t
-{
-  uint32_t ctx[CHACHA20_STATE_LEN];
-  size_t have;
-  size_t count;
-  uint8_t buf[CHACHA20_BUFSIZE];
-};
-
-#endif
diff --git a/stdlib/chacha20.c b/stdlib/chacha20.c
deleted file mode 100644
index 2745a81315..0000000000
--- a/stdlib/chacha20.c
+++ /dev/null
@@ -1,191 +0,0 @@
-/* Generic ChaCha20 implementation (used on arc4random).
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#include <array_length.h>
-#include <endian.h>
-#include <stddef.h>
-#include <stdint.h>
-#include <string.h>
-
-/* 32-bit stream position, then 96-bit nonce.  */
-#define CHACHA20_IV_SIZE	16
-#define CHACHA20_KEY_SIZE	32
-
-#define CHACHA20_STATE_LEN	16
-
-/* The ChaCha20 implementation is based on RFC8439 [1], omitting the final
-   XOR of the keystream with the plaintext because the plaintext is a
-   stream of zeros.  */
-
-enum chacha20_constants
-{
-  CHACHA20_CONSTANT_EXPA = 0x61707865U,
-  CHACHA20_CONSTANT_ND_3 = 0x3320646eU,
-  CHACHA20_CONSTANT_2_BY = 0x79622d32U,
-  CHACHA20_CONSTANT_TE_K = 0x6b206574U
-};
-
-static inline uint32_t
-read_unaligned_32 (const uint8_t *p)
-{
-  uint32_t r;
-  memcpy (&r, p, sizeof (r));
-  return r;
-}
-
-static inline void
-write_unaligned_32 (uint8_t *p, uint32_t v)
-{
-  memcpy (p, &v, sizeof (v));
-}
-
-#if __BYTE_ORDER == __BIG_ENDIAN
-# define read_unaligned_le32(p) __builtin_bswap32 (read_unaligned_32 (p))
-# define set_state(v)		__builtin_bswap32 ((v))
-#else
-# define read_unaligned_le32(p) read_unaligned_32 ((p))
-# define set_state(v)		(v)
-#endif
-
-static inline void
-chacha20_init (uint32_t *state, const uint8_t *key, const uint8_t *iv)
-{
-  state[0]  = CHACHA20_CONSTANT_EXPA;
-  state[1]  = CHACHA20_CONSTANT_ND_3;
-  state[2]  = CHACHA20_CONSTANT_2_BY;
-  state[3]  = CHACHA20_CONSTANT_TE_K;
-
-  state[4]  = read_unaligned_le32 (key + 0 * sizeof (uint32_t));
-  state[5]  = read_unaligned_le32 (key + 1 * sizeof (uint32_t));
-  state[6]  = read_unaligned_le32 (key + 2 * sizeof (uint32_t));
-  state[7]  = read_unaligned_le32 (key + 3 * sizeof (uint32_t));
-  state[8]  = read_unaligned_le32 (key + 4 * sizeof (uint32_t));
-  state[9]  = read_unaligned_le32 (key + 5 * sizeof (uint32_t));
-  state[10] = read_unaligned_le32 (key + 6 * sizeof (uint32_t));
-  state[11] = read_unaligned_le32 (key + 7 * sizeof (uint32_t));
-
-  state[12] = read_unaligned_le32 (iv + 0 * sizeof (uint32_t));
-  state[13] = read_unaligned_le32 (iv + 1 * sizeof (uint32_t));
-  state[14] = read_unaligned_le32 (iv + 2 * sizeof (uint32_t));
-  state[15] = read_unaligned_le32 (iv + 3 * sizeof (uint32_t));
-}
-
-static inline uint32_t
-rotl32 (unsigned int shift, uint32_t word)
-{
-  return (word << (shift & 31)) | (word >> ((-shift) & 31));
-}
-
-static void
-state_final (const uint8_t *src, uint8_t *dst, uint32_t v)
-{
-#ifdef CHACHA20_XOR_FINAL
-  v ^= read_unaligned_32 (src);
-#endif
-  write_unaligned_32 (dst, v);
-}
-
-static inline void
-chacha20_block (uint32_t *state, uint8_t *dst, const uint8_t *src)
-{
-  uint32_t x0, x1, x2, x3, x4, x5, x6, x7;
-  uint32_t x8, x9, x10, x11, x12, x13, x14, x15;
-
-  x0 = state[0];
-  x1 = state[1];
-  x2 = state[2];
-  x3 = state[3];
-  x4 = state[4];
-  x5 = state[5];
-  x6 = state[6];
-  x7 = state[7];
-  x8 = state[8];
-  x9 = state[9];
-  x10 = state[10];
-  x11 = state[11];
-  x12 = state[12];
-  x13 = state[13];
-  x14 = state[14];
-  x15 = state[15];
-
-  for (int i = 0; i < 20; i += 2)
-    {
-#define QROUND(_x0, _x1, _x2, _x3) 			\
-  do {							\
-   _x0 = _x0 + _x1; _x3 = rotl32 (16, (_x0 ^ _x3)); 	\
-   _x2 = _x2 + _x3; _x1 = rotl32 (12, (_x1 ^ _x2)); 	\
-   _x0 = _x0 + _x1; _x3 = rotl32 (8,  (_x0 ^ _x3));	\
-   _x2 = _x2 + _x3; _x1 = rotl32 (7,  (_x1 ^ _x2));	\
-  } while(0)
-
-      QROUND (x0, x4, x8,  x12);
-      QROUND (x1, x5, x9,  x13);
-      QROUND (x2, x6, x10, x14);
-      QROUND (x3, x7, x11, x15);
-
-      QROUND (x0, x5, x10, x15);
-      QROUND (x1, x6, x11, x12);
-      QROUND (x2, x7, x8,  x13);
-      QROUND (x3, x4, x9,  x14);
-    }
-
-  state_final (&src[0], &dst[0], set_state (x0 + state[0]));
-  state_final (&src[4], &dst[4], set_state (x1 + state[1]));
-  state_final (&src[8], &dst[8], set_state (x2 + state[2]));
-  state_final (&src[12], &dst[12], set_state (x3 + state[3]));
-  state_final (&src[16], &dst[16], set_state (x4 + state[4]));
-  state_final (&src[20], &dst[20], set_state (x5 + state[5]));
-  state_final (&src[24], &dst[24], set_state (x6 + state[6]));
-  state_final (&src[28], &dst[28], set_state (x7 + state[7]));
-  state_final (&src[32], &dst[32], set_state (x8 + state[8]));
-  state_final (&src[36], &dst[36], set_state (x9 + state[9]));
-  state_final (&src[40], &dst[40], set_state (x10 + state[10]));
-  state_final (&src[44], &dst[44], set_state (x11 + state[11]));
-  state_final (&src[48], &dst[48], set_state (x12 + state[12]));
-  state_final (&src[52], &dst[52], set_state (x13 + state[13]));
-  state_final (&src[56], &dst[56], set_state (x14 + state[14]));
-  state_final (&src[60], &dst[60], set_state (x15 + state[15]));
-
-  state[12]++;
-}
-
-static void
-__attribute_maybe_unused__
-chacha20_crypt_generic (uint32_t *state, uint8_t *dst, const uint8_t *src,
-			size_t bytes)
-{
-  while (bytes >= CHACHA20_BLOCK_SIZE)
-    {
-      chacha20_block (state, dst, src);
-
-      bytes -= CHACHA20_BLOCK_SIZE;
-      dst += CHACHA20_BLOCK_SIZE;
-      src += CHACHA20_BLOCK_SIZE;
-    }
-
-  if (__glibc_unlikely (bytes != 0))
-    {
-      uint8_t stream[CHACHA20_BLOCK_SIZE];
-      chacha20_block (state, stream, src);
-      memcpy (dst, stream, bytes);
-      explicit_bzero (stream, sizeof stream);
-    }
-}
-
-/* Get the architecture optimized version.  */
-#include <chacha20_arch.h>
diff --git a/stdlib/tst-arc4random-chacha20.c b/stdlib/tst-arc4random-chacha20.c
deleted file mode 100644
index 45ba54920d..0000000000
--- a/stdlib/tst-arc4random-chacha20.c
+++ /dev/null
@@ -1,167 +0,0 @@
-/* Basic tests for chacha20 cypher used in arc4random.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#include <arc4random.h>
-#include <support/check.h>
-#include <sys/cdefs.h>
-
-/* The test does not define CHACHA20_XOR_FINAL to mimic what arc4random
-   actual does.  */
-#include <chacha20.c>
-
-static int
-do_test (void)
-{
-  const uint8_t key[CHACHA20_KEY_SIZE] =
-    {
-      0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-      0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-      0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-      0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-    };
-  const uint8_t iv[CHACHA20_IV_SIZE] =
-    {
-      0x0, 0x0, 0x0, 0x0,
-      0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-    };
-  const uint8_t expected1[CHACHA20_BUFSIZE] =
-    {
-      0x76, 0xb8, 0xe0, 0xad, 0xa0, 0xf1, 0x3d, 0x90, 0x40, 0x5d, 0x6a,
-      0xe5, 0x53, 0x86, 0xbd, 0x28, 0xbd, 0xd2, 0x19, 0xb8, 0xa0, 0x8d,
-      0xed, 0x1a, 0xa8, 0x36, 0xef, 0xcc, 0x8b, 0x77, 0x0d, 0xc7, 0xda,
-      0x41, 0x59, 0x7c, 0x51, 0x57, 0x48, 0x8d, 0x77, 0x24, 0xe0, 0x3f,
-      0xb8, 0xd8, 0x4a, 0x37, 0x6a, 0x43, 0xb8, 0xf4, 0x15, 0x18, 0xa1,
-      0x1c, 0xc3, 0x87, 0xb6, 0x69, 0xb2, 0xee, 0x65, 0x86, 0x9f, 0x07,
-      0xe7, 0xbe, 0x55, 0x51, 0x38, 0x7a, 0x98, 0xba, 0x97, 0x7c, 0x73,
-      0x2d, 0x08, 0x0d, 0xcb, 0x0f, 0x29, 0xa0, 0x48, 0xe3, 0x65, 0x69,
-      0x12, 0xc6, 0x53, 0x3e, 0x32, 0xee, 0x7a, 0xed, 0x29, 0xb7, 0x21,
-      0x76, 0x9c, 0xe6, 0x4e, 0x43, 0xd5, 0x71, 0x33, 0xb0, 0x74, 0xd8,
-      0x39, 0xd5, 0x31, 0xed, 0x1f, 0x28, 0x51, 0x0a, 0xfb, 0x45, 0xac,
-      0xe1, 0x0a, 0x1f, 0x4b, 0x79, 0x4d, 0x6f, 0x2d, 0x09, 0xa0, 0xe6,
-      0x63, 0x26, 0x6c, 0xe1, 0xae, 0x7e, 0xd1, 0x08, 0x19, 0x68, 0xa0,
-      0x75, 0x8e, 0x71, 0x8e, 0x99, 0x7b, 0xd3, 0x62, 0xc6, 0xb0, 0xc3,
-      0x46, 0x34, 0xa9, 0xa0, 0xb3, 0x5d, 0x01, 0x27, 0x37, 0x68, 0x1f,
-      0x7b, 0x5d, 0x0f, 0x28, 0x1e, 0x3a, 0xfd, 0xe4, 0x58, 0xbc, 0x1e,
-      0x73, 0xd2, 0xd3, 0x13, 0xc9, 0xcf, 0x94, 0xc0, 0x5f, 0xf3, 0x71,
-      0x62, 0x40, 0xa2, 0x48, 0xf2, 0x13, 0x20, 0xa0, 0x58, 0xd7, 0xb3,
-      0x56, 0x6b, 0xd5, 0x20, 0xda, 0xaa, 0x3e, 0xd2, 0xbf, 0x0a, 0xc5,
-      0xb8, 0xb1, 0x20, 0xfb, 0x85, 0x27, 0x73, 0xc3, 0x63, 0x97, 0x34,
-      0xb4, 0x5c, 0x91, 0xa4, 0x2d, 0xd4, 0xcb, 0x83, 0xf8, 0x84, 0x0d,
-      0x2e, 0xed, 0xb1, 0x58, 0x13, 0x10, 0x62, 0xac, 0x3f, 0x1f, 0x2c,
-      0xf8, 0xff, 0x6d, 0xcd, 0x18, 0x56, 0xe8, 0x6a, 0x1e, 0x6c, 0x31,
-      0x67, 0x16, 0x7e, 0xe5, 0xa6, 0x88, 0x74, 0x2b, 0x47, 0xc5, 0xad,
-      0xfb, 0x59, 0xd4, 0xdf, 0x76, 0xfd, 0x1d, 0xb1, 0xe5, 0x1e, 0xe0,
-      0x3b, 0x1c, 0xa9, 0xf8, 0x2a, 0xca, 0x17, 0x3e, 0xdb, 0x8b, 0x72,
-      0x93, 0x47, 0x4e, 0xbe, 0x98, 0x0f, 0x90, 0x4d, 0x10, 0xc9, 0x16,
-      0x44, 0x2b, 0x47, 0x83, 0xa0, 0xe9, 0x84, 0x86, 0x0c, 0xb6, 0xc9,
-      0x57, 0xb3, 0x9c, 0x38, 0xed, 0x8f, 0x51, 0xcf, 0xfa, 0xa6, 0x8a,
-      0x4d, 0xe0, 0x10, 0x25, 0xa3, 0x9c, 0x50, 0x45, 0x46, 0xb9, 0xdc,
-      0x14, 0x06, 0xa7, 0xeb, 0x28, 0x15, 0x1e, 0x51, 0x50, 0xd7, 0xb2,
-      0x04, 0xba, 0xa7, 0x19, 0xd4, 0xf0, 0x91, 0x02, 0x12, 0x17, 0xdb,
-      0x5c, 0xf1, 0xb5, 0xc8, 0x4c, 0x4f, 0xa7, 0x1a, 0x87, 0x96, 0x10,
-      0xa1, 0xa6, 0x95, 0xac, 0x52, 0x7c, 0x5b, 0x56, 0x77, 0x4a, 0x6b,
-      0x8a, 0x21, 0xaa, 0xe8, 0x86, 0x85, 0x86, 0x8e, 0x09, 0x4c, 0xf2,
-      0x9e, 0xf4, 0x09, 0x0a, 0xf7, 0xa9, 0x0c, 0xc0, 0x7e, 0x88, 0x17,
-      0xaa, 0x52, 0x87, 0x63, 0x79, 0x7d, 0x3c, 0x33, 0x2b, 0x67, 0xca,
-      0x4b, 0xc1, 0x10, 0x64, 0x2c, 0x21, 0x51, 0xec, 0x47, 0xee, 0x84,
-      0xcb, 0x8c, 0x42, 0xd8, 0x5f, 0x10, 0xe2, 0xa8, 0xcb, 0x18, 0xc3,
-      0xb7, 0x33, 0x5f, 0x26, 0xe8, 0xc3, 0x9a, 0x12, 0xb1, 0xbc, 0xc1,
-      0x70, 0x71, 0x77, 0xb7, 0x61, 0x38, 0x73, 0x2e, 0xed, 0xaa, 0xb7,
-      0x4d, 0xa1, 0x41, 0x0f, 0xc0, 0x55, 0xea, 0x06, 0x8c, 0x99, 0xe9,
-      0x26, 0x0a, 0xcb, 0xe3, 0x37, 0xcf, 0x5d, 0x3e, 0x00, 0xe5, 0xb3,
-      0x23, 0x0f, 0xfe, 0xdb, 0x0b, 0x99, 0x07, 0x87, 0xd0, 0xc7, 0x0e,
-      0x0b, 0xfe, 0x41, 0x98, 0xea, 0x67, 0x58, 0xdd, 0x5a, 0x61, 0xfb,
-      0x5f, 0xec, 0x2d, 0xf9, 0x81, 0xf3, 0x1b, 0xef, 0xe1, 0x53, 0xf8,
-      0x1d, 0x17, 0x16, 0x17, 0x84, 0xdb
-    };
-
-  const uint8_t expected2[CHACHA20_BUFSIZE] =
-    {
-      0x1c, 0x88, 0x22, 0xd5, 0x3c, 0xd1, 0xee, 0x7d, 0xb5, 0x32, 0x36,
-      0x48, 0x28, 0xbd, 0xf4, 0x04, 0xb0, 0x40, 0xa8, 0xdc, 0xc5, 0x22,
-      0xf3, 0xd3, 0xd9, 0x9a, 0xec, 0x4b, 0x80, 0x57, 0xed, 0xb8, 0x50,
-      0x09, 0x31, 0xa2, 0xc4, 0x2d, 0x2f, 0x0c, 0x57, 0x08, 0x47, 0x10,
-      0x0b, 0x57, 0x54, 0xda, 0xfc, 0x5f, 0xbd, 0xb8, 0x94, 0xbb, 0xef,
-      0x1a, 0x2d, 0xe1, 0xa0, 0x7f, 0x8b, 0xa0, 0xc4, 0xb9, 0x19, 0x30,
-      0x10, 0x66, 0xed, 0xbc, 0x05, 0x6b, 0x7b, 0x48, 0x1e, 0x7a, 0x0c,
-      0x46, 0x29, 0x7b, 0xbb, 0x58, 0x9d, 0x9d, 0xa5, 0xb6, 0x75, 0xa6,
-      0x72, 0x3e, 0x15, 0x2e, 0x5e, 0x63, 0xa4, 0xce, 0x03, 0x4e, 0x9e,
-      0x83, 0xe5, 0x8a, 0x01, 0x3a, 0xf0, 0xe7, 0x35, 0x2f, 0xb7, 0x90,
-      0x85, 0x14, 0xe3, 0xb3, 0xd1, 0x04, 0x0d, 0x0b, 0xb9, 0x63, 0xb3,
-      0x95, 0x4b, 0x63, 0x6b, 0x5f, 0xd4, 0xbf, 0x6d, 0x0a, 0xad, 0xba,
-      0xf8, 0x15, 0x7d, 0x06, 0x2a, 0xcb, 0x24, 0x18, 0xc1, 0x76, 0xa4,
-      0x75, 0x51, 0x1b, 0x35, 0xc3, 0xf6, 0x21, 0x8a, 0x56, 0x68, 0xea,
-      0x5b, 0xc6, 0xf5, 0x4b, 0x87, 0x82, 0xf8, 0xb3, 0x40, 0xf0, 0x0a,
-      0xc1, 0xbe, 0xba, 0x5e, 0x62, 0xcd, 0x63, 0x2a, 0x7c, 0xe7, 0x80,
-      0x9c, 0x72, 0x56, 0x08, 0xac, 0xa5, 0xef, 0xbf, 0x7c, 0x41, 0xf2,
-      0x37, 0x64, 0x3f, 0x06, 0xc0, 0x99, 0x72, 0x07, 0x17, 0x1d, 0xe8,
-      0x67, 0xf9, 0xd6, 0x97, 0xbf, 0x5e, 0xa6, 0x01, 0x1a, 0xbc, 0xce,
-      0x6c, 0x8c, 0xdb, 0x21, 0x13, 0x94, 0xd2, 0xc0, 0x2d, 0xd0, 0xfb,
-      0x60, 0xdb, 0x5a, 0x2c, 0x17, 0xac, 0x3d, 0xc8, 0x58, 0x78, 0xa9,
-      0x0b, 0xed, 0x38, 0x09, 0xdb, 0xb9, 0x6e, 0xaa, 0x54, 0x26, 0xfc,
-      0x8e, 0xae, 0x0d, 0x2d, 0x65, 0xc4, 0x2a, 0x47, 0x9f, 0x08, 0x86,
-      0x48, 0xbe, 0x2d, 0xc8, 0x01, 0xd8, 0x2a, 0x36, 0x6f, 0xdd, 0xc0,
-      0xef, 0x23, 0x42, 0x63, 0xc0, 0xb6, 0x41, 0x7d, 0x5f, 0x9d, 0xa4,
-      0x18, 0x17, 0xb8, 0x8d, 0x68, 0xe5, 0xe6, 0x71, 0x95, 0xc5, 0xc1,
-      0xee, 0x30, 0x95, 0xe8, 0x21, 0xf2, 0x25, 0x24, 0xb2, 0x0b, 0xe4,
-      0x1c, 0xeb, 0x59, 0x04, 0x12, 0xe4, 0x1d, 0xc6, 0x48, 0x84, 0x3f,
-      0xa9, 0xbf, 0xec, 0x7a, 0x3d, 0xcf, 0x61, 0xab, 0x05, 0x41, 0x57,
-      0x33, 0x16, 0xd3, 0xfa, 0x81, 0x51, 0x62, 0x93, 0x03, 0xfe, 0x97,
-      0x41, 0x56, 0x2e, 0xd0, 0x65, 0xdb, 0x4e, 0xbc, 0x00, 0x50, 0xef,
-      0x55, 0x83, 0x64, 0xae, 0x81, 0x12, 0x4a, 0x28, 0xf5, 0xc0, 0x13,
-      0x13, 0x23, 0x2f, 0xbc, 0x49, 0x6d, 0xfd, 0x8a, 0x25, 0x68, 0x65,
-      0x7b, 0x68, 0x6d, 0x72, 0x14, 0x38, 0x2a, 0x1a, 0x00, 0x90, 0x30,
-      0x17, 0xdd, 0xa9, 0x69, 0x87, 0x84, 0x42, 0xba, 0x5a, 0xff, 0xf6,
-      0x61, 0x3f, 0x55, 0x3c, 0xbb, 0x23, 0x3c, 0xe4, 0x6d, 0x9a, 0xee,
-      0x93, 0xa7, 0x87, 0x6c, 0xf5, 0xe9, 0xe8, 0x29, 0x12, 0xb1, 0x8c,
-      0xad, 0xf0, 0xb3, 0x43, 0x27, 0xb2, 0xe0, 0x42, 0x7e, 0xcf, 0x66,
-      0xb7, 0xce, 0xb7, 0xc0, 0x91, 0x8d, 0xc4, 0x7b, 0xdf, 0xf1, 0x2a,
-      0x06, 0x2a, 0xdf, 0x07, 0x13, 0x30, 0x09, 0xce, 0x7a, 0x5e, 0x5c,
-      0x91, 0x7e, 0x01, 0x68, 0x30, 0x61, 0x09, 0xb7, 0xcb, 0x49, 0x65,
-      0x3a, 0x6d, 0x2c, 0xae, 0xf0, 0x05, 0xde, 0x78, 0x3a, 0x9a, 0x9b,
-      0xfe, 0x05, 0x38, 0x1e, 0xd1, 0x34, 0x8d, 0x94, 0xec, 0x65, 0x88,
-      0x6f, 0x9c, 0x0b, 0x61, 0x9c, 0x52, 0xc5, 0x53, 0x38, 0x00, 0xb1,
-      0x6c, 0x83, 0x61, 0x72, 0xb9, 0x51, 0x82, 0xdb, 0xc5, 0xee, 0xc0,
-      0x42, 0xb8, 0x9e, 0x22, 0xf1, 0x1a, 0x08, 0x5b, 0x73, 0x9a, 0x36,
-      0x11, 0xcd, 0x8d, 0x83, 0x60, 0x18
-    };
-
-  /* Check with the expected internal arc4random keystream buffer.  Some
-     architecture optimizations expects a buffer with a minimum size which
-     is a multiple of then ChaCha20 blocksize, so they might not be prepared
-     to handle smaller buffers.  */
-
-  uint8_t output[CHACHA20_BUFSIZE];
-
-  uint32_t state[CHACHA20_STATE_LEN];
-  chacha20_init (state, key, iv);
-
-  /* Check with the initial state.  */
-  uint8_t input[CHACHA20_BUFSIZE] = { 0 };
-
-  chacha20_crypt (state, output, input, CHACHA20_BUFSIZE);
-  TEST_COMPARE_BLOB (output, sizeof output, expected1, CHACHA20_BUFSIZE);
-
-  /* And on the next round.  */
-  chacha20_crypt (state, output, input, CHACHA20_BUFSIZE);
-  TEST_COMPARE_BLOB (output, sizeof output, expected2, CHACHA20_BUFSIZE);
-
-  return 0;
-}
-
-#include <support/test-driver.c>
diff --git a/sysdeps/aarch64/Makefile b/sysdeps/aarch64/Makefile
index 7dfd1b62dd..17fb1c5b72 100644
--- a/sysdeps/aarch64/Makefile
+++ b/sysdeps/aarch64/Makefile
@@ -51,10 +51,6 @@ ifeq ($(subdir),csu)
 gen-as-const-headers += tlsdesc.sym
 endif
 
-ifeq ($(subdir),stdlib)
-sysdep_routines += chacha20-aarch64
-endif
-
 ifeq ($(subdir),gmon)
 CFLAGS-mcount.c += -mgeneral-regs-only
 endif
diff --git a/sysdeps/aarch64/chacha20-aarch64.S b/sysdeps/aarch64/chacha20-aarch64.S
deleted file mode 100644
index cce5291c5c..0000000000
--- a/sysdeps/aarch64/chacha20-aarch64.S
+++ /dev/null
@@ -1,314 +0,0 @@
-/* Optimized AArch64 implementation of ChaCha20 cipher.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-/* Copyright (C) 2017-2019 Jussi Kivilinna <jussi.kivilinna@iki.fi>
-
-   This file is part of Libgcrypt.
-
-   Libgcrypt is free software; you can redistribute it and/or modify
-   it under the terms of the GNU Lesser General Public License as
-   published by the Free Software Foundation; either version 2.1 of
-   the License, or (at your option) any later version.
-
-   Libgcrypt is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with this program; if not, see <https://www.gnu.org/licenses/>.
- */
-
-/* Based on D. J. Bernstein reference implementation at
-   http://cr.yp.to/chacha.html:
-
-   chacha-regs.c version 20080118
-   D. J. Bernstein
-   Public domain.  */
-
-#include <sysdep.h>
-
-/* Only LE is supported.  */
-#ifdef __AARCH64EL__
-
-#define GET_DATA_POINTER(reg, name) \
-        adrp    reg, name ; \
-        add     reg, reg, :lo12:name
-
-/* 'ret' instruction replacement for straight-line speculation mitigation */
-#define ret_spec_stop \
-        ret; dsb sy; isb;
-
-.cpu generic+simd
-
-.text
-
-/* register macros */
-#define INPUT     x0
-#define DST       x1
-#define SRC       x2
-#define NBLKS     x3
-#define ROUND     x4
-#define INPUT_CTR x5
-#define INPUT_POS x6
-#define CTR       x7
-
-/* vector registers */
-#define X0 v16
-#define X4 v17
-#define X8 v18
-#define X12 v19
-
-#define X1 v20
-#define X5 v21
-
-#define X9 v22
-#define X13 v23
-#define X2 v24
-#define X6 v25
-
-#define X3 v26
-#define X7 v27
-#define X11 v28
-#define X15 v29
-
-#define X10 v30
-#define X14 v31
-
-#define VCTR    v0
-#define VTMP0   v1
-#define VTMP1   v2
-#define VTMP2   v3
-#define VTMP3   v4
-#define X12_TMP v5
-#define X13_TMP v6
-#define ROT8    v7
-
-/**********************************************************************
-  helper macros
- **********************************************************************/
-
-#define _(...) __VA_ARGS__
-
-#define vpunpckldq(s1, s2, dst) \
-	zip1 dst.4s, s2.4s, s1.4s;
-
-#define vpunpckhdq(s1, s2, dst) \
-	zip2 dst.4s, s2.4s, s1.4s;
-
-#define vpunpcklqdq(s1, s2, dst) \
-	zip1 dst.2d, s2.2d, s1.2d;
-
-#define vpunpckhqdq(s1, s2, dst) \
-	zip2 dst.2d, s2.2d, s1.2d;
-
-/* 4x4 32-bit integer matrix transpose */
-#define transpose_4x4(x0, x1, x2, x3, t1, t2, t3) \
-	vpunpckhdq(x1, x0, t2); \
-	vpunpckldq(x1, x0, x0); \
-	\
-	vpunpckldq(x3, x2, t1); \
-	vpunpckhdq(x3, x2, x2); \
-	\
-	vpunpckhqdq(t1, x0, x1); \
-	vpunpcklqdq(t1, x0, x0); \
-	\
-	vpunpckhqdq(x2, t2, x3); \
-	vpunpcklqdq(x2, t2, x2);
-
-/**********************************************************************
-  4-way chacha20
- **********************************************************************/
-
-#define XOR(d,s1,s2) \
-	eor d.16b, s2.16b, s1.16b;
-
-#define PLUS(ds,s) \
-	add ds.4s, ds.4s, s.4s;
-
-#define ROTATE4(dst1,dst2,dst3,dst4,c,src1,src2,src3,src4) \
-	shl dst1.4s, src1.4s, #(c);		\
-	shl dst2.4s, src2.4s, #(c);		\
-	shl dst3.4s, src3.4s, #(c);		\
-	shl dst4.4s, src4.4s, #(c);		\
-	sri dst1.4s, src1.4s, #(32 - (c));	\
-	sri dst2.4s, src2.4s, #(32 - (c));	\
-	sri dst3.4s, src3.4s, #(32 - (c));	\
-	sri dst4.4s, src4.4s, #(32 - (c));
-
-#define ROTATE4_8(dst1,dst2,dst3,dst4,src1,src2,src3,src4) \
-	tbl dst1.16b, {src1.16b}, ROT8.16b;     \
-	tbl dst2.16b, {src2.16b}, ROT8.16b;	\
-	tbl dst3.16b, {src3.16b}, ROT8.16b;	\
-	tbl dst4.16b, {src4.16b}, ROT8.16b;
-
-#define ROTATE4_16(dst1,dst2,dst3,dst4,src1,src2,src3,src4) \
-	rev32 dst1.8h, src1.8h;			\
-	rev32 dst2.8h, src2.8h;			\
-	rev32 dst3.8h, src3.8h;			\
-	rev32 dst4.8h, src4.8h;
-
-#define QUARTERROUND4(a1,b1,c1,d1,a2,b2,c2,d2,a3,b3,c3,d3,a4,b4,c4,d4,ign,tmp1,tmp2,tmp3,tmp4) \
-	PLUS(a1,b1); PLUS(a2,b2);						\
-	PLUS(a3,b3); PLUS(a4,b4);						\
-	    XOR(tmp1,d1,a1); XOR(tmp2,d2,a2);					\
-	    XOR(tmp3,d3,a3); XOR(tmp4,d4,a4);					\
-		ROTATE4_16(d1, d2, d3, d4, tmp1, tmp2, tmp3, tmp4);		\
-	PLUS(c1,d1); PLUS(c2,d2);						\
-	PLUS(c3,d3); PLUS(c4,d4);						\
-	    XOR(tmp1,b1,c1); XOR(tmp2,b2,c2);					\
-	    XOR(tmp3,b3,c3); XOR(tmp4,b4,c4);					\
-		ROTATE4(b1, b2, b3, b4, 12, tmp1, tmp2, tmp3, tmp4)		\
-	PLUS(a1,b1); PLUS(a2,b2);						\
-	PLUS(a3,b3); PLUS(a4,b4);						\
-	    XOR(tmp1,d1,a1); XOR(tmp2,d2,a2);					\
-	    XOR(tmp3,d3,a3); XOR(tmp4,d4,a4);					\
-		ROTATE4_8(d1, d2, d3, d4, tmp1, tmp2, tmp3, tmp4)		\
-	PLUS(c1,d1); PLUS(c2,d2);						\
-	PLUS(c3,d3); PLUS(c4,d4);						\
-	    XOR(tmp1,b1,c1); XOR(tmp2,b2,c2);					\
-	    XOR(tmp3,b3,c3); XOR(tmp4,b4,c4);					\
-		ROTATE4(b1, b2, b3, b4, 7, tmp1, tmp2, tmp3, tmp4)		\
-
-.align 4
-L(__chacha20_blocks4_data_inc_counter):
-	.long 0,1,2,3
-
-.align 4
-L(__chacha20_blocks4_data_rot8):
-	.byte 3,0,1,2
-	.byte 7,4,5,6
-	.byte 11,8,9,10
-	.byte 15,12,13,14
-
-.hidden __chacha20_neon_blocks4
-ENTRY (__chacha20_neon_blocks4)
-	/* input:
-	 *	x0: input
-	 *	x1: dst
-	 *	x2: src
-	 *	x3: nblks (multiple of 4)
-	 */
-
-	GET_DATA_POINTER(CTR, L(__chacha20_blocks4_data_rot8))
-	add INPUT_CTR, INPUT, #(12*4);
-	ld1 {ROT8.16b}, [CTR];
-	GET_DATA_POINTER(CTR, L(__chacha20_blocks4_data_inc_counter))
-	mov INPUT_POS, INPUT;
-	ld1 {VCTR.16b}, [CTR];
-
-L(loop4):
-	/* Construct counter vectors X12 and X13 */
-
-	ld1 {X15.16b}, [INPUT_CTR];
-	mov ROUND, #20;
-	ld1 {VTMP1.16b-VTMP3.16b}, [INPUT_POS];
-
-	dup X12.4s, X15.s[0];
-	dup X13.4s, X15.s[1];
-	ldr CTR, [INPUT_CTR];
-	add X12.4s, X12.4s, VCTR.4s;
-	dup X0.4s, VTMP1.s[0];
-	dup X1.4s, VTMP1.s[1];
-	dup X2.4s, VTMP1.s[2];
-	dup X3.4s, VTMP1.s[3];
-	dup X14.4s, X15.s[2];
-	cmhi VTMP0.4s, VCTR.4s, X12.4s;
-	dup X15.4s, X15.s[3];
-	add CTR, CTR, #4; /* Update counter */
-	dup X4.4s, VTMP2.s[0];
-	dup X5.4s, VTMP2.s[1];
-	dup X6.4s, VTMP2.s[2];
-	dup X7.4s, VTMP2.s[3];
-	sub X13.4s, X13.4s, VTMP0.4s;
-	dup X8.4s, VTMP3.s[0];
-	dup X9.4s, VTMP3.s[1];
-	dup X10.4s, VTMP3.s[2];
-	dup X11.4s, VTMP3.s[3];
-	mov X12_TMP.16b, X12.16b;
-	mov X13_TMP.16b, X13.16b;
-	str CTR, [INPUT_CTR];
-
-L(round2):
-	subs ROUND, ROUND, #2
-	QUARTERROUND4(X0, X4,  X8, X12,   X1, X5,  X9, X13,
-		      X2, X6, X10, X14,   X3, X7, X11, X15,
-		      tmp:=,VTMP0,VTMP1,VTMP2,VTMP3)
-	QUARTERROUND4(X0, X5, X10, X15,   X1, X6, X11, X12,
-		      X2, X7,  X8, X13,   X3, X4,  X9, X14,
-		      tmp:=,VTMP0,VTMP1,VTMP2,VTMP3)
-	b.ne L(round2);
-
-	ld1 {VTMP0.16b, VTMP1.16b}, [INPUT_POS], #32;
-
-	PLUS(X12, X12_TMP);        /* INPUT + 12 * 4 + counter */
-	PLUS(X13, X13_TMP);        /* INPUT + 13 * 4 + counter */
-
-	dup VTMP2.4s, VTMP0.s[0]; /* INPUT + 0 * 4 */
-	dup VTMP3.4s, VTMP0.s[1]; /* INPUT + 1 * 4 */
-	dup X12_TMP.4s, VTMP0.s[2]; /* INPUT + 2 * 4 */
-	dup X13_TMP.4s, VTMP0.s[3]; /* INPUT + 3 * 4 */
-	PLUS(X0, VTMP2);
-	PLUS(X1, VTMP3);
-	PLUS(X2, X12_TMP);
-	PLUS(X3, X13_TMP);
-
-	dup VTMP2.4s, VTMP1.s[0]; /* INPUT + 4 * 4 */
-	dup VTMP3.4s, VTMP1.s[1]; /* INPUT + 5 * 4 */
-	dup X12_TMP.4s, VTMP1.s[2]; /* INPUT + 6 * 4 */
-	dup X13_TMP.4s, VTMP1.s[3]; /* INPUT + 7 * 4 */
-	ld1 {VTMP0.16b, VTMP1.16b}, [INPUT_POS];
-	mov INPUT_POS, INPUT;
-	PLUS(X4, VTMP2);
-	PLUS(X5, VTMP3);
-	PLUS(X6, X12_TMP);
-	PLUS(X7, X13_TMP);
-
-	dup VTMP2.4s, VTMP0.s[0]; /* INPUT + 8 * 4 */
-	dup VTMP3.4s, VTMP0.s[1]; /* INPUT + 9 * 4 */
-	dup X12_TMP.4s, VTMP0.s[2]; /* INPUT + 10 * 4 */
-	dup X13_TMP.4s, VTMP0.s[3]; /* INPUT + 11 * 4 */
-	dup VTMP0.4s, VTMP1.s[2]; /* INPUT + 14 * 4 */
-	dup VTMP1.4s, VTMP1.s[3]; /* INPUT + 15 * 4 */
-	PLUS(X8, VTMP2);
-	PLUS(X9, VTMP3);
-	PLUS(X10, X12_TMP);
-	PLUS(X11, X13_TMP);
-	PLUS(X14, VTMP0);
-	PLUS(X15, VTMP1);
-
-	transpose_4x4(X0, X1, X2, X3, VTMP0, VTMP1, VTMP2);
-	transpose_4x4(X4, X5, X6, X7, VTMP0, VTMP1, VTMP2);
-	transpose_4x4(X8, X9, X10, X11, VTMP0, VTMP1, VTMP2);
-	transpose_4x4(X12, X13, X14, X15, VTMP0, VTMP1, VTMP2);
-
-	subs NBLKS, NBLKS, #4;
-
-	st1 {X0.16b,X4.16B,X8.16b, X12.16b}, [DST], #64
-	st1 {X1.16b,X5.16b}, [DST], #32;
-	st1 {X9.16b, X13.16b, X2.16b, X6.16b}, [DST], #64
-	st1 {X10.16b,X14.16b}, [DST], #32;
-	st1 {X3.16b, X7.16b, X11.16b, X15.16b}, [DST], #64;
-
-	b.ne L(loop4);
-
-	ret_spec_stop
-END (__chacha20_neon_blocks4)
-
-#endif
diff --git a/sysdeps/aarch64/chacha20_arch.h b/sysdeps/aarch64/chacha20_arch.h
deleted file mode 100644
index 37dbb917f1..0000000000
--- a/sysdeps/aarch64/chacha20_arch.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* Chacha20 implementation, used on arc4random.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#include <ldsodefs.h>
-#include <stdbool.h>
-
-unsigned int __chacha20_neon_blocks4 (uint32_t *state, uint8_t *dst,
-				      const uint8_t *src, size_t nblks)
-     attribute_hidden;
-
-static void
-chacha20_crypt (uint32_t *state, uint8_t *dst, const uint8_t *src,
-		size_t bytes)
-{
-  _Static_assert (CHACHA20_BUFSIZE % 4 == 0,
-		  "CHACHA20_BUFSIZE not multiple of 4");
-  _Static_assert (CHACHA20_BUFSIZE > CHACHA20_BLOCK_SIZE * 4,
-		  "CHACHA20_BUFSIZE <= CHACHA20_BLOCK_SIZE * 4");
-#ifdef __AARCH64EL__
-  __chacha20_neon_blocks4 (state, dst, src,
-			   CHACHA20_BUFSIZE / CHACHA20_BLOCK_SIZE);
-#else
-  chacha20_crypt_generic (state, dst, src, bytes);
-#endif
-}
diff --git a/sysdeps/generic/chacha20_arch.h b/sysdeps/generic/chacha20_arch.h
deleted file mode 100644
index 1b4559ccbc..0000000000
--- a/sysdeps/generic/chacha20_arch.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* Chacha20 implementation, generic interface for encrypt.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-static inline void
-chacha20_crypt (uint32_t *state, uint8_t *dst, const uint8_t *src,
-		size_t bytes)
-{
-  chacha20_crypt_generic (state, dst, src, bytes);
-}
diff --git a/sysdeps/generic/tls-internal.c b/sysdeps/generic/tls-internal.c
index 8a0f37d509..b32b31b5a9 100644
--- a/sysdeps/generic/tls-internal.c
+++ b/sysdeps/generic/tls-internal.c
@@ -16,7 +16,6 @@
    License along with the GNU C Library; if not, see
    <https://www.gnu.org/licenses/>.  */
 
-#include <stdlib/arc4random.h>
 #include <string.h>
 #include <tls-internal.h>
 
@@ -27,13 +26,4 @@ __glibc_tls_internal_free (void)
 {
   free (__tls_internal.strsignal_buf);
   free (__tls_internal.strerror_l_buf);
-
-  if (__tls_internal.rand_state != NULL)
-    {
-      /* Clear any lingering random state prior so if the thread stack is
-	 cached it won't leak any data.  */
-      explicit_bzero (__tls_internal.rand_state,
-		      sizeof (*__tls_internal.rand_state));
-      free (__tls_internal.rand_state);
-    }
 }
diff --git a/sysdeps/mach/hurd/_Fork.c b/sysdeps/mach/hurd/_Fork.c
index 667068c8cf..e60b86fab1 100644
--- a/sysdeps/mach/hurd/_Fork.c
+++ b/sysdeps/mach/hurd/_Fork.c
@@ -662,8 +662,6 @@ retry:
       _hurd_malloc_fork_child ();
       call_function_static_weak (__malloc_fork_unlock_child);
 
-      call_function_static_weak (__arc4random_fork_subprocess);
-
       /* Run things that want to run in the child task to set up.  */
       RUN_HOOK (_hurd_fork_child_hook, ());
 
diff --git a/sysdeps/nptl/_Fork.c b/sysdeps/nptl/_Fork.c
index 7dc02569f6..dd568992e2 100644
--- a/sysdeps/nptl/_Fork.c
+++ b/sysdeps/nptl/_Fork.c
@@ -43,8 +43,6 @@ _Fork (void)
       self->robust_head.list = &self->robust_head;
       INTERNAL_SYSCALL_CALL (set_robust_list, &self->robust_head,
 			     sizeof (struct robust_list_head));
-
-      call_function_static_weak (__arc4random_fork_subprocess);
     }
   return pid;
 }
diff --git a/sysdeps/powerpc/powerpc64/be/multiarch/Makefile b/sysdeps/powerpc/powerpc64/be/multiarch/Makefile
deleted file mode 100644
index 8c75165f7f..0000000000
--- a/sysdeps/powerpc/powerpc64/be/multiarch/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-ifeq ($(subdir),stdlib)
-sysdep_routines += chacha20-ppc
-CFLAGS-chacha20-ppc.c += -mcpu=power8
-endif
diff --git a/sysdeps/powerpc/powerpc64/be/multiarch/chacha20-ppc.c b/sysdeps/powerpc/powerpc64/be/multiarch/chacha20-ppc.c
deleted file mode 100644
index cf9e735326..0000000000
--- a/sysdeps/powerpc/powerpc64/be/multiarch/chacha20-ppc.c
+++ /dev/null
@@ -1 +0,0 @@
-#include <sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c>
diff --git a/sysdeps/powerpc/powerpc64/be/multiarch/chacha20_arch.h b/sysdeps/powerpc/powerpc64/be/multiarch/chacha20_arch.h
deleted file mode 100644
index 08494dc045..0000000000
--- a/sysdeps/powerpc/powerpc64/be/multiarch/chacha20_arch.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* PowerPC optimization for ChaCha20.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#include <stdbool.h>
-#include <ldsodefs.h>
-
-unsigned int __chacha20_power8_blocks4 (uint32_t *state, uint8_t *dst,
-					const uint8_t *src, size_t nblks)
-     attribute_hidden;
-
-static void
-chacha20_crypt (uint32_t *state, uint8_t *dst,
-		const uint8_t *src, size_t bytes)
-{
-  _Static_assert (CHACHA20_BUFSIZE % 4 == 0,
-		  "CHACHA20_BUFSIZE not multiple of 4");
-  _Static_assert (CHACHA20_BUFSIZE >= CHACHA20_BLOCK_SIZE * 4,
-		  "CHACHA20_BUFSIZE < CHACHA20_BLOCK_SIZE * 4");
-
-  unsigned long int hwcap = GLRO(dl_hwcap);
-  unsigned long int hwcap2 = GLRO(dl_hwcap2);
-  if (hwcap2 & PPC_FEATURE2_ARCH_2_07 && hwcap & PPC_FEATURE_HAS_ALTIVEC)
-    __chacha20_power8_blocks4 (state, dst, src,
-			       CHACHA20_BUFSIZE / CHACHA20_BLOCK_SIZE);
-  else
-    chacha20_crypt_generic (state, dst, src, bytes);
-}
diff --git a/sysdeps/powerpc/powerpc64/power8/Makefile b/sysdeps/powerpc/powerpc64/power8/Makefile
index abb0aa3f11..71a59529f3 100644
--- a/sysdeps/powerpc/powerpc64/power8/Makefile
+++ b/sysdeps/powerpc/powerpc64/power8/Makefile
@@ -1,8 +1,3 @@
 ifeq ($(subdir),string)
 sysdep_routines += strcasestr-ppc64
 endif
-
-ifeq ($(subdir),stdlib)
-sysdep_routines += chacha20-ppc
-CFLAGS-chacha20-ppc.c += -mcpu=power8
-endif
diff --git a/sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c b/sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c
deleted file mode 100644
index 0bbdcb9363..0000000000
--- a/sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c
+++ /dev/null
@@ -1,256 +0,0 @@
-/* Optimized PowerPC implementation of ChaCha20 cipher.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-/* chacha20-ppc.c - PowerPC vector implementation of ChaCha20
-   Copyright (C) 2019 Jussi Kivilinna <jussi.kivilinna@iki.fi>
-
-   This file is part of Libgcrypt.
-
-   Libgcrypt is free software; you can redistribute it and/or modify
-   it under the terms of the GNU Lesser General Public License as
-   published by the Free Software Foundation; either version 2.1 of
-   the License, or (at your option) any later version.
-
-   Libgcrypt is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with this program; if not, see <https://www.gnu.org/licenses/>.
- */
-
-#include <altivec.h>
-#include <endian.h>
-#include <stddef.h>
-#include <stdint.h>
-#include <sys/cdefs.h>
-
-typedef vector unsigned char vector16x_u8;
-typedef vector unsigned int vector4x_u32;
-typedef vector unsigned long long vector2x_u64;
-
-#if __BYTE_ORDER == __BIG_ENDIAN
-static const vector16x_u8 le_bswap_const =
-  { 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12 };
-#endif
-
-static inline vector4x_u32
-vec_rol_elems (vector4x_u32 v, unsigned int idx)
-{
-#if __BYTE_ORDER != __BIG_ENDIAN
-  return vec_sld (v, v, (16 - (4 * idx)) & 15);
-#else
-  return vec_sld (v, v, (4 * idx) & 15);
-#endif
-}
-
-static inline vector4x_u32
-vec_load_le (unsigned long offset, const unsigned char *ptr)
-{
-  vector4x_u32 vec;
-  vec = vec_vsx_ld (offset, (const uint32_t *)ptr);
-#if __BYTE_ORDER == __BIG_ENDIAN
-  vec = (vector4x_u32) vec_perm ((vector16x_u8)vec, (vector16x_u8)vec,
-				 le_bswap_const);
-#endif
-  return vec;
-}
-
-static inline void
-vec_store_le (vector4x_u32 vec, unsigned long offset, unsigned char *ptr)
-{
-#if __BYTE_ORDER == __BIG_ENDIAN
-  vec = (vector4x_u32)vec_perm((vector16x_u8)vec, (vector16x_u8)vec,
-			       le_bswap_const);
-#endif
-  vec_vsx_st (vec, offset, (uint32_t *)ptr);
-}
-
-
-static inline vector4x_u32
-vec_add_ctr_u64 (vector4x_u32 v, vector4x_u32 a)
-{
-#if __BYTE_ORDER == __BIG_ENDIAN
-  static const vector16x_u8 swap32 =
-    { 4, 5, 6, 7, 0, 1, 2, 3, 12, 13, 14, 15, 8, 9, 10, 11 };
-  vector2x_u64 vec, add, sum;
-
-  vec = (vector2x_u64)vec_perm ((vector16x_u8)v, (vector16x_u8)v, swap32);
-  add = (vector2x_u64)vec_perm ((vector16x_u8)a, (vector16x_u8)a, swap32);
-  sum = vec + add;
-  return (vector4x_u32)vec_perm ((vector16x_u8)sum, (vector16x_u8)sum, swap32);
-#else
-  return (vector4x_u32)((vector2x_u64)(v) + (vector2x_u64)(a));
-#endif
-}
-
-/**********************************************************************
-  4-way chacha20
- **********************************************************************/
-
-#define ROTATE(v1,rolv)			\
-	__asm__ ("vrlw %0,%1,%2\n\t" : "=v" (v1) : "v" (v1), "v" (rolv))
-
-#define PLUS(ds,s) \
-	((ds) += (s))
-
-#define XOR(ds,s) \
-	((ds) ^= (s))
-
-#define ADD_U64(v,a) \
-	(v = vec_add_ctr_u64(v, a))
-
-/* 4x4 32-bit integer matrix transpose */
-#define transpose_4x4(x0, x1, x2, x3) ({ \
-	vector4x_u32 t1 = vec_mergeh(x0, x2); \
-	vector4x_u32 t2 = vec_mergel(x0, x2); \
-	vector4x_u32 t3 = vec_mergeh(x1, x3); \
-	x3 = vec_mergel(x1, x3); \
-	x0 = vec_mergeh(t1, t3); \
-	x1 = vec_mergel(t1, t3); \
-	x2 = vec_mergeh(t2, x3); \
-	x3 = vec_mergel(t2, x3); \
-      })
-
-#define QUARTERROUND2(a1,b1,c1,d1,a2,b2,c2,d2)			\
-	PLUS(a1,b1); PLUS(a2,b2); XOR(d1,a1); XOR(d2,a2);	\
-	    ROTATE(d1, rotate_16); ROTATE(d2, rotate_16);	\
-	PLUS(c1,d1); PLUS(c2,d2); XOR(b1,c1); XOR(b2,c2);	\
-	    ROTATE(b1, rotate_12); ROTATE(b2, rotate_12);	\
-	PLUS(a1,b1); PLUS(a2,b2); XOR(d1,a1); XOR(d2,a2);	\
-	    ROTATE(d1, rotate_8); ROTATE(d2, rotate_8);		\
-	PLUS(c1,d1); PLUS(c2,d2); XOR(b1,c1); XOR(b2,c2);	\
-	    ROTATE(b1, rotate_7); ROTATE(b2, rotate_7);
-
-unsigned int attribute_hidden
-__chacha20_power8_blocks4 (uint32_t *state, uint8_t *dst, const uint8_t *src,
-			   size_t nblks)
-{
-  vector4x_u32 counters_0123 = { 0, 1, 2, 3 };
-  vector4x_u32 counter_4 = { 4, 0, 0, 0 };
-  vector4x_u32 rotate_16 = { 16, 16, 16, 16 };
-  vector4x_u32 rotate_12 = { 12, 12, 12, 12 };
-  vector4x_u32 rotate_8 = { 8, 8, 8, 8 };
-  vector4x_u32 rotate_7 = { 7, 7, 7, 7 };
-  vector4x_u32 state0, state1, state2, state3;
-  vector4x_u32 v0, v1, v2, v3, v4, v5, v6, v7;
-  vector4x_u32 v8, v9, v10, v11, v12, v13, v14, v15;
-  vector4x_u32 tmp;
-  int i;
-
-  /* Force preload of constants to vector registers.  */
-  __asm__ ("": "+v" (counters_0123) :: "memory");
-  __asm__ ("": "+v" (counter_4) :: "memory");
-  __asm__ ("": "+v" (rotate_16) :: "memory");
-  __asm__ ("": "+v" (rotate_12) :: "memory");
-  __asm__ ("": "+v" (rotate_8) :: "memory");
-  __asm__ ("": "+v" (rotate_7) :: "memory");
-
-  state0 = vec_vsx_ld (0 * 16, state);
-  state1 = vec_vsx_ld (1 * 16, state);
-  state2 = vec_vsx_ld (2 * 16, state);
-  state3 = vec_vsx_ld (3 * 16, state);
-
-  do
-    {
-      v0 = vec_splat (state0, 0);
-      v1 = vec_splat (state0, 1);
-      v2 = vec_splat (state0, 2);
-      v3 = vec_splat (state0, 3);
-      v4 = vec_splat (state1, 0);
-      v5 = vec_splat (state1, 1);
-      v6 = vec_splat (state1, 2);
-      v7 = vec_splat (state1, 3);
-      v8 = vec_splat (state2, 0);
-      v9 = vec_splat (state2, 1);
-      v10 = vec_splat (state2, 2);
-      v11 = vec_splat (state2, 3);
-      v12 = vec_splat (state3, 0);
-      v13 = vec_splat (state3, 1);
-      v14 = vec_splat (state3, 2);
-      v15 = vec_splat (state3, 3);
-
-      v12 += counters_0123;
-      v13 -= vec_cmplt (v12, counters_0123);
-
-      for (i = 20; i > 0; i -= 2)
-	{
-	  QUARTERROUND2 (v0, v4,  v8, v12,   v1, v5,  v9, v13)
-	  QUARTERROUND2 (v2, v6, v10, v14,   v3, v7, v11, v15)
-	  QUARTERROUND2 (v0, v5, v10, v15,   v1, v6, v11, v12)
-	  QUARTERROUND2 (v2, v7,  v8, v13,   v3, v4,  v9, v14)
-	}
-
-      v0 += vec_splat (state0, 0);
-      v1 += vec_splat (state0, 1);
-      v2 += vec_splat (state0, 2);
-      v3 += vec_splat (state0, 3);
-      v4 += vec_splat (state1, 0);
-      v5 += vec_splat (state1, 1);
-      v6 += vec_splat (state1, 2);
-      v7 += vec_splat (state1, 3);
-      v8 += vec_splat (state2, 0);
-      v9 += vec_splat (state2, 1);
-      v10 += vec_splat (state2, 2);
-      v11 += vec_splat (state2, 3);
-      tmp = vec_splat( state3, 0);
-      tmp += counters_0123;
-      v12 += tmp;
-      v13 += vec_splat (state3, 1) - vec_cmplt (tmp, counters_0123);
-      v14 += vec_splat (state3, 2);
-      v15 += vec_splat (state3, 3);
-      ADD_U64 (state3, counter_4);
-
-      transpose_4x4 (v0, v1, v2, v3);
-      transpose_4x4 (v4, v5, v6, v7);
-      transpose_4x4 (v8, v9, v10, v11);
-      transpose_4x4 (v12, v13, v14, v15);
-
-      vec_store_le (v0, (64 * 0 + 16 * 0), dst);
-      vec_store_le (v1, (64 * 1 + 16 * 0), dst);
-      vec_store_le (v2, (64 * 2 + 16 * 0), dst);
-      vec_store_le (v3, (64 * 3 + 16 * 0), dst);
-
-      vec_store_le (v4, (64 * 0 + 16 * 1), dst);
-      vec_store_le (v5, (64 * 1 + 16 * 1), dst);
-      vec_store_le (v6, (64 * 2 + 16 * 1), dst);
-      vec_store_le (v7, (64 * 3 + 16 * 1), dst);
-
-      vec_store_le (v8, (64 * 0 + 16 * 2), dst);
-      vec_store_le (v9, (64 * 1 + 16 * 2), dst);
-      vec_store_le (v10, (64 * 2 + 16 * 2), dst);
-      vec_store_le (v11, (64 * 3 + 16 * 2), dst);
-
-      vec_store_le (v12, (64 * 0 + 16 * 3), dst);
-      vec_store_le (v13, (64 * 1 + 16 * 3), dst);
-      vec_store_le (v14, (64 * 2 + 16 * 3), dst);
-      vec_store_le (v15, (64 * 3 + 16 * 3), dst);
-
-      src += 4*64;
-      dst += 4*64;
-
-      nblks -= 4;
-    }
-  while (nblks);
-
-  vec_vsx_st (state3, 3 * 16, state);
-
-  return 0;
-}
diff --git a/sysdeps/powerpc/powerpc64/power8/chacha20_arch.h b/sysdeps/powerpc/powerpc64/power8/chacha20_arch.h
deleted file mode 100644
index ded06762b6..0000000000
--- a/sysdeps/powerpc/powerpc64/power8/chacha20_arch.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/* PowerPC optimization for ChaCha20.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#include <stdbool.h>
-#include <ldsodefs.h>
-
-unsigned int __chacha20_power8_blocks4 (uint32_t *state, uint8_t *dst,
-					const uint8_t *src, size_t nblks)
-     attribute_hidden;
-
-static void
-chacha20_crypt (uint32_t *state, uint8_t *dst,
-		const uint8_t *src, size_t bytes)
-{
-  _Static_assert (CHACHA20_BUFSIZE % 4 == 0,
-		  "CHACHA20_BUFSIZE not multiple of 4");
-  _Static_assert (CHACHA20_BUFSIZE >= CHACHA20_BLOCK_SIZE * 4,
-		  "CHACHA20_BUFSIZE < CHACHA20_BLOCK_SIZE * 4");
-
-  __chacha20_power8_blocks4 (state, dst, src,
-			     CHACHA20_BUFSIZE / CHACHA20_BLOCK_SIZE);
-}
diff --git a/sysdeps/s390/s390-64/Makefile b/sysdeps/s390/s390-64/Makefile
index 96c110f490..66ed844e68 100644
--- a/sysdeps/s390/s390-64/Makefile
+++ b/sysdeps/s390/s390-64/Makefile
@@ -67,9 +67,3 @@ tests-container += tst-glibc-hwcaps-cache
 endif
 
 endif # $(subdir) == elf
-
-ifeq ($(subdir),stdlib)
-sysdep_routines += \
-  chacha20-s390x \
-  # sysdep_routines
-endif
diff --git a/sysdeps/s390/s390-64/chacha20-s390x.S b/sysdeps/s390/s390-64/chacha20-s390x.S
deleted file mode 100644
index e38504d370..0000000000
--- a/sysdeps/s390/s390-64/chacha20-s390x.S
+++ /dev/null
@@ -1,573 +0,0 @@
-/* Optimized s390x implementation of ChaCha20 cipher.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-/* chacha20-s390x.S  -  zSeries implementation of ChaCha20 cipher
-
-   Copyright (C) 2020 Jussi Kivilinna <jussi.kivilinna@iki.fi>
-
-   This file is part of Libgcrypt.
-
-   Libgcrypt is free software; you can redistribute it and/or modify
-   it under the terms of the GNU Lesser General Public License as
-   published by the Free Software Foundation; either version 2.1 of
-   the License, or (at your option) any later version.
-
-   Libgcrypt is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with this program; if not, see <https://www.gnu.org/licenses/>.
- */
-
-#include <sysdep.h>
-
-#ifdef HAVE_S390_VX_ASM_SUPPORT
-
-/* CFA expressions are used for pointing CFA and registers to
- * SP relative offsets. */
-# define DW_REGNO_SP 15
-
-/* Fixed length encoding used for integers for now. */
-# define DW_SLEB128_7BIT(value) \
-        0x00|((value) & 0x7f)
-# define DW_SLEB128_28BIT(value) \
-        0x80|((value)&0x7f), \
-        0x80|(((value)>>7)&0x7f), \
-        0x80|(((value)>>14)&0x7f), \
-        0x00|(((value)>>21)&0x7f)
-
-# define cfi_cfa_on_stack(rsp_offs,cfa_depth) \
-        .cfi_escape \
-          0x0f, /* DW_CFA_def_cfa_expression */ \
-            DW_SLEB128_7BIT(11), /* length */ \
-          0x7f, /* DW_OP_breg15, rsp + constant */ \
-            DW_SLEB128_28BIT(rsp_offs), \
-          0x06, /* DW_OP_deref */ \
-          0x23, /* DW_OP_plus_constu */ \
-            DW_SLEB128_28BIT((cfa_depth)+160)
-
-.machine "z13+vx"
-.text
-
-.balign 16
-.Lconsts:
-.Lwordswap:
-	.byte 12, 13, 14, 15, 8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3
-.Lbswap128:
-	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-.Lbswap32:
-	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
-.Lone:
-	.long 0, 0, 0, 1
-.Ladd_counter_0123:
-	.long 0, 1, 2, 3
-.Ladd_counter_4567:
-	.long 4, 5, 6, 7
-
-/* register macros */
-#define INPUT %r2
-#define DST   %r3
-#define SRC   %r4
-#define NBLKS %r0
-#define ROUND %r1
-
-/* stack structure */
-
-#define STACK_FRAME_STD    (8 * 16 + 8 * 4)
-#define STACK_FRAME_F8_F15 (8 * 8)
-#define STACK_FRAME_Y0_Y15 (16 * 16)
-#define STACK_FRAME_CTR    (4 * 16)
-#define STACK_FRAME_PARAMS (6 * 8)
-
-#define STACK_MAX   (STACK_FRAME_STD + STACK_FRAME_F8_F15 + \
-		     STACK_FRAME_Y0_Y15 + STACK_FRAME_CTR + \
-		     STACK_FRAME_PARAMS)
-
-#define STACK_F8     (STACK_MAX - STACK_FRAME_F8_F15)
-#define STACK_F9     (STACK_F8 + 8)
-#define STACK_F10    (STACK_F9 + 8)
-#define STACK_F11    (STACK_F10 + 8)
-#define STACK_F12    (STACK_F11 + 8)
-#define STACK_F13    (STACK_F12 + 8)
-#define STACK_F14    (STACK_F13 + 8)
-#define STACK_F15    (STACK_F14 + 8)
-#define STACK_Y0_Y15 (STACK_F8 - STACK_FRAME_Y0_Y15)
-#define STACK_CTR    (STACK_Y0_Y15 - STACK_FRAME_CTR)
-#define STACK_INPUT  (STACK_CTR - STACK_FRAME_PARAMS)
-#define STACK_DST    (STACK_INPUT + 8)
-#define STACK_SRC    (STACK_DST + 8)
-#define STACK_NBLKS  (STACK_SRC + 8)
-#define STACK_POCTX  (STACK_NBLKS + 8)
-#define STACK_POSRC  (STACK_POCTX + 8)
-
-#define STACK_G0_H3  STACK_Y0_Y15
-
-/* vector registers */
-#define A0 %v0
-#define A1 %v1
-#define A2 %v2
-#define A3 %v3
-
-#define B0 %v4
-#define B1 %v5
-#define B2 %v6
-#define B3 %v7
-
-#define C0 %v8
-#define C1 %v9
-#define C2 %v10
-#define C3 %v11
-
-#define D0 %v12
-#define D1 %v13
-#define D2 %v14
-#define D3 %v15
-
-#define E0 %v16
-#define E1 %v17
-#define E2 %v18
-#define E3 %v19
-
-#define F0 %v20
-#define F1 %v21
-#define F2 %v22
-#define F3 %v23
-
-#define G0 %v24
-#define G1 %v25
-#define G2 %v26
-#define G3 %v27
-
-#define H0 %v28
-#define H1 %v29
-#define H2 %v30
-#define H3 %v31
-
-#define IO0 E0
-#define IO1 E1
-#define IO2 E2
-#define IO3 E3
-#define IO4 F0
-#define IO5 F1
-#define IO6 F2
-#define IO7 F3
-
-#define S0 G0
-#define S1 G1
-#define S2 G2
-#define S3 G3
-
-#define TMP0 H0
-#define TMP1 H1
-#define TMP2 H2
-#define TMP3 H3
-
-#define X0 A0
-#define X1 A1
-#define X2 A2
-#define X3 A3
-#define X4 B0
-#define X5 B1
-#define X6 B2
-#define X7 B3
-#define X8 C0
-#define X9 C1
-#define X10 C2
-#define X11 C3
-#define X12 D0
-#define X13 D1
-#define X14 D2
-#define X15 D3
-
-#define Y0 E0
-#define Y1 E1
-#define Y2 E2
-#define Y3 E3
-#define Y4 F0
-#define Y5 F1
-#define Y6 F2
-#define Y7 F3
-#define Y8 G0
-#define Y9 G1
-#define Y10 G2
-#define Y11 G3
-#define Y12 H0
-#define Y13 H1
-#define Y14 H2
-#define Y15 H3
-
-/**********************************************************************
-  helper macros
- **********************************************************************/
-
-#define _ /*_*/
-
-#define START_STACK(last_r) \
-	lgr %r0, %r15; \
-	lghi %r1, ~15; \
-	stmg %r6, last_r, 6 * 8(%r15); \
-	aghi %r0, -STACK_MAX; \
-	ngr %r0, %r1; \
-	lgr %r1, %r15; \
-	cfi_def_cfa_register(1); \
-	lgr %r15, %r0; \
-	stg %r1, 0(%r15); \
-	cfi_cfa_on_stack(0, 0); \
-	std %f8, STACK_F8(%r15); \
-	std %f9, STACK_F9(%r15); \
-	std %f10, STACK_F10(%r15); \
-	std %f11, STACK_F11(%r15); \
-	std %f12, STACK_F12(%r15); \
-	std %f13, STACK_F13(%r15); \
-	std %f14, STACK_F14(%r15); \
-	std %f15, STACK_F15(%r15);
-
-#define END_STACK(last_r) \
-	lg %r1, 0(%r15); \
-	ld %f8, STACK_F8(%r15); \
-	ld %f9, STACK_F9(%r15); \
-	ld %f10, STACK_F10(%r15); \
-	ld %f11, STACK_F11(%r15); \
-	ld %f12, STACK_F12(%r15); \
-	ld %f13, STACK_F13(%r15); \
-	ld %f14, STACK_F14(%r15); \
-	ld %f15, STACK_F15(%r15); \
-	lmg %r6, last_r, 6 * 8(%r1); \
-	lgr %r15, %r1; \
-	cfi_def_cfa_register(DW_REGNO_SP);
-
-#define PLUS(dst,src) \
-	vaf dst, dst, src;
-
-#define XOR(dst,src) \
-	vx dst, dst, src;
-
-#define ROTATE(v1,c) \
-	verllf v1, v1, (c)(0);
-
-#define WORD_ROTATE(v1,s) \
-	vsldb v1, v1, v1, ((s) * 4);
-
-#define DST_8(OPER, I, J) \
-	OPER(A##I, J); OPER(B##I, J); OPER(C##I, J); OPER(D##I, J); \
-	OPER(E##I, J); OPER(F##I, J); OPER(G##I, J); OPER(H##I, J);
-
-/**********************************************************************
-  round macros
- **********************************************************************/
-
-/**********************************************************************
-  8-way chacha20 ("vertical")
- **********************************************************************/
-
-#define QUARTERROUND4_V8_POLY(x0,x1,x2,x3,x4,x5,x6,x7,\
-			      x8,x9,x10,x11,x12,x13,x14,x15,\
-			      y0,y1,y2,y3,y4,y5,y6,y7,\
-			      y8,y9,y10,y11,y12,y13,y14,y15,\
-			      op1,op2,op3,op4,op5,op6,op7,op8,\
-			      op9,op10,op11,op12) \
-	op1;							\
-	PLUS(x0, x1); PLUS(x4, x5);				\
-	PLUS(x8, x9); PLUS(x12, x13);				\
-	PLUS(y0, y1); PLUS(y4, y5);				\
-	PLUS(y8, y9); PLUS(y12, y13);				\
-	    op2;						\
-	    XOR(x3, x0);  XOR(x7, x4);				\
-	    XOR(x11, x8); XOR(x15, x12);			\
-	    XOR(y3, y0);  XOR(y7, y4);				\
-	    XOR(y11, y8); XOR(y15, y12);			\
-		op3;						\
-		ROTATE(x3, 16); ROTATE(x7, 16);			\
-		ROTATE(x11, 16); ROTATE(x15, 16);		\
-		ROTATE(y3, 16); ROTATE(y7, 16);			\
-		ROTATE(y11, 16); ROTATE(y15, 16);		\
-	op4;							\
-	PLUS(x2, x3); PLUS(x6, x7);				\
-	PLUS(x10, x11); PLUS(x14, x15);				\
-	PLUS(y2, y3); PLUS(y6, y7);				\
-	PLUS(y10, y11); PLUS(y14, y15);				\
-	    op5;						\
-	    XOR(x1, x2); XOR(x5, x6);				\
-	    XOR(x9, x10); XOR(x13, x14);			\
-	    XOR(y1, y2); XOR(y5, y6);				\
-	    XOR(y9, y10); XOR(y13, y14);			\
-		op6;						\
-		ROTATE(x1,12); ROTATE(x5,12);			\
-		ROTATE(x9,12); ROTATE(x13,12);			\
-		ROTATE(y1,12); ROTATE(y5,12);			\
-		ROTATE(y9,12); ROTATE(y13,12);			\
-	op7;							\
-	PLUS(x0, x1); PLUS(x4, x5);				\
-	PLUS(x8, x9); PLUS(x12, x13);				\
-	PLUS(y0, y1); PLUS(y4, y5);				\
-	PLUS(y8, y9); PLUS(y12, y13);				\
-	    op8;						\
-	    XOR(x3, x0); XOR(x7, x4);				\
-	    XOR(x11, x8); XOR(x15, x12);			\
-	    XOR(y3, y0); XOR(y7, y4);				\
-	    XOR(y11, y8); XOR(y15, y12);			\
-		op9;						\
-		ROTATE(x3,8); ROTATE(x7,8);			\
-		ROTATE(x11,8); ROTATE(x15,8);			\
-		ROTATE(y3,8); ROTATE(y7,8);			\
-		ROTATE(y11,8); ROTATE(y15,8);			\
-	op10;							\
-	PLUS(x2, x3); PLUS(x6, x7);				\
-	PLUS(x10, x11); PLUS(x14, x15);				\
-	PLUS(y2, y3); PLUS(y6, y7);				\
-	PLUS(y10, y11); PLUS(y14, y15);				\
-	    op11;						\
-	    XOR(x1, x2); XOR(x5, x6);				\
-	    XOR(x9, x10); XOR(x13, x14);			\
-	    XOR(y1, y2); XOR(y5, y6);				\
-	    XOR(y9, y10); XOR(y13, y14);			\
-		op12;						\
-		ROTATE(x1,7); ROTATE(x5,7);			\
-		ROTATE(x9,7); ROTATE(x13,7);			\
-		ROTATE(y1,7); ROTATE(y5,7);			\
-		ROTATE(y9,7); ROTATE(y13,7);
-
-#define QUARTERROUND4_V8(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,\
-			 y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15) \
-	QUARTERROUND4_V8_POLY(x0,x1,x2,x3,x4,x5,x6,x7,\
-			      x8,x9,x10,x11,x12,x13,x14,x15,\
-			      y0,y1,y2,y3,y4,y5,y6,y7,\
-			      y8,y9,y10,y11,y12,y13,y14,y15,\
-			      ,,,,,,,,,,,)
-
-#define TRANSPOSE_4X4_2(v0,v1,v2,v3,va,vb,vc,vd,tmp0,tmp1,tmp2,tmpa,tmpb,tmpc) \
-	  vmrhf tmp0, v0, v1;					\
-	  vmrhf tmp1, v2, v3;					\
-	  vmrlf tmp2, v0, v1;					\
-	  vmrlf   v3, v2, v3;					\
-	  vmrhf tmpa, va, vb;					\
-	  vmrhf tmpb, vc, vd;					\
-	  vmrlf tmpc, va, vb;					\
-	  vmrlf   vd, vc, vd;					\
-	  vpdi v0, tmp0, tmp1, 0;				\
-	  vpdi v1, tmp0, tmp1, 5;				\
-	  vpdi v2, tmp2,   v3, 0;				\
-	  vpdi v3, tmp2,   v3, 5;				\
-	  vpdi va, tmpa, tmpb, 0;				\
-	  vpdi vb, tmpa, tmpb, 5;				\
-	  vpdi vc, tmpc,   vd, 0;				\
-	  vpdi vd, tmpc,   vd, 5;
-
-.balign 8
-.globl __chacha20_s390x_vx_blocks8
-ENTRY (__chacha20_s390x_vx_blocks8)
-	/* input:
-	 *	%r2: input
-	 *	%r3: dst
-	 *	%r4: src
-	 *	%r5: nblks (multiple of 8)
-	 */
-
-	START_STACK(%r8);
-	lgr NBLKS, %r5;
-
-	larl %r7, .Lconsts;
-
-	/* Load counter. */
-	lg %r8, (12 * 4)(INPUT);
-	rllg %r8, %r8, 32;
-
-.balign 4
-	/* Process eight chacha20 blocks per loop. */
-.Lloop8:
-	vlm Y0, Y3, 0(INPUT);
-
-	slgfi NBLKS, 8;
-	lghi ROUND, (20 / 2);
-
-	/* Construct counter vectors X12/X13 & Y12/Y13. */
-	vl X4, (.Ladd_counter_0123 - .Lconsts)(%r7);
-	vl Y4, (.Ladd_counter_4567 - .Lconsts)(%r7);
-	vrepf Y12, Y3, 0;
-	vrepf Y13, Y3, 1;
-	vaccf X5, Y12, X4;
-	vaccf Y5, Y12, Y4;
-	vaf X12, Y12, X4;
-	vaf Y12, Y12, Y4;
-	vaf X13, Y13, X5;
-	vaf Y13, Y13, Y5;
-
-	vrepf X0, Y0, 0;
-	vrepf X1, Y0, 1;
-	vrepf X2, Y0, 2;
-	vrepf X3, Y0, 3;
-	vrepf X4, Y1, 0;
-	vrepf X5, Y1, 1;
-	vrepf X6, Y1, 2;
-	vrepf X7, Y1, 3;
-	vrepf X8, Y2, 0;
-	vrepf X9, Y2, 1;
-	vrepf X10, Y2, 2;
-	vrepf X11, Y2, 3;
-	vrepf X14, Y3, 2;
-	vrepf X15, Y3, 3;
-
-	/* Store counters for blocks 0-7. */
-	vstm X12, X13, (STACK_CTR + 0 * 16)(%r15);
-	vstm Y12, Y13, (STACK_CTR + 2 * 16)(%r15);
-
-	vlr Y0, X0;
-	vlr Y1, X1;
-	vlr Y2, X2;
-	vlr Y3, X3;
-	vlr Y4, X4;
-	vlr Y5, X5;
-	vlr Y6, X6;
-	vlr Y7, X7;
-	vlr Y8, X8;
-	vlr Y9, X9;
-	vlr Y10, X10;
-	vlr Y11, X11;
-	vlr Y14, X14;
-	vlr Y15, X15;
-
-	/* Update and store counter. */
-	agfi %r8, 8;
-	rllg %r5, %r8, 32;
-	stg %r5, (12 * 4)(INPUT);
-
-.balign 4
-.Lround2_8:
-	QUARTERROUND4_V8(X0, X4,  X8, X12,   X1, X5,  X9, X13,
-			 X2, X6, X10, X14,   X3, X7, X11, X15,
-			 Y0, Y4,  Y8, Y12,   Y1, Y5,  Y9, Y13,
-			 Y2, Y6, Y10, Y14,   Y3, Y7, Y11, Y15);
-	QUARTERROUND4_V8(X0, X5, X10, X15,   X1, X6, X11, X12,
-			 X2, X7,  X8, X13,   X3, X4,  X9, X14,
-			 Y0, Y5, Y10, Y15,   Y1, Y6, Y11, Y12,
-			 Y2, Y7,  Y8, Y13,   Y3, Y4,  Y9, Y14);
-	brctg ROUND, .Lround2_8;
-
-	/* Store blocks 4-7. */
-	vstm Y0, Y15, STACK_Y0_Y15(%r15);
-
-	/* Load counters for blocks 0-3. */
-	vlm Y0, Y1, (STACK_CTR + 0 * 16)(%r15);
-
-	lghi ROUND, 1;
-	j .Lfirst_output_4blks_8;
-
-.balign 4
-.Lsecond_output_4blks_8:
-	/* Load blocks 4-7. */
-	vlm X0, X15, STACK_Y0_Y15(%r15);
-
-	/* Load counters for blocks 4-7. */
-	vlm Y0, Y1, (STACK_CTR + 2 * 16)(%r15);
-
-	lghi ROUND, 0;
-
-.balign 4
-	/* Output four chacha20 blocks per loop. */
-.Lfirst_output_4blks_8:
-	vlm Y12, Y15, 0(INPUT);
-	PLUS(X12, Y0);
-	PLUS(X13, Y1);
-	vrepf Y0, Y12, 0;
-	vrepf Y1, Y12, 1;
-	vrepf Y2, Y12, 2;
-	vrepf Y3, Y12, 3;
-	vrepf Y4, Y13, 0;
-	vrepf Y5, Y13, 1;
-	vrepf Y6, Y13, 2;
-	vrepf Y7, Y13, 3;
-	vrepf Y8, Y14, 0;
-	vrepf Y9, Y14, 1;
-	vrepf Y10, Y14, 2;
-	vrepf Y11, Y14, 3;
-	vrepf Y14, Y15, 2;
-	vrepf Y15, Y15, 3;
-	PLUS(X0, Y0);
-	PLUS(X1, Y1);
-	PLUS(X2, Y2);
-	PLUS(X3, Y3);
-	PLUS(X4, Y4);
-	PLUS(X5, Y5);
-	PLUS(X6, Y6);
-	PLUS(X7, Y7);
-	PLUS(X8, Y8);
-	PLUS(X9, Y9);
-	PLUS(X10, Y10);
-	PLUS(X11, Y11);
-	PLUS(X14, Y14);
-	PLUS(X15, Y15);
-
-	vl Y15, (.Lbswap32 - .Lconsts)(%r7);
-	TRANSPOSE_4X4_2(X0, X1, X2, X3, X4, X5, X6, X7,
-			Y9, Y10, Y11, Y12, Y13, Y14);
-	TRANSPOSE_4X4_2(X8, X9, X10, X11, X12, X13, X14, X15,
-			Y9, Y10, Y11, Y12, Y13, Y14);
-
-	vlm Y0, Y14, 0(SRC);
-	vperm X0, X0, X0, Y15;
-	vperm X1, X1, X1, Y15;
-	vperm X2, X2, X2, Y15;
-	vperm X3, X3, X3, Y15;
-	vperm X4, X4, X4, Y15;
-	vperm X5, X5, X5, Y15;
-	vperm X6, X6, X6, Y15;
-	vperm X7, X7, X7, Y15;
-	vperm X8, X8, X8, Y15;
-	vperm X9, X9, X9, Y15;
-	vperm X10, X10, X10, Y15;
-	vperm X11, X11, X11, Y15;
-	vperm X12, X12, X12, Y15;
-	vperm X13, X13, X13, Y15;
-	vperm X14, X14, X14, Y15;
-	vperm X15, X15, X15, Y15;
-	vl Y15, (15 * 16)(SRC);
-
-	XOR(Y0, X0);
-	XOR(Y1, X4);
-	XOR(Y2, X8);
-	XOR(Y3, X12);
-	XOR(Y4, X1);
-	XOR(Y5, X5);
-	XOR(Y6, X9);
-	XOR(Y7, X13);
-	XOR(Y8, X2);
-	XOR(Y9, X6);
-	XOR(Y10, X10);
-	XOR(Y11, X14);
-	XOR(Y12, X3);
-	XOR(Y13, X7);
-	XOR(Y14, X11);
-	XOR(Y15, X15);
-	vstm Y0, Y15, 0(DST);
-
-	aghi SRC, 256;
-	aghi DST, 256;
-
-	clgije ROUND, 1, .Lsecond_output_4blks_8;
-
-	clgijhe NBLKS, 8, .Lloop8;
-
-
-	END_STACK(%r8);
-	xgr %r2, %r2;
-	br %r14;
-END (__chacha20_s390x_vx_blocks8)
-
-#endif /* HAVE_S390_VX_ASM_SUPPORT */
diff --git a/sysdeps/s390/s390-64/chacha20_arch.h b/sysdeps/s390/s390-64/chacha20_arch.h
deleted file mode 100644
index 0c6abf77e8..0000000000
--- a/sysdeps/s390/s390-64/chacha20_arch.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* s390x optimization for ChaCha20.VE_S390_VX_ASM_SUPPORT
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#include <stdbool.h>
-#include <ldsodefs.h>
-#include <sys/auxv.h>
-
-unsigned int __chacha20_s390x_vx_blocks8 (uint32_t *state, uint8_t *dst,
-					  const uint8_t *src, size_t nblks)
-     attribute_hidden;
-
-static inline void
-chacha20_crypt (uint32_t *state, uint8_t *dst, const uint8_t *src,
-		size_t bytes)
-{
-#ifdef HAVE_S390_VX_ASM_SUPPORT
-  _Static_assert (CHACHA20_BUFSIZE % 8 == 0,
-		  "CHACHA20_BUFSIZE not multiple of 8");
-  _Static_assert (CHACHA20_BUFSIZE >= CHACHA20_BLOCK_SIZE * 8,
-		  "CHACHA20_BUFSIZE < CHACHA20_BLOCK_SIZE * 8");
-
-  if (GLRO(dl_hwcap) & HWCAP_S390_VX)
-    {
-      __chacha20_s390x_vx_blocks8 (state, dst, src,
-				   CHACHA20_BUFSIZE / CHACHA20_BLOCK_SIZE);
-      return;
-    }
-#endif
-  chacha20_crypt_generic (state, dst, src, bytes);
-}
diff --git a/sysdeps/unix/sysv/linux/tls-internal.c b/sysdeps/unix/sysv/linux/tls-internal.c
index 0326ebb767..c8a9ed2d40 100644
--- a/sysdeps/unix/sysv/linux/tls-internal.c
+++ b/sysdeps/unix/sysv/linux/tls-internal.c
@@ -16,7 +16,6 @@
    License along with the GNU C Library; if not, see
    <https://www.gnu.org/licenses/>.  */
 
-#include <stdlib/arc4random.h>
 #include <string.h>
 #include <tls-internal.h>
 
@@ -26,13 +25,4 @@ __glibc_tls_internal_free (void)
   struct pthread *self = THREAD_SELF;
   free (self->tls_state.strsignal_buf);
   free (self->tls_state.strerror_l_buf);
-
-  if (self->tls_state.rand_state != NULL)
-    {
-      /* Clear any lingering random state prior so if the thread stack is
-         cached it won't leak any data.  */
-      explicit_bzero (self->tls_state.rand_state,
-		      sizeof (*self->tls_state.rand_state));
-      free (self->tls_state.rand_state);
-    }
 }
diff --git a/sysdeps/x86_64/Makefile b/sysdeps/x86_64/Makefile
index 1178475d75..c19bef2dec 100644
--- a/sysdeps/x86_64/Makefile
+++ b/sysdeps/x86_64/Makefile
@@ -5,13 +5,6 @@ ifeq ($(subdir),csu)
 gen-as-const-headers += link-defines.sym
 endif
 
-ifeq ($(subdir),stdlib)
-sysdep_routines += \
-  chacha20-amd64-sse2 \
-  chacha20-amd64-avx2 \
-  # sysdep_routines
-endif
-
 ifeq ($(subdir),gmon)
 sysdep_routines += _mcount
 # We cannot compile _mcount.S with -pg because that would create
diff --git a/sysdeps/x86_64/chacha20-amd64-avx2.S b/sysdeps/x86_64/chacha20-amd64-avx2.S
deleted file mode 100644
index aefd1cdbd0..0000000000
--- a/sysdeps/x86_64/chacha20-amd64-avx2.S
+++ /dev/null
@@ -1,328 +0,0 @@
-/* Optimized AVX2 implementation of ChaCha20 cipher.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-/* chacha20-amd64-avx2.S  -  AVX2 implementation of ChaCha20 cipher
-
-   Copyright (C) 2017-2019 Jussi Kivilinna <jussi.kivilinna@iki.fi>
-
-   This file is part of Libgcrypt.
-
-   Libgcrypt is free software; you can redistribute it and/or modify
-   it under the terms of the GNU Lesser General Public License as
-   published by the Free Software Foundation; either version 2.1 of
-   the License, or (at your option) any later version.
-
-   Libgcrypt is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with this program; if not, see <https://www.gnu.org/licenses/>.
-*/
-
-/* Based on D. J. Bernstein reference implementation at
-   http://cr.yp.to/chacha.html:
-
-   chacha-regs.c version 20080118
-   D. J. Bernstein
-   Public domain.  */
-
-#include <sysdep.h>
-
-#ifdef PIC
-#  define rRIP (%rip)
-#else
-#  define rRIP
-#endif
-
-/* register macros */
-#define INPUT %rdi
-#define DST   %rsi
-#define SRC   %rdx
-#define NBLKS %rcx
-#define ROUND %eax
-
-/* stack structure */
-#define STACK_VEC_X12 (32)
-#define STACK_VEC_X13 (32 + STACK_VEC_X12)
-#define STACK_TMP     (32 + STACK_VEC_X13)
-#define STACK_TMP1    (32 + STACK_TMP)
-
-#define STACK_MAX     (32 + STACK_TMP1)
-
-/* vector registers */
-#define X0 %ymm0
-#define X1 %ymm1
-#define X2 %ymm2
-#define X3 %ymm3
-#define X4 %ymm4
-#define X5 %ymm5
-#define X6 %ymm6
-#define X7 %ymm7
-#define X8 %ymm8
-#define X9 %ymm9
-#define X10 %ymm10
-#define X11 %ymm11
-#define X12 %ymm12
-#define X13 %ymm13
-#define X14 %ymm14
-#define X15 %ymm15
-
-#define X0h %xmm0
-#define X1h %xmm1
-#define X2h %xmm2
-#define X3h %xmm3
-#define X4h %xmm4
-#define X5h %xmm5
-#define X6h %xmm6
-#define X7h %xmm7
-#define X8h %xmm8
-#define X9h %xmm9
-#define X10h %xmm10
-#define X11h %xmm11
-#define X12h %xmm12
-#define X13h %xmm13
-#define X14h %xmm14
-#define X15h %xmm15
-
-/**********************************************************************
-  helper macros
- **********************************************************************/
-
-/* 4x4 32-bit integer matrix transpose */
-#define transpose_4x4(x0,x1,x2,x3,t1,t2) \
-	vpunpckhdq x1, x0, t2; \
-	vpunpckldq x1, x0, x0; \
-	\
-	vpunpckldq x3, x2, t1; \
-	vpunpckhdq x3, x2, x2; \
-	\
-	vpunpckhqdq t1, x0, x1; \
-	vpunpcklqdq t1, x0, x0; \
-	\
-	vpunpckhqdq x2, t2, x3; \
-	vpunpcklqdq x2, t2, x2;
-
-/* 2x2 128-bit matrix transpose */
-#define transpose_16byte_2x2(x0,x1,t1) \
-	vmovdqa    x0, t1; \
-	vperm2i128 $0x20, x1, x0, x0; \
-	vperm2i128 $0x31, x1, t1, x1;
-
-/**********************************************************************
-  8-way chacha20
- **********************************************************************/
-
-#define ROTATE2(v1,v2,c,tmp)	\
-	vpsrld $(32 - (c)), v1, tmp;	\
-	vpslld $(c), v1, v1;		\
-	vpaddb tmp, v1, v1;		\
-	vpsrld $(32 - (c)), v2, tmp;	\
-	vpslld $(c), v2, v2;		\
-	vpaddb tmp, v2, v2;
-
-#define ROTATE_SHUF_2(v1,v2,shuf)	\
-	vpshufb shuf, v1, v1;		\
-	vpshufb shuf, v2, v2;
-
-#define XOR(ds,s) \
-	vpxor s, ds, ds;
-
-#define PLUS(ds,s) \
-	vpaddd s, ds, ds;
-
-#define QUARTERROUND2(a1,b1,c1,d1,a2,b2,c2,d2,ign,tmp1,\
-		      interleave_op1,interleave_op2,\
-		      interleave_op3,interleave_op4)		\
-	vbroadcasti128 .Lshuf_rol16 rRIP, tmp1;			\
-		interleave_op1;					\
-	PLUS(a1,b1); PLUS(a2,b2); XOR(d1,a1); XOR(d2,a2);	\
-	    ROTATE_SHUF_2(d1, d2, tmp1);			\
-		interleave_op2;					\
-	PLUS(c1,d1); PLUS(c2,d2); XOR(b1,c1); XOR(b2,c2);	\
-	    ROTATE2(b1, b2, 12, tmp1);				\
-	vbroadcasti128 .Lshuf_rol8 rRIP, tmp1;			\
-		interleave_op3;					\
-	PLUS(a1,b1); PLUS(a2,b2); XOR(d1,a1); XOR(d2,a2);	\
-	    ROTATE_SHUF_2(d1, d2, tmp1);			\
-		interleave_op4;					\
-	PLUS(c1,d1); PLUS(c2,d2); XOR(b1,c1); XOR(b2,c2);	\
-	    ROTATE2(b1, b2,  7, tmp1);
-
-	.section .text.avx2, "ax", @progbits
-	.align 32
-chacha20_data:
-L(shuf_rol16):
-	.byte 2,3,0,1,6,7,4,5,10,11,8,9,14,15,12,13
-L(shuf_rol8):
-	.byte 3,0,1,2,7,4,5,6,11,8,9,10,15,12,13,14
-L(inc_counter):
-	.byte 0,1,2,3,4,5,6,7
-L(unsigned_cmp):
-	.long 0x80000000
-
-	.hidden __chacha20_avx2_blocks8
-ENTRY (__chacha20_avx2_blocks8)
-	/* input:
-	 *	%rdi: input
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: nblks (multiple of 8)
-	 */
-	vzeroupper;
-
-	pushq %rbp;
-	cfi_adjust_cfa_offset(8);
-	cfi_rel_offset(rbp, 0)
-	movq %rsp, %rbp;
-	cfi_def_cfa_register(rbp);
-
-	subq $STACK_MAX, %rsp;
-	andq $~31, %rsp;
-
-L(loop8):
-	mov $20, ROUND;
-
-	/* Construct counter vectors X12 and X13 */
-	vpmovzxbd L(inc_counter) rRIP, X0;
-	vpbroadcastd L(unsigned_cmp) rRIP, X2;
-	vpbroadcastd (12 * 4)(INPUT), X12;
-	vpbroadcastd (13 * 4)(INPUT), X13;
-	vpaddd X0, X12, X12;
-	vpxor X2, X0, X0;
-	vpxor X2, X12, X1;
-	vpcmpgtd X1, X0, X0;
-	vpsubd X0, X13, X13;
-	vmovdqa X12, (STACK_VEC_X12)(%rsp);
-	vmovdqa X13, (STACK_VEC_X13)(%rsp);
-
-	/* Load vectors */
-	vpbroadcastd (0 * 4)(INPUT), X0;
-	vpbroadcastd (1 * 4)(INPUT), X1;
-	vpbroadcastd (2 * 4)(INPUT), X2;
-	vpbroadcastd (3 * 4)(INPUT), X3;
-	vpbroadcastd (4 * 4)(INPUT), X4;
-	vpbroadcastd (5 * 4)(INPUT), X5;
-	vpbroadcastd (6 * 4)(INPUT), X6;
-	vpbroadcastd (7 * 4)(INPUT), X7;
-	vpbroadcastd (8 * 4)(INPUT), X8;
-	vpbroadcastd (9 * 4)(INPUT), X9;
-	vpbroadcastd (10 * 4)(INPUT), X10;
-	vpbroadcastd (11 * 4)(INPUT), X11;
-	vpbroadcastd (14 * 4)(INPUT), X14;
-	vpbroadcastd (15 * 4)(INPUT), X15;
-	vmovdqa X15, (STACK_TMP)(%rsp);
-
-L(round2):
-	QUARTERROUND2(X0, X4,  X8, X12,   X1, X5,  X9, X13, tmp:=,X15,,,,)
-	vmovdqa (STACK_TMP)(%rsp), X15;
-	vmovdqa X8, (STACK_TMP)(%rsp);
-	QUARTERROUND2(X2, X6, X10, X14,   X3, X7, X11, X15, tmp:=,X8,,,,)
-	QUARTERROUND2(X0, X5, X10, X15,   X1, X6, X11, X12, tmp:=,X8,,,,)
-	vmovdqa (STACK_TMP)(%rsp), X8;
-	vmovdqa X15, (STACK_TMP)(%rsp);
-	QUARTERROUND2(X2, X7,  X8, X13,   X3, X4,  X9, X14, tmp:=,X15,,,,)
-	sub $2, ROUND;
-	jnz L(round2);
-
-	vmovdqa X8, (STACK_TMP1)(%rsp);
-
-	/* tmp := X15 */
-	vpbroadcastd (0 * 4)(INPUT), X15;
-	PLUS(X0, X15);
-	vpbroadcastd (1 * 4)(INPUT), X15;
-	PLUS(X1, X15);
-	vpbroadcastd (2 * 4)(INPUT), X15;
-	PLUS(X2, X15);
-	vpbroadcastd (3 * 4)(INPUT), X15;
-	PLUS(X3, X15);
-	vpbroadcastd (4 * 4)(INPUT), X15;
-	PLUS(X4, X15);
-	vpbroadcastd (5 * 4)(INPUT), X15;
-	PLUS(X5, X15);
-	vpbroadcastd (6 * 4)(INPUT), X15;
-	PLUS(X6, X15);
-	vpbroadcastd (7 * 4)(INPUT), X15;
-	PLUS(X7, X15);
-	transpose_4x4(X0, X1, X2, X3, X8, X15);
-	transpose_4x4(X4, X5, X6, X7, X8, X15);
-	vmovdqa (STACK_TMP1)(%rsp), X8;
-	transpose_16byte_2x2(X0, X4, X15);
-	transpose_16byte_2x2(X1, X5, X15);
-	transpose_16byte_2x2(X2, X6, X15);
-	transpose_16byte_2x2(X3, X7, X15);
-	vmovdqa (STACK_TMP)(%rsp), X15;
-	vmovdqu X0, (64 * 0 + 16 * 0)(DST)
-	vmovdqu X1, (64 * 1 + 16 * 0)(DST)
-	vpbroadcastd (8 * 4)(INPUT), X0;
-	PLUS(X8, X0);
-	vpbroadcastd (9 * 4)(INPUT), X0;
-	PLUS(X9, X0);
-	vpbroadcastd (10 * 4)(INPUT), X0;
-	PLUS(X10, X0);
-	vpbroadcastd (11 * 4)(INPUT), X0;
-	PLUS(X11, X0);
-	vmovdqa (STACK_VEC_X12)(%rsp), X0;
-	PLUS(X12, X0);
-	vmovdqa (STACK_VEC_X13)(%rsp), X0;
-	PLUS(X13, X0);
-	vpbroadcastd (14 * 4)(INPUT), X0;
-	PLUS(X14, X0);
-	vpbroadcastd (15 * 4)(INPUT), X0;
-	PLUS(X15, X0);
-	vmovdqu X2, (64 * 2 + 16 * 0)(DST)
-	vmovdqu X3, (64 * 3 + 16 * 0)(DST)
-
-	/* Update counter */
-	addq $8, (12 * 4)(INPUT);
-
-	transpose_4x4(X8, X9, X10, X11, X0, X1);
-	transpose_4x4(X12, X13, X14, X15, X0, X1);
-	vmovdqu X4, (64 * 4 + 16 * 0)(DST)
-	vmovdqu X5, (64 * 5 + 16 * 0)(DST)
-	transpose_16byte_2x2(X8, X12, X0);
-	transpose_16byte_2x2(X9, X13, X0);
-	transpose_16byte_2x2(X10, X14, X0);
-	transpose_16byte_2x2(X11, X15, X0);
-	vmovdqu X6,  (64 * 6 + 16 * 0)(DST)
-	vmovdqu X7,  (64 * 7 + 16 * 0)(DST)
-	vmovdqu X8,  (64 * 0 + 16 * 2)(DST)
-	vmovdqu X9,  (64 * 1 + 16 * 2)(DST)
-	vmovdqu X10, (64 * 2 + 16 * 2)(DST)
-	vmovdqu X11, (64 * 3 + 16 * 2)(DST)
-	vmovdqu X12, (64 * 4 + 16 * 2)(DST)
-	vmovdqu X13, (64 * 5 + 16 * 2)(DST)
-	vmovdqu X14, (64 * 6 + 16 * 2)(DST)
-	vmovdqu X15, (64 * 7 + 16 * 2)(DST)
-
-	sub $8, NBLKS;
-	lea (8 * 64)(DST), DST;
-	lea (8 * 64)(SRC), SRC;
-	jnz L(loop8);
-
-	vzeroupper;
-
-	/* eax zeroed by round loop. */
-	leave;
-	cfi_adjust_cfa_offset(-8)
-	cfi_def_cfa_register(%rsp);
-	ret;
-	int3;
-END(__chacha20_avx2_blocks8)
diff --git a/sysdeps/x86_64/chacha20-amd64-sse2.S b/sysdeps/x86_64/chacha20-amd64-sse2.S
deleted file mode 100644
index 351a1109c6..0000000000
--- a/sysdeps/x86_64/chacha20-amd64-sse2.S
+++ /dev/null
@@ -1,311 +0,0 @@
-/* Optimized SSE2 implementation of ChaCha20 cipher.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-/* chacha20-amd64-ssse3.S  -  SSSE3 implementation of ChaCha20 cipher
-
-   Copyright (C) 2017-2019 Jussi Kivilinna <jussi.kivilinna@iki.fi>
-
-   This file is part of Libgcrypt.
-
-   Libgcrypt is free software; you can redistribute it and/or modify
-   it under the terms of the GNU Lesser General Public License as
-   published by the Free Software Foundation; either version 2.1 of
-   the License, or (at your option) any later version.
-
-   Libgcrypt is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with this program; if not, see <https://www.gnu.org/licenses/>.
-*/
-
-/* Based on D. J. Bernstein reference implementation at
-   http://cr.yp.to/chacha.html:
-
-   chacha-regs.c version 20080118
-   D. J. Bernstein
-   Public domain.  */
-
-#include <sysdep.h>
-#include <isa-level.h>
-
-#if MINIMUM_X86_ISA_LEVEL <= 2
-
-#ifdef PIC
-#  define rRIP (%rip)
-#else
-#  define rRIP
-#endif
-
-/* 'ret' instruction replacement for straight-line speculation mitigation */
-#define ret_spec_stop \
-        ret; int3;
-
-/* register macros */
-#define INPUT %rdi
-#define DST   %rsi
-#define SRC   %rdx
-#define NBLKS %rcx
-#define ROUND %eax
-
-/* stack structure */
-#define STACK_VEC_X12 (16)
-#define STACK_VEC_X13 (16 + STACK_VEC_X12)
-#define STACK_TMP     (16 + STACK_VEC_X13)
-#define STACK_TMP1    (16 + STACK_TMP)
-#define STACK_TMP2    (16 + STACK_TMP1)
-
-#define STACK_MAX     (16 + STACK_TMP2)
-
-/* vector registers */
-#define X0 %xmm0
-#define X1 %xmm1
-#define X2 %xmm2
-#define X3 %xmm3
-#define X4 %xmm4
-#define X5 %xmm5
-#define X6 %xmm6
-#define X7 %xmm7
-#define X8 %xmm8
-#define X9 %xmm9
-#define X10 %xmm10
-#define X11 %xmm11
-#define X12 %xmm12
-#define X13 %xmm13
-#define X14 %xmm14
-#define X15 %xmm15
-
-/**********************************************************************
-  helper macros
- **********************************************************************/
-
-/* 4x4 32-bit integer matrix transpose */
-#define TRANSPOSE_4x4(x0, x1, x2, x3, t1, t2, t3) \
-	movdqa    x0, t2; \
-	punpckhdq x1, t2; \
-	punpckldq x1, x0; \
-	\
-	movdqa    x2, t1; \
-	punpckldq x3, t1; \
-	punpckhdq x3, x2; \
-	\
-	movdqa     x0, x1; \
-	punpckhqdq t1, x1; \
-	punpcklqdq t1, x0; \
-	\
-	movdqa     t2, x3; \
-	punpckhqdq x2, x3; \
-	punpcklqdq x2, t2; \
-	movdqa     t2, x2;
-
-/* fill xmm register with 32-bit value from memory */
-#define PBROADCASTD(mem32, xreg) \
-	movd mem32, xreg; \
-	pshufd $0, xreg, xreg;
-
-/**********************************************************************
-  4-way chacha20
- **********************************************************************/
-
-#define ROTATE2(v1,v2,c,tmp1,tmp2)	\
-	movdqa v1, tmp1; 		\
-	movdqa v2, tmp2; 		\
-	psrld $(32 - (c)), v1;		\
-	pslld $(c), tmp1;		\
-	paddb tmp1, v1;			\
-	psrld $(32 - (c)), v2;		\
-	pslld $(c), tmp2;		\
-	paddb tmp2, v2;
-
-#define XOR(ds,s) \
-	pxor s, ds;
-
-#define PLUS(ds,s) \
-	paddd s, ds;
-
-#define QUARTERROUND2(a1,b1,c1,d1,a2,b2,c2,d2,ign,tmp1,tmp2)	\
-	PLUS(a1,b1); PLUS(a2,b2); XOR(d1,a1); XOR(d2,a2);	\
-	    ROTATE2(d1, d2, 16, tmp1, tmp2);			\
-	PLUS(c1,d1); PLUS(c2,d2); XOR(b1,c1); XOR(b2,c2);	\
-	    ROTATE2(b1, b2, 12, tmp1, tmp2);			\
-	PLUS(a1,b1); PLUS(a2,b2); XOR(d1,a1); XOR(d2,a2);	\
-	    ROTATE2(d1, d2, 8, tmp1, tmp2);			\
-	PLUS(c1,d1); PLUS(c2,d2); XOR(b1,c1); XOR(b2,c2);	\
-	    ROTATE2(b1, b2,  7, tmp1, tmp2);
-
-	.section .text.sse2,"ax",@progbits
-
-chacha20_data:
-	.align 16
-L(counter1):
-	.long 1,0,0,0
-L(inc_counter):
-	.long 0,1,2,3
-L(unsigned_cmp):
-	.long 0x80000000,0x80000000,0x80000000,0x80000000
-
-	.hidden __chacha20_sse2_blocks4
-ENTRY (__chacha20_sse2_blocks4)
-	/* input:
-	 *	%rdi: input
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: nblks (multiple of 4)
-	 */
-
-	pushq %rbp;
-	cfi_adjust_cfa_offset(8);
-	cfi_rel_offset(rbp, 0)
-	movq %rsp, %rbp;
-	cfi_def_cfa_register(%rbp);
-
-	subq $STACK_MAX, %rsp;
-	andq $~15, %rsp;
-
-L(loop4):
-	mov $20, ROUND;
-
-	/* Construct counter vectors X12 and X13 */
-	movdqa L(inc_counter) rRIP, X0;
-	movdqa L(unsigned_cmp) rRIP, X2;
-	PBROADCASTD((12 * 4)(INPUT), X12);
-	PBROADCASTD((13 * 4)(INPUT), X13);
-	paddd X0, X12;
-	movdqa X12, X1;
-	pxor X2, X0;
-	pxor X2, X1;
-	pcmpgtd X1, X0;
-	psubd X0, X13;
-	movdqa X12, (STACK_VEC_X12)(%rsp);
-	movdqa X13, (STACK_VEC_X13)(%rsp);
-
-	/* Load vectors */
-	PBROADCASTD((0 * 4)(INPUT), X0);
-	PBROADCASTD((1 * 4)(INPUT), X1);
-	PBROADCASTD((2 * 4)(INPUT), X2);
-	PBROADCASTD((3 * 4)(INPUT), X3);
-	PBROADCASTD((4 * 4)(INPUT), X4);
-	PBROADCASTD((5 * 4)(INPUT), X5);
-	PBROADCASTD((6 * 4)(INPUT), X6);
-	PBROADCASTD((7 * 4)(INPUT), X7);
-	PBROADCASTD((8 * 4)(INPUT), X8);
-	PBROADCASTD((9 * 4)(INPUT), X9);
-	PBROADCASTD((10 * 4)(INPUT), X10);
-	PBROADCASTD((11 * 4)(INPUT), X11);
-	PBROADCASTD((14 * 4)(INPUT), X14);
-	PBROADCASTD((15 * 4)(INPUT), X15);
-	movdqa X11, (STACK_TMP)(%rsp);
-	movdqa X15, (STACK_TMP1)(%rsp);
-
-L(round2_4):
-	QUARTERROUND2(X0, X4,  X8, X12,   X1, X5,  X9, X13, tmp:=,X11,X15)
-	movdqa (STACK_TMP)(%rsp), X11;
-	movdqa (STACK_TMP1)(%rsp), X15;
-	movdqa X8, (STACK_TMP)(%rsp);
-	movdqa X9, (STACK_TMP1)(%rsp);
-	QUARTERROUND2(X2, X6, X10, X14,   X3, X7, X11, X15, tmp:=,X8,X9)
-	QUARTERROUND2(X0, X5, X10, X15,   X1, X6, X11, X12, tmp:=,X8,X9)
-	movdqa (STACK_TMP)(%rsp), X8;
-	movdqa (STACK_TMP1)(%rsp), X9;
-	movdqa X11, (STACK_TMP)(%rsp);
-	movdqa X15, (STACK_TMP1)(%rsp);
-	QUARTERROUND2(X2, X7,  X8, X13,   X3, X4,  X9, X14, tmp:=,X11,X15)
-	sub $2, ROUND;
-	jnz L(round2_4);
-
-	/* tmp := X15 */
-	movdqa (STACK_TMP)(%rsp), X11;
-	PBROADCASTD((0 * 4)(INPUT), X15);
-	PLUS(X0, X15);
-	PBROADCASTD((1 * 4)(INPUT), X15);
-	PLUS(X1, X15);
-	PBROADCASTD((2 * 4)(INPUT), X15);
-	PLUS(X2, X15);
-	PBROADCASTD((3 * 4)(INPUT), X15);
-	PLUS(X3, X15);
-	PBROADCASTD((4 * 4)(INPUT), X15);
-	PLUS(X4, X15);
-	PBROADCASTD((5 * 4)(INPUT), X15);
-	PLUS(X5, X15);
-	PBROADCASTD((6 * 4)(INPUT), X15);
-	PLUS(X6, X15);
-	PBROADCASTD((7 * 4)(INPUT), X15);
-	PLUS(X7, X15);
-	PBROADCASTD((8 * 4)(INPUT), X15);
-	PLUS(X8, X15);
-	PBROADCASTD((9 * 4)(INPUT), X15);
-	PLUS(X9, X15);
-	PBROADCASTD((10 * 4)(INPUT), X15);
-	PLUS(X10, X15);
-	PBROADCASTD((11 * 4)(INPUT), X15);
-	PLUS(X11, X15);
-	movdqa (STACK_VEC_X12)(%rsp), X15;
-	PLUS(X12, X15);
-	movdqa (STACK_VEC_X13)(%rsp), X15;
-	PLUS(X13, X15);
-	movdqa X13, (STACK_TMP)(%rsp);
-	PBROADCASTD((14 * 4)(INPUT), X15);
-	PLUS(X14, X15);
-	movdqa (STACK_TMP1)(%rsp), X15;
-	movdqa X14, (STACK_TMP1)(%rsp);
-	PBROADCASTD((15 * 4)(INPUT), X13);
-	PLUS(X15, X13);
-	movdqa X15, (STACK_TMP2)(%rsp);
-
-	/* Update counter */
-	addq $4, (12 * 4)(INPUT);
-
-	TRANSPOSE_4x4(X0, X1, X2, X3, X13, X14, X15);
-	movdqu X0, (64 * 0 + 16 * 0)(DST)
-	movdqu X1, (64 * 1 + 16 * 0)(DST)
-	movdqu X2, (64 * 2 + 16 * 0)(DST)
-	movdqu X3, (64 * 3 + 16 * 0)(DST)
-	TRANSPOSE_4x4(X4, X5, X6, X7, X0, X1, X2);
-	movdqa (STACK_TMP)(%rsp), X13;
-	movdqa (STACK_TMP1)(%rsp), X14;
-	movdqa (STACK_TMP2)(%rsp), X15;
-	movdqu X4, (64 * 0 + 16 * 1)(DST)
-	movdqu X5, (64 * 1 + 16 * 1)(DST)
-	movdqu X6, (64 * 2 + 16 * 1)(DST)
-	movdqu X7, (64 * 3 + 16 * 1)(DST)
-	TRANSPOSE_4x4(X8, X9, X10, X11, X0, X1, X2);
-	movdqu X8,  (64 * 0 + 16 * 2)(DST)
-	movdqu X9,  (64 * 1 + 16 * 2)(DST)
-	movdqu X10, (64 * 2 + 16 * 2)(DST)
-	movdqu X11, (64 * 3 + 16 * 2)(DST)
-	TRANSPOSE_4x4(X12, X13, X14, X15, X0, X1, X2);
-	movdqu X12, (64 * 0 + 16 * 3)(DST)
-	movdqu X13, (64 * 1 + 16 * 3)(DST)
-	movdqu X14, (64 * 2 + 16 * 3)(DST)
-	movdqu X15, (64 * 3 + 16 * 3)(DST)
-
-	sub $4, NBLKS;
-	lea (4 * 64)(DST), DST;
-	lea (4 * 64)(SRC), SRC;
-	jnz L(loop4);
-
-	/* eax zeroed by round loop. */
-	leave;
-	cfi_adjust_cfa_offset(-8)
-	cfi_def_cfa_register(%rsp);
-	ret_spec_stop;
-END (__chacha20_sse2_blocks4)
-
-#endif /* if MINIMUM_X86_ISA_LEVEL <= 2 */
diff --git a/sysdeps/x86_64/chacha20_arch.h b/sysdeps/x86_64/chacha20_arch.h
deleted file mode 100644
index 6f3784e392..0000000000
--- a/sysdeps/x86_64/chacha20_arch.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/* Chacha20 implementation, used on arc4random.
-   Copyright (C) 2022 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
-
-#include <isa-level.h>
-#include <ldsodefs.h>
-#include <cpu-features.h>
-#include <sys/param.h>
-
-unsigned int __chacha20_sse2_blocks4 (uint32_t *state, uint8_t *dst,
-				      const uint8_t *src, size_t nblks)
-     attribute_hidden;
-unsigned int __chacha20_avx2_blocks8 (uint32_t *state, uint8_t *dst,
-				      const uint8_t *src, size_t nblks)
-     attribute_hidden;
-
-static inline void
-chacha20_crypt (uint32_t *state, uint8_t *dst, const uint8_t *src,
-		size_t bytes)
-{
-  _Static_assert (CHACHA20_BUFSIZE % 4 == 0 && CHACHA20_BUFSIZE % 8 == 0,
-		  "CHACHA20_BUFSIZE not multiple of 4 or 8");
-  _Static_assert (CHACHA20_BUFSIZE >= CHACHA20_BLOCK_SIZE * 8,
-		  "CHACHA20_BUFSIZE < CHACHA20_BLOCK_SIZE * 8");
-
-#if MINIMUM_X86_ISA_LEVEL > 2
-  __chacha20_avx2_blocks8 (state, dst, src,
-			   CHACHA20_BUFSIZE / CHACHA20_BLOCK_SIZE);
-#else
-  const struct cpu_features* cpu_features = __get_cpu_features ();
-
-  /* AVX2 version uses vzeroupper, so disable it if RTM is enabled.  */
-  if (X86_ISA_CPU_FEATURE_USABLE_P (cpu_features, AVX2)
-      && X86_ISA_CPU_FEATURES_ARCH_P (cpu_features, Prefer_No_VZEROUPPER, !))
-    __chacha20_avx2_blocks8 (state, dst, src,
-			     CHACHA20_BUFSIZE / CHACHA20_BLOCK_SIZE);
-  else
-    __chacha20_sse2_blocks4 (state, dst, src,
-			     CHACHA20_BUFSIZE / CHACHA20_BLOCK_SIZE);
-#endif
-}
-- 
2.35.1

