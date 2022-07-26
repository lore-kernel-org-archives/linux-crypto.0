Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0EAC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiGZLLN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiGZLLN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:11:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9183122A
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C23D6127D
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 11:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C0CC341C0;
        Tue, 26 Jul 2022 11:11:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jCa5mvMq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658833869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l7hYUvk2TiaSprm6mFDyeBH2ADTccUvHbnvTYPsCan4=;
        b=jCa5mvMqI+dAcQQu2FHePYp2GD/9lv1a527lIHZjQ0StSkDnZg7t84oU5rVoNOVm29/yhp
        uB5+PXHJSUr0p6lAxWuhRn+vRdC5cwYebDrI2QW5mmKTBG0cJwG8QtWua/w1SKri3TW8Z+
        da2rZPXMSwocEttvO4YyZQ3pEx2UFcs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7394da2e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 11:11:09 +0000 (UTC)
Date:   Tue, 26 Jul 2022 13:11:06 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     libc-alpha@sourceware.org
Cc:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Mark Harris <mark.hsj@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] arc4random: simplify design for better safety
Message-ID: <Yt/LyuNnzfRRedvT@zx2c4.com>
References: <Yt/KOQLPSnXFPtWH@zx2c4.com>
 <20220726110727.1079196-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220726110727.1079196-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As before, I'll paste the main function in question standalone so that
this is a bit easier to read for those not applying this to an actual
tree.

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
      else if (l == -EINTR)
	continue; /* Interrupted by a signal; keep going. */
      else if (l == -ENOSYS)
	{
	  have_getrandom = false;
	  break; /* No syscall, so fallback to /dev/urandom. */
	}
      arc4random_getrandom_failure (); /* Unknown error, should never happen. */
    }

  if (!seen_initialized)
    {
      struct pollfd pfd = { .events = POLLIN };
      pfd.fd = TEMP_FAILURE_RETRY (
	  __open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
      if (pfd.fd < 0)
	arc4random_getrandom_failure ();
      if (TEMP_FAILURE_RETRY (__poll_nocancel (&pfd, 1, -1)) < 0)
	arc4random_getrandom_failure ();
      if (__close_nocancel (pfd.fd) < 0)
	arc4random_getrandom_failure ();
      seen_initialized = true;
    }

  fd = TEMP_FAILURE_RETRY (
      __open64_nocancel ("/dev/urandom", O_RDONLY | O_CLOEXEC | O_NOCTTY));
  if (fd < 0)
    arc4random_getrandom_failure ();
  do
    {
      ssize_t l = TEMP_FAILURE_RETRY (__read_nocancel (fd, p, n));
      if (l <= 0)
	arc4random_getrandom_failure ();
      p = (uint8_t *) p + l;
      n -= l;
    }
  while (n);
  if (__close_nocancel (fd) < 0)
    arc4random_getrandom_failure ();
}
