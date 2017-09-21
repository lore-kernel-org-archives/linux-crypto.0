From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Thu, 21 Sep 2017 16:05:54 +0800
Message-ID: <20170921080554.GB7718@gondor.apana.org.au>
References: <cover.1505763153.git.jpoimboe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44876 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdIUIGp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 04:06:45 -0400
Content-Disposition: inline
In-Reply-To: <cover.1505763153.git.jpoimboe@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 18, 2017 at 02:41:59PM -0500, Josh Poimboeuf wrote:
> v2:
> - fix performance issues in sha256-avx2-asm.S and sha512-avx2-asm.S
>   (Eric)
> 
> Many of the x86 crypto functions use RBP as a temporary register.  This
> breaks frame pointer convention, and breaks stack traces when unwinding
> from an interrupt in the crypto code.
> 
> Convert most* of them to leave RBP alone.
> 
> These pass the crypto boot tests for me.  Any further testing would be
> appreciated!
> 
> [*] There are still a few crypto files left that need fixing, but the
>     fixes weren't trivial and nobody reported unwinder warnings about
>     them yet, so I'm skipping them for now.
> 
> Josh Poimboeuf (12):

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
