From: Mark Allyn <allyn@well.com>
Subject: Question on __crypto_alg_lookup
Date: Fri, 27 Jan 2012 14:23:45 -0800 (PST)
Message-ID: <alpine.LRH.2.02.1201271415230.23638@well.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from newsmtp.well.com ([107.20.247.102]:49224 "EHLO newsmtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab2A0WXp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Jan 2012 17:23:45 -0500
Received: from well.com (well.com [10.110.241.121])
	by newsmtp.well.com (8.14.3/8.14.3) with ESMTP id q0RMNjQo003338
	for <linux-crypto@vger.kernel.org>; Fri, 27 Jan 2012 14:23:45 -0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Folks:

In __crypto_alg_lookup, at about line 85 of api.c, there is the following:

                 if ((q->cra_flags ^ type) & mask)
                         continue;

There is no commenting on this at all.

Can someone please explain what this is for and just what is this trying
to filter?

I am trying to get dm-crypt to work with a ahash device that we have.

The dm-crypt is calling crypto_alloc_hash with "sha256" type 0, and 
mask 0x 80

My driver is setting these flags:

                 .cra_flags              = CRYPTO_ALG_TYPE_AHASH |
                                                 CRYPTO_ALG_ASYNC,

The search seems to be failing at the above sequence in 
__crypto_alg_lookup.

Is dm-crypt supposed to work with ahash?

The Documentation/crypto does not seem to include much information
on using the ahash and ablkcipher infrastructure.

There is one document called async-tx-api.txt that seems to have no
correlation with the ahash or ablkcipher stuff. Is it still valid?

Is there another place I can look for decent documentation?

Thank you

Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588
