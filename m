From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] revamp fips_allowed flag
Date: Thu, 15 Sep 2016 13:58:08 +0800
Message-ID: <20160915055808.GA14688@gondor.apana.org.au>
References: <1818375.56xtGUSNII@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <stephan.mueller@atsec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53598 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753415AbcIOF60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 01:58:26 -0400
Content-Disposition: inline
In-Reply-To: <1818375.56xtGUSNII@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 15, 2016 at 07:35:43AM +0200, Stephan Mueller wrote:
>
> Wouldn't it be more prudent to move that flag into the crypto_alg and 
> crypto_template data structures so that the flag is checked during the 
> crypto_register_* functions? I.e. if the flag is not set and the FIPS mode is 
> enabled, the cipher is simply not registered?

The problem with that is then if you have 10 implementations of a
given algorithm you'd have to change 10 places to modify its FIPS
status.

Where's the pain point here? For cases like seqiv where you want to
say if X is FIPS-allowed then so is seqiv(X) we can certainly add
some code to testmgr to cater for that instead of listing them
individually.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
