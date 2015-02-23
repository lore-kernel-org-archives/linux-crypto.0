From: Marcus Meissner <meissner@suse.de>
Subject: Re: GCM / seqiv and SP800-38D
Date: Mon, 23 Feb 2015 14:32:43 +0100
Message-ID: <20150223133243.GB19890@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbbBWNcp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 08:32:45 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D4C2CAC97
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2015 13:32:43 +0000 (UTC)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I had some offline discussion with Stephan and it seems to me
at least that it is very hard to use the described "Deterministic"
method under Linux while at the same time still keeping the
uniqueness requirement to stay FIPS 140-2 certifiable.


How about going full randomized IV generation on GCM?

For that I wonder if the givencrypt can ever be called with the same
sequence number again so we would need to reproduce earlier randomness?

Ciao, Marcus


> Hi Herbert,
> 
> After some research, we think that the current implementation of seqiv 
> as used for GCM does not comply with SP800-38D. Before I outline the 
> issue, please allow me to state my understanding of seqiv (to make sure 
> I really understand it :-) ).
> 
> Seqiv works as a wrapper around the associated cipher (like GCM in our 
> case). If a caller wants to use the seqiv helper, the caller must use 
> the aead_givcrypt_set_* API calls. For example, esp_output does that.
> 
> If the API calls are invoked seqiv performs its work and then calls the 
> underlying cipher. The main work in seqiv is implemented in 
> seqiv_geniv(). This function creates the IV for GCM. Its logic can be 
> characterized as follows:
> 
> 1. get some salt value from an RNG during init time (ctx->salt)
> 
> 2. fill the IV with a sequence number provided by the caller (esp_output 
> provides the IPSec sequence number here)
> 
> 3. left-pad the sequence number with zeros
> 
> 4. XOR the salt with the value from 3.
> 
> In case of rfc4106(gcm(aes)), the IV is 96 bits. Thus, our constructed 
> IV looks like:
> 
> - rightmost 64 bit is an XOR of the sequence number and the rightmost 64 
> bit of the random number
> 
> - leftmost 32 bit is leftmost 32 bit of the random number
> 
> If my understanding is correct, then this does not comply with 
> SP800-38D. Even after speaking with the mathematicians at NIST 
> controlling SP800-38D, they do not want to accept that solution.
> 
> The particular problem is SP800-38D section 8.2.1 and 8.2.2 where one 
> can choose which of these two sections are implemented (either a full 
> deterministic generation of an IV or a full RNG-based generation with an 
> approved DRBG).
> 
> The key issue the authors of SP800-38D want to protect against is that 
> there is no collision in the generation of an IV (for a given key). 
> 
> What seqiv does is to use the output of a DRBG (in FIPS mode) or 
> /dev/urandom (in normal mode) and XOR it with a static value. The 
> "postprocessing" of the XORing is not allowed as it may introduce 
> potential collisions. I do not want to dive into math here, but if 
> needed, we can do some calculations.
> 
> Thus, may I ask for a change in the GCM/seqiv combo? I think one of the 
> following solutions would be possible:
> 
> - change seqiv to eliminate the XOR step (not sure whether we need to 
> generate a random number every time seq_geniv is invoked)
> 
> - create a new IV handler (maybe call it simpleiv that may be a simple 
> counter or an LFSR or a frontend to an RNG)
> 
> I would prefer the latter and wire up GCM with that "simpleiv".
> 
> Ciao
> Stephan
