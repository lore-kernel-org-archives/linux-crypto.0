From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 16 Aug 2016 17:26:56 +0800
Message-ID: <20160816092656.GA26928@gondor.apana.org.au>
References: <2808589.gm6f519sFh@positron.chronox.de>
 <11427544.kWdLX5BMAt@tauon.atsec.com>
 <20160816091347.GA26733@gondor.apana.org.au>
 <1605606.kqFagSqufY@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38132 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbcHPJ1G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:27:06 -0400
Content-Disposition: inline
In-Reply-To: <1605606.kqFagSqufY@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 16, 2016 at 11:25:33AM +0200, Stephan Mueller wrote:
>> I was thinking of the DRBG implementation: decouple it from the underlying 
> ciphers. Though, I am not fully sure that will work as there are several 
> specific settings that depend on the underlying ciphers (e.g. the state of a 
> Hash DRBG with SHA-256 is 444 bits whereas a Hash DRBG with SHA-512 has 888 
> bits).

The only reason DRBG is in crypto is because it implements stdrng.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
