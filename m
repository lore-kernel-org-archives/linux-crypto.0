From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Sat, 29 Sep 2007 21:33:08 +0800
Message-ID: <20070929133308.GA3619@gondor.apana.org.au>
References: <200709272054.l8RKspsx002649@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@suug.sh
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2477 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbXI2Ndm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Sep 2007 09:33:42 -0400
Content-Disposition: inline
In-Reply-To: <200709272054.l8RKspsx002649@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 27, 2007 at 03:54:51PM -0500, Joy Latten wrote:
>
>    So, for example,
> 
> 		ctr(aes,4,8)
> 
>    specifies the counter block will be composed of 4 bytes from a
>    nonce and 8 bytes from the IV and 4 bytes for counter, which is set.

Could you please add a check to verify that for

	ctr(X,Y,Z)

we have

	block_size(X) - Y - Z == 4

Return -EINVAL if this fails.

> 2. it is assumed that plaintext is  multiple of blocksize.

Yes blkcipher will fail if there's any left-over.

Sorry, I think I misled you earlier when you asked about the
block size and left-overs.

The block size of ctr(aes,X,Y) should not be that of the block
size of AES.  It should instead be 1 as CTR is a stream cipher.

The API currently doesn't allow that but I'll patch it so
that it does :)

> 3. currently nonce is extracted from the last 4 bytes of key.
>    Thus keys entered through setkey() have an additional 32 bits.
>    This causes problems for 256-bit keys. For example,
>    crypto_ablkcipher_setkey() checks the maximum keysize and
>    complains about keysize.
>    This issue will be taken cared of with the new
>    infrastructure/template for combined mode that is planned,
>    and appropriate changes will be made to crypto_ctr_setkey()
>    and testcases.

You should instead increase min_keysize/max_keysize accordingly.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
