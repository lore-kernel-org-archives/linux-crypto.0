From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ahash and halg.statesize
Date: Fri, 27 Nov 2015 20:54:42 +0800
Message-ID: <20151127125442.GB29303@gondor.apana.org.au>
References: <17889830.Qe4KtthDOe@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39171 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbK0Myo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 07:54:44 -0500
Content-Disposition: inline
In-Reply-To: <17889830.Qe4KtthDOe@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 26, 2015 at 05:01:24PM +0100, Stephan Mueller wrote:
> 
> after Fabio's confirmation on the mxs-dcp ahash implementations, I briefly 
> looked for the invocation of crypto_register_ahash and found numerous 
> invocations. After taking two examples (sahara, n2), I did not find 
> halg.statesize.
> 
> Thus, I would conclude that none of these ciphers would work currently.
> 
> I am currently not sure how to solve that issue as every ahash implementation 
> must be assessed for its statesize.

Unfortunately these drivers can cause algif_hash to crash when
the latter invokes the export/import functions.

So we need to audit them one-by-one and ensure that export and
import actually works before turning them back on.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
