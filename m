Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0247AC433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Apr 2022 21:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiDXVpt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiDXVps (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Apr 2022 17:45:48 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A2A6210B
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 14:42:47 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id n14so2397312lfu.13
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 14:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7MOvdDWFomD1nJ5GdyiOljnnxohoncHWbCnMwGFS3Nw=;
        b=cIO+GGhoCShCdoHOaekc0Dd3Zn20Ajx6KNM9RIVWQANU7JQc64mQ2VRKGeDxwVofxb
         aXXGspJ1zsoi/XEx4RlK2UsZ2Dr48k+QhRm9+5uZ22gG6p3bycyshuaOP9vC2n6zWJ57
         SWBjYcKaLh1+iwJHq97THJm1elyRtpxtDXesE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7MOvdDWFomD1nJ5GdyiOljnnxohoncHWbCnMwGFS3Nw=;
        b=JFGGETKj3xHNme5PwhauVuv8VhXXF+CqpDOAUeaa1jw8btoWFmXT4xogP18FBL+IMV
         9KojK9RYKzXqM2YNTxJthGAWCuecaAS8+/vnglg5bc4apB0vMPJq+QcZfB1zn22HuSRS
         MO24enhc++StNOhX8a9lH993B4tRJGU+l0jvX2HT9J8AItWe5dPocibdCXvmayJb3kn+
         rFAVhrDaX72IHH8wBHusBX0a4cdzVw3WiaLsIOTVBxrBHwMSMg/F6zYTxiufs+kiyN86
         6pjSQNKoQCNJAxmQ1SWT1GmGZ/otw+yUNev1R6v/q7XhHmxjj9jHcQ/4GPdbZH2HHBON
         eSiw==
X-Gm-Message-State: AOAM532weu+ztV3jm8NzAvdF6I3BgJ25ZxOFa7v6HXnC7Ce5lJ3A9j60
        CMzIg5my1ZYElO15BFRfJc/fBpk/AjcRI+At1Y8=
X-Google-Smtp-Source: ABdhPJzczaIcD6fLxDxI+vxpDPl1apl7Z9QOawPCHp35R8roCLVwWCqLVPNChLh3PEUy4W0ym9VuTQ==
X-Received: by 2002:a05:6512:3f0e:b0:471:acdd:590c with SMTP id y14-20020a0565123f0e00b00471acdd590cmr10732886lfa.520.1650836565226;
        Sun, 24 Apr 2022 14:42:45 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id e25-20020a196759000000b004718bb40b4bsm1156278lfj.165.2022.04.24.14.42.44
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 14:42:44 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id m23so2946854ljb.8
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 14:42:44 -0700 (PDT)
X-Received: by 2002:a2e:8789:0:b0:24f:124c:864a with SMTP id
 n9-20020a2e8789000000b0024f124c864amr824977lji.164.1650836564386; Sun, 24 Apr
 2022 14:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
In-Reply-To: <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 24 Apr 2022 14:42:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
Message-ID: <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
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

On Sun, Apr 24, 2022 at 2:37 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Finally, for the same reason - please don't use ">> 8".  Because I do
> not believe that bit 8 is well-defined in your arithmetic. The *sign*
> bit will be, but I'm not convinced bit 8 is.

Hmm.. I think it's ok. It can indeed overflow in 'char' and change the
sign in bit #7, but I suspect bit #8 is always fine.

Still, If you want to just extend the sign bit, ">> 31" _is_ the
obvious thing to use (yeah, yeah, properly "sizeof(int)*8-1" or
whatever, you get my drift).

           Linus
