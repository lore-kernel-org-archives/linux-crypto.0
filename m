Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB5DC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jul 2022 17:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiGPRpq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jul 2022 13:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPRpp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jul 2022 13:45:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E8A1EAD3
        for <linux-crypto@vger.kernel.org>; Sat, 16 Jul 2022 10:45:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w12so10047903edd.13
        for <linux-crypto@vger.kernel.org>; Sat, 16 Jul 2022 10:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/9Uf2ntR2S8w+9n+2/JTbBl/aHorYxeMkxTEqnBf5zA=;
        b=KHq5BHgTW6a26TA22avGT40/OX1T0KJ9vHTQYgoSQVl90AvqUS8BuUjeuXpWCfw2EW
         ubTGMe99X22vI1DcAbUUut4EKhJI8cMPudvsj+AL3JGaY/yeXFqfRwY+s8J+4aK48UiO
         RVJbBas2mHgzq0So7/+vObT5GYYbOCHb0xhQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/9Uf2ntR2S8w+9n+2/JTbBl/aHorYxeMkxTEqnBf5zA=;
        b=pRbEpW7yP6RcN4WIwp50Dlpm7qn0P+/NoWpr4HoUdrKG0v9vK0mLRJvWYKGqgmZl02
         IOEEc62saEaDODr5uaeIqJxn6RTDDZwQd5B5Jtdbzlis+RVFbMg5ECXB3Zf0NXPloYWi
         kagV8gd8tK9gqugHyKH+EJLdWA3BIXX9jg1BsX6B38bgFcMPwStZzdxmXdwVGJgxYdSP
         Jr5QUM8kRwsn6y7gq7WUhvCCw2KirOjh6yfmMVJEO4ybVW+UsyFsELU019m3pGpYxuUO
         2oG4bnxZbCHaQhDn+fRHobi4KEehOlIuWuQK5b75zc0c+0E/iyD22v1RiUuHUEqhZsXM
         o+DA==
X-Gm-Message-State: AJIora+cZOBD86nHMFjdBWJLj5MNQfCYmisdWnI908T1edmFyuQeRSyk
        5617gKQdL7tnCN0R4uMoC7MvxgtKfdyTcYIQ
X-Google-Smtp-Source: AGRyM1t4tkCAdg6juw85u3NUjnlnqTi8jEk1856qs7Km+KlJr0zLWKaGlqb40FNcVkxZcZnaUfNj0Q==
X-Received: by 2002:a05:6402:2554:b0:43a:902b:d31f with SMTP id l20-20020a056402255400b0043a902bd31fmr26774942edb.416.1657993542618;
        Sat, 16 Jul 2022 10:45:42 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id gr19-20020a170906e2d300b0072b2f95d5d1sm3456706ejb.170.2022.07.16.10.45.41
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jul 2022 10:45:41 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id r14so10981187wrg.1
        for <linux-crypto@vger.kernel.org>; Sat, 16 Jul 2022 10:45:41 -0700 (PDT)
X-Received: by 2002:a05:6000:180f:b0:21d:68f8:c4ac with SMTP id
 m15-20020a056000180f00b0021d68f8c4acmr17511700wrh.193.1657993540707; Sat, 16
 Jul 2022 10:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rrQVm72P6cLL4dUnSw+9nnXszDbQXRd3epRaQgKTy8BQ@mail.gmail.com>
 <20220713151115.1014188-1-Jason@zx2c4.com> <88d9e600-b687-7d09-53cb-727601612e21@arm.com>
 <Ys7xHMIF6OLkLbvv@zx2c4.com>
In-Reply-To: <Ys7xHMIF6OLkLbvv@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 16 Jul 2022 10:45:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg+TYBp8WD_b9OG9iNeh08jsPc=P_Xkr=CFHgVPc0f5sA@mail.gmail.com>
Message-ID: <CAHk-=wg+TYBp8WD_b9OG9iNeh08jsPc=P_Xkr=CFHgVPc0f5sA@mail.gmail.com>
Subject: Re: [PATCH] random: cap jitter samples per bit to factor of HZ
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 13, 2022 at 9:22 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Thanks for testing. I'll push this out to Linus probably tomorrow.
>
> (Though I noticed that Linus is in the CC for this thread already, and
> he's been on a patch picking spree as of late, so in case he happens to
> be following along, fell free to pick away. Otherwise I'll send a pull
> not before long.)

Well, the "probably tomorrow" didn't happen, so yes, I've just picked
it up directly.

                 Linus
