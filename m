Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CAAC5B57D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 08:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F252218BC
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 08:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGEIvV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:51:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40692 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfGEIvV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 04:51:21 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hjJw2-0004ul-QO; Fri, 05 Jul 2019 16:51:14 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hjJvz-00030Q-8S; Fri, 05 Jul 2019 16:51:11 +0800
Date:   Fri, 5 Jul 2019 16:51:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted byte-offset
 initialization vector.
Message-ID: <20190705085111.ibpv3bmbxzy4mxgo@gondor.apana.org.au>
References: <20190704131033.9919-1-gmazyland@gmail.com>
 <20190704131033.9919-3-gmazyland@gmail.com>
 <7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
 <CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
 <CAKv+Gu8a6cBQYsbYs8CDyGbhHx0E=+1SU7afqoy9Cs+K8PMfqA@mail.gmail.com>
 <4286b8f6-03b5-a8b4-4db2-35dda954e518@gmail.com>
 <CAKv+Gu_Nesqtz-xs0LkHYZ6HXrKkbJjq8dKL6Cnrk9ZsQ=T3jg@mail.gmail.com>
 <20190705030827.k6f7hnhxjsoxdj6b@gondor.apana.org.au>
 <CAKv+Gu-Nye8TF68bZ=fKzU-SBpW7nx3F8ECcZjLjKD_TTbtsmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Nye8TF68bZ=fKzU-SBpW7nx3F8ECcZjLjKD_TTbtsmw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 05, 2019 at 08:32:03AM +0200, Ard Biesheuvel wrote:
>
> > AFAICS this is using the same key as the actual data.  So why
> > don't you combine it with the actual data when encrypting/decrypting?
> >
> > That is, add a block at the front of the actual data containing
> > the little-endian byte offset and then use an IV of zero.
> >
> 
> That would only work for encryption.

True.  So this doesn't obviate the need to access the single-block
cipher.  But the code probably should still do it that way for
encryption for performance reasons.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
