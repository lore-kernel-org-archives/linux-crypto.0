Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbeJTEii (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 00:38:38 -0400
Date: Fri, 19 Oct 2018 13:30:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v3 2/2] crypto: arm/aes - add some hardening against
 cache-timing attacks
Message-ID: <20181019203056.GC246441@gmail.com>
References: <20181018043759.7669-1-ebiggers@kernel.org>
 <20181018043759.7669-3-ebiggers@kernel.org>
 <CAKv+Gu9XJ0k82ZNPRirs3Qhda3375CUA8uhJmsK85=1a9VmaNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9XJ0k82ZNPRirs3Qhda3375CUA8uhJmsK85=1a9VmaNQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 19, 2018 at 01:41:35PM +0800, Ard Biesheuvel wrote:
> On 18 October 2018 at 12:37, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Make the ARM scalar AES implementation closer to constant-time by
> > disabling interrupts and prefetching the tables into L1 cache.  This is
> > feasible because due to ARM's "free" rotations, the main tables are only
> > 1024 bytes instead of the usual 4096 used by most AES implementations.
> >
> > On ARM Cortex-A7, the speed loss is only about 5%.  The resulting code
> > is still over twice as fast as aes_ti.c.  Responsiveness is potentially
> > a concern, but interrupts are only disabled for a single AES block.
> >
> 
> So that would be in the order of 700 cycles, based on the numbers you
> shared in v1 of the aes_ti.c patch. Does that sound about right? So
> that would be around 1 microsecond, which is really not a number to
> obsess about imo.
> 

Correct, on ARM Cortex-A7 I'm seeing slightly over 700 cycles per block
encrypted or decrypted, including the prefetching.

- Eric
