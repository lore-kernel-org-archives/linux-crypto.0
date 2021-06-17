Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BF4C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 521106117A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhFQX3o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 19:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhFQX3o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 19:29:44 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AA8C061574
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:27:36 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o10-20020a17090aac0ab029016e92770073so4775033pjq.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=mJE3vn89L8/9BwSz8wTo8P/yLsaHXdWdVlVTB99IrQw=;
        b=sg64B7iTgVNF2/ubNs03b6i+SVZXHydv7axmVRMwFRLRGF2IFM2KivPII5dDie5zy0
         EfdXmAPhpMcvldd/Nh+3mb7P7uZbYIADKya9+r9m6AnDtQkpqffuDmCniEzYLEGRAF6B
         fac4Bj9yol6KYAWtKBSKpIxTzGswqt4xIdA1NNhgUfhQKBHPa7PgC3OKmUZVCg2lXOfO
         eXZlRyyFnJzw+xx90sC+gamRkDfnqMsxcfXcMcTlzJEI3FXqkaoablzm6GWPAE7lOyPq
         TxbtyoqnTAxlg92kwLm1Og4e3FnS2wY3sqVxXAmbSwvuXs9InJywUcQVLhpzmP3BqRTC
         irwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=mJE3vn89L8/9BwSz8wTo8P/yLsaHXdWdVlVTB99IrQw=;
        b=hKCbYUT5GqdQdHYAIpCTUIp/esHjWb0rJnzb2WtclDNsxn5X/jkVwl6dKjAMVhxr/v
         vVYjOyTK7qfbxkHAelq49x7spI7DOWjmp4kANqjlhqSqsZ1VauIZAlOjqlwGD94TzYrE
         wn7nukZHZfgou8DNfB/YNhWyrFQmMThvI5/kPqetvkvp9M89OuPEVEFs0Vk29K6cKK4t
         VfqWZaBezdTwjlLaOpMJvnukqGB3kLRKdKcT99QW0E6e8Es9YOnD8odCqS1T6eVXyL7s
         Jv8lSz5sbfw6OTRG4+KN7AcI87fKxVGy4Wz9NiSF71k1QNhgpOzwBai2CeUUTN1TpUJX
         taQA==
X-Gm-Message-State: AOAM530VaaB98zGS7TiTuES2PImJ6f+9B5XbGDt1aZrVVSSwV+I2KsCh
        hYh8bRJtACNuFkFqeR1pFironjHj/lc=
X-Google-Smtp-Source: ABdhPJy0y2W8C9jd99x+VfO8xyAJhEj7y9qnJvlWDxqtHyZv6oruEfG1SDhlGUe0iEVohuMpX/RW2Q==
X-Received: by 2002:a17:90a:4a8f:: with SMTP id f15mr6421593pjh.76.1623972455763;
        Thu, 17 Jun 2021 16:27:35 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id f7sm6084744pfk.191.2021.06.17.16.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 16:27:35 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:27:29 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 04/17] powerpc/vas: Add platform specific user window
 operations
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
        <f85091f4ace67f951ac04d60394d67b21e2f5d3c.camel@linux.ibm.com>
In-Reply-To: <f85091f4ace67f951ac04d60394d67b21e2f5d3c.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623972363.whor4uwn96.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 18, 2021 6:31 am:
>=20
> PowerNV uses registers to open/close VAS windows, and getting the
> paste address. Whereas the hypervisor calls are used on PowerVM.
>=20
> This patch adds the platform specific user space window operations
> and register with the common VAS user space interface.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/include/asm/vas.h              | 16 +++++--
>  arch/powerpc/platforms/book3s/vas-api.c     | 53 +++++++++++++--------
>  arch/powerpc/platforms/powernv/vas-window.c | 45 ++++++++++++++++-
>  arch/powerpc/platforms/powernv/vas.h        |  2 +
>  4 files changed, 91 insertions(+), 25 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index 6076adf9ab4f..163a8bb85d02 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -5,6 +5,7 @@
> =20
>  #ifndef _ASM_POWERPC_VAS_H
>  #define _ASM_POWERPC_VAS_H
> +#include <uapi/asm/vas-api.h>
> =20
>  struct vas_window;
> =20
> @@ -48,6 +49,16 @@ enum vas_cop_type {
>  	VAS_COP_TYPE_MAX,
>  };
> =20
> +/*
> + * User space window operations used for powernv and powerVM
> + */
> +struct vas_user_win_ops {
> +	struct vas_window * (*open_win)(int vas_id, u64 flags,
> +				enum vas_cop_type);

Thanks for changing that to not pass down the struct passed in by the=20
user. Looks good.

Thanks,
Nick

