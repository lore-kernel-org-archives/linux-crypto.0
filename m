Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD47C43217
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Nov 2022 22:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiKPWnj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiKPWn2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2022 17:43:28 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198556BDD6
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 14:43:15 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b11so14374pjp.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2022 14:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wf2gFJO0eZI55pjXm8OYjMYkGLte7QuRao7+IuvSaqE=;
        b=D2amVl9V9KQfzLW2zaIS23IBouuPji7hB+OAx+ZhW9BBCDB5OKBikMdNxb0VPTDxJj
         csClJ0YRCWBC/mBx5CM8cmRfxBeg4UGIi36VQSyP9C8PzSygpHTtXYMcx806fNdiiKsi
         DAssScFkYAwJ1pFNUcIn3ZWqN1hBHz6LpWnys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wf2gFJO0eZI55pjXm8OYjMYkGLte7QuRao7+IuvSaqE=;
        b=7vGzCZS7c2EMPWx8NprOLgvlfg9hAfpx2GlOlAcJ3op+TFrKYmOxFfTs2DQQ9Go7S5
         Yv2VARKHEw5heRti3s3VKyXpY094/eL33/xjpcg9YU57d11lYqhhSqw9UaxawbLe9pq6
         oq1NSCL2MlYLvXiIIA2cWxXSdJ9Pb17+q3n+xNHxLzZq04yryWN/6rcf4l+s/OGoYGFC
         L3qGKM591TxRsmpgAGcoJhmYRDMKwPlwM8vwQL3OnU8BlWGx5iiM3/wJKFRrDI1xhce4
         9ZSCK5ZscxdS/ZnSt5AIFNxbclPLIHPP6r9qHG0fktZTboaXs6wrl29QDJl5Bts5FyMX
         oPEw==
X-Gm-Message-State: ANoB5pl65hSx8g/4P2vi8LMWYU750QUodPXcurbxFaj28QYHWBsrQF3/
        hrVw9KFG38ubP5bv1tuf9fKPIg==
X-Google-Smtp-Source: AA0mqf5VxV4Cbn3MvfOzCKh9TKzLZskissYVmNmiO/kVOhEqnlwi5i8J4bomSjPXRjnnkIIEn4wz5w==
X-Received: by 2002:a17:90b:3c42:b0:213:1ce7:d962 with SMTP id pm2-20020a17090b3c4200b002131ce7d962mr6007688pjb.63.1668638594628;
        Wed, 16 Nov 2022 14:43:14 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902710900b00183c6784704sm12680746pll.291.2022.11.16.14.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:43:14 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:43:13 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Message-ID: <202211161436.A45AD719A@keescook>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221114164558.1180362-4-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114164558.1180362-4-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 14, 2022 at 05:45:58PM +0100, Jason A. Donenfeld wrote:
> -				(get_random_u32_below(1024) + 1) * PAGE_SIZE;
> +				get_random_u32_between(1, 1024 + 1) * PAGE_SIZE;

I really don't like "between". Can't this be named "inclusive" (and
avoid adding 1 everywhere, which seems ugly), or at least named
something less ambiguous?

> -		n = get_random_u32_below(100) + 1;
> +		n = get_random_u32_between(1, 101);

Because I find this much less readable. "Below 100" is clear: 0-99
inclusive, plus 1, so 1-100 inclusive. "Between 1 and 101" is not obvious
to me to mean: 1-100 inclusive.

These seem so much nicer:
	get_random_u32_inclusive(1, 1024)
	get_random_u32_inclusive(1, 100)

-- 
Kees Cook
