Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DA4C19F2A
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Aug 2022 16:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiHDQIP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Aug 2022 12:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiHDQIO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Aug 2022 12:08:14 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC3F1583E;
        Thu,  4 Aug 2022 09:08:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 130so11923356pfv.13;
        Thu, 04 Aug 2022 09:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=pQ0wjiUpMxMUrhiOjjlA1NT+tSkd+3JCN8+vuokHeWQ=;
        b=FCfEBDCpzV6BUH81I7/XX4t1j8llNmRGQwHJDlguWpwcckuQU7kS5bRA1CkvCPn1jX
         qWeiQS5f0eQSfAw8sY6JZ6sQdSTjrZvl/qEZba9goON6ohvch8LCLr9Fzk2DepcC5hgJ
         7vg7hMWfHVhkzB3tVqE5zZDCtbYc2dbLo1oRzGXiq76+ZROPrTPzeRm/dSIyEwdcv8XO
         HUBvQKbDHqSj9U/pGTlra7uQEY9cCvgUYG7zujGw1AxO0IKiDD21kDx6nKTTo6k+TKjn
         zjtKtQYXOYPUJUhN3M0WXxJvVBN39ji3vunyvoS8ntoEqLlQrsAHqmL3dkv9D3Co910Q
         oAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=pQ0wjiUpMxMUrhiOjjlA1NT+tSkd+3JCN8+vuokHeWQ=;
        b=LchddmIFQomIYJmt5SBMf9MKI/lZXwpZXl5GcXHNStF7Pacji6yKUtPh0w6m7YQfZX
         aJM1q/jtcwjZxSxugnA5qecf4I8unIA8O8Xt5xT1CEaZlEUVnbdT+XKLe/fnWxQbD8Qx
         SuzTqbsxlr7TDo/9JJ73ydgISnp6+wQftxBwyHko79+AFayDzfJ5BA/oO9N0U/jnrI1G
         a5KgJhDZY1vsb8UG9kCLKpr1VxIsY5Aibc3kFr4xkkiHhm91vbVHpxkr254u4G3NV5at
         sOHc04dnGK9rojI9f3W6yrAysRDupHW1iA2gOa/uuphsCuhbrmQ7jyKQQ5h4Xc6iyfmQ
         dKWw==
X-Gm-Message-State: ACgBeo2pelMupQ0ROKOOlozObDzK/WR6dsPurRAObHfKcEgIfsn0JfhX
        7FP/HzG0c8Fg5/SOnKkpWajM/uaehaFDU6VawOa3CL5r
X-Google-Smtp-Source: AA6agR4ffrzAKh9l9yfmb3mD4mHL7Lr5NSjz0DrBKMx2JR5RdEYONXPODTeceLYmSekdcAsIZ1UyflNhle9vw59Fg+4=
X-Received: by 2002:a05:6a00:3392:b0:52b:4896:b317 with SMTP id
 cm18-20020a056a00339200b0052b4896b317mr2548845pfb.17.1659629293075; Thu, 04
 Aug 2022 09:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220729145525.1729066-1-Jason@zx2c4.com> <CAHk-=wiLwz=9h9LD1-_yb1+T+u59a2EjTmMvCiGj4A-ZsPN1wA@mail.gmail.com>
 <YuXCpyULk6jFgGV5@zx2c4.com> <87zggnsqwj.ffs@tglx> <Yuhe6IIFXqNMZs5b@zx2c4.com>
 <87bkt2sqq4.ffs@tglx> <YuktqQS7Rb0IbJNh@zx2c4.com> <878ro6smmm.ffs@tglx>
 <CAHmME9pNN6Pc_1NaMDv+hqv_ULXiVUYFXM=Xigu_StvGS_-53A@mail.gmail.com>
 <87zggmqo0w.ffs@tglx> <Yuvki1nU2vJeINNk@zx2c4.com>
In-Reply-To: <Yuvki1nU2vJeINNk@zx2c4.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Thu, 4 Aug 2022 12:08:00 -0400
Message-ID: <CAH8yC8nwHPMtsHHbkvUYrqjWBBs6WtuaFKjXpMP5cSnp+AJyKg@mail.gmail.com>
Subject: Re: [PATCH RFC v1] random: implement getrandom() in vDSO
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 4, 2022 at 11:40 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Aug 03, 2022 at 12:27:43AM +0200, Thomas Gleixner wrote:
> > Jason!
>
>  ...
> > Vs. the storage problem. That yells TLS, but that makes your process
> > wide sharing moot, which might not be the worst of all things IMO.
>
> Yea, TLS is what we want here. The `void *state` argument thing is meant
> for this. You allocate an array of states using that alloc function, and
> then you divvy them up per-thread.

I think it would be wise to give each thread its own state. It will
simplify locking and help avoid contention.

Jeff
