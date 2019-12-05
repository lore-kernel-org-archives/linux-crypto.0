Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C99C43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 03:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4C5821835
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 03:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575517384;
	bh=xHk28tHwYhEb4U6c7CM8t/KzOiI44LWUsDvxC+Y8E2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MNBJ713pSRvDwJJ5rLFF4mp48YnPLC2I8/AfPYoIVg6peN6krzC44AeMp6LFm1A7W
	 1Yqyf3UTWt0+eMLRW8ROunF/DnsRnsXXM8V4oYNUyS4RCeYkAsa7vaMrcIeA6vpoTz
	 4pmW5XcV2xfxFNKEZIRLuF9oMbmQJxZZwll5svK8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfLEDnE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 22:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbfLEDnE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 22:43:04 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A77B206DB;
        Thu,  5 Dec 2019 03:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575517383;
        bh=xHk28tHwYhEb4U6c7CM8t/KzOiI44LWUsDvxC+Y8E2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XdB1HO4TrbYWSyENtlkJ1qKBcoR+k4yQtWRv/wuHy5aqqYgyUtbArNGu8+2g3qibq
         ZZD9yWZmbrawrrkRNuYEmDH9A3jfekvnGKdHsrj5MgQIuMi5cNuvV2w9djqHaCDV9U
         TFgACnsipGKEJ5uml4QBRW8m+cajjGkp0Ybg0sZY=
Date:   Wed, 4 Dec 2019 19:43:01 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: Re: [v3 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191205034301.GA1158@sol.localdomain>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
 <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 05, 2019 at 09:58:11AM +0800, Herbert Xu wrote:
> On Wed, Dec 04, 2019 at 09:22:44AM -0800, Eric Biggers wrote:
> >
> > I was going to do something like this originally (but also checking that 'q' is
> > not "moribund", is a test larval, and has compatible cra_flags).  But I don't
> 
> You are right.  I'll add these tests to the patch.
> 
> > think it will work because a higher priority implementation could be registered
> > while a lower priority one is being instantiated and tested.  Based on this
> > logic, when the lower priority implementation finishes being tested,
> > larval->adult wouldn't be set since a higher priority implementation is still
> > being tested.  But then cryptomgr_probe() will complete() the larval anyway and
> > for the user crypto_alloc_foo() will fail with ENOENT.
> 
> I think this is a different problem, one which we probably should
> address but it already exists regardless of what we do here.  For
> example, assuming that tmpl(X) does not currently exist, and I
> request tmpl(X-generic) then tmpl(X-generic) along with X-generic
> will be created in the system.  If someone then comes along and
> asks for tmpl(X) then we'll simply give them tmpl(X-generic) even
> if there exists an accelerated version of X.
> 
> The problem you describe is simply a racy version of the above
> scenario where the requests for tmpl(X) and tmpl(X-generic) occur
> about the same time.
> 

No, the problem I'm talking about is different and is new to your patch.  If
tmpl(X-accelerated) is registered while someone is doing crypto_alg_mod_lookup()
that triggered instantiation of tmpl(X-generic), then crypto_alg_mod_lookup()
could fail with ENOENT, instead of returning tmpl(X-generic) as it does
currently.  This is because the proposed new logic will not fulfill the request
larval if a better implementation of tmpl(X) is still being tested.  But there's
no guarantee that tmpl(X) will finish being tested by the time cryptomgr_probe()
thinks it is done and complete()s the request larval with 'adult' still NULL.

(I think; I haven't actually tested this, this analysis is just based on my
reading of the code...)

- Eric
