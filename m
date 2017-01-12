From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 09:18:06 -0600
Message-ID: <20170112151806.2btvh64k44eud4fr@treble>
References: <20170110143340.GA3787@gondor.apana.org.au>
 <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170112070534.GA14016@gondor.apana.org.au>
 <CALCETrV78gNs5ZqunaSPZ4AATapb1+ESKd6Wv+5rdMpZe9TSJQ@mail.gmail.com>
 <20170112150318.eq4lmfitxvitpix4@treble>
 <20170112150650.GA16000@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750733AbdALPSI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:18:08 -0500
Content-Disposition: inline
In-Reply-To: <20170112150650.GA16000@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 11:06:50PM +0800, Herbert Xu wrote:
> On Thu, Jan 12, 2017 at 09:03:18AM -0600, Josh Poimboeuf wrote:
> > 
> > For the entry code, could we just replace all calls with CALL_ALIGNED?
> > That might be less intrusive than trying to adjust all the pt_regs
> > accesses.
> > 
> > Then to ensure that nobody ever uses 'call' directly:
> > 
> >   '#define call please-use-CALL-ALIGNED-instead-of-call'
> > 
> > I think that would be possible if CALL_ALIGNED were a ".macro".
> 
> The trouble with that is that you have got things like TRACE_IRQS_OFF
> which are also used outside of the entry code.

Where?  As far as I can tell, TRACE_IRQS_OFF is used exclusively by entry
code.

-- 
Josh
