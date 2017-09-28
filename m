From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [GIT PULL] KEYS: Fixes and crypto fixes
Date: Wed, 27 Sep 2017 17:15:29 -0700
Message-ID: <20170928001529.GA120911@gmail.com>
References: <28036.1506547164@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1709280912400.12069@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Halcrow <mhalcrow@google.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1709280912400.12069@namei.org>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 28, 2017 at 09:14:58AM +1000, James Morris wrote:
> On Wed, 27 Sep 2017, David Howells wrote:
> 
> >  (2) Fixing big_key to use safe crypto from Jason A. Donenfeld.
> > 
> 
> I'm concerned about the lack of crypto review mentioned by Jason -- I 
> wonder if we can get this rewrite any more review from crypto folk.
> 
> Also, are there any tests for this code?  If not, it would be good to make 
> some.
> 

There is a test for the big_key key type in the keyutils test suite.  I also
manually tested Jason's change.  And as far as I can tell there isn't actually a
whole lot to test besides adding a big_key larger than BIG_KEY_FILE_THRESHOLD
bytes, reading it back, and verifying that the data is unchanged --- since that
covers the code that was changed.  An earlier version of the patch produced a
warning with CONFIG_DEBUG_SG=y since it put the aead_request on the stack, but
that's been fixed.

It would be great if someone else would comment on the crypto too, but for what
it's worth I'm satisfied with the crypto changes.  GCM is a much better choice
than ECB as long as we don't repeat (key, IV) pairs --- which we don't.  And in
any case ECB mode makes no sense in this context; you'd need a *very* good
reason to actually choose to encrypt something with ECB mode.  Unfortunately it
tends to be a favorite of people who don't understand encryption modes...

Plus, getting all the randomness at boot time didn't make sense because that's
when entropy is the most scarce.

Eric
