Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9E7C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 06:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACAD661A36
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 06:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhCZGC7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 02:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhCZGCv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 02:02:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B243C0613AA
        for <linux-crypto@vger.kernel.org>; Thu, 25 Mar 2021 23:02:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id l76so3890110pga.6
        for <linux-crypto@vger.kernel.org>; Thu, 25 Mar 2021 23:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Hs9OgF31bMON2rPAD0tIeR6wNV10U38bJiGXIHf5UOw=;
        b=OIUEqK7S1YRl3jUepx5bdUjpwjMzjf1s9/+ifSprr+jrcdJknDJ9DcFvV7/lqoD7vy
         454f8j+EdYyEUe4+8vtnY90vxaz+y44BjNZZ+KxIwikxHnpYodTCmjrkOTR9qs5B8xgL
         zqePz9LzrIFdmsCx0V6Um+qv0rLC7209kDvNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Hs9OgF31bMON2rPAD0tIeR6wNV10U38bJiGXIHf5UOw=;
        b=feAdF17nlE3+sjPFWqxIDvM3Ow5jGa9Id1tG77++wbZhgIuNG5viHNPGfDGm/m03Pz
         A2zY6KqI/a/iBuhkwT+LkUD5ZycmiyOPeKGMD+LJvVL6r0HvkKxxjrEPUQzL1X91MDiB
         URgvWy0Yd7K1APILi/+83bb8HbkoAKXCS0TiYirAATkeOuoOxJdK1FtUQSRw3VXR/N+k
         +LCXEr/1pnyJfWo1jEaIED/K9b4hwwS955IKKpVSj478eQiXlVSmXBbKv1ODBi/rXaA9
         Gx/PxKqTTc7qd1uAuR2Haf2uOmJ0Lm94S58wfmnRDKE06l++mh55yVTlAOE7mzKIO7fT
         Hfww==
X-Gm-Message-State: AOAM530MwZYPXNPretXK9qq301HgVhprgsgcRDyrrHSiBi1pKzlFZHeC
        kY8pmk5J1ijP7MRWxtco60vCsA==
X-Google-Smtp-Source: ABdhPJyb9vEQTn14Ygn7ph6wsyHte+vZpEhCWA7YO0ZLL4Ybk2CFwm5mHZTO4rXc61h8McUbl0WXPw==
X-Received: by 2002:a63:1303:: with SMTP id i3mr10528838pgl.32.1616738570584;
        Thu, 25 Mar 2021 23:02:50 -0700 (PDT)
Received: from localhost (2001-44b8-111e-5c00-39c5-e677-fdb8-5d64.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:39c5:e677:fdb8:5d64])
        by smtp.gmail.com with ESMTPSA id i7sm7347282pgq.16.2021.03.25.23.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 23:02:50 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Aditya Srivastava <yashsri421@gmail.com>, leitao@debian.org
Cc:     rdunlap@infradead.org, herbert@gondor.apana.org.au, corbet@lwn.net,
        nayna@linux.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, yashsri421@gmail.com,
        pfsmorigo@gmail.com, linux-crypto@vger.kernel.org,
        lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        davem@davemloft.net, paulus@samba.org
Subject: Re: [PATCH] crypto: vmx: fix incorrect kernel-doc comment syntax in files
In-Reply-To: <20210320202525.12562-1-yashsri421@gmail.com>
References: <20210320202525.12562-1-yashsri421@gmail.com>
Date:   Fri, 26 Mar 2021 17:02:47 +1100
Message-ID: <87o8f678qg.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Aditya,

Thanks for your patch!

> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> There are certain files in drivers/crypto/vmx, which follow this syntax,
> but the content inside does not comply with kernel-doc.
> Such lines were probably not meant for kernel-doc parsing, but are parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warnings from kernel-doc.
>
> E.g., presence of kernel-doc like comment in the header line for
> drivers/crypto/vmx/vmx.c causes this warning by kernel-doc:
>
> "warning: expecting prototype for Routines supporting VMX instructions on the Power 8(). Prototype was for p8_init() instead"

checkpatch (scripts/checkpatch.pl --strict -g HEAD) complains about this line:
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
but checkpatch should be ignored here, as you did the right thing by not
breaking an error message across multiple lines.

> Similarly for other files too.
>
> Provide a simple fix by replacing such occurrences with general comment
> format, i.e. '/*', to prevent kernel-doc from parsing it.

This makes sense.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel

>
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
> ---
> * Applies perfectly on next-20210319
>
>  drivers/crypto/vmx/aes.c     | 2 +-
>  drivers/crypto/vmx/aes_cbc.c | 2 +-
>  drivers/crypto/vmx/aes_ctr.c | 2 +-
>  drivers/crypto/vmx/aes_xts.c | 2 +-
>  drivers/crypto/vmx/ghash.c   | 2 +-
>  drivers/crypto/vmx/vmx.c     | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
> index d05c02baebcf..ec06189fbf99 100644
> --- a/drivers/crypto/vmx/aes.c
> +++ b/drivers/crypto/vmx/aes.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/**
> +/*
>   * AES routines supporting VMX instructions on the Power 8
>   *
>   * Copyright (C) 2015 International Business Machines Inc.
> diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
> index d88084447f1c..ed0debc7acb5 100644
> --- a/drivers/crypto/vmx/aes_cbc.c
> +++ b/drivers/crypto/vmx/aes_cbc.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/**
> +/*
>   * AES CBC routines supporting VMX instructions on the Power 8
>   *
>   * Copyright (C) 2015 International Business Machines Inc.
> diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
> index 79ba062ee1c1..9a3da8cd62f3 100644
> --- a/drivers/crypto/vmx/aes_ctr.c
> +++ b/drivers/crypto/vmx/aes_ctr.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/**
> +/*
>   * AES CTR routines supporting VMX instructions on the Power 8
>   *
>   * Copyright (C) 2015 International Business Machines Inc.
> diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
> index 9fee1b1532a4..dabbccb41550 100644
> --- a/drivers/crypto/vmx/aes_xts.c
> +++ b/drivers/crypto/vmx/aes_xts.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/**
> +/*
>   * AES XTS routines supporting VMX In-core instructions on Power 8
>   *
>   * Copyright (C) 2015 International Business Machines Inc.
> diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
> index 14807ac2e3b9..5bc5710a6de0 100644
> --- a/drivers/crypto/vmx/ghash.c
> +++ b/drivers/crypto/vmx/ghash.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
> -/**
> +/*
>   * GHASH routines supporting VMX instructions on the Power 8
>   *
>   * Copyright (C) 2015, 2019 International Business Machines Inc.
> diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
> index a40d08e75fc0..7eb713cc87c8 100644
> --- a/drivers/crypto/vmx/vmx.c
> +++ b/drivers/crypto/vmx/vmx.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/**
> +/*
>   * Routines supporting VMX instructions on the Power 8
>   *
>   * Copyright (C) 2015 International Business Machines Inc.
> -- 
> 2.17.1
