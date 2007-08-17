From: Joy Latten <latten@austin.ibm.com>
Subject: Re: can CTR use blkcipher_walk_virt()?
Date: Fri, 17 Aug 2007 14:54:52 -0500
Message-ID: <1187380492.15699.590.camel@faith.austin.ibm.com>
References: <E1ILrQp-0003OV-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56383 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbXHQT5i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Aug 2007 15:57:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7HJvb8R030534
	for <linux-crypto@vger.kernel.org>; Fri, 17 Aug 2007 15:57:37 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7HJvb8w558056
	for <linux-crypto@vger.kernel.org>; Fri, 17 Aug 2007 15:57:37 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7HJvbJK007113
	for <linux-crypto@vger.kernel.org>; Fri, 17 Aug 2007 15:57:37 -0400
In-Reply-To: <E1ILrQp-0003OV-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2007-08-17 at 10:19 +0800, Herbert Xu wrote:
> Joy Latten <latten@austin.ibm.com> wrote:
> > I am in learning mode and have been looking into CTR.
> > Based on the fact that CTR does not require the plaintext to 
> > be a multiple of the blocksize nor is padding required,
> > should I use cipher.c routines (as xcbc does) instead
> > of blkcipher.c routines (as cbc does)?
> > (I've been referencing rfc 3686.)
> 
> CBC is the correct model to follow.  For our purposes you
> will only get multiples of blocks.  The only difference
> is that unlike CBC you can chop bits off the last block
> of plain text and the same bits will be chopped off in
> the cipher text.
> 
ok, that is good, I started out following CBC model and will continue. 

Just to make sure I understand correctly, 
our plaintext will be a multiple of the blocksize,
therefore it may be padded, right? 
Also, since it is a multiple, I don't have to worry about last
block of plaintext being less than blocksize and truncating 
the keystream or ciphertext, right?


Thanks.

Joy



> With CBC chopping off bits in either changes the other one
> entirely.
> 
> Cheers,
