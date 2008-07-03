From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 0/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Thu, 3 Jul 2008 16:19:24 -0400
Message-ID: <20080703201924.GA5237@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nhorman@tuxdriver.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4074 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYGCUTl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2008 16:19:41 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset add a pseudo random number generator to the kernel crypto library.
Usefull in assisting with the implementation of various FIPS compliant ipsec
algorithms.  Based on the suggestions provided in ANSI X9.31 Appendix A.2.4.
Tested successfully by myself.  Set consists of two parts:
1/2: creation of files prng.c and prng.h
2/2: Addition of Kconfig & Makefile rules to build code

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
 

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
