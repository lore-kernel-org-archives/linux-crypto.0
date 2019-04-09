Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3E7C10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D32920883
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfDIGYN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:24:13 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:48448 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfDIGYN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 02:24:13 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDkB1-0008Bt-SU; Tue, 09 Apr 2019 14:24:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDkAz-0007hz-Px; Tue, 09 Apr 2019 14:24:09 +0800
Date:   Tue, 9 Apr 2019 14:24:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 18/18] crypto: run initcalls for generic
 implementations earlier
Message-ID: <20190409062409.gs5a6o2kuxeuztt2@gondor.apana.org.au>
References: <20190331200428.26597-19-ebiggers@kernel.org>
 <20190408055322.kke6emtixhhbkppn@gondor.apana.org.au>
 <20190408174402.GB9145@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408174402.GB9145@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 08, 2019 at 10:44:02AM -0700, Eric Biggers wrote:
> 
> My patch also moved cryptomgr earlier in the Makefile, so it's linked first.  Do
> you think that's too fragile?  Otherwise, I'll probably change cryptomgr_init()
> to arch_initcall().

I don't think we should rely on link-time ordering to fulfil
this as it will just fail silently when it breaks.

> BTW, I found another problem caused by allocating the generic implementation
> during the self-tests, which is that the generic implementation will fulfill any
> outstanding allocation requests before the other implementation has finished
> testing.  E.g. on x86_64, the first call to
> 
> 	crypto_alloc_skcipher("adiantum(xchacha12,aes)", 0, 0)
> 
> will get "adiantum(xchacha12-generic,aes-generic,nhpoly1305-generic)" rather
> than "adiantum(xchacha12-simd,aes-aesni,nhpoly1305-avx2)" as expected.  Do you
> have any suggestion on the best way to fix this?

Well this is to be expected.  Normally we don't start the allocation
until all probing is done.  That is, all modules should have been
loaded before (or rather during) the first allocation call.  If it
occurs during the first allocation call then a larval algorithm will
hold any subsequent allocations until the testing is done.

So the question is who is doing the allocation prior the registration
of the accelerated algorithms? Is it the fuzzing test?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
