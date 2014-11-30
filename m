From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: Sun, 30 Nov 2014 15:31:10 +0100
Message-ID: <15947662.NrEOFplJdZ@tauon>
References: <20141128232351.27607.qmail@ns.horizon.com> <20141129175856.GB15743@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: George Spelvin <linux@horizon.com>, herbert@gondor.apana.org.au,
	jarod@redhat.com, linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54850 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaK3ObO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Nov 2014 09:31:14 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S9DDB> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 30 Nov 2014 15:31:11 +0100
In-Reply-To: <20141129175856.GB15743@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 29. November 2014, 12:58:56 schrieb Neil Horman:

Hi Neil,

>On Fri, Nov 28, 2014 at 06:23:51PM -0500, George Spelvin wrote:
>> I've been trying to understand the crypto layer, and it's a bit of a
>> struggle because I'm trying to learn how it's supposed to work by
>> reading the code, and I keep finding code I want to fix.
>
>Patches welcome.
>
>> ansi_cprng.c is the current itch I'm eager to scratch.
>> 
>> Other than enough implementation stupidities to make me scream
>> (particularly the "rand_data_valid" variable name which is actually a
>
>Its actually a counter of the number of valid random data bytes in the
>buffer being returned to a caller, as well as an index into the
>internal buffer from which to draw fresh random data.  Sorry if you
>don't get that, but it seems pretty clear.
>
>> count of INvalid data, and  keeping 5 blocks of state, including
>> sensitive previous output, when only 3 are needed), one thing I
>> can't help noticing
>Not sure where you're getting that from, only 1 block of random data is
>stored at any one time to return to a caller
>
>> is that this is definitely NOT conformant with the X9.17/X9.31 spec.
>
>This is the document it was based of off:
>http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf

As this implementation has successfully being checked with the FIPS 
140-2 reference implementation, we all must assume it is in total 
compliance with the spec.
>
>From my read, it seems to be in complete compliance.
>
>> That's because the spec requires a timestamp for each output block
>> to provide additional entropy, and a counter won't cut it.
>
>The document places no constrints on the value or progression of DT. 
>As such a counter is as valid as any other implementation.  You're
>welcome to enhance that however, as I said, patches welcome.
>
>> I'm fixing the obvious things, but on this point, I have two choices:
>> 
>> 1. Add some comments clarifying that the "Based on" part of the
>> header
>> 
>>    is anything but a claim of compliance; those specs are for an RNG,
>>    while this is a PRNG.
>
>Please read more closely, the header clearly states this is a PRNG
>implementation, and a quick google search of the terms in the header
>bring up the document referenced above, with which this cprng is in
>compliance with.
>>  And probably delete all the FIPS stuff, as
>>  
>>    there's no spec to claim compliance with.  Or
>
>Maybe do some research before making big claims like this:
>http://csrc.nist.gov/publications/fips/fips140-2/fips1402annexc.pdf

Supporting to that is FIPS 140-2 standard section 4.9.2 which requires 
the continuous self test.
>
>Its just a draft, but digging through the NIST site will bring up the

It is kept draft deliberately to allow NIST to make changes without some 
government big-wig to sign up on it (and cause a delay of a couple of 
years.

>approved version.  Both show that a 3 DES CPRNG based on ANSI X9.31 is
>valid, and provides  a reference to the paper above as the
>implementation guideline.
>> 2. Fix the code to use random_get_entropy() and jiffies for the
>> 
>>    DT seed vector.
>
>Sure, knock yourself out.  I don't consider it more or less valid to do
>so, but patches are welcome.

There is NO need for additional entropy at this point as the X9.31 DRNG 
does not claim prediction resistance with a constant reseeding.
>
>> In the latter case, I'd have to leave the current deterministic code
>> as an option for self-testing, but I'd drop the recommended seedsize
>> to DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ (one key and one IV), and have
>> an internal flag indicating whether to use an incrementing DT vector
>> or generate it fresh.
>
>Yup.  Strictly speaking the API is in-kernel only, so you don't really
>have to worry about handling backwards compatibility, but if you don't
>allow for DT to be specified as an initial value, you won't be able to
>validate against any of the test vectors that NIST provides:
>http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
>
>I will also point out that CPRNG's are designed such that peers
>communicating with a cprng are expected to be able to predect the
>cprng output, which implies that the DT value needs to remain
>predictable as well.  Using an actual date time vector is going to
>make communication like that very unstable if there is even a little
>clock drift on either system.  As such, while its less entropy, using
>a simple arbitrary vector with an increment on each random data
>generation leads to greater stability and predictability for those
>with the key.  The data provided in the validation test in Appendix
>B.1.5 of the above document supports that, as the DT value is
>arbitrary and incremented by one on each iteration.
>> If some code (like the current self-test code) provides an extra
>> DEFAULT_BLK_SZ of seed material, it would go into determinsitic mode,
>> but if it's missing, DT would be generated dynamically.
>
>Sure, patches welcome.
>
>> But that's a question of design intent, and I can't intuit that from
>> the code.  Can someome enlighten me as to which option is preferred?
>Definately keep the ability to support external setting of DT, as you
>can't pass any validation tests without it.


Ciao
Stephan
-- 
