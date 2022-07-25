Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E94FC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 16:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiGYQS0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiGYQSZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 12:18:25 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B9013FBB
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:18:24 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id a63so9425209vsa.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fc1J30D6r7mde3k9IPDDshDjtaUYY2uogkc3ovfvjEI=;
        b=Em7SGbFTrxEKEJD5Uz4uAVwejPFY74whyLl7E1HJ5+9fxy6M/ETQh2HFiMLRsRrswQ
         36OiQkohujGPUGp6h4+7NzJuLbPUS2jH6g/2TVclxJMlayAlO52P2DUCzCIn88AN6f37
         /dRPiKC/RE7AjIrBlMAenspIM+O7uHu5ixVz6RtPAKepVPdAfSiVuCg8uO7LPGT/wxf8
         HKk07pRdS6xsigeXbu0gWKF7JjJLSFXcmJ3xsOuNSbx9ylFJvppkUTFxrRGPagSzGJLF
         +lorp8Booc5TWv8IFioHYi4we3UyYr0tS2MBGxAHRMZjrqOUi4fxaO7QY8MUJK06UcLX
         I/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fc1J30D6r7mde3k9IPDDshDjtaUYY2uogkc3ovfvjEI=;
        b=OVnXBevLebRwkBC6G0xIYrya1B4LM/XB551FiAR+ezMdxFlJ1wedeCEopsu9asDj6X
         8W23K2PIttRKx5JBPaACO3QUopg09SMlHIU3Om3o18shCp3DhHzGXqYN49MMacaHm83H
         VILWRh87gIvo84GemMA+XFZxm1YEVFJHHNG+hBIob4mm2RGMm8Sz2TQddhTywit8WqRU
         b9wFYvmEntLJvZaSTNJhLi/rfimEQlt8kd3axPoJMDvGETL3mIgGT9ZybZ5DEClKFYF2
         ffuoMbD6lM/598qZXmONCXSa/arj8NCZQNCQdtLi7+OiNtmNoIUjLrS+wKrXCGv1rTga
         1N3A==
X-Gm-Message-State: AJIora/i5a8XT6XFyjxmAKSF37UL+NRCHSMPzJpNqeOVRmCEd+4R34SB
        9FCOp3ML/Ut2izD8vKVVMGxIRHQ9EXJdAmegOIs=
X-Google-Smtp-Source: AGRyM1ujBEbAUqh4MfaViAAlZ790Qj3W0JFGgnsUifxf2NkIa2OA015RvDJKJpEFMEIm/fZfW5cF/WloURQJPRQ67bE=
X-Received: by 2002:a67:bc10:0:b0:358:5fbd:79e7 with SMTP id
 t16-20020a67bc10000000b003585fbd79e7mr1393764vsn.24.1658765903949; Mon, 25
 Jul 2022 09:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <6bf352e9-1312-40de-4733-3219721b343c@linaro.org> <20220725153303.GF7074@brightrain.aerifal.cx>
In-Reply-To: <20220725153303.GF7074@brightrain.aerifal.cx>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 26 Jul 2022 00:18:10 +0800
Message-ID: <CACXcFm=N4ii8yW27TNrsC-XH21c5iPsQ85MMjWpq=3sHvgjKJg@mail.gmail.com>
Subject: Re: arc4random - are you sure we want these?
To:     Rich Felker <dalias@libc.org>
Cc:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Jann Horn <jann@thejh.net>, Michael@phoronix.com,
        Paul Eggert <eggert@cs.ucla.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rich Felker <dalias@libc.org> wrote:

> This is an extreme documentation/specification bug that *hurts*
> portability and security. The core contract of the historical
> arc4random function is that it *is* a CSPRNG. Having a function by
> that name that's allowed not to be one means now all software using it
> has to add detection for the broken glibc variant.
>
> If the glibc implementation has flaws that actually make it not a
> CSPRNG, this absolutely needs to be fixed. Not doing so is
> irresponsible and will set everyone back a long ways.

Exactly!
