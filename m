From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: combined mode algorithms
Date: Tue, 21 Aug 2007 07:34:08 +0800
Message-ID: <E1INGl6-0004yE-00@gondolin.me.apana.org.au>
References: <200708202312.l7KNCNBA015041@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: latten@austin.ibm.com (Joy Latten)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4821 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750724AbXHTXeL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 19:34:11 -0400
In-Reply-To: <200708202312.l7KNCNBA015041@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Joy Latten <latten@austin.ibm.com> wrote:
>>
>>The salt will just come from the key field.  So instead of having
>>an 128-bit key for example, you'd have 152 bits.
> 
> ok, quick question, this 152 bits key will be part
> of input to setkey()? 

Yes.

> The reason I am asking is because setkey in ablkcipher and
> blkcipher check key length for min and max size.  
> Thus for example, aes, when using a 256 bit key, would
> pass in 288 bits or 36 octet key. max is 32 bits, so would
> result in error. 

No AES or blkcipher will never see the longer key.  The key
will be broken up by the CCM template (yet to be written)
and part of it goes to AES while the other part gets used
as the nonce.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
