Return-Path: <SRS0=5PE5=PU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36280 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfALJ4d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Jan 2019 04:56:33 -0500
Date: Sat, 12 Jan 2019 17:55:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/6] crypto: hkdf - RFC5869 Key Derivation Function
Message-ID: <20190112095535.36rh3ptnrf7yxacv@gondor.apana.org.au>
References: <20190103143227.9138-1-jlee@suse.com>
 <20190109082103.GA8586@sol.localdomain>
 <9733066.Vrs4h5eWcW@positron.chronox.de>
 <2423373.Zd5ThvQH5g@positron.chronox.de>
 <20190112051252.GA639@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190112051252.GA639@sol.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 11, 2019 at 09:12:54PM -0800, Eric Biggers wrote:
> Hi Stephan,
> 
> On Fri, Jan 11, 2019 at 08:10:39PM +0100, Stephan Müller wrote:
> > The RFC5869 compliant Key Derivation Function is implemented as a
> > random number generator considering that it behaves like a deterministic
> > RNG.
> > 
> 
> Thanks for the proof of concept!  I guess it ended up okay.  But can you explain
> more the benefits of using the crypto_rng interface, as opposed to just some
> crypto_hkdf_*() helper functions that are exported for modules to use?

I agree.  I see no benefit in adding this through the RNG API as
opposed to just providing it as a helper.  If some form of hardware
acceleration were to eventuate in the future we could always revisit
this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
