From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hmac(crc32)
Date: Fri, 7 Apr 2017 14:14:59 +0800
Message-ID: <20170407061459.GA2366@gondor.apana.org.au>
References: <1891573.4Vd40q9uOn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:41970 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752691AbdDGGPH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2017 02:15:07 -0400
Content-Disposition: inline
In-Reply-To: <1891573.4Vd40q9uOn@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 08, 2017 at 09:20:08AM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> hmac(crc32) is defined in testmgr.c and tcrypt.c. Yet, when using that cipher, 
> I get an ENOENT:
> 
> alg: hash: Failed to load transform for hmac(crc32): -2
> 
> 
> Is there such a thing as hmac(crc32)?

Yes this is a bogus driver implementation that sneaked through.

We should remove bfin_crc along with the test vector.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
