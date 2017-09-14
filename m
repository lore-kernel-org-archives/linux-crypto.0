From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Thu, 14 Sep 2017 11:28:57 +0200
Message-ID: <20170914092857.mvarp7iok6jf43sn@gmail.com>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
 <20170913212428.kibwbqs2f7dkeslb@treble>
 <20170914091612.ck33coyubzevru2i@gmail.com>
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
Received: from mail-wm0-f53.google.com ([74.125.82.53]:46829 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbdINJ3C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2017 05:29:02 -0400
Content-Disposition: inline
In-Reply-To: <20170914091612.ck33coyubzevru2i@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Ingo Molnar <mingo@kernel.org> wrote:

> 1)
> 
> Note how R12 is used immediately, right in the next instruction:
> 
>         vpaddq  (TBL), Y_0, XFER
> 
> I.e. the RBP fixes lengthen the program order data dependencies - that's a new 
> constraint and a few extra cycles per loop iteration if the workload is 
> address-generator bandwidth limited on that.
> 
> A simple way to ease that constraint would be to move the 'TLB' load up into the 
> loop, body, to the point where 'T1' is used for the last time - which is:
> 
> 
>         mov     a, T1           # T1 = a                                # MAJB
>         and     c, T1           # T1 = a&c                              # MAJB
> 
>         add     y0, y2          # y2 = S1 + CH                          # --
>         or      T1, y3          # y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
> 
> +       mov frame_TBL(%rsp), TBL
> 
>         add     y1, h           # h = k + w + h + S0                    # --
> 
>         add     y2, d           # d = k + w + h + d + S1 + CH = d + t1  # --
> 
>         add     y2, h           # h = k + w + h + S0 + S1 + CH = t1 + S0# --
>         add     y3, h           # h = t1 + S0 + MAJ                     # --
> 
> Note how this moves up the 'TLB' reload by 4 instructions.

Note that in this case 'TBL' would have to be initialized before the 1st 
iteration, via something like:

        movq    $4, frame_SRND(%rsp)

+	mov frame_TBL(%rsp), TBL

.align 16
loop1:
        vpaddq  (TBL), Y_0, XFER
        vmovdqa XFER, frame_XFER(%rsp)
        FOUR_ROUNDS_AND_SCHED

Thanks,

	Ingo
