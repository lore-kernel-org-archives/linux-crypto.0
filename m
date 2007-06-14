From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Subject: Re: Where has CRYPTO_TFM_MODE_nnn gone?
Date: Thu, 14 Jun 2007 15:06:02 -0700
Message-ID: <4671BBCA.5080508@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: linux-crypto@vger.kernel.org,
	Shane McDonald <Shane_McDonald@pmc-sierra.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mother.pmc-sierra.com ([216.241.224.12]:41957 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751694AbXFNWGK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jun 2007 18:06:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu wrote:
> On Fri, Jun 08, 2007 at 12:13:17PM -0700, Marc St-Jean wrote:
>  >
>  > In CBC mode we had a line of code copying cipher_desc.info to get the
>  > initialization vector. Such as:
>  >               /* Copy in IV */
>  >               memcpy((u8*)(sa->crypt_iv), desc->info,
>  >                       crypto_tfm_alg_ivsize(tfm));
>  >
>  > Now the only reference to the function I can find is in an IPsec comment
>  > from include/net/esp.h. Any tips on getting the size?
> 
> We now have two types of ciphers, simple ciphers and block ciphers.  The
> former only ever ecnrypts one block at a time, and therefore needs no IV.
> Only block ciphers have IVs.
> 
> The other change is that instead of having everything as crypto_tfm they
> all have their own types now.  So ciphers are crypto_cipher while block
> ciphers are crypto_blkcipher.
> 
> In your case your tfm should be of type crypto_blkcipher.  Then you simply
> call crypto_blkcipher_ivsize(tfm) to get the size.
>  
>  > Thanks, I have been looking at that code but unfortunately it supports
>  > fewer cryptos/hashes so does not answer all my questions.
> 
> The same concept still applies regardless of the actual number of modes.
> 
> Oh and yes you do register it multiple times, once for each combination
> of the blocking mode and the cipher.

Thanks for the info Herbert.

Marc
