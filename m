Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85973EB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jun 2023 14:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjF2Ogo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjF2Ogi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2023 10:36:38 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6CD35B8
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jun 2023 07:36:36 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-76243a787a7so72931185a.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jun 2023 07:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1688049395; x=1690641395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l0Z9EHkxsMojDfIG/k9qkoelknrnfRSmn3Ow7k1MaPE=;
        b=F4poY21W6hcqbJLOEbHh3sabaLWv2chcW5xmlM/K7y2TWq2gKHYRY+RdZ/sNbNZyHw
         tzqwWBc8ALyXT2kvmdfjTL0lSOVsKiv1hWHvUoVhRxijNn+butlhHTQgbCj1FdggqzPX
         TJUrCwxjZFHAhvVwkeQuOpixpv1TBCaNxLF+yNoFiN1GHWTZlSLVZpgLwZZCsj7bM3dh
         xh+2dzh26Ccndaz5JTaXUAf/KG1uQ0QMHC9+EpbqLBkz5GUEZ5jesAptDyrbUAW+8oad
         UhRQBYxlr2bMxFzJTqJEIxiB1F14+lwuZIkD54opB4i0UONspS39p3gC3ipjzyfbRhkI
         ihqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688049395; x=1690641395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0Z9EHkxsMojDfIG/k9qkoelknrnfRSmn3Ow7k1MaPE=;
        b=SNeCdDXufrmozZl6pT2ZPpckFonGgISgk5ysErMnm7Lg7TjbCy4705iLNYY9DVBkDe
         v0hbNS+zuYF7B9MR1s4dSQWbTyj8RcsgLdrVclZCSd48FCaClPX0u/GOkpyAVY7aShBL
         MBDEkkNIPW5I4Lg/a2f8oagaEiuL8e8SUHkpk8tRav+MYc1Q0Z9AfyqDnpSWUx5Lzvar
         dfxOVFYZ+TNAxw3mKsJxjZgTq8EnwgtUcUROr/sdgY4Md40dDAQ1wK4TQMI5Gl6kbLa9
         sEZniQPJbRg0HYeBNgcm24K7Fvn8f4EhqSZZWXexDeRS/CEfRCRqj+HyZUQo4xQ4pQSy
         x6Pw==
X-Gm-Message-State: AC+VfDz7A56JpZIdRvdyCNx6Qi9u84XF+cn7daZTVrx+ImSOiWHkTQOV
        A/g5TZL7n/eRn7PPS7N920gieg==
X-Google-Smtp-Source: ACHHUZ5pB2c69T7VmW1zJ57G8s1Pb6Y3ihqEO07bMaoudhMGPexaLnS1zfBqc1+w7Qy5+JKyeVfOFg==
X-Received: by 2002:a05:620a:44d0:b0:765:5441:3193 with SMTP id y16-20020a05620a44d000b0076554413193mr27610256qkp.6.1688049395369;
        Thu, 29 Jun 2023 07:36:35 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id a4-20020a05620a124400b0075aff6f835bsm6312732qkl.19.2023.06.29.07.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 07:36:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qEsl8-009s8J-82;
        Thu, 29 Jun 2023 11:36:34 -0300
Date:   Thu, 29 Jun 2023 11:36:34 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: Build error in crypto/marvell/cesa/cipher.c
Message-ID: <ZJ2W8vQjljJej1tw@ziepe.ca>
References: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 28, 2023 at 08:13:25PM -0700, Linus Torvalds wrote:

> I get a similar error in 'irdma_clr_wqes()' at
> drivers/infiniband/hw/irdma/uk.c:103 (and same thing on line 105). I
> don't see what the right solution there is, but it looks like we have
> 
>         IRDMA_CQP_WQE_SIZE = 8
>         __le64 elem[IRDMA_CQP_WQE_SIZE];
> 
> and it's doing a 4kB memset to that element. The mistake is not as
> obvious as in the cesa driver.

I think this fix is in the RDMA PR i just sent you:

commit b002760f877c0d91ecd3c78565b52f4bbac379dd
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue May 23 13:18:45 2023 +0200

    RDMA/irdma: avoid fortify-string warning in irdma_clr_wqes
    
    Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") triggers a
    warning for fortified memset():
    
    In function 'fortify_memset_chk',
        inlined from 'irdma_clr_wqes' at drivers/infiniband/hw/irdma/uk.c:103:4:
    include/linux/fortify-string.h:493:25: error: call to '__write_overflow_field' declared with attribute warning: detected write b>
      493 |                         __write_overflow_field(p_size_field, size);
          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    The problem here isthat the inner array only has four 8-byte elements, so
    clearing 4096 bytes overflows that. As this structure is part of an outer
    array, change the code to pass a pointer to the irdma_qp_quanta instead,
    and change the size argument for readability, matching the comment above
    it.
    
    Fixes: 551c46edc769 ("RDMA/irdma: Add user/kernel shared libraries")
    Link: https://lore.kernel.org/r/20230523111859.2197825-1-arnd@kernel.org
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
    Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
