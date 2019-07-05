Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C787FC5B57D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 03:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5BB21850
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 03:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfGEDIh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 23:08:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51362 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfGEDIh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 23:08:37 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hjEaM-0000wR-V8; Fri, 05 Jul 2019 11:08:30 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hjEaJ-0002dk-BM; Fri, 05 Jul 2019 11:08:27 +0800
Date:   Fri, 5 Jul 2019 11:08:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted byte-offset
 initialization vector.
Message-ID: <20190705030827.k6f7hnhxjsoxdj6b@gondor.apana.org.au>
References: <20190704131033.9919-1-gmazyland@gmail.com>
 <20190704131033.9919-3-gmazyland@gmail.com>
 <7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
 <CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
 <CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
 <4286b8f6-03b5-a8b4-4db2-35dda954e518@gmail.com>
 <CAKv+Gu_Nesqtz-xs0LkHYZ6HXrKkbJjq8dKL6Cnrk9ZsQ=T3jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Nesqtz-xs0LkHYZ6HXrKkbJjq8dKL6Cnrk9ZsQ=T3jg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 04, 2019 at 08:11:46PM +0200, Ard Biesheuvel wrote:
> 
> To be clear, making the cipher API internal only is something that I
> am proposing but hasn't been widely discussed yet. So if you make a
> good argument why it is a terrible idea, I'm sure it will be taken
> into account.
> 
> The main issue is that the cipher API is suboptimal if you process
> many blocks in sequence, since SIMD implementations will not be able
> to amortize the cost of kernel_fpu_begin()/end(). This is something
> that we might be able to fix in other ways (and a SIMD get/put
> interface has already been proposed which looks suitable for this as
> well) but that would still involve an API change for something that
> isn't the correct abstraction in the first place in many cases. (There
> are multiple implementations of ccm(aes) using cipher_encrypt_one() in
> a loop, for instance, and these are not able to benefit from, e.g,
> the accelerated implementation that I created for arm64, since it open
> codes the CCM operations)

I agree with what you guys have concluded so far.  But I do have
something I want to say about eboiv's implementation itself.

AFAICS this is using the same key as the actual data.  So why
don't you combine it with the actual data when encrypting/decrypting?

That is, add a block at the front of the actual data containing
the little-endian byte offset and then use an IV of zero.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
