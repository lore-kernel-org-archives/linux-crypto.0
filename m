From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Wed, 6 Sep 2017 19:15:18 -0500
Message-ID: <20170907001518.dv6leyfidmjf4e24@treble>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbdIGAPW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 20:15:22 -0400
Content-Disposition: inline
In-Reply-To: <20170902000919.GA139193@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 01, 2017 at 05:09:19PM -0700, Eric Biggers wrote:
> Hi Josh,
> 
> On Tue, Aug 29, 2017 at 01:05:33PM -0500, Josh Poimboeuf wrote:
> > Many of the x86 crypto functions use RBP as a temporary register.  This
> > breaks frame pointer convention, and breaks stack traces when unwinding
> > from an interrupt in the crypto code.
> > 
> > Convert most* of them to leave RBP alone.
> > 
> > These pass the crypto boot tests for me.  Any further testing would be
> > appreciated!
> > 
> > [*] There are still a few crypto files left that need fixing, but the
> >     fixes weren't trivial and nobody reported unwinder warnings about
> >     them yet, so I'm skipping them for now.
> > 
> > Josh Poimboeuf (12):
> >   x86/crypto: Fix RBP usage in blowfish-x86_64-asm_64.S
> >   x86/crypto: Fix RBP usage in camellia-x86_64-asm_64.S
> >   x86/crypto: Fix RBP usage in cast5-avx-x86_64-asm_64.S
> >   x86/crypto: Fix RBP usage in cast6-avx-x86_64-asm_64.S
> >   x86/crypto: Fix RBP usage in des3_ede-asm_64.S
> >   x86/crypto: Fix RBP usage in sha1_avx2_x86_64_asm.S
> >   x86/crypto: Fix RBP usage in sha1_ssse3_asm.S
> >   x86/crypto: Fix RBP usage in sha256-avx-asm.S
> >   x86/crypto: Fix RBP usage in sha256-avx2-asm.S
> >   x86/crypto: Fix RBP usage in sha256-ssse3-asm.S
> >   x86/crypto: Fix RBP usage in sha512-avx2-asm.S
> >   x86/crypto: Fix RBP usage in twofish-avx-x86_64-asm_64.S
> > 
> 
> Thanks for fixing these!  I don't have time to review these in detail, but I ran
> the crypto self-tests on the affected algorithms, and they all pass.  I also
> benchmarked them before and after; the only noticable performance difference was
> that sha256-avx2 and sha512-avx2 became a few percent slower.  I don't suppose
> there is a way around that?  Otherwise it's probably not a big deal.

Thanks for testing.  I might have a way to make sha256-avx2 faster, but
not sha512-avx2.  I'll let you know when I have a patch.

-- 
Josh
