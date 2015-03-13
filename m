From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AES-NI - fix memory usage in GCM decryption
Date: Fri, 13 Mar 2015 21:33:06 +1100
Message-ID: <20150313103306.GA1559@gondor.apana.org.au>
References: <44569470.FQKUtYhtg6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37954 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbCMKdO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 06:33:14 -0400
Content-Disposition: inline
In-Reply-To: <44569470.FQKUtYhtg6@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 12, 2015 at 09:17:51AM +0100, Stephan Mueller wrote:
> The kernel crypto API logic requires the caller to provide the
> length of (ciphertext || authentication tag) as cryptlen for the
> AEAD decryption operation. Thus, the cipher implementation must
> calculate the size of the plaintext output itself and cannot simply use
> cryptlen.
> 
> The RFC4106 GCM decryption operation tries to overwrite cryptlen memory
> in req->dst. As the destination buffer for decryption only needs to hold
> the plaintext memory but cryptlen references the input buffer holding
> (ciphertext || authentication tag), the assumption of the destination
> buffer length in RFC4106 GCM operation leads to a too large size. This
> patch simply uses the already calculated plaintext size.
> 
> In addition, this patch fixes the offset calculation of the AAD buffer
> pointer: as mentioned before, cryptlen already includes the size of the
> tag. Thus, the tag does not need to be added. With the addition, the AAD
> will be written beyond the already allocated buffer.
> 
> Note, this fixes a kernel crash that can be triggered from user space
> via AF_ALG(aead) -- simply use the libkcapi test application
> from [1] and update it to use rfc4106-gcm-aes.
> 
> Using [1], the changes were tested using CAVS vectors to demonstrate
> that the crypto operation still delivers the right results.
> 
> [1] http://www.chronox.de/libkcapi.html
> 
> CC: Tadeusz Struk <tadeusz.struk@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
