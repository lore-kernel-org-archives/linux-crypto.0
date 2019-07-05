Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8D7C4649B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 12:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A19D20828
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 12:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfGEM7g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 08:59:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52034 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGEM7f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 08:59:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hjNoM-0000jn-FP; Fri, 05 Jul 2019 20:59:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hjNoI-00063F-Ut; Fri, 05 Jul 2019 20:59:30 +0800
Date:   Fri, 5 Jul 2019 20:59:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: skcipher and aead API question
Message-ID: <20190705125930.7idte7awvhixvsnc@gondor.apana.org.au>
References: <BY5PR20MB296261AC5E07B6E7E2B7E6A9CAF50@BY5PR20MB2962.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR20MB296261AC5E07B6E7E2B7E6A9CAF50@BY5PR20MB2962.namprd20.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 05, 2019 at 09:48:53AM +0000, Pascal Van Leeuwen wrote:
> Hi,
> 
> Just browsing through include/crypto/skcipher.h and include/crypto/aead.h I noticed that
> struct skcipher_alg and struct aead_alg define callbacks named 'init' and 'exit' as well as a
> field called 'chunksize'. The inside-secure driver is currently initializing these fields to NULL
> or 0 and that appears to work fine, but the respective heade files mention that all fields
> should be filled in except for 'ivsize' ...
> 
> >From the code I deduce that init and exit are not called if they are null pointers, which is
> fine for me as I have no need for such callbacks, but can I rely on that going forward?
> 
> I also deduce that if chunksize is set to 0, the chunksize will actually be taken from
> cra_blocksize, which is at least fine for block ciphers. Again, can I rely on that?
> If so, I guess I would  still have to set it for CTR modes which have cra_blocksize is 1?

These fields are indeed optional.

> Finally, I noticed that aead.h defines an additional callback 'setauthsize', which the
> driver currently also keeps at NULL and that *seems* to work fine with all current
> testmgr tests ... so I do wonder whether that is a must implement or not?
> And if so, which subset of auth sizes MUST be implemented?

This however must be implemented *if* the underlying algorithm
(IOW refer to the generic implementation) supports them.  The
set of supported values must not be smaller than that of the
generic algorithm.

In practice this shouldn't be a big deal as it's just a matter
of truncating the ICV.

Note that you don't actually need to supply a setauthsize function
if all values (less than maxauthsize are supported).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
