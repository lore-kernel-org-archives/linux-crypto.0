Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447E1C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 16:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbiBKQTk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 11:19:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiBKQTj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 11:19:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8452E5;
        Fri, 11 Feb 2022 08:19:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6918560C93;
        Fri, 11 Feb 2022 16:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C1AC340F0;
        Fri, 11 Feb 2022 16:19:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="qF8ii9xn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644596374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rzoW3YyPeWW4jcsbMPGuowkW6K7jrfIKlpTP07j3oZQ=;
        b=qF8ii9xn1PIkYi89MtcaCVAe6oLfJN2XVVnJfYjqvNpIsxSUYDZ/7HfekmgVESjrNgLWX2
        r+emPjzh7b12Z6VnR7dqZpfNWio0IgebayJVQIWDAfwj5LfFQo+lyqzWEKUxC/Y4gqI9YA
        i161VRjF9xtuyRzEmQUpmP9NiaBlwNc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5541b2af (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 11 Feb 2022 16:19:34 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id bt13so26486629ybb.2;
        Fri, 11 Feb 2022 08:19:34 -0800 (PST)
X-Gm-Message-State: AOAM532zs7XKPzSfCMf8h9BqQDCKTSpAXU3jh7uz84NKoAfhEz7ZJJ9e
        vYGQkN4MscrKNPQ29LUYxy8NarJ8NCx7YIPabIU=
X-Google-Smtp-Source: ABdhPJyp0xbNqy8TteC9ejOQXQZA8vDZXsCwEQWpQ1NkPK9f112/FiMVl+2FqyDJcUdMhwm/EtcL4aD7mXq6sWgELvQ=
X-Received: by 2002:a25:ba49:: with SMTP id z9mr2087182ybj.32.1644596373383;
 Fri, 11 Feb 2022 08:19:33 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pGwyZKu=9yCben-V30hR+zEjb9iZGWr5_RAE-uXt_Ofw@mail.gmail.com>
 <20220211011446.392673-1-Jason@zx2c4.com> <YgYbRa+5cC0ivWrK@linutronix.de>
 <CAHmME9oBCt=bvjQLwmppr29W9FdJ612+d1a8gUExyWZuZHVWZw@mail.gmail.com> <YgZ36ShvikQhcQYl@linutronix.de>
In-Reply-To: <YgZ36ShvikQhcQYl@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 11 Feb 2022 17:19:21 +0100
X-Gmail-Original-Message-ID: <CAHmME9p9RVRtD_GQ7FPdj64_a6aArQTtdE6Ch7X_8AQngi1pUQ@mail.gmail.com>
Message-ID: <CAHmME9p9RVRtD_GQ7FPdj64_a6aArQTtdE6Ch7X_8AQngi1pUQ@mail.gmail.com>
Subject: Re: [PATCH] random: ensure mix_interrupt_randomness() is consistent
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sultan Alsawaf <sultan@kerneltoast.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sebastian,

On Fri, Feb 11, 2022 at 3:51 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> > Unfortunately, though, I think disabling migration is required. Sultan
> > (CC'd) found that these workqueues can migrate even midway through
> > running. And generally the whole idea is to keep this on the *same*
> > CPU so that we don't have to introduce locks and synchronization.
>
> They can't. Your workqueue is not unbound _and_ you specify a specific
> CPU instead of WORK_CPU_UNBOUND (or an offlined CPU).
> The only way it can migrate is if the CPU goes down while the worker is
> running (or before it had a chance I think) which forces the scheduler
> to break its (worker's) CPU affinity and move it to another CPU.

Right, but the CPU could come back up while the worker is running on
the wrong CPU, and then kaboom. Anyway, the migration_disable() window
is very, very small - a few instructions at most with no loops. I
think it'll be fine.

> > I'll add comments around the acquire/release. The remaining question
> > I believe is: would you prefer disabing irqs during the 2 word memcpy,
> > or this counter double read loop?
>
> I would prefer the cmpxchg

I'll do the cmpxchg and send you a v+1. Sorry it wasn't in the last
one. It only now clicked with me what that code would look like, after
I stepped away from the screen for a bit to defrobulate my brains.

Jason
