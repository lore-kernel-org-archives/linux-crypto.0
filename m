From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Fri, 15 Sep 2017 07:37:10 +0200
Message-ID: <20170915053710.l54tgafyku2bfkbx@gmail.com>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
 <20170913212428.kibwbqs2f7dkeslb@treble>
 <20170914091612.ck33coyubzevru2i@gmail.com>
 <20170914132805.l6yfpyinw7lgruee@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, x86@kernel.org,
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
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37226 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdIOFhO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2017 01:37:14 -0400
Content-Disposition: inline
In-Reply-To: <20170914132805.l6yfpyinw7lgruee@treble>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> > So if this observation of mine is true we could go back to the old code for the 
> > hotpath, but use RDI for TBL and not reload it in the hotpath.
> 
> Thanks for the excellent breakdown.
> 
> When I looked at the patch again, I came to the same conclusion as your
> #4, which is that RDI isn't being used in the inner loops.  It *is* used
> in the outermost loop, however.
> 
> So v2 of my sha512-avx2-asm.S patch spilled CTX onto the stack, instead
> of TBL:
> 
>   https://lkml.kernel.org/r/20170913223303.pskmy2v7nto6rvtg@treble

Indeed - I should have checked your v2 patch, but somehow missed it. Would have 
saved me some looking+typing ;-)

Thanks,

	Ingo
