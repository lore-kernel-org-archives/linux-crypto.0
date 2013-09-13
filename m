From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: question about rfc404 support.
Date: Fri, 13 Sep 2013 21:09:04 +1000
Message-ID: <20130913110904.GA7881@gondor.apana.org.au>
References: <A83C99F8370D4D42BEB2D2B3153A6BBC23D6C796@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Bronstein, Dan" <dbronste@qti.qualcomm.com>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:42007 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952Ab3IMLJI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 07:09:08 -0400
Content-Disposition: inline
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC23D6C796@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 11, 2013 at 07:16:13PM +0000, Hsieh, Che-Min wrote:
> Herbert:
> 
>   Can you confirm the following. Thanks.
> 
>   Rfc2404 - The Use of HMAC-SHA-1-96 within ESP and AH
>  
>  For the support, I can't find any algorithm to be specified in the .craname of ahash_alg for Rfc2404.
>  
>   From 
> http://www.freebsd.org/cgi/man.cgi?query=setkey&sektion=8
>  it says the following :
> 
>   ALGORITHMS
>      The following list shows the supported algorithms.  The protocol and algorithm are almost completely orthogonal.  The following list of authentication algorithms can be used as aalgo in the -A aalgo of the protocol parameter:
> 
> 	   algorithm	   keylen (bits)       comment
> 	   
> 	   hmac-sha1	   160		   ah: rfc2404
>  
> 
> That leads me to believe, from crypto driver stand point, there is no need to have a new algorithm for hmac-sha-1-96 support.  Instead, the agent SW(such as ipsec) should use  "hmac(sha1)", and do the truncation of digested data from 160 bits to 96 bits.
> 
> I run a quick test. The input file to setkey command is defined as such ----
> 
> flush;
> spdflush;
> add 10.2.243.75 10.2.243.29 ah 0x604 -A hmac-sha1 0x8D967D88F6CAA9D714800AB3D48051D63F73A312;
> add 10.2.243.29 10.2.243.75 ah 0x605 -A hmac-sha1 0x8D967D88F6CAA9D714800AB3D48051D63F73A314;
> spdadd 10.2.243.75 10.2.243.29 any -P in ipsec ah/transport//use;
> spdadd 10.2.243.29 10.2.243.75 any -P out ipsec ah/transport//use;
> 
> 
> I use tcpdump. Clearly I can see 24 bytes of AH header of the ipsec packets.  The header has 12 bytes of fixed information  - Next (1), Ah len (1) ,Reserved (2), Spi (4)  ,Sequence                      (4),  and Auth result.  (12 bytes)
> 
> 
> Can you confirm the above? Thanks.

Yes, see net/xfrm/xfrm_algo.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
