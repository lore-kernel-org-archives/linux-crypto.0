Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531D3C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Apr 2022 21:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbiDXVlY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiDXVlW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Apr 2022 17:41:22 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B8215248C
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 14:38:20 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id l19so3085727ljb.7
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 14:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Lj+8I0FO8qrcoAXKsUQ/7bkIYJ5OSyWim41oZ7eGAE=;
        b=KHxV1EGyudGee9WRj/AK3mRuuSFGQaU2WbRpDeBjO+4p17nGhVHLE1H5WV46pDemIT
         kLR9CVjz0o6OcYGCl94opQlwarAN2+atjKFY0JzJkSkvtYVU+MmJFCJyMLkyvsRUjJ3L
         e2bakbwMP3wwR5Bf3TNbjHY/rMlRuB+LJzpWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Lj+8I0FO8qrcoAXKsUQ/7bkIYJ5OSyWim41oZ7eGAE=;
        b=Dk/v8eaSQvX8tdV5BUi4QvdEWeBbxu3vy8Yg63CMg/MJ1fBVQb3sEIHsRzfMe2QYcq
         yj8tWaPUcp/iXcMgqDDeEOC14gCZAvRQp35277leG1xnjWyrN1KxGFAJFLHX94DYXNOQ
         7DXw0LLWvylbpfUMpke/KTDY3znqSuvcBqUpFkyHEfiCCdPGeh3VIVKJAJ5aFmZMG/Fw
         BIdoxnyE8+DY31NAvzdNzmEgQawPWVznf+AvZY86fNvt45a0viRzd5TXkt0cznSB0n2P
         HUtoFyYvi2KslAbrxAg6gTrZ8dXpsT27Y0FCJLEcWoIawLQnaIA1fsYSQ8EcEJumtvWF
         yBHg==
X-Gm-Message-State: AOAM530VFsx67/5snfAJYUUKqcK00gCmvD4L/A/QW/gOCqH5oQhJHopf
        HxKHgSfvLLvLUkY16OBz3K84ME6NVD0m5husd6Q=
X-Google-Smtp-Source: ABdhPJzBRoY83MSdouaxw5Ypc0Vp19W3PbBywTGdf8Y8iDaEcX6kJ+Vau3KzSC1/RSJMcGUQt3aPmw==
X-Received: by 2002:a2e:bf25:0:b0:247:d216:43fc with SMTP id c37-20020a2ebf25000000b00247d21643fcmr9232172ljr.520.1650836298321;
        Sun, 24 Apr 2022 14:38:18 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id h13-20020a056512054d00b00470313df8e6sm1156518lfl.124.2022.04.24.14.38.15
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 14:38:15 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id x17so23110499lfa.10
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 14:38:15 -0700 (PDT)
X-Received: by 2002:ac2:5084:0:b0:471:ccb3:8c99 with SMTP id
 f4-20020ac25084000000b00471ccb38c99mr10965514lfm.435.1650836294999; Sun, 24
 Apr 2022 14:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 24 Apr 2022 14:37:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
Message-ID: <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
Subject: Re: [PATCH] hex2bin: make the function hex_to_bin constant-time
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Andy Shevchenko <andy@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <msnitzer@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 24, 2022 at 1:54 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> + *
> + * Explanation of the logic:
> + * (ch - '9' - 1) is negative if ch <= '9'
> + * ('0' - 1 - ch) is negative if ch >= '0'

True, but...

Please, just to make me happier, make the sign of 'ch' be something
very explicit. Right now that code uses 'char ch', which could be
signed or unsigned.

It doesn't really matter in this case, since the arithmetic will be
done in 'int', and as long as 'int' is larger than 'char' as a type
(to be really nit-picky), it all ends up working ok regardless.

But just to make me happier, and to make the algorithm actually do the
_same_ thing on every architecture, please use an explicit signedness
for that 'ch' type.

Because then that 'ch >= X' is well-defined.

Again - your code _works_. That's not what I worry about. But when
playing these kinds of tricks, please make it have the same behavior
across architectures, not just "the end result will be the same
regardless".

Yes, a 'ch' with the high bit set will always be either >= '0' or <=
'9', but note how *which* one it is depends on the exact type, and
'char' is simply not well-defined.

Finally, for the same reason - please don't use ">> 8".  Because I do
not believe that bit 8 is well-defined in your arithmetic. The *sign*
bit will be, but I'm not convinced bit 8 is.

So use ">> 31" or similar.

Also, I do worry that this is *exactly* the kind of trick that a
compiler could easily turn back into a conditional. Usually compilers
tend to go the other way (ie turn conditionals into arithmetic if
possible), but..

                    Linus
