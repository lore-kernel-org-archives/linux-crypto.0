Return-Path: <SRS0=EWVs=PV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39502 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbfAMQw0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jan 2019 11:52:26 -0500
Message-ID: <1547398342.4409.3.camel@HansenPartnership.com>
Subject: Re: [PATCH 4/6] crypto: hkdf - RFC5869 Key Derivation Function
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
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
Date: Sun, 13 Jan 2019 08:52:22 -0800
In-Reply-To: <9795894.APlZEWIbOH@positron.chronox.de>
References: <20190103143227.9138-1-jlee@suse.com>
         <20190112051252.GA639@sol.localdomain>
         <20190112095535.36rh3ptnrf7yxacv@gondor.apana.org.au>
         <9795894.APlZEWIbOH@positron.chronox.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2019-01-13 at 08:56 +0100, Stephan Müller wrote:
> The question may arise why to plug the KDFs into RNGs. The answer is
> quite simple: KDFs are a form of random number generator. In that
> they take some input for initialization (aka seed, salt, key,
> personalization string). Then they produce pseudo-random bit
> sequences of arbitrary length. Possibly the generation operation can
> be modified by providing some additional input to be used by the
> generation process (aka label, context, info string, additional 
> information string). Thus, the RNG interface is a natural fit for the
> KDFs.

Philosophically, that's quite wrong.  KDFs are a class of pseudorandom
functions (PRFs).  PRFs are designed so that the output is
indistinguishable from a random number generator to observers who don't
know the input but is deterministically useful for participants who do.
 That means the're definitely not RNGs they're functions whose output
is designed to look like the output of an RNG.

I suppose the mathematical thing that distinguishes PRFs and RNGs is
entropy: PRFs have zero entropy because given the same inputs you
expect the same output. Now whether it makes sense to use the RNG API
or not I'll leave that up to the crypto people.  I would have expected
any cryptographic RNG API to be mostly about entropy management (the
Linux core internal one certainly is), but it appears that the one in
crypto isn't.

James
