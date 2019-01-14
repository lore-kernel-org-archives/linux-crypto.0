Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbfANRoT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 12:44:19 -0500
Date: Mon, 14 Jan 2019 09:44:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
Subject: Re: [PATCH 5/6] crypto: hkdf - add known answer tests
Message-ID: <20190114174415.GA7644@gmail.com>
References: <20190103143227.9138-1-jlee@suse.com>
 <9857029.1Sm7LFDBlJ@positron.chronox.de>
 <20190112051914.GB639@sol.localdomain>
 <2750733.sbdFDJOICv@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2750733.sbdFDJOICv@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 14, 2019 at 10:25:16AM +0100, Stephan Müller wrote:
> Am Samstag, 12. Januar 2019, 06:19:15 CET schrieb Eric Biggers:
> 
> Hi Eric,
> 
> [...]
> > 
> > > +			}
> > > +		}
> > > +	}, {
> > > +		.alg = "hkdf(hmac(sha224))",
> > > +		.test = alg_test_null,
> > > +		.fips_allowed = 1,
> > 
> > I think it is dumb to add algorithms to the testmgr with no tests just so
> > the 'fips_allowed' flag can be set. 
> 
> Currently it is the only way. But I agree that it could be done better.
> 
> > And doesn't FIPS sometimes require
> > tests anyway?  I don't think the "null test" should count as a test :-)
> 
> Yes, it DOES count as a test (as strange as it may sound)! :-)
> 
> The FIPS requirements are as follows:
> 
> - raw ciphers must be subject to a FIPS test with one block chaining mode to 
> cover that cipher with all block chaining modes (e.g. you can test ecb(aes) to 
> cover AES with *all* existing block chaining modes).
> 
> - for compound crypto algorithm (like RSA with respect to hashes, KDF with 
> respect to the keyed message digest, HMAC with respect to hashes), the 
> wrapping crypto algorithm needs to be tested with *one* wrapped cipher at 
> least (but also not more. E.g. if you have a self test for, say, all SHA-1 and 
> SHA-2, you only need one HMAC SHA test or one KDF HMAC SHA test.
> 
> - in some circumstances, it is even permissible to test wrapping crypto 
> algorithms where the underlying algo is implicitly tested. E.g. if you have a 
> HMAC SHA-256 test, you do not need an individual SHA-256 test.
> 
> 
> > 
> > Perhaps just include sha256 and sha512, and have tests for them?
> 
> Do you happen to have an official SHA-512 HKDF test vector? RFC5869 only has 
> SHA-1 and SHA-256 tests.
> > 
> 

No, I don't know of any official HKDF-SHA512 test vectors.

> [...]
> > > 
> > > +/* Test vectors from RFC 5869 appendix A */
> > > +static struct kdf_testvec hkdf_hmac_sha256_tv_template[] = {
> > 
> > const
> > 
> > Likewise for all other kdf_testvecs.
> 
> const does not work with __VECS :-(
> 
> I leave it without const at the moment. I think the __VECS should be updated 
> along with all test vectors.
> 
> [...]

I don't see why.  kdf_testvec just needs to be made const everywhere.

- Eric
