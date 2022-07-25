Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F9AC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 23:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbiGYXLf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 19:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237595AbiGYXLb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 19:11:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429262613E
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C2861444
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 23:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A57C341C6;
        Mon, 25 Jul 2022 23:11:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LBHOcs51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658790687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zonKIOJ2fmlfI/iMb+LZK9aQ2EHiBAm9kqAGXEH1jK0=;
        b=LBHOcs51Df5uhRvh0NDxL1bA8na9UDxXZUye1546ycyHT5ZbIlCZCSi2TUzzbuReIGACWj
        qgyVI/ZWg3Q2C6SVl8fOjJbhXzIN4I8mOQJfidmiM94ozETc7qZNAkWDERpm2M3t+ay3B/
        gZP0bgxXYY2xBmMwlDIN6gWGRwbvJb0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0756cbc2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 25 Jul 2022 23:11:26 +0000 (UTC)
Date:   Tue, 26 Jul 2022 01:11:24 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     libc-alpha@sourceware.org
Cc:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] arc4random: simplify design for better safety
Message-ID: <Yt8jHGUdFAKdWgZf@zx2c4.com>
References: <Ytwg8YEJn+76h5g9@zx2c4.com>
 <20220725225728.824128-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220725225728.824128-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If you're just following along on the mailing list, without actively
trying to apply this to a glibc tree, that diff might be hard to read.
The meat of it is the below function implementation. Notably this is
basically the same as systemd's crypto_random_bytes() (which I recently
rewrote there).

void
__arc4random_buf (void *p, size_t n)
{
  static bool have_getrandom = true, seen_initialized = false;
  int fd;

  if (n == 0)
    return;

  for (;;)
    {
      ssize_t l;

      if (!have_getrandom)
        break;

      l = __getrandom_nocancel (p, n, 0);
      if (l > 0)
        {
          if ((size_t) l == n)
              return; /* Done reading, success. */
          p = (uint8_t *) p + l;
          n -= l;
          continue; /* Interrupted by a signal; keep going. */
        }
      else if (l == 0)
        arc4random_getrandom_failure (); /* Weird, should never happen. */
      else if (errno == ENOSYS)
        {
          have_getrandom = false;
          break; /* No syscall, so fallback to /dev/urandom. */
        }
      arc4random_getrandom_failure (); /* Unknown other error, should never happen. */
    }

  if (!seen_initialized)
    {
      struct pollfd pfd = { .events = POLLIN };
      pfd.fd = TEMP_FAILURE_RETRY (__open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
      if (pfd.fd < 0)
        arc4random_getrandom_failure ();
      if (__poll(&pfd, 1, -1) < 0)
        arc4random_getrandom_failure ();
      if (__close_nocancel(pfd.fd) < 0)
        arc4random_getrandom_failure ();
      seen_initialized = true;
    }

  fd = open("/dev/urandom", O_RDONLY | O_CLOEXEC | O_NOCTTY);
  if (fd < 0)
    arc4random_getrandom_failure ();
  while (n)
    {
      ssize_t l = TEMP_FAILURE_RETRY (__read_nocancel (fd, p, n));
      if (l <= 0)
        arc4random_getrandom_failure ();
      p = (uint8_t *) p + l;
      n -= l;
    }
  if (__close_nocancel (fd) < 0)
    arc4random_getrandom_failure ();
}
libc_hidden_def (__arc4random_buf)
weak_alias (__arc4random_buf, arc4random_buf)
