From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Tue, 28 Apr 2015 10:54:02 +0800
Message-ID: <20150428025402.GB29738@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <20150428010941.GA28820@gondor.apana.org.au>
 <1742335.S7ujyfP8MQ@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53994 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbD1CyF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 22:54:05 -0400
Content-Disposition: inline
In-Reply-To: <1742335.S7ujyfP8MQ@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2015 at 04:45:17AM +0200, Stephan Mueller wrote:
>
> The use case I see goes along the lines of dm-crypt and Ext4 crypto, or 
> ecryptfs:
> 
> For the key wrapping they all do, I am thinking about suggesting KW as it has 
> one advantage no other cipher currently has: it is an authenticated decryption 
> where I still only need one symmetric key. Yes, KW is inefficient compared to 
> other ciphers, but for handling small data blobs, it should be just fine.
> 
> For example, dm-crypt: dm-crypt currently uses the same cipher used for the 
> bulk encryption to wrap the LUKS header. Obviously we miss the authentication 
> check of the data blob. So, we could use other authenticated schemas, like GCM 
> or authenc(). But they all need either two keys or AAD for which the common 
> mechanisms typically have no provisions. Therefore, KW is a drop-in 
> replacement for standard symmetric ciphers where one want authentication as 
> well.

If it's for cases where the data is always linear, we could always
do this outside the crypto API.  You can still use AES from the crypto
API to do the actual crypto of course.

By keeping it out of the crypto API you wouldn't have to worry about
SG lists and can simply require the input to be linear u8 * buffers.

However, because this is an algorithm that is not otherwise useful
you'll need to ensure that at least one user is going to be accepted
into the kernel.

The implementation could go into lib.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
