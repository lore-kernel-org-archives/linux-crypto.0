Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE5BAC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Dec 2021 23:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353811AbhLAXm3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Dec 2021 18:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343755AbhLAXm3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Dec 2021 18:42:29 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA0AC061748
        for <linux-crypto@vger.kernel.org>; Wed,  1 Dec 2021 15:39:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so1923883pjb.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Dec 2021 15:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UawCFas+5bZ9exexPy9lvfbEbmZL7VR3eGOrgATJsH8=;
        b=A8eNGOFu0vIOMaHT4l7C4EoIimLChbTvJpK/SjbKL+cGy7flSP2NYafcB63LvueIup
         71/cJtJUgSz+4eibG0/SOn2Xm1bVGwsersyiW63GCH1NxiMc5tlcHFN34TbR6YtloFcN
         USJwViJRknUN91ndNZl/fKfQRnFt7j8LvKk2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UawCFas+5bZ9exexPy9lvfbEbmZL7VR3eGOrgATJsH8=;
        b=RrjcuRbXtGrzPsTEf6dvYnHyWeqz4VLX/ptiq46fIW7aDXPNnhrZwc7B53lm0rpgPC
         sXhosAAC3IyX7B5feUPotKHQYjf1sYc5DVS0Hfdigqs7jcslzKHvufoZmwmyH4704vme
         FMyO61FHBXK3TxicW9kptD2vrPfzLCdDdF3Yz+HGOIBP9zR8GsvgLBuy7K+Coje4aUZx
         7eBcbK7f0uKkfWqwsn66tUIWBgjdzSNDaxGD4uvI8OkR8vg0fDH84xpv7uL7FhPCk6HW
         VrAJKLOhQ7+3drrju6lKyMx7jYfZGOLS8TcgU6kEVoG3XGTXA2yfTKrZW+Jw4zbCSVOd
         WeZg==
X-Gm-Message-State: AOAM5301dBjiNZmhpAsTYKANiTBvdbAxbLB3ugFLnVSo6AQlJLy/Sq8c
        Oibdpe/NxNl3T7O5DR7m8VOCQA==
X-Google-Smtp-Source: ABdhPJyxw1qs9NtdzCmDjuuVZNqmvVXK2zwTG8U0NkrN5jw/rru6EDAv7ww9fqfBoloYaFmt+iz8qQ==
X-Received: by 2002:a17:90b:4a0f:: with SMTP id kk15mr1639024pjb.223.1638401947451;
        Wed, 01 Dec 2021 15:39:07 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q17sm1024190pfu.117.2021.12.01.15.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 15:39:06 -0800 (PST)
Date:   Wed, 1 Dec 2021 15:39:06 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Haren Myneni <haren@us.ibm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/9] crypto: add zbufsize() interface
Message-ID: <202112011529.699092F@keescook>
References: <20180802215118.17752-1-keescook@chromium.org>
 <20180802215118.17752-2-keescook@chromium.org>
 <20180807094513.vstt5dhbb7n6kvds@gondor.apana.org.au>
 <CAGXu5j+dPqpJZbO_AuGsNqJzq7XGcB2deXA5RELWv1-Ywi5QOA@mail.gmail.com>
 <20180808025319.32d57wtjpyyapwo5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180808025319.32d57wtjpyyapwo5@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 08, 2018 at 10:53:19AM +0800, Herbert Xu wrote:
> On Tue, Aug 07, 2018 at 11:10:10AM -0700, Kees Cook wrote:
> >
> > > Please don't add new features to the old compress interface.  Any
> > > new improvements should be added to scomp/acomp only.  Users who
> > > need new features should be converted.
> > 
> > So, keep crypto_scomp_zbufsize() and drop crypto_comp_zbufsize() and
> > crypto_zbufsize()? Should I add crypto_acomp_zbufsize()?
> 
> Yes and yes.  acomp is the primary interface and should support
> all the features in scomp.

*thread necromancy*

Okay, I'm looking at this again because of the need in the module loader
to know "worst case decompression size"[1]. I am at a loss for how (or
why) the acomp interface is the "primary interface".

For modules, all that would be wanted is this, where the buffer size can
be allocated on demand:

u8 *decompressed = NULL;
size_t decompressed_size = 0;

decompressed = decompress(decompressed, compressed, compressed_size, &decompressed_size);

For pstore, the compressed_size is fixed and the decompression buffer
must be preallocated (for catching panic dumps), so the worst-case size
needs to be known in advance:

u8 *decompressed = NULL;
size_t decompressed_worst_size = 0;
size_t decompressed_size = 0;

worst_case(&decompressed_worst_size, compressed_size);

decompressed = kmalloc(decompressed_worst_size, GFP_KERNEL);
...
decompressed_size = decompressed_worst_size;
decompress(decompressed, compressed, compressed_size, &decompressed_size);


I don't see anything like this in the kernel for handling a simple
buffer-to-buffer decompression besides crypto_comp_decompress(). The
acomp interface is wildly over-complex for this. What the right
way to do this? (I can't find any documentation that discusses
compress/decompress[2].)

-Kees

[1] https://lore.kernel.org/linux-modules/YaMYJv539OEBz5B%2F@google.com/
[2] https://www.kernel.org/doc/html/latest/crypto/api-samples.html

-- 
Kees Cook
