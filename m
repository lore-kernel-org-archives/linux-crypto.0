Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11467C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 02:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0E63239D1
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 02:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgLJCoh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:44:37 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55748 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgLJCo1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Dec 2020 21:44:27 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1knBvi-0004u5-8K; Thu, 10 Dec 2020 13:43:43 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Dec 2020 13:43:42 +1100
Date:   Thu, 10 Dec 2020 13:43:42 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
Message-ID: <20201210024342.GA26428@gondor.apana.org.au>
References: <20201201194556.5220-1-ardb@kernel.org>
 <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au>
 <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au>
 <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au>
 <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 10, 2020 at 01:18:12AM +0100, Ard Biesheuvel wrote:
> 
> One thing I realized just now is that in the current situation, all
> the synchronous skciphers already degrade like this.
> 
> I.e., in Ben's case, without the special ccm implementation, ccm(aes)
> will resolve to ccm(ctr(aesni),cbcmac(aesni)), which is instantiated
> as a sync skcipher using the ctr and ccm/cbcmac templates built on top
> of the AES-NI cipher (not skcipher).  This cipher will also fall back
> to suboptimal scalar code if the SIMD is in use in process context.

Sure, your patch is not making it any worse.  But I don't think
the extra code is worth it considering that you're still going to
be running into that slow fallback path all the time.

Much better to fix the wireless code to actually go async.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
