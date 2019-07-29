Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0784EC433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 22:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8CC72070D
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 22:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfG2WbU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 18:31:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60626 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbfG2WbU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 18:31:20 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hsEAk-0001yp-MA; Tue, 30 Jul 2019 08:31:14 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hsEAi-0001xi-Mn; Tue, 30 Jul 2019 08:31:12 +1000
Date:   Tue, 30 Jul 2019 08:31:12 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190729223112.GA7529@gondor.apana.org.au>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 10:16:48PM +0000, Pascal Van Leeuwen wrote:
>
> > EINVAL is for invalid lengths while EBADMSG is for inauthentic inputs.
> > Inauthentic test vectors aren't yet automatically generated (even after this
> > patch), so I don't think EBADMSG should be seen here.  Are you sure there isn't
> > a bug in your patch that's causing this?
> > 
> As far as I understand it, the output of the encryption is fed back in to
> decrypt. However, if the encryption didn't work due to blocksize mismatch, 
> there would not be any valid encrypted and authenticated data written out. 
> So, if the (generic) driver checks that for decryption, it would result in
> -EINVAL. If it wouldn't check that, it would try to decrypt and authentica
> te the data, which would almost certainly result in a tag mismatch and
> thus an -EBADMSG error being reported.
> 
> So actually, the witnessed issue can be perfectly explained from a missing
> block size check in aesni.

The same input can indeed fail for multiple reasons.  I think in
such cases it is unreasonable to expect all implementations to
return the same error value.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
