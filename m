From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] KEYS: Fixes and crypto fixes
Date: Thu, 28 Sep 2017 12:08:36 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1709281208010.24604@namei.org>
References: <28036.1506547164@warthog.procyon.org.uk> <alpine.LRH.2.21.1709280912400.12069@namei.org> <20170928001529.GA120911@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: David Howells <dhowells@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Halcrow <mhalcrow@google.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from namei.org ([65.99.196.166]:50717 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752494AbdI1CIw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Sep 2017 22:08:52 -0400
In-Reply-To: <20170928001529.GA120911@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 27 Sep 2017, Eric Biggers wrote:

> On Thu, Sep 28, 2017 at 09:14:58AM +1000, James Morris wrote:
> > On Wed, 27 Sep 2017, David Howells wrote:
> > 
> > >  (2) Fixing big_key to use safe crypto from Jason A. Donenfeld.
> > > 
> > 
> > I'm concerned about the lack of crypto review mentioned by Jason -- I 
> > wonder if we can get this rewrite any more review from crypto folk.
> > 
> > Also, are there any tests for this code?  If not, it would be good to make 
> > some.
> > 
> 
> There is a test for the big_key key type in the keyutils test suite.  I also
> manually tested Jason's change.  And as far as I can tell there isn't actually a
> whole lot to test besides adding a big_key larger than BIG_KEY_FILE_THRESHOLD
> bytes, reading it back, and verifying that the data is unchanged --- since that
> covers the code that was changed.  An earlier version of the patch produced a
> warning with CONFIG_DEBUG_SG=y since it put the aead_request on the stack, but
> that's been fixed.
> 

Ok, thanks a lot.

> It would be great if someone else would comment on the crypto too, but for what
> it's worth I'm satisfied with the crypto changes.  GCM is a much better choice
> than ECB as long as we don't repeat (key, IV) pairs --- which we don't.  And in
> any case ECB mode makes no sense in this context; you'd need a *very* good
> reason to actually choose to encrypt something with ECB mode.  Unfortunately it
> tends to be a favorite of people who don't understand encryption modes...

Adding Herbert.


-- 
James Morris
<jmorris@namei.org>
