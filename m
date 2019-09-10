Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8476EC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 12:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6348A208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 12:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfIJM7H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 08:59:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33174 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfIJM7G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 08:59:06 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i7fjb-0003M1-Pj; Tue, 10 Sep 2019 22:59:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Sep 2019 22:59:02 +1000
Date:   Tue, 10 Sep 2019 22:59:02 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: Interesting crypto manager behavior
Message-ID: <20190910125902.GA5116@gondor.apana.org.au>
References: <MN2PR20MB2973C378D06E1694AE061983CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973C378D06E1694AE061983CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 10, 2019 at 12:50:04PM +0000, Pascal Van Leeuwen wrote:
> 
> I'm allocating a fallback (AEAD) cipher to handle some corner cases
> my HW cannot handle, but I noticed that the fallback itself is being
> tested when I allocate it (or so it seems) and if the fallback itself
> fails on some testvector, it is not replaced by an alternative while
> such an alternative should be available. So I have to fail my entire
> init because the fallback could not be allocated.

This has nothing to do with fallbacks and it's just how template
instantiation works.  If the instantiation fails it will not try
to construct another one.  The point is that if your algorithm
works then it should not fail the instantiation self-test.  And
if it does fail then it's a bug in the algorithm, not the API.

> i.e. while requesting a fallback for rfc7539(chacha20, poly1305), it
> attempts rfc7539(safexcel-chacha20,poly1305-simd), which fails, but
> it could still fall back to e.g. rfc7539(chacha20-simd, poly1305-simd),
> which should work.
> 
> Actually, I really do not want the fallback to hit another algorithm
> of my own driver. Is there some way to prevent that from happening?
> (without actually referencing hard cra_driver_name's ...)

I think if safexcel-chacha20 causes a failure when used with rfc7539
then it should just be fixed, or unexported.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
