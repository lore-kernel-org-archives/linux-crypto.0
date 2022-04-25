Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF15DC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 17:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbiDYR4s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 13:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244118AbiDYR4s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 13:56:48 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B3E107728
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 10:53:43 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 17so18839222lji.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/LM5ApeDrM+ZiQkhPKo2nD8z3VPb3CiZfRSSBlkwszA=;
        b=BsY4pOkfn3DG5B5zct/wRzU14afza6Td5Lww1u3ewMVuTqlUDLuuUSSqkL5GiYshCE
         Af5nvn4SN/67YfETMMEi2NtXlQOejoI+5yvUA5qfEs9uGHOdZvqJA8BxEijrFHNTDfUl
         aDeCEhneNkVbrDwdkHnVsK7wqLVmqL9Kk0+S8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/LM5ApeDrM+ZiQkhPKo2nD8z3VPb3CiZfRSSBlkwszA=;
        b=EhKezrcc27K8b7c14mi1mmZuD8BhpnDEkbSpuavDgjUUB4+IHwbHl98bu40CC5Ozfq
         Mwh4dT0I8W8TdlUHlKn3d/2zCVS3DAMUFkSXCtwj8SiXqYvL5RnyRGYCzF3ftiisuqNj
         yw2D2HZL04D5jetsT2lXO6vFIhMYb4TDCz/NRABKISpB08Tiz4G5vylkurfWfFAWVhbD
         yr7pBdY8QCw7wb0VteWwn7GnFkasRrhnOOofl07QdKsEgww2ZshLBejobfCnz+Vx5Oft
         gA8mr4dhTWHviqnbaGxPTR2wtwXLfh+qgmeMQSI092JV2Y5U5T4O1elJUDwo96VZljDT
         kLuQ==
X-Gm-Message-State: AOAM532Mg75vUrK8iMuSoxixW+AvaKwdyxSTECmBOOFqJutyvo04pXAf
        JHKF4DiaXcvcEeW5BJNttCMjZXZfxhQZqZniup4=
X-Google-Smtp-Source: ABdhPJy1h8t2qzyxgi0qzTHCtTPktDcjF7iMDUxHS6tc/xaXprB+XIFjNUPxAD7OmmYvqfWBbjkV3w==
X-Received: by 2002:a2e:bf27:0:b0:246:7ed6:33b0 with SMTP id c39-20020a2ebf27000000b002467ed633b0mr12127174ljr.167.1650909221561;
        Mon, 25 Apr 2022 10:53:41 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id n4-20020a196f44000000b0047195a0fd47sm1476540lfk.5.2022.04.25.10.53.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 10:53:40 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id j4so3056555lfh.8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 10:53:39 -0700 (PDT)
X-Received: by 2002:a05:6512:1193:b0:471:af88:2d74 with SMTP id
 g19-20020a056512119300b00471af882d74mr13719233lfr.531.1650909219017; Mon, 25
 Apr 2022 10:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com> <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 25 Apr 2022 10:53:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjhP7EdVkj9V2aWbUtPbC=rNxvJ1R1Bs45jFz4KT3xg-Q@mail.gmail.com>
Message-ID: <CAHk-=wjhP7EdVkj9V2aWbUtPbC=rNxvJ1R1Bs45jFz4KT3xg-Q@mail.gmail.com>
Subject: Re: [PATCH v2] hex2bin: make the function hex_to_bin constant-time
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

On Mon, Apr 25, 2022 at 5:07 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> We are subtracting values that are in the 0 ... 255 range.

Well, except that's not what the original patch did.

It was subtracting values that were in the -128 ... 255 range (where
the exact range depended on the sign of 'char').

But yeah, I think bit8 was always safe. Probably. Particularly as the
possible ranges across different architectures is bigger than the
range within one _particular_ architecture (so you'll never see "255 -
-128" even when the sign wasn't defined ;)

> > Also, I do worry that this is *exactly* the kind of trick that a
> > compiler could easily turn back into a conditional. Usually compilers
> > tend to go the other way (ie turn conditionals into arithmetic if
> > possible), but..
>
> Some old version that I tried used "(ch - '0' + 1) * ((unsigned)(ch - '0')
> <= 9)" - it worked with gcc, but clang was too smart and turned it into a
> cmov when compiling for i686 and to a conditional branch when compiling
> for i586.
>
> Another version used "-(c - '0' + 1) * (((unsigned)(c - '0') >= 10) - 1)"
> - it almost worked, except that clang still turned it into a conditional
> jump on sparc32 and powerpc32.
>
> So, I came up with this version that avoids comparison operators at all
> and tested it with gcc and clang on all architectures that I could try.

Yeah, the thing about those compiler heuristics is that they are often
based on almost arbitrary patterns that just happen to be what
somebody has found in some benchmark.

Hopefully nobody ever uses something like this as a benchmark.

             Linus
