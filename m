From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: can CTR use blkcipher_walk_virt()?
Date: Fri, 17 Aug 2007 10:19:23 +0800
Message-ID: <E1ILrQp-0003OV-00@gondolin.me.apana.org.au>
References: <200708162100.l7GL0Qt4010595@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: latten@austin.ibm.com (Joy Latten)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4298 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592AbXHQCTm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 22:19:42 -0400
In-Reply-To: <200708162100.l7GL0Qt4010595@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Joy Latten <latten@austin.ibm.com> wrote:
> I am in learning mode and have been looking into CTR.
> Based on the fact that CTR does not require the plaintext to 
> be a multiple of the blocksize nor is padding required,
> should I use cipher.c routines (as xcbc does) instead
> of blkcipher.c routines (as cbc does)?
> (I've been referencing rfc 3686.)

CBC is the correct model to follow.  For our purposes you
will only get multiples of blocks.  The only difference
is that unlike CBC you can chop bits off the last block
of plain text and the same bits will be chopped off in
the cipher text.

With CBC chopping off bits in either changes the other one
entirely.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
