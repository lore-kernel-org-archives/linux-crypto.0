Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB101C4743D
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 04:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A244361285
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 04:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhFKEDT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 00:03:19 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:47024 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhFKEDS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 00:03:18 -0400
Received: by mail-wr1-f53.google.com with SMTP id a11so4454055wrt.13
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jun 2021 21:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=spNifO7CMCVLxoGBh5rTw2gyoH/VU9wB+1EGF7V1ah4=;
        b=ZA7XbJ3QtDmFVOHSvJm4q7hwVL7/zTSNhMrDZuAPOpOd8mV0oxPvTp4fMuz0huPkwV
         T+ySIku0MHtVu6Kuttd/IeuwgYWXgzigvV2JTnb5kKRIUVEjLky8VhZ2v7Bt8pvrPq1G
         Jr5DaPL5EkT7G24vlQ0QYX5UiffHNVwWmGaiAw9INgEK05XQrYuUcBO+vJ44oO103567
         wPN1l+LQ074fdVAYFo6/Ooj+hx+VdlY2n5XckSUYo/A/hFqDQcvJS7aKpQlQ2fhbYzHl
         SejOnB2+itoyiMr5NZo8ZA/bTa2FcBrkF4vRr5SDH1fVRffKqazyJEZHm/iZeJG+wQH6
         QHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=spNifO7CMCVLxoGBh5rTw2gyoH/VU9wB+1EGF7V1ah4=;
        b=SRL6Be+ytK54xro/dwvJuI2xDjl+5iElUmAkNxUdfucZBof+/OjxBzvHhK/yUrFuM5
         RsOcphrBc+P56AK0C4B46TiaO01jRnSKVaJV7t4nSaUQouXKb8fvaYF8psJ3oufUMrg9
         hFISwLSFPNgnuytv41DDOUloOiceehFbFKzIxqyDK4fhanvplxZY+xRXP445hAy8VGVI
         B8jA8XTCr3c6mKGbQ5VLKJTCoOs3wotNX+3Xp7kx1L2Kl2NPhYpR9ukZvcyYdUisgMpv
         7Cw+OjnKeY3TqavE0HrR9POBjZwEQV7ccI2D4GnPlUxdsQaPmxWdaAfYZmxLcjLXZWQ6
         NrDw==
X-Gm-Message-State: AOAM530eR/N4WQ7pQpnWpnBVOS/go25DT7PraAJdcAHfAnrEz8o05Z14
        uUgx9hLdMPONzzX+qM6DZV0NqNN7FJfLmObtONn3MN/jhfE=
X-Google-Smtp-Source: ABdhPJzwUYM8QTyH4pWZbr6PQY+vfauMnW/nEvsFO9ke1tTkmvRuExGPtA7Twn+F+L4A1MJ6zeZFp7ycWauVBI6pcAE=
X-Received: by 2002:adf:f1c3:: with SMTP id z3mr1473133wro.375.1623384005667;
 Thu, 10 Jun 2021 21:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
In-Reply-To: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 11 Jun 2021 11:59:52 +0800
Message-ID: <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
Subject: Re: Lockless /dev/random - Performance/Security/Stability improvement
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        John Denker <jsd@av8n.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The basic ideas here look good to me; I will look at details later.
Meanwhile I wonder what others might think, so I've added some to cc
list.

One thing disturbs me, wanting to give more control to
"the user who should be free to choose their own security/performance tradeoff"

I doubt most users, or even sys admins, know enough to make such
choices. Yes, some options like the /dev/random vs /dev/urandom choice
can be given, but I'm not convinced even that is necessary. Our
objective should be to make the thing foolproof, incapable of being
messed up by user actions.
