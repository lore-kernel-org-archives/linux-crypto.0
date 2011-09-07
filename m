From: Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 07 Sep 2011 23:27:12 +0200
Message-ID: <4E67E1B0.2040309@atsec.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org> <201109071602.24519.sgrubb@redhat.com> <20110907211858.GE20571@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Steve Grubb <sgrubb@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@sele
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.atsec.com ([195.30.99.214]:53580 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab1IGV1W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 17:27:22 -0400
Received: from mail.atsec.com (localhost [127.0.0.1])
	by mail.atsec.com (Postfix) with ESMTP id 19C2678070
	for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2011 23:27:17 +0200 (CEST)
In-Reply-To: <20110907211858.GE20571@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07.09.2011 23:18:58, +0200, Ted Ts'o <tytso@mit.edu> wrote:

Hi Ted,

> On Wed, Sep 07, 2011 at 04:02:24PM -0400, Steve Grubb wrote:
>>
>> When a system is underattack, do you really want to be using a PRNG
>> for anything like seeding openssl?  Because a PRNG is what urandom
>> degrades into when its attacked.
> 
> This is not technically true.  urandom degrades into a CRNG
> (cryptographic random number generator).  In fact what most security
> experts recommend is to take a small amount of security, and then use
> that to seed a CRNG.

Correct.

However, a CRNG shall be reseeded once in a while - see standard crypto
libraries and their CRNGs (OpenSSL being a notable exception here). And
that is what this entire discussion is all about: to ensure that the
CRNG is reseeded with entropy, eventually.

> 
>> If enough bytes are read that an
>> attacker can guess the internal state of the RNG, do you really want
>> it seeding a openssh session?
> 
> In a cryptographic random number generator, there is a either a
> cryptographic hash or a encryption algorithm at the core.  So you
> would need a huge amounts of bytes, and then you would have to carry
> out an attack on the cryptographic core.

Correct.

And exactly that is the concern from organizations like BSI. Their
cryptographer's concern is that due to the volume of data that you can
extract from /dev/urandom, you may find cycles or patterns that increase
the probability to guess the next random value compared to brute force
attack. Note, it is all about probabilities.
> 
> If this is the basis for the patch, then we should definitely NACK it.
> It sounds like snake oil fear mongering.
> 
> 					- Ted
> 
> 
> 


-- 
Ciao
Stephan
