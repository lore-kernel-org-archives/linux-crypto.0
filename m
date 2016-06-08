From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 8 Jun 2016 10:41:40 +0800
Message-ID: <20160608024140.GA12283@gondor.apana.org.au>
References: <1664837.3VbqQRUZed@positron.chronox.de>
 <3243059.jE1At2qco9@tauon.atsec.com>
 <20160602094211.GA16489@gondor.apana.org.au>
 <1580741.tpUX5Z7OKy@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44336 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbcFHClo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 22:41:44 -0400
Content-Disposition: inline
In-Reply-To: <1580741.tpUX5Z7OKy@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 02:06:55PM +0200, Stephan Mueller wrote:
>
> I am working on it. During the analysis, I saw, however, that the DRBG 
> increments the counter before the encryption whereas the the CTR mode 
> increments it after the encryption.
> 
> I could of course adjust the handling in the code, but this would be a real 
> hack IMHO.

Changing the order of increment is equivalent to changing the IV, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
