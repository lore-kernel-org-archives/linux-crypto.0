From: Herbert Xu <herbert.xu@redhat.com>
Subject: Re: [PATCH 1/1]: CTR mode implementation
Date: Tue, 25 Sep 2007 09:17:11 +0800
Message-ID: <20070925011711.GB23634@gondor.apana.org.au>
References: <200709250031.l8P0VWjo014505@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1251 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754571AbXIYBRu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Sep 2007 21:17:50 -0400
Content-Disposition: inline
In-Reply-To: <200709250031.l8P0VWjo014505@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2007 at 07:31:32PM -0500, Joy Latten wrote:
> 
> I have another question regarding this change to using a tuple.
> The size of my counter is now, csize = blocksize - (noncesize + ivsize).
> rfc 3686 (CTR-AES for ESP) states in section 4, that the counter
> portion of the counter block be a 32-bit big endian. To keep
> code endian-neutral as I can, would it be appropriate if I only did
> this when my csize is 2, 4 or 8 bytes so I can easily use be16_to_cpu(), 
> be32_to_cpu() and be64_to_cpu() respectively? And for all other 
> sizes for csize, don't worry about this "endian" requirement, just store as is. 
> Does it matter that I store the 32 bits as big endian?

Just fail the algorithm construction if the the counter block
size doesn't come out to be 4 for now.  We can change this later
on when needs arise.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
