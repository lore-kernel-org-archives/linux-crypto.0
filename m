Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8744BC433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Dec 2021 03:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhLBDyt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbhLBDys (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Dec 2021 22:54:48 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9A0C061748
        for <linux-crypto@vger.kernel.org>; Wed,  1 Dec 2021 19:51:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id o14so19293120plg.5
        for <linux-crypto@vger.kernel.org>; Wed, 01 Dec 2021 19:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6dRMcrqaLSVZWLWxgZvZUiIkmkSi//hdjaprS6i9c/k=;
        b=Iw6Z9G703+8Oacfc/+IMYQbcIwOyswn5g8sXDOXzDZtON7qh5uAAiI1RuRpE00j7QX
         PW/LzuLD64epIXzcGXCofioNdiDkpVUX8ymodyrHEif9vKSHIZTJP9MJVm81wU/vZBUF
         /4abdNmBp/jgXFd+yD3kjZyWHgXCIg0Xqh1lE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6dRMcrqaLSVZWLWxgZvZUiIkmkSi//hdjaprS6i9c/k=;
        b=kbu9OWaALYmDTZYipLQEnKEmsE2ivnziXst9xrP/vgu12Us3T2MQRcWFXD/W1uaARu
         k3ox+EoAd2Rfnwsu8tUrzy4/ACxw92JfJrMuAm2zrgdyWyH2zsiz0+ZGA3YTSoLVcQsr
         WBhVzUo+KWW5cq9AJk46yDCvA64QBkDtExBO9BDSnmyzBJqbZiKf8PnJmo0BEXsX/qX4
         Nl3N2+H+mw+7l9hfGaUhJp3PgRrK4+A7hvPjk24xWFYflciZxyFSRy2yNZDPk/IaKSKT
         JuA9hIpH9PH1+T0nzt12/4gFPA5rx8Q0gnT2JuLDx3NmC29qelxHPsdcV65RiD9HA7Ma
         0ckA==
X-Gm-Message-State: AOAM532IVZs119nHOa+imMCsdG8WnCrRVdvgjCKbey8rJSRZjpwTMdp+
        rAslqeIwdq/ts5ziTw3Iv+gorw==
X-Google-Smtp-Source: ABdhPJwS+XGcbakLCT12C7UGQbun44XSxZpZFdjTrU+G1v2azU2aW/NcFHzM7MDllaF2F2nej60j7Q==
X-Received: by 2002:a17:90b:33d0:: with SMTP id lk16mr3136783pjb.20.1638417086417;
        Wed, 01 Dec 2021 19:51:26 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s19sm1303687pfu.137.2021.12.01.19.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:51:25 -0800 (PST)
Date:   Wed, 1 Dec 2021 19:51:25 -0800
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
Message-ID: <202112011947.7FA0A587C@keescook>
References: <20180802215118.17752-1-keescook@chromium.org>
 <20180802215118.17752-2-keescook@chromium.org>
 <20180807094513.vstt5dhbb7n6kvds@gondor.apana.org.au>
 <CAGXu5j+dPqpJZbO_AuGsNqJzq7XGcB2deXA5RELWv1-Ywi5QOA@mail.gmail.com>
 <20180808025319.32d57wtjpyyapwo5@gondor.apana.org.au>
 <202112011529.699092F@keescook>
 <20211202015820.GB8138@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202015820.GB8138@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 02, 2021 at 12:58:20PM +1100, Herbert Xu wrote:
> On Wed, Dec 01, 2021 at 03:39:06PM -0800, Kees Cook wrote:
> >
> > Okay, I'm looking at this again because of the need in the module loader
> > to know "worst case decompression size"[1]. I am at a loss for how (or
> > why) the acomp interface is the "primary interface".
> 
> This is similar to how we transitioned from the old hash interface
> to shash/ahash.
> 
> Basically the legacy interface is synchronous only and cannot support
> hardware devices without having the CPU spinning while waiting for the
> result to come back.
> 
> If you only care about synchronous support and don't need to access
> these hardware devices then you should use the new scomp interface
> that's equivalent to the old compress interface but built in a way
> to allow acomp users to easily access sync algorithms, but if you
> are processing large amounts of data and wish to access offload devices
> then you should consider using the async acomp interface.

But the scomp API appears to be "internal only":

include/crypto/internal/scompress.h:static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,

What's the correct API calling sequence to do a simple decompress?

> > For modules, all that would be wanted is this, where the buffer size can
> > be allocated on demand:
> > 
> > u8 *decompressed = NULL;
> > size_t decompressed_size = 0;
> > 
> > decompressed = decompress(decompressed, compressed, compressed_size, &decompressed_size);
> > 
> > For pstore, the compressed_size is fixed and the decompression buffer
> > must be preallocated (for catching panic dumps), so the worst-case size
> > needs to be known in advance:
> > 
> > u8 *decompressed = NULL;
> > size_t decompressed_worst_size = 0;
> > size_t decompressed_size = 0;
> > 
> > worst_case(&decompressed_worst_size, compressed_size);
> > 
> > decompressed = kmalloc(decompressed_worst_size, GFP_KERNEL);
> > ...
> > decompressed_size = decompressed_worst_size;
> > decompress(decompressed, compressed, compressed_size, &decompressed_size);
> > 
> > 
> > I don't see anything like this in the kernel for handling a simple
> > buffer-to-buffer decompression besides crypto_comp_decompress(). The
> > acomp interface is wildly over-complex for this. What the right
> > way to do this? (I can't find any documentation that discusses
> > compress/decompress[2].)
> 
> I think you're asking about a different issue, which is that we
> don't have an interface for on-the-go allocation of decompressed
> results so every user has to allocate the maximum worst-case buffer.
> 
> This is definitely an area that should be addressed but a lot of work
> needs to be done to get there.  Essentially we'd need to convert
> the underlying algorithms to a model where they decompress into a
> list of pages and then they could simply allocate a new page if they
> need extra space.
> 
> The result can then be returned to the original caller as an SG list.
> 
> Would you be willing to work on something like this? This would benefit
> all existing users too.  For example, IPsec would no longer need to
> allocate those 64K buffers for IPcomp.
> 
> Unfortunately not many people care deeply about compression so
> volunteers are hard to find.

Dmitry has, I think, a bit of this already in [1] that could maybe be
generalized if it'd needed?

pstore still needs the "worst case" API to do a preallocation, though.

Anyway, if I could have an example of how to use scomp in pstore, I
could better see where to wire up the proposed zbufsize API...

Thanks!

[1] https://lore.kernel.org/linux-modules/YaMYJv539OEBz5B%2F@google.com/#Z31kernel:module_decompress.c

-- 
Kees Cook
