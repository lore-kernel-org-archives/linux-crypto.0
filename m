Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA3EC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Oct 2021 07:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA826124F
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Oct 2021 07:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhJDHYo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Oct 2021 03:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhJDHYn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Oct 2021 03:24:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065B7C061745
        for <linux-crypto@vger.kernel.org>; Mon,  4 Oct 2021 00:22:55 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t8so29100769wri.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 Oct 2021 00:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUDOhGU1hKfpMIdYt6saUO3YB5wtNNxgpFXtu9hoNB8=;
        b=lEt4edeH9VCU9X7mSopsWx3Zw17qpbuwDG6MGSwIvIdGyPMn7WxdX9HGtSkTuU5L2h
         PGUAf90+M1tShKqcwbDo5PBfdeoQkLDbkMltuGzx6b8NijhayO2ECe3YeeadxPwCZZi4
         O8rZWoHiBdLs/9jAGK9MpDzZF+0CufdDuaf+8Qy4yD88oONd1MHNvWLr623woJiXlKcu
         pFdErUpeNQMWUnq9N+kcrRRoRFj1UhJKNMXw6abwZzE5YgeX5xsVCeRpxSho6Ku1VDtv
         bU41qgeJSt7hN52Q8cGdATcy1AFIp98mqQqHJdThYvCz3LdYVgfRT+R4dVY/wLVInr84
         5OtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUDOhGU1hKfpMIdYt6saUO3YB5wtNNxgpFXtu9hoNB8=;
        b=RJ3X3I+DoR37VC5rcJsDBFos6Vpi3sY2bZJ3gRVoAZaDXiBG3FLgfr46rqKOgzzAXh
         fwTi2JGIHn55RXw+68Kx0UiLpxGwxxPSunYTeqxhbd27TgUwOnHCdOF48Dvn4rE48JE1
         /qRBG3K01yIITWc+oVNNWx4XEwmfLTMTdcoy6Hvo9PqKOzMd2vDj8bdn8Wwpj/8h391d
         t2/tRk/5Yw/fYq4HPbn8p90pr7lG8nv1iq4xtO1t3AcmIRTqfIM/jNU/O+aHHWSo2tYa
         kQM68cOyEQPBF3KACMtQZsm7GPrQTHGelDQaeHuDGOPRC1Mh0CPS+gjD/ZdPomZt42CD
         SEWQ==
X-Gm-Message-State: AOAM533PAnfjOKO+9CeJWd7u5PvfrKRHpzNQxwyyj/pt2E7gPvwAPdIh
        +qlR5+q+HMQkEujlumucx6NIkNwRNKr3OQxSZS4B65WlBHQ=
X-Google-Smtp-Source: ABdhPJyrtTXYusOZGw7z9CnOvmIwU9tio5qiaNiFp9AYUcTvTodromH0mzDT8Ztq6CJKqKJwoRJGDjSg7N2oWir5bfY=
X-Received: by 2002:adf:a15c:: with SMTP id r28mr12468046wrr.287.1633332173647;
 Mon, 04 Oct 2021 00:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
 <CAAMy4UTgnpO9dv3hLzB_DWYfC-OAx6SYactSjL_J8oDJ76XfhA@mail.gmail.com>
In-Reply-To: <CAAMy4UTgnpO9dv3hLzB_DWYfC-OAx6SYactSjL_J8oDJ76XfhA@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Mon, 4 Oct 2021 15:22:41 +0800
Message-ID: <CACXcFmnLa5gGa9+V5Do6Wbimup5rh3nkaUcTwThUGpWZH8gyxw@mail.gmail.com>
Subject: Re: [Cryptography] [RFC] random: add new pseudorandom number generator
To:     Tom Mitchell <mitch@niftyegg.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Cryptography <cryptography@metzdowd.com>,
        "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 4, 2021 Tom Mitchell <mitch@niftyegg.com> wrote:

> How do you plan to get this into the Linux community for testing?
> In a cluster of machines a PRNG kernel update and verification process
> seems tedious and difficult to tidy up after a problem is found or
> suspected.

I'll submit it as a kernel patch; there's a procedure in place to test
those before acceptance. I'm doing this RFC version first to try
and be certain I have it right before submitting.

> Spinlocks ... hmmm... now I need to look at how the kernel can ignore
> or not need them?

The spinlocks in my code are rather dubious emulations used
for out-of-kernel testing. My comments include:

* The locking here is completely untested and quite likely
* to be partly wrong. I just define emulations for spin_lock()
* and spin_unlock() and stick them in as reminders of where
* locks are needed.
....
 * this will catch some basic blunders
 * like taking a lock that the calling code holds
 *
 * it is definitely not enough for serious lock tests

The current driver uses spinlocks fairly extensively.
There was a thread on the linux crypto list about
getting rid of those locks:
https://www.spinics.net/lists/linux-crypto/msg55255.html
but as far as I know the prposal went nowhere.

Another comment in my code is:
* I add two new locks, one for xtea and and an output lock
* which all output routines take. Contexts are updated
* within that lock, so duplicate outputs are astronomically
* unlikely.
*
* In the rest of the code, I only lock data structures which
* are being written to, never ones that are only read. If
* someone writes while we are reading then read output becomes
* indeterminate, and in most applications that would be a Bad
* Thing. In an rng, though, it is at worst harmless, and
* arguably even a Good Thing.
