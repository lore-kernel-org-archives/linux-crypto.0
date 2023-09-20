Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB02C04FE8
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 18:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjITSsy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 14:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjITSsx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 14:48:53 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C88C6
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 11:48:47 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-5033918c09eso288880e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 11:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695235725; x=1695840525; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X1hFrP0vWNBME7dDNcg/fEbps60Tl05diwzAP59+3sw=;
        b=AXQsgJaTWvfLszH1nhmige5zIrolkGN5tWGUxIw594N1LopPbLxoF0j0ViApTvCNuY
         keo4+edsKUcrkrlobuH2zC/yx6NOiZIyjZ3ACCvlz1LuWC5bdy1EhXcwv6t4xe9ZTD9p
         dliCbhUkn6qj8aV3SfMYY+lz3i3ajWTOPpXFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695235725; x=1695840525;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X1hFrP0vWNBME7dDNcg/fEbps60Tl05diwzAP59+3sw=;
        b=egy5u/Kpcl3XKjVmlOQnMYRICZb3JtSU+awtrx+mYA0qaq4o3/gLH59Ov5eB92kSoq
         HsOF3wIfAPTMQ/oxZcwz+3N2HVnnCJMwreh2eKTpOZ4xncRIFN09iKjmvZtVvUxzI0NZ
         31SClCqnWKAt5JO5F5Q85WVzFrPTKPeVxTjywxrSthdoe+x9ff3KSqZJJu9bW+gjVoeX
         XiqBTLTucVKMc4LHPyxPmkT9/0y4n1T/dnui/GwMasGFUNfg7TUVB8K+oK7dWhm8KNtq
         cED1g2t2XlW0fLJqwljrfY4m5zq91K+hAEr4ah/3VzsCci/ojY3Is1wKCNQYhi4L/FPM
         CZYQ==
X-Gm-Message-State: AOJu0YwiSEE4CHo/u/jcL3/fO+CMZwp5gQrOLHo4QkzOfoke0Jvp6YH4
        zXv7Z0hhxGzzOpuH15CJuaO4ukoU7EwCRZf7fJeVog==
X-Google-Smtp-Source: AGHT+IE+GsZW9a0WmXEfwl1kO/OMICI4nChXdV5umGwpZSoghgBYZQysxVSoVA1BTKPdxn329YfYJQ==
X-Received: by 2002:a05:6512:3b12:b0:503:3808:389a with SMTP id f18-20020a0565123b1200b005033808389amr3834620lfv.11.1695235725299;
        Wed, 20 Sep 2023 11:48:45 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id c11-20020a056512324b00b00503134e23b6sm1561654lfr.141.2023.09.20.11.48.44
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 11:48:44 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-502153ae36cso289835e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 11:48:44 -0700 (PDT)
X-Received: by 2002:a05:6512:b1c:b0:503:6b8:a84a with SMTP id
 w28-20020a0565120b1c00b0050306b8a84amr3636614lfu.54.1695235724132; Wed, 20
 Sep 2023 11:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230920060615.GA2739@sol.localdomain>
In-Reply-To: <20230920060615.GA2739@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 20 Sep 2023 11:48:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wja26UmHQCu48n_HN5t5w3fa6ocm5d_VrJe6-RhCU_x9A@mail.gmail.com>
Message-ID: <CAHk-=wja26UmHQCu48n_HN5t5w3fa6ocm5d_VrJe6-RhCU_x9A@mail.gmail.com>
Subject: Re: [RFC] Should writes to /dev/urandom immediately affect reads?
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 19 Sept 2023 at 23:06, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This would be the potential change, BTW:

Entirely regardless of your fundamental question, no, that's not the
potential change.

That causes a crng_reseed() even if the write fails completely and
returns -EFAULT.

So at a *minimum*, I'd expect the patch to be be something like

        memzero_explicit(block, sizeof(block));
-       return ret ? ret : -EFAULT;
+       if (!ret)
+               return -EFAULT;
+       crng_reseed(NULL);
+       return ret;

but even then I'd ask

 - wouldn't we want some kind of minimum check?

 - do we really trust writes to add any actual entropy at all and at what point?

which are admittedly likely the same question just in different guises.

Also, are there any relevant architectures where
"try_to_generate_entropy()" doesn't work? IOW, why do you even care?

                Linus
