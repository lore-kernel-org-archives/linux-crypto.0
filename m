Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD7EC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 22:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF04B20709
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 22:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgHRWeV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:34:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43778 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgHRWeU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 18:34:20 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8AB5-0008BJ-Ar; Wed, 19 Aug 2020 08:34:00 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Aug 2020 08:33:59 +1000
Date:   Wed, 19 Aug 2020 08:33:59 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
Message-ID: <20200818223359.GA27712@gondor.apana.org.au>
References: <20200802090616.1328-1-ardb@kernel.org>
 <20200818082410.GA24497@gondor.apana.org.au>
 <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
 <20200818135128.GA25652@gondor.apana.org.au>
 <2aad9569-877e-4398-88ef-e40d9bbf7656@candelatech.com>
 <20200818140532.GA25807@gondor.apana.org.au>
 <be188471-b75f-d2e2-d657-265a1cd9831b@candelatech.com>
 <20200818221550.GA27421@gondor.apana.org.au>
 <20200818222719.GA27622@gondor.apana.org.au>
 <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 18, 2020 at 03:31:10PM -0700, Ben Greear wrote:
>
> I don't think it has been discussed recently, but mac80211 is already
> a complicated beast, so if this added any significant complexity
> it might not be worth it.

Any bulk data path should be using the async interface, otherwise
performance will seriously suffer should SIMD be unavailable.  I
think someone should look at converting wireless to async like IPsec.

> Truth is though, I know very little about what changes would be
> needed to make it do async decrypt, so maybe it would be a simple
> matter?

IPsec was actually quite straightforward.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
