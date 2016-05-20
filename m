From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Sat, 21 May 2016 07:31:32 +0800
Message-ID: <20160520233132.GA18006@gondor.apana.org.au>
References: <20160520041901.GA2645@gondor.apana.org.au>
 <573F324E.7000100@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Denis B <begun.denis@gmail.com>, linux-crypto@vger.kernel.org
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50213 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbcETXbj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 May 2016 19:31:39 -0400
Content-Disposition: inline
In-Reply-To: <573F324E.7000100@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 20, 2016 at 10:50:38AM -0500, Gary R Hook wrote:
>
> Why is (or should) setting geniv (be) required?
> 
> crypto_givcipher_default() appears to call crypto_default_geniv() if
> the geniv member
> is NULL. That function returns "eseqiv" or "chainiv" (under certain
> conditions). If an
> implementation isn't generating its own IVs, shouldn't the default
> happen anyway? Or is
> this more a matter of populating the structure with known,
> intentional values?
> 
> Thank you for any illumination provided.

In the upstream kernel AEAD geniv has been completely phased out
and no longer exists.  Denis is working on an old kernel that still
has it.

We haven't yet phased it out for skcipher but I'm working on it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
