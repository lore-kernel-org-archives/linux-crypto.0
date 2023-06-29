Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A20EB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jun 2023 03:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjF2Ds4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Jun 2023 23:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjF2Dsv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2023 23:48:51 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154492D7C
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 20:48:21 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-676f16e0bc4so165203b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 20:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688010500; x=1690602500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sl9cDs+dMZ1xPRPSdclW6Nu0fFDs2pGjl1gH1ncuWpU=;
        b=S3tEQGyhVNsWNlMiKokWkq9tSUkkHRwRK9tvImQlxLgyrkeFMLHXMWUp4ncvv36IF1
         oODr14JP7j4qASBPJTJ+OcFFtXTplk8wcupj04Jxys3Mlz4qT+GB+BLujgQQecAUBcwa
         XYHo/Gpg6pfH9eT72nDnrNvROfKligDEU1wyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688010500; x=1690602500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sl9cDs+dMZ1xPRPSdclW6Nu0fFDs2pGjl1gH1ncuWpU=;
        b=Z/CLgCn0S3w0GSGfkCHYP74ZtcSFvtzWT50H2VbpBx1qZ6OGaRd0mnGrphKsdSIjJs
         QqcXBrh5cjG7w3Xpst/TmQNk0baGc6n0rhtxS/2JjffY6Nx3ANBrNEqK+aBOmxP4jFBy
         RBxYsKATUSD/SKWyFi9amqT7j70RGj9ywdlqNAmg+Db0dRWQoRUFpr/UMj85zRSZw/HZ
         s/vs38Wg6hJ2UagExn8TbzZ49f5S4uODRFsOBwPtF36YMtS7waEzx3lCHb7lKioNdJ7H
         YzfqoSJ7eyZyOVL61e2Gnc1M6DLAlJscxIylL7iXbBd3d8kwvKl7wL870Xab5UPhoN+q
         WZkg==
X-Gm-Message-State: AC+VfDz+1/GEoP2RaWinkf7cWep0FOUs6nHV68F1ah3wjcvT4lSLmTIk
        RDnxA7lI+1K4vGqwxpXKo2HgxyU3SnYy9wID850=
X-Google-Smtp-Source: ACHHUZ5jmiEQVjJFz/DV5JdL3d/2zSGGMRBiVq3Ge1NiIwpgvh1yKPzoJf6FwnsVhLHmt/VEDNCA1g==
X-Received: by 2002:a05:6a20:96c6:b0:12c:a57:6e46 with SMTP id hq6-20020a056a2096c600b0012c0a576e46mr3403176pzc.18.1688010500519;
        Wed, 28 Jun 2023 20:48:20 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b001b558c37f91sm8243240plh.288.2023.06.28.20.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 20:48:19 -0700 (PDT)
Date:   Wed, 28 Jun 2023 20:48:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: Build error in crypto/marvell/cesa/cipher.c
Message-ID: <202306282038.C3A12326A@keescook>
References: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 28, 2023 at 08:13:25PM -0700, Linus Torvalds wrote:
> So I don't see anything that has changed, and I suspect the only
> change is that my compiler version changed, but my arm64 build fails
> right now with FORTIFY_STRING enabled.
> 
> On arm64 I now get this warning:
> 
>   In function 'fortify_memcpy_chk',
>     inlined from 'mv_cesa_des3_ede_setkey' and
> drivers/crypto/marvell/cesa/cipher.c:307:2:
>   ./include/linux/fortify-string.h:583:25: error: call to
> '__write_overflow_field' declared with attribute warning: detected
> write beyond size of field (1st parameter); maybe use struct_group()?
> [-Werror=attribute-warning[

This was fixed very recently here:
https://lore.kernel.org/all/20230523083313.899332-1-arnd@kernel.org/
and Herbert took it.

I assume the crypto tree hasn't been merged yet?

> Kees, any idea why I'm seeing it now? Is it the new
> -fstrict-flex-arrays=3? And if so, why? None of this is about flex
> arrays...

The unexpected bit is that without -fstrict-flex-arrays=3 (i.e. the
default since the dawn of time), the compiler treats any array that
happens to be the last struct member as a flexible array. So with it
enabled, FORTIFY_SOURCE gains coverage over things it should have been
examining before.

-- 
Kees Cook
