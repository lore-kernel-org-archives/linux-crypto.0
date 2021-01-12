Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258B9C433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 00:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E720722D57
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 00:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbhALA0F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404229AbhALAFQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 19:05:16 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBF2C061786
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 16:04:36 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m25so606536lfc.11
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 16:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XS9x4tfe1NBdhR5zesiN+CGaWhvZlzcF27NwBDw1wRc=;
        b=BwuL7yZDyqnpbChB/UKU5UXidDWpM3L+UCh8vme2kp6gTLToZsZm1L1RfZcYNQGazl
         DFFfgj4uolkUm4miyvKJI6qqjg6Z/Ki+44uqk4vu4c5RPyuUiNAvdVru3mNlE8qEz6PM
         TaWeQMdrvQH6MprIAZ7kh3zKiLuSUNKE32ZBoUFtJQljg/EtDbgtGsdmEJUAY0L3Fnvv
         JEfjbD2zpD8dscnUTTaBP2NWfr398kEhY98XyiLXGdb74Q+Nab1+nFXUJqe4j/RNxyUM
         E3tR6xYDgRI4TTtAwI+h1FH2FT97l6Zggb1QX8Csql6ftmNXBO+Xs8tSuIsSOmwo2tVT
         cmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XS9x4tfe1NBdhR5zesiN+CGaWhvZlzcF27NwBDw1wRc=;
        b=kdoCYZZtBqN07FEnzYOHeD2X/5ZSKx4icEt3+hf6T6Sn+3r7LiTFLUTbWhY+DHh5dW
         9oGEK6Kk9C1wHR8IULv8xu4RgJSigxBzWL8i8lsZT2HjT8zN8dFiIeOIYqlOZdDpyoQj
         rz46mj5X4NrDEZ2p6TQWKmWb51Fb6FiQxrM94VSZpaKuDMlGDbQpHhA/POoO3H1OxxRN
         kACn5ba/9++YAni0OYcssFhaGHLVoXoiP87V+wknwXPM+M0iV4tAnZ/VWmIV2lHmQRcH
         FlcNoDmKcz169IrSB6LG6fgnu7QBFKmrDgy7jtH/3DDOi9mQL+PImBvcQxUDHcfFuMXP
         ziWg==
X-Gm-Message-State: AOAM533HBfkSNofFIu6ic92+zq9A9aY/0GyCBeKBOOXnYvQsHOz8kdGd
        yWetG/6ZcQlrUkEp6owfoBFGAlXo6H38dRYoH+aZBPGTqvI=
X-Google-Smtp-Source: ABdhPJz14xwXYhwbbFhkre/rPYl8XJ3OSRRH0dml61aMapQmWaL6oyMIRX6e5N36iBQqwJMMrVjceYW8T5GSc0X5O+I=
X-Received: by 2002:a19:716:: with SMTP id 22mr890888lfh.390.1610409874106;
 Mon, 11 Jan 2021 16:04:34 -0800 (PST)
MIME-Version: 1.0
References: <20200916041908.66649-1-ebiggers@kernel.org> <20201007035021.GB912@sol.localdomain>
 <20201026163343.GA858@sol.localdomain> <X7gQXgoXHHEr6HXC@sol.localdomain> <X/NkrKpaIBTjQzbv@sol.localdomain>
In-Reply-To: <X/NkrKpaIBTjQzbv@sol.localdomain>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 12 Jan 2021 01:04:07 +0100
Message-ID: <CAG48ez3iicHcf1WoVh6LhV4pxo-rOh2FkrtmqQUcSS69NyiKxw@mail.gmail.com>
Subject: Re: [PATCH] random: fix the RNDRESEEDCRNG ioctl
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 4, 2021 at 7:55 PM Eric Biggers <ebiggers@kernel.org> wrote:
> On Fri, Nov 20, 2020 at 10:52:14AM -0800, Eric Biggers wrote:
> > On Mon, Oct 26, 2020 at 09:33:43AM -0700, Eric Biggers wrote:
> > > On Tue, Oct 06, 2020 at 08:50:21PM -0700, Eric Biggers wrote:
> > > > On Tue, Sep 15, 2020 at 09:19:08PM -0700, Eric Biggers wrote:
> > > > > From: Eric Biggers <ebiggers@google.com>
> > > > >
> > > > > The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
> > > > > doesn't make sense.  Reseed it from the input_pool instead.
> > > > >
> > > > > Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > >
> > > > Ping?
> > >
> > > Ping.
> >
> > Ping.
>
> Ping.

You may want to resend to akpm with a note that the maintainer is unresponsive.
