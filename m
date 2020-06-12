Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98EBC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 16:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BA720835
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591978270;
	bh=mlvA3fRFJd1ofgemn9Cg88XKNtreb2StpEMQQYwXytU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Tm4mQHiJtUP9CeDrB08zAxoi6V6biyMyHxtYdSfO0WSECh/jvVsRyovhfscSZSgHD
	 5UwmPmwMw5HTmHdCEyvLCtcv1dfCpqQQDKccRYUlgPtW3SLC98BZ2JEw0BpTwFpEbG
	 AzkUKp9LXZ19MG2K/qTi15V7wjzbKHvLmx2mqJ4I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgFLQLK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 12:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgFLQLJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 12:11:09 -0400
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4436F20836
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2020 16:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591978269;
        bh=mlvA3fRFJd1ofgemn9Cg88XKNtreb2StpEMQQYwXytU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k7OjDO7VRvdqiphYLCJxzfELRv+yzdvCVHRMAgw6/yOFeKv6AdBwn7EZjkSxfgDkq
         A+r8W3X5PHIWbRtLsbsUNBrVIJotfyXBuKt6FymLxv92wdnVU78c9Uxht39Pkry0uN
         ZV2qLr+uGa1YxtGCQqhzvJ/4LZJ2NmijOw6qOlPo=
Received: by mail-oo1-f49.google.com with SMTP id e12so2039277oou.2
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2020 09:11:09 -0700 (PDT)
X-Gm-Message-State: AOAM531ONlT+hRnsfmhg8jPXgDfKajclUPBcfyWAEgz1ZwBJgrp8Zg5g
        qpUBIJzd0OhG7YmjDZ2O6TC3WZXZSzLhr+WsshA=
X-Google-Smtp-Source: ABdhPJxJLfbwZr+B2+AS1vnlt7Q1BxZjKGSKYx5sowtHPifpG0qEJI2KU9nKUIyFCZVtoZ9kX9vr7MuoiQ4uBLLl2/I=
X-Received: by 2002:a4a:896e:: with SMTP id g43mr11356276ooi.13.1591978268570;
 Fri, 12 Jun 2020 09:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200612120643.GA15724@gondor.apana.org.au> <E1jjiTA-0005BO-9n@fornost.hmeau.com>
 <1688262.LSb4nGpegl@tauon.chronox.de> <20200612121651.GA15849@gondor.apana.org.au>
 <20200612122105.GA18892@gondor.apana.org.au>
In-Reply-To: <20200612122105.GA18892@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 12 Jun 2020 18:10:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
Message-ID: <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
Subject: Re: [v2 PATCH 0/3] crypto: skcipher - Add support for no chaining and
 partial chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 12 Jun 2020 at 14:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> v2
>
> Fixed return type of crypto_skcipher_fcsize.
>
> --
>
> This patch-set adds support to the Crypto API and algif_skcipher
> for algorithms that cannot be chained, as well as ones that can
> be chained if you withhold a certain number of blocks at the end.
>
> It only modifies one algorithm to utilise this, namely cts-generic.
> Changing others should be fairly straightforward.  In particular,
> we should mark all the ones that don't support chaining (e.g., most
> stream ciphers).
>

I understand that there is an oversight here that we need to address,
but I am not crazy about this approach, tbh.

First of all, the default fcsize for all existing XTS implementations
should be -1 as well, given that chaining is currently not supported
at all at the sckipher interface layer for any of them (due to the
fact that the IV gets encrypted with a different key at the start of
the operation). This also means it is going to be rather tricky to
implement for h/w accelerated XTS implementations, and it seems to me
that the only way to deal with this is to decrypt the IV in software
before chaining the next operation, which is rather horrid and needs
to be implemented by all of them.

Given that

a) this is wholly an AF_ALG issue, as there are no in-kernel users
currently suffering from this afaik,
b) using AF_ALG to get access to software implementations is rather
pointless in general, given that userspace can simply issue the same
instructions directly
c) fixing all XTS and CTS implementation on all arches and all
accelerators is not a small task

wouldn't it be better to special case XTS and CBC-CTS in
algif_skcipher instead, rather than polluting the skipcher API this
way?
