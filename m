From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question about ahash export and import
Date: Thu, 28 Sep 2017 18:25:53 +0800
Message-ID: <20170928102553.GA8118@gondor.apana.org.au>
References: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
 <CGME20170926103514epcas1p4494e6502b2b6835c732201a4aeff60b1@epcas1p4.samsung.com>
 <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
 <be29fd42-2e64-5ca8-546c-e7f68a2d0da7@partner.samsung.com>
 <20170927090802.GA1547@gondor.apana.org.au>
 <0fbf816a-5a0a-b9fc-3441-171116fe4c1c@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:47564 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdI1K00 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Sep 2017 06:26:26 -0400
Content-Disposition: inline
In-Reply-To: <0fbf816a-5a0a-b9fc-3441-171116fe4c1c@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 27, 2017 at 04:59:56PM +0200, Christophe LEROY wrote:
> 
> Can we consider that once an export has been done, no new update call will
> be performed prior to doing an init or an import ? Or should it be possible
> to continue with an update or a final/finup call after an export ?

No export should not affect the ability to perform subsequent
update/finalize calls.  IOW it should be a read-only operation
as far as the hash state is concerned.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
