From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
 operational modes
Date: Wed, 16 Sep 2009 16:56:12 -0400
Message-ID: <4AB150EC.8070303@redhat.com>
References: <20090916160456.GC11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZIPU7D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 16:59:03 -0400
In-Reply-To: <20090916160456.GC11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/16/2009 12:04 PM, Neil Horman wrote:
> Hey all-
> 	Ok, so I've got a story behind this one.  It was recently called to my
> attention that the ansi cprng is missing an aspect of its compliance requrements
> for FIPS-140.  Specifically, its missing a behavior in its continuous test.
> When the CPRNG produces random blocks, the firrst block that it produces must
> never be returned to the user.  Instead it must be saved and a second block must
> be generated so that it can be compared to the first block before being returned
> to the user.
>
> 	I recently posted a patch to do this for the hardware RNG.  Its fine to
> do this there, since there are no expectations of a predictable result in that
> RNG.  The CPRNG however, provides a predictable random sequence for a given
> input seed key and iteration.  The above requirement messes with that
> predictability however because it changes which block is returned on the zeroth
> iteration to the user.  Some test vectors expect this, some do not.
>
> 	So the question is, how do I make this RNG fips compliant without
> breaking some subset of users out there that rely on the predictability of the
> CPRNG?  The solution I've come up with is a dynamic flag.  This patch series
> adds two api calls to the crypto RNG api rng_set_flags and rng_get_flags, which
> set flags with global meaning on instances of an rng.  A given RNG can opt to
> set the registered agorithm methods for these api calls or not.  In the event
> they don't a default handler is set for each that returns EOPNOTSUPPORT.
>
> 	Using this new mechanism I've implemented these calls in ansi_cprng so
> that setting the TEST_MODE flag disables the continuous check, allowing for the
> zeroth block to get returned to the user, which lets us pass most of the
> supplied test vectors (most notably the NIST provided vectors).

Neil and I discussed this whole mess off-list, and I'm in agreement that 
this is the cleanest solution to the problem, despite the relative 
complexity it adds to the base rng code.

Will reply to each part individually for tracking purposes, but ACK for 
all three parts.

-- 
Jarod Wilson
jarod@redhat.com
