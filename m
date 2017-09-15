From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Thu, 14 Sep 2017 21:54:51 -0700
Message-ID: <20170915045451.GA26063@zzz.localdomain>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
 <20170913212428.kibwbqs2f7dkeslb@treble>
 <20170913223303.pskmy2v7nto6rvtg@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33205 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdIOEy7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2017 00:54:59 -0400
Content-Disposition: inline
In-Reply-To: <20170913223303.pskmy2v7nto6rvtg@treble>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Josh,

On Wed, Sep 13, 2017 at 05:33:03PM -0500, Josh Poimboeuf wrote:
> And here's v2 of the sha512-avx2 patch.  It should hopefully gain back
> most of the performance lost by v1.
> 
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> Subject: [PATCH] x86/crypto: Fix RBP usage in sha512-avx2-asm.S
> 
> Using RBP as a temporary register breaks frame pointer convention and
> breaks stack traces when unwinding from an interrupt in the crypto code.
> 
> Mix things up a little bit to get rid of the RBP usage, without
> destroying performance.  Use RDI instead of RBP for the TBL pointer.
> That will clobber CTX, so save CTX on the stack and use RDI as CTX
> before it gets clobbered, and R12 as CTX after it gets clobbered.
> 
> Also remove the unused y4 variable.
> 

I tested the v2 patches for both sha256-avx2 and sha512-avx2 on Skylake.  They
both pass the crypto self-tests, and there was no noticable performance
difference compared to the unpatched versions.  Thanks!

Eric
