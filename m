From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question about ahash export and import
Date: Sat, 25 Nov 2017 11:16:40 +1100
Message-ID: <20171125001640.GB20780@gondor.apana.org.au>
References: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
 <CGME20170926103514epcas1p4494e6502b2b6835c732201a4aeff60b1@epcas1p4.samsung.com>
 <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
 <be29fd42-2e64-5ca8-546c-e7f68a2d0da7@partner.samsung.com>
 <20170927090802.GA1547@gondor.apana.org.au>
 <e7eaa2a4-dc44-8542-c2a2-702d8ac7256c@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Christophe LEROY <christophe.leroy@c-s.fr>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:39174 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdKYARU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 19:17:20 -0500
Content-Disposition: inline
In-Reply-To: <e7eaa2a4-dc44-8542-c2a2-702d8ac7256c@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 24, 2017 at 02:35:04PM +0100, Kamil Konieczny wrote:
>
> I have more questions, this time about HMAC export/import.
> In doc, there is stated that key can be copied into context transformation.
> 
> Should .export copy request context _and_ key used ? Or not ?

The key is stored in the tfm so export does not need to touch the
key.  However, sometimes the key is naturally embedded in the hash
state too, e.g., with hmac, in that case it would make sense for
export to copy it as part of the hash state.

> When processing requests, can I assume the key in transformation is const until .final ?

Yes you may.

> Is is possible to have okey derived from different key then ikey ? I think not.

We do not need to support that case.  If the user changes the
key mid-stream it results in undefined behaviour.  However,
the code should not crash though.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
