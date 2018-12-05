Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbeLEGPQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 01:15:16 -0500
Date: Tue, 4 Dec 2018 22:15:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Martin Willi <martin@strongswan.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] crypto: x86/chacha20 - limit the
 preemption-disabled section
Message-ID: <20181205061513.GB26750@sol.localdomain>
References: <20181129230217.158038-1-ebiggers@kernel.org>
 <20181129230217.158038-4-ebiggers@kernel.org>
 <acad781e9981c49b83b6dfdc8cefed6246df469a.camel@strongswan.org>
 <CAKv+Gu89RiDBx35rtGS2uOZ+TwPt6P8UjwpqE17xm7dtMx-nNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu89RiDBx35rtGS2uOZ+TwPt6P8UjwpqE17xm7dtMx-nNQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 03, 2018 at 03:13:37PM +0100, Ard Biesheuvel wrote:
> On Sun, 2 Dec 2018 at 11:47, Martin Willi <martin@strongswan.org> wrote:
> >
> >
> > > To improve responsiveness, disable preemption for each step of the
> > > walk (which is at most PAGE_SIZE) rather than for the entire
> > > encryption/decryption operation.
> >
> > It seems that it is not that uncommon for IPsec to get small inputs
> > scattered over multiple blocks. Doing FPU context saving for each walk
> > step then can slow down things.
> >
> > An alternative approach could be to re-enable preemption not based on
> > the walk steps, but on the amount of bytes processed. This would
> > satisfy both users, I guess.
> >
> > In the long run we probably need a better approach for FPU context
> > saving, as this really hurts performance-wise. For IPsec we should find
> > a way to avoid the (multiple) per-packet FPU save/restores in softirq
> > context, but I guess this requires support from process context
> > switching.
> >
> 
> At Jason's Zinc talk at plumbers, this came up, and apparently someone
> is working on this, i.e., to ensure that on x86, the FPU restore only
> occurs lazily, when returning to userland rather than every time you
> call kernel_fpu_end() [like we do on arm64 as well]
> 
> Not sure what the ETA for that work is, though, nor did I get the name
> of the guy working on it.

Thanks for the suggestion; I'll replace this with a patch that re-enables
preemption every 4 KiB encrypted.  That also avoids having to do a
kernel_fpu_begin(), kernel_fpu_end() pair just for hchacha_block_ssse3().  But
yes, I'd definitely like repeated kernel_fpu_begin(), kernel_fpu_end() to not be
incredibly slow.  That would help in a lot of other places too.

- Eric
