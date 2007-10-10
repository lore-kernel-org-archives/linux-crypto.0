From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Wed, 10 Oct 2007 11:08:26 -0500
Message-ID: <1192032506.2477.285.camel@faith.austin.ibm.com>
References: <200710091944.l99JiedH009971@faith.austin.ibm.com>
	 <20071010151743.GA8337@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53258 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbXJJQNA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Oct 2007 12:13:00 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9AGCucD021635
	for <linux-crypto@vger.kernel.org>; Wed, 10 Oct 2007 12:12:56 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9AGCuZU134332
	for <linux-crypto@vger.kernel.org>; Wed, 10 Oct 2007 12:12:56 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9AGCk7E009173
	for <linux-crypto@vger.kernel.org>; Wed, 10 Oct 2007 12:12:46 -0400
In-Reply-To: <20071010151743.GA8337@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2007-10-10 at 23:17 +0800, Herbert Xu wrote:
> On Tue, Oct 09, 2007 at 02:44:40PM -0500, Joy Latten wrote:
> > This should contain the geniv as well as all the
> > improvements discussed. All the testcases pass.
> 
> This looks pretty good!
> 
> I'm going to apply this once I fix up the geniv problems found
> by Sebastian.
> 
> BTW, could you please send me a final changeset description
> and Signed-off-by?
> 

Description:

This patch implements CTR mode for IPsec.
It is based off of RFC 3686.

Please note:
1. CTR turns a block cipher into a stream cipher.
Encryption is done in blocks, however the last block
may be a partial block.

A "counter block" is encrypted, creating a keystream
that is xor'ed with the plaintext. The counter portion
of the counter block is incremented after each block
of plaintext is encrypted.
Decryption is performed in same manner.

2. The CTR counterblock is composed of,
        nonce + IV + counter

The size of the counterblock is equivalent to the
blocksize of the cipher.
        sizeof(nonce) + sizeof(IV) + sizeof(counter) = blocksize

The CTR template requires the name of the cipher
algorithm, the sizeof the nonce, and the sizeof the iv.
        ctr(cipher,sizeof_nonce,sizeof_iv)

So for example,
        ctr(aes,4,8)
specifies the counterblock will be composed of 4 bytes
from a nonce, 8 bytes from the iv, and 4 bytes for counter
since aes has a blocksize of 16 bytes.

3. The counter portion of the counter block is stored
in big endian for conformance to rfc 3686.

Regards,
Joy

Signed-off-by: Joy Latten <latten@austin.ibm.com>
