Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A626C282DA
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D201E2082A
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbfDIGho (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:37:44 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:48512 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfDIGho (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 02:37:44 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDkO6-0008M9-I1; Tue, 09 Apr 2019 14:37:42 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDkO6-0007jg-EK; Tue, 09 Apr 2019 14:37:42 +0800
Date:   Tue, 9 Apr 2019 14:37:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 04/18] crypto: skcipher - restore default
 skcipher_walk::iv on error
Message-ID: <20190409063742.pihvjcu3ied7u3fp@gondor.apana.org.au>
References: <20190331200428.26597-5-ebiggers@kernel.org>
 <20190408062354.nfxkxj333ocrs52z@gondor.apana.org.au>
 <20190408172736.GA9145@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408172736.GA9145@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 08, 2019 at 10:27:37AM -0700, Eric Biggers wrote:
>
> It's not just LRW though.  It's actually 7 places:
> 
> 	arch/arm/crypto/aes-neonbs-glue.c
> 	arch/arm/crypto/chacha-neon-glue.c
> 	arch/arm64/crypto/aes-neonbs-glue.c
> 	arch/arm64/crypto/chacha-neon-glue.c
> 	crypto/chacha-generic.c
> 	crypto/lrw.c
> 	crypto/salsa20-generic.c
> 
> Do you prefer that all those be updated?

We have to because if memory allocation fails then walk->iv will
just be the origial IV.  If you can use the original IV then you
might as well just do that.

I just checked chacha-generic and it is fine as it's using the
original IV and not walk->iv (the difference is that one may be
unaligned while the other is guaranteed to be aligned).

arm*/chacha-neon-glue.c are also correct.

salsa20 is indeed broken but the fix is trivial since it's already
using unaligned loads.

arm/aes-neonbs-glue seems easily fixed as it can simply use the
unaligned original IV since it's going through the crypto API
again.

arm64/aes-neonbs-glue I'm not quite sure as it's calling into
assembly so depending on whether that wants aligned/unaligned
this can either use the original IV or check for errors and
abort if necessary.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
