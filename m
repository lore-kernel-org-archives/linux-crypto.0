From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [GIT PULL] KEYS: Fixes and crypto fixes
Date: Thu, 28 Sep 2017 18:34:51 +0800
Message-ID: <20170928103451.GC8118@gondor.apana.org.au>
References: <28036.1506547164@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1709280912400.12069@namei.org>
 <20170928001529.GA120911@gmail.com>
 <alpine.LRH.2.21.1709281208010.24604@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Halcrow <mhalcrow@google.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: James Morris <jmorris@namei.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1709281208010.24604@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 28, 2017 at 12:08:36PM +1000, James Morris wrote:
> On Wed, 27 Sep 2017, Eric Biggers wrote:
> 
> > On Thu, Sep 28, 2017 at 09:14:58AM +1000, James Morris wrote:
> > > On Wed, 27 Sep 2017, David Howells wrote:
> > > 
> > > >  (2) Fixing big_key to use safe crypto from Jason A. Donenfeld.
> > > > 
> > > 
> > > I'm concerned about the lack of crypto review mentioned by Jason -- I 
> > > wonder if we can get this rewrite any more review from crypto folk.
> > > 
> > > Also, are there any tests for this code?  If not, it would be good to make 
> > > some.
> > > 
> > 
> > There is a test for the big_key key type in the keyutils test suite.  I also
> > manually tested Jason's change.  And as far as I can tell there isn't actually a
> > whole lot to test besides adding a big_key larger than BIG_KEY_FILE_THRESHOLD
> > bytes, reading it back, and verifying that the data is unchanged --- since that
> > covers the code that was changed.  An earlier version of the patch produced a
> > warning with CONFIG_DEBUG_SG=y since it put the aead_request on the stack, but
> > that's been fixed.
> > 
> 
> Ok, thanks a lot.
> 
> > It would be great if someone else would comment on the crypto too, but for what
> > it's worth I'm satisfied with the crypto changes.  GCM is a much better choice
> > than ECB as long as we don't repeat (key, IV) pairs --- which we don't.  And in
> > any case ECB mode makes no sense in this context; you'd need a *very* good
> > reason to actually choose to encrypt something with ECB mode.  Unfortunately it
> > tends to be a favorite of people who don't understand encryption modes...
> 
> Adding Herbert.

I think Jason's patch is definitely an improvement over the status quo.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
