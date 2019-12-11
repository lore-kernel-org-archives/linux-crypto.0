Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A072C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 754A120838
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576034137;
	bh=LnRgNWrB9e3OtxsNvhc/9QxzPV1Cp5v3WSvOJ29i5FM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gC0wKVxi170OKUsP08o4r01fNdbadMKQuncZXSacMe7xrdjDkfkI3M6wVdk3wjtzy
	 Ob86kTT2VAZR1Vr7gJ9ikGdrYJ9FG+rG4lfx/kv16nJfXpfVbmFYXsKnRFAQ7i9nMq
	 7N+thDDTtCKAFMBU+bSNtWGiQUh3oQqFJCtYRo20=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLKDPg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 22:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbfLKDPg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 22:15:36 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29DE920836;
        Wed, 11 Dec 2019 03:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576034136;
        bh=LnRgNWrB9e3OtxsNvhc/9QxzPV1Cp5v3WSvOJ29i5FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7vmDrSZohZtYEEGwe55qbQodyBWSERTMPIvGRGh61oJpgMGq3bUzvsVvLVBZM+AJ
         0HX7aQDo33I1bcAyRQxSnJdYb3gcMNazbaDqqt30DMOUCucqcYmidk3V2CObXR39hD
         EjHJvaLOyKvjbWC+7Pi2hIln4vZg6FtmdAjn/KRo=
Date:   Tue, 10 Dec 2019 19:15:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: Re: [v5 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191211031534.GC732@sol.localdomain>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
 <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
 <20191205034301.GA1158@sol.localdomain>
 <20191205045545.qernhqet4dx3b47b@gondor.apana.org.au>
 <20191211022613.GA732@sol.localdomain>
 <20191211025010.advtedzhazvx52ij@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211025010.advtedzhazvx52ij@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 11, 2019 at 10:50:11AM +0800, Herbert Xu wrote:
> On Tue, Dec 10, 2019 at 06:26:13PM -0800, Eric Biggers wrote:
> >
> > Sorry, I didn't notice you had already sent another patch for this.  I think
> > this patch is okay, except that it's broken because it doesn't actually do
> > anything with the 'r' variable in crypto_alg_tested().  I suggest just removing
> 
> Oops.
> 
> > that variable and doing:
> > 
> > 		if (best && crypto_mod_get(alg))
> > 			larval->adult = alg;
> > 		else
> > 			larval->adult = ERR_PTR(-EAGAIN);
> 
> OK I have made this change.
> 
> > Also, it would be nice to also add a function comment for crypto_alg_tested(),
> > like I had in my original patch.  It's hard to understand this code.
> 
> Your original comments no longer apply but if you wish to make
> another patch to add more comments that would certainly be welcome.
> 
> Thanks,
> 
> ---8<---
> When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the first lookup of an
> algorithm that needs to be instantiated using a template will always get
> the generic implementation, even when an accelerated one is available.
> 
> This happens because the extra self-tests for the accelerated
> implementation allocate the generic implementation for comparison
> purposes, and then crypto_alg_tested() for the generic implementation
> "fulfills" the original request (i.e. sets crypto_larval::adult).
> 
> This patch fixes this by only fulfilling the original request if
> we are currently the best outstanding larval as judged by the
> priority.  If we're not the best then we will ask all waiters on
> that larval request to retry the lookup.
> 
> Note that this patch introduces a behaviour change when the module
> providing the new algorithm is unregistered during the process.
> Previously we would have failed with ENOENT, after the patch we
> will instead redo the lookup.
>  
> Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against...")
> Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against...")
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against...")
> Reported-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks good, thanks.

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
