Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6B5CCA48A
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 01:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiGZBKT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 21:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiGZBKS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 21:10:18 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8112E63EF
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 18:10:17 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id l188so3845427oia.4
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 18:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P//9YslxSg0bCM7OInCyxs68DQsmujiF20lhQqTd+fM=;
        b=JTZedKGTrcWe/Ub4nKLqeliWPkRxdH6OPf5Z7jQiK5zuRFyxCyRmNEDhV9AMzjEtSe
         OfGfrtNfSeDsNyhIYprFegPPxuANescRMesq46uNLSFbx132a5WN5QWVG9zAKV3chSwo
         muuHWikeXyynoW2jBAfba10TMxAChvFEEbNJJsiRA7+B7YSSZUGWmDLaw64BRFKsmr+N
         P7Z9pkkgf1x+eOLoKwlh2F0QA0AxCdo81ewgO3k8Ve1yzbC5bufa5aC2YjLga7H/2EsI
         tzX9A8d2xMfSGwScneuCGB/z7dJY/+7FYD4ZBLnxyTIgI99lx3gSB93UbloKwWRL3pGe
         rj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P//9YslxSg0bCM7OInCyxs68DQsmujiF20lhQqTd+fM=;
        b=4uwQxWNvURcOdfP7OaNapA/b4qH2fQdAy1dna1qoOD5cH4SdNWXF1Lwy2DSiWrjMcR
         xzgQbW7GUYpKKDecNHQj8+QBw0XJOFfc3uQTSzMs2wSao9Tq4BvHG1s0/nWKIi3zWYNH
         zN0cz/7sJpWI0pPLqQ2IU7SwlPBnZ0FBsMKN3q7IofngGFgV5DLa1v3FiZBWU+NsP2vZ
         8LnQj6Di/uJ52UMej4HJ9X19PgqLOBvQVRDT0/BDVH95JanoQQUOBXtYccrYdcz6lKIh
         wGEoInUtDUaj7lrwy00+t5kTY64jJo30oc9rpgu9R+RzNC56CLgHdLkb3aTWtCs/cBdq
         saGg==
X-Gm-Message-State: AJIora8sJ7jMK30LTd8sVKQJ+dsd581q22QEYL6mebUEfqU7H3X0wxMX
        +ePTywGaUi2k5ayAzCIKPmOU32CguqTkHIwdUic0mseY
X-Google-Smtp-Source: AGRyM1sLAXqvTUzm/QUqgW1tI5ulvclyuwh658EK2d9nP+ocqw4QSNWkChDqNZXZLdFm3+Sa4ErBcN7cPJCSYZjEn8E=
X-Received: by 2002:a05:6808:1313:b0:33a:b979:b2c6 with SMTP id
 y19-20020a056808131300b0033ab979b2c6mr8346963oiv.37.1658797816867; Mon, 25
 Jul 2022 18:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220725225728.824128-1-Jason@zx2c4.com> <20220725232810.843433-1-Jason@zx2c4.com>
In-Reply-To: <20220725232810.843433-1-Jason@zx2c4.com>
From:   Mark Harris <mark.hsj@gmail.com>
Date:   Mon, 25 Jul 2022 18:10:06 -0700
Message-ID: <CAMdZqKH=9mDhoW_gpL-pUEQAGuN=orc1doudyAuHdoPc7O53RQ@mail.gmail.com>
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld wrote:
> +      l = __getrandom_nocancel (p, n, 0);
> +      if (l > 0)
> +       {
> +         if ((size_t) l == n)
> +           return; /* Done reading, success. */
> +         p = (uint8_t *) p + l;
> +         n -= l;
> +         continue; /* Interrupted by a signal; keep going. */
> +       }
> +      else if (l == 0)
> +       arc4random_getrandom_failure (); /* Weird, should never happen. */
> +      else if (errno == ENOSYS)
> +       {
> +         have_getrandom = false;
> +         break; /* No syscall, so fallback to /dev/urandom. */
> +       }
> +      arc4random_getrandom_failure (); /* Unknown error, should never happen. */

Isn't EINTR also possible?  Aborting in that case does not seem reasonable.

Also the __getrandom_nocancel function does not set errno on Linux; it
just returns INTERNAL_SYSCALL_CALL (getrandom, buf, buflen, flags).
So unless that is changed, it doesn't look like this ENOSYS check will
detect old Linux kernels.

> +      struct pollfd pfd = { .events = POLLIN };
> +      pfd.fd = TEMP_FAILURE_RETRY (
> +         __open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
> +      if (pfd.fd < 0)
> +       arc4random_getrandom_failure ();
> +      if (__poll (&pfd, 1, -1) < 0)
> +       arc4random_getrandom_failure ();
> +      if (__close_nocancel (pfd.fd) < 0)
> +       arc4random_getrandom_failure ();

The TEMP_FAILURE_RETRY handles EINTR on open, but __poll can also
result in EINTR.


 - Mark
