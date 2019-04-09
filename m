Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7E0C10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 18:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87B092133D
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554833773;
	bh=q1GH865rjht60RquOpvj6oNRViyP48EwO5zhIz8OLQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=m9C8DqWCavkyOE5w0qb6T1R5hsiN0DybDNUShaHj7EeCAjo99DSGopUO9QItVEBdG
	 RPuLBAj/ukL+FUnH1uWKDOH1d3X6inzBNWXOo8fAo9n36BwzEwPMHIam0+eSU024da
	 D8g6B/qkyS4C7IMfKCbidLE2laKhiVj88SIoMis4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfDISQM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 14:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfDISQM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 14:16:12 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CAEE20857;
        Tue,  9 Apr 2019 18:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554833771;
        bh=q1GH865rjht60RquOpvj6oNRViyP48EwO5zhIz8OLQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJ9PVBRebbkSC23e+nw1nbc2T+St3XmtQiEsVYiYGRnhZfUj/CYFihCAHPSjRVeDr
         T3/Jln7Tc8Q8kcyMI0OfKZH55xNwuoh5r1YPH5mFHaAxR0SiALu9azmxG/aFlmkDLl
         jF0WweWq9xyLoH+aPrLhliY+PTR4Eh5tDJGvVRNw=
Date:   Tue, 9 Apr 2019 11:16:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 18/18] crypto: run initcalls for generic
 implementations earlier
Message-ID: <20190409181608.GA122471@gmail.com>
References: <20190331200428.26597-19-ebiggers@kernel.org>
 <20190408055322.kke6emtixhhbkppn@gondor.apana.org.au>
 <20190408174402.GB9145@gmail.com>
 <20190409062409.gs5a6o2kuxeuztt2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409062409.gs5a6o2kuxeuztt2@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Tue, Apr 09, 2019 at 02:24:09PM +0800, Herbert Xu wrote:
> 
> > BTW, I found another problem caused by allocating the generic implementation
> > during the self-tests, which is that the generic implementation will fulfill any
> > outstanding allocation requests before the other implementation has finished
> > testing.  E.g. on x86_64, the first call to
> > 
> > 	crypto_alloc_skcipher("adiantum(xchacha12,aes)", 0, 0)
> > 
> > will get "adiantum(xchacha12-generic,aes-generic,nhpoly1305-generic)" rather
> > than "adiantum(xchacha12-simd,aes-aesni,nhpoly1305-avx2)" as expected.  Do you
> > have any suggestion on the best way to fix this?
> 
> Well this is to be expected.  Normally we don't start the allocation
> until all probing is done.  That is, all modules should have been
> loaded before (or rather during) the first allocation call.  If it
> occurs during the first allocation call then a larval algorithm will
> hold any subsequent allocations until the testing is done.
> 
> So the question is who is doing the allocation prior the registration
> of the accelerated algorithms? Is it the fuzzing test?
> 

All modules are already loaded, but there's no "adiantum(xchacha12,aes)"
algorithm directly available so it has be instantiated using the template.

Then with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the self-tests for the
accelerated instance will allocate a generic instance to compare it against.
This causes the generic instance to be tested and registered first, so the first
user will get the generic instance, not the accelerated one as expected.

- Eric
