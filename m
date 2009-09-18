From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 0/1] enhance RNG api with flags to allow for different
	operational modes (v2)
Date: Fri, 18 Sep 2009 14:32:54 -0400
Message-ID: <20090918183254.GA28540@hmsreliant.think-freely.org>
References: <20090916160456.GC11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jarod@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59220 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbZIRSdA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2009 14:33:00 -0400
Content-Disposition: inline
In-Reply-To: <20090916160456.GC11163@hmsreliant.think-freely.org>
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
 CPRNG? The solution we've discussed here is the use of a wrapper algorithm.  We
implement fips(ansi_cprng), which is exactly like the ansi_cprng, except that it
implements the continuous test on top of it.
 
 Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
