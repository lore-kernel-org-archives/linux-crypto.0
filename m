From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question about ahash export and import
Date: Wed, 27 Sep 2017 17:08:02 +0800
Message-ID: <20170927090802.GA1547@gondor.apana.org.au>
References: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
 <CGME20170926103514epcas1p4494e6502b2b6835c732201a4aeff60b1@epcas1p4.samsung.com>
 <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
 <be29fd42-2e64-5ca8-546c-e7f68a2d0da7@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Christophe LEROY <christophe.leroy@c-s.fr>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44960 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751787AbdI0JIu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Sep 2017 05:08:50 -0400
Content-Disposition: inline
In-Reply-To: <be29fd42-2e64-5ca8-546c-e7f68a2d0da7@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 26, 2017 at 01:09:05PM +0200, Kamil Konieczny wrote:
> 
> Can import() be called without _any_ init(), for example
> after reboot of machine ? Is following scenario valid:

Of course it can.  import must restore the state of the request
to that at the time when export was called.

import does not need to be called after init.  init simply resets
the hash state for new update/final calls.

> init(), update() 0 or more times, export(),
> save exported data to pernament storage
> reboot machine
> load crypto driver, import() saved state ?

Yes this must be supported.

Basically after any update call is complete (you've called the
completion function), you should be able to call export and
completely extract the partial (as opposed to finalised) hash
state.

Remember we need to support an arbitrarily large number of
concurrent hashing operations.  So you cannot keep a hash state
in hardware indefinitely just because the user has not called
finalize on it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
