Return-Path: <SRS0=o+Is=OM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:40955 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbeLCOPA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Dec 2018 09:15:00 -0500
Received: by mail-io1-f67.google.com with SMTP id n9so10558854ioh.7
        for <linux-crypto@vger.kernel.org>; Mon, 03 Dec 2018 06:13:49 -0800 (PST)
MIME-Version: 1.0
References: <20181129230217.158038-1-ebiggers@kernel.org> <20181129230217.158038-4-ebiggers@kernel.org>
 <acad781e9981c49b83b6dfdc8cefed6246df469a.camel@strongswan.org>
In-Reply-To: <acad781e9981c49b83b6dfdc8cefed6246df469a.camel@strongswan.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 3 Dec 2018 15:13:37 +0100
Message-ID: <CAKv+Gu89RiDBx35rtGS2uOZ+TwPt6P8UjwpqE17xm7dtMx-nNQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] crypto: x86/chacha20 - limit the
 preemption-disabled section
To: Martin Willi <martin@strongswan.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2 Dec 2018 at 11:47, Martin Willi <martin@strongswan.org> wrote:
>
>
> > To improve responsiveness, disable preemption for each step of the
> > walk (which is at most PAGE_SIZE) rather than for the entire
> > encryption/decryption operation.
>
> It seems that it is not that uncommon for IPsec to get small inputs
> scattered over multiple blocks. Doing FPU context saving for each walk
> step then can slow down things.
>
> An alternative approach could be to re-enable preemption not based on
> the walk steps, but on the amount of bytes processed. This would
> satisfy both users, I guess.
>
> In the long run we probably need a better approach for FPU context
> saving, as this really hurts performance-wise. For IPsec we should find
> a way to avoid the (multiple) per-packet FPU save/restores in softirq
> context, but I guess this requires support from process context
> switching.
>

At Jason's Zinc talk at plumbers, this came up, and apparently someone
is working on this, i.e., to ensure that on x86, the FPU restore only
occurs lazily, when returning to userland rather than every time you
call kernel_fpu_end() [like we do on arm64 as well]

Not sure what the ETA for that work is, though, nor did I get the name
of the guy working on it.
