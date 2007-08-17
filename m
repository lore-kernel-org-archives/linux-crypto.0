From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: can CTR use blkcipher_walk_virt()?
Date: Sat, 18 Aug 2007 07:27:47 +0800
Message-ID: <20070817232747.GA25157@gondor.apana.org.au>
References: <E1ILrQp-0003OV-00@gondolin.me.apana.org.au> <1187380492.15699.590.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4495 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753702AbXHQX2S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Aug 2007 19:28:18 -0400
Content-Disposition: inline
In-Reply-To: <1187380492.15699.590.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 17, 2007 at 02:54:52PM -0500, Joy Latten wrote:
> 
> Just to make sure I understand correctly, 
> our plaintext will be a multiple of the blocksize,
> therefore it may be padded, right? 

Yes but the padding is something for the user to worry about
and shouldn't concern you.

> Also, since it is a multiple, I don't have to worry about last
> block of plaintext being less than blocksize and truncating 
> the keystream or ciphertext, right?

Yes.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
