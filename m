From: "George Spelvin" <linux@horizon.com>
Subject: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: 28 Nov 2014 18:23:51 -0500
Message-ID: <20141128232351.27607.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, jarod@redhat.com,
	nhorman@tuxdriver.com, stephan.mueller@atsec.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:52665 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751465AbaK1XbO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Nov 2014 18:31:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I've been trying to understand the crypto layer, and it's a bit of a
struggle because I'm trying to learn how it's supposed to work by
reading the code, and I keep finding code I want to fix.

ansi_cprng.c is the current itch I'm eager to scratch.

Other than enough implementation stupidities to make me scream
(particularly the "rand_data_valid" variable name which is actually a
count of INvalid data, and  keeping 5 blocks of state, including sensitive
previous output, when only 3 are needed), one thing I can't help noticing
is that this is definitely NOT conformant with the X9.17/X9.31 spec.

That's because the spec requires a timestamp for each output block
to provide additional entropy, and a counter won't cut it.

I'm fixing the obvious things, but on this point, I have two choices:

1. Add some comments clarifying that the "Based on" part of the header
   is anything but a claim of compliance; those specs are for an RNG,
   while this is a PRNG.  And probably delete all the FIPS stuff, as
   there's no spec to claim compliance with.  Or
2. Fix the code to use random_get_entropy() and jiffies for the
   DT seed vector.

In the latter case, I'd have to leave the current deterministic code as
an option for self-testing, but I'd drop the recommended seedsize
to DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ (one key and one IV), and have
an internal flag indicating whether to use an incrementing DT vector
or generate it fresh.

If some code (like the current self-test code) provides an extra
DEFAULT_BLK_SZ of seed material, it would go into determinsitic mode,
but if it's missing, DT would be generated dynamically.

But that's a question of design intent, and I can't intuit that from the
code.  Can someome enlighten me as to which option is preferred?
