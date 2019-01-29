Return-Path: <SRS0=zJfq=QF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E38C169C4
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 13:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61CF720880
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 13:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="F9Q4+/+Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbfA2NPf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Jan 2019 08:15:35 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:51705 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbfA2NPf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Jan 2019 08:15:35 -0500
Received: by mail-it1-f196.google.com with SMTP id w18so4411165ite.1
        for <linux-crypto@vger.kernel.org>; Tue, 29 Jan 2019 05:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uAyW2nZnw+/miFxBHbz4nNJJDn0f6yfiB/jBJhvzg60=;
        b=F9Q4+/+Z5KVRwyT1x7LcRbDXuPYMRoel5+qrY7wB+PnEcmngiqPJ4S5HVaMjwTp1WD
         gFgoVlz+crhYLr/r09g3RnxiBgrTKub8Q4TF2DaIIHXzoHQt812CihjOfhVloGfBDZVe
         i5RjGvF1Ge2ip4Yj1661lc0usLXKq+DToRqdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uAyW2nZnw+/miFxBHbz4nNJJDn0f6yfiB/jBJhvzg60=;
        b=Q922Q3PgHPog0W++/mmz/9Zc7y4F/52EzzGUE1z2bqeMXOTUAwxmORDKgefd/wlw0q
         A23fHfq46KPNSYxZT/KUfYhDHoW94kHX9rlMoEE/f2s4yUe4Ky3Gv5S5eKcFQj/Of0fH
         QtevfnQH9wN3NsOXLV6CWZkj6KbGoXNFD7HtYnpnXbySs1PvnxD/KbpWpIns2PmwyltE
         GGDqgFwYEaMOFxtJuccsjZpzEl22BA0Q+aFL87Zj6h9JaR3ptgS2CXUKYVktJwhrD6Ss
         hRIGHHiySb9+Gp5AkK2MbEMwl7kFcaZVgipnxMCqIexRCVvCcrzpIRjic2blZdBoqWxj
         a55A==
X-Gm-Message-State: AJcUuke7B2tEUyCmA/hSfyKbAyQ4jPT44J5h99GktAyQQDdffh2zY7jo
        0Qr5iciVS0NVBsOT5mXnKmUUCC0R+CXmkCNczlTmlH5YPR0oFg==
X-Google-Smtp-Source: ALg8bN69/7MxgaM8DjIabGxryNw9/JBqa/GNrhz+TradELTVI5+Uy8F5gbHQxJaMuHVZlrI+TTpz9Lu3N4MW5kr/tWE=
X-Received: by 2002:a05:660c:4b:: with SMTP id p11mr13440259itk.71.1548767734506;
 Tue, 29 Jan 2019 05:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20190129080029.22261-1-ebiggers@kernel.org>
In-Reply-To: <20190129080029.22261-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 29 Jan 2019 14:15:23 +0100
Message-ID: <CAKv+Gu_8cg_bdxPqvSh8yzdNooNtnMc_CWe_UdCtZ2jTiB4aDw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] crypto: crct10dif assembly cleanup and optimizations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 29 Jan 2019 at 09:01, Eric Biggers <ebiggers@kernel.org> wrote:
>
> The x86, arm, and arm64 asm implementations of crct10dif are very
> difficult to understand partly because many of the comments, labels, and
> macros are named incorrectly: the lengths mentioned are usually off by a
> factor of two from the actual code.  Many other things are unnecessarily
> convoluted as well, e.g. there are many more fold constants than
> actually needed and some aren't fully reduced.
>
> This series therefore cleans up all these implementations to be much
> more maintainable.  I also made some small optimizations where I saw
> opportunities, resulting in slightly better performance.
>
> This is based on top of the pending patches from Ard Biesheuvel.

As for v1:

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

>
> These all pass the new extra self-tests.
>
> Changed since v1:
> - Moved constants in arm implementation to .rodata.

One nit: the __adr macro is a bit pointless for v7/v8 ARM code, since
it will always resolve to e movw/movt pair, but it doesn't harm
either.

> - Eliminated a few instructions from the x86 implementation.
> - Tweaked a few comments.
>
> Eric Biggers (3):
>   crypto: x86/crct10dif-pcl - cleanup and optimizations
>   crypto: arm/crct10dif-ce - cleanup and optimizations
>   crypto: arm64/crct10dif-ce - cleanup and optimizations
>
>  arch/arm/crypto/crct10dif-ce-core.S     | 554 ++++++++--------
>  arch/arm/crypto/crct10dif-ce-glue.c     |   2 +-
>  arch/arm64/crypto/crct10dif-ce-core.S   | 496 +++++++-------
>  arch/arm64/crypto/crct10dif-ce-glue.c   |   4 +-
>  arch/x86/crypto/crct10dif-pcl-asm_64.S  | 844 +++++++++---------------
>  arch/x86/crypto/crct10dif-pclmul_glue.c |   3 +-
>  6 files changed, 797 insertions(+), 1106 deletions(-)
>
> --
> 2.20.1
>
