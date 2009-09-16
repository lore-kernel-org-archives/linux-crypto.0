From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 0/3] enhance RNG api with flags to allow for different
	operational modes
Date: Wed, 16 Sep 2009 12:04:56 -0400
Message-ID: <20090916160456.GC11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jarod@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57359 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759340AbZIPQFE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 12:05:04 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey all-
	Ok, so I've got a story behind this one.  It was recently called to my
attention that the ansi cprng is missing an aspect of its compliance requrements
for FIPS-140.  Specifically, its missing a behavior in its continuous test.
When the CPRNG produces random blocks, the firrst block that it produces must
never be returned to the user.  Instead it must be saved and a second block must
be generated so that it can be compared to the first block before being returned
to the user.

	I recently posted a patch to do this for the hardware RNG.  Its fine to
do this there, since there are no expectations of a predictable result in that
RNG.  The CPRNG however, provides a predictable random sequence for a given
input seed key and iteration.  The above requirement messes with that
predictability however because it changes which block is returned on the zeroth
iteration to the user.  Some test vectors expect this, some do not.

	So the question is, how do I make this RNG fips compliant without
breaking some subset of users out there that rely on the predictability of the
CPRNG?  The solution I've come up with is a dynamic flag.  This patch series
adds two api calls to the crypto RNG api rng_set_flags and rng_get_flags, which
set flags with global meaning on instances of an rng.  A given RNG can opt to
set the registered agorithm methods for these api calls or not.  In the event
they don't a default handler is set for each that returns EOPNOTSUPPORT.

	Using this new mechanism I've implemented these calls in ansi_cprng so
that setting the TEST_MODE flag disables the continuous check, allowing for the
zeroth block to get returned to the user, which lets us pass most of the
supplied test vectors (most notably the NIST provided vectors).

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


