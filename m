From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Tue, 19 Sep 2017 11:00:58 +0800
Message-ID: <20170919030058.GB27716@gondor.apana.org.au>
References: <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
 <20170913212428.kibwbqs2f7dkeslb@treble>
 <20170913223303.pskmy2v7nto6rvtg@treble>
 <20170915045451.GA26063@zzz.localdomain>
 <20170915053431.xizfyla7lobrwqn3@gmail.com>
 <20170915160732.GA687@zzz.localdomain>
 <20170915210629.p5tv42za4ux7s2sy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33842 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdISDBo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2017 23:01:44 -0400
Content-Disposition: inline
In-Reply-To: <20170915210629.p5tv42za4ux7s2sy@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 15, 2017 at 11:06:29PM +0200, Ingo Molnar wrote:
>
> Indeed, I suspect they should go through the crypto tree, these fixes are 
> independent, they don't depend on anything in the x86 tree.

Sure I can pick them up through cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
