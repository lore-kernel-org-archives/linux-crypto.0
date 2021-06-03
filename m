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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD15C47080
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16E1D613DE
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhFCEHZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhFCEHY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 00:07:24 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA6DC06174A
        for <linux-crypto@vger.kernel.org>; Wed,  2 Jun 2021 21:05:26 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u18so3869469pfk.11
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jun 2021 21:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=795WZ/W4WPdDcq8kKiZWiu2NEgJWT4oKxelx0R4hEO8=;
        b=TTyiAwJ3SUuLjCZCApR55XIk/saCQ2zDy3RFA8o0NikxDgZWw5nMzYJONgf6XJaxYb
         lgEzTUfE9efXxv1XawtZ5IVAs6wW7nJyCMyOw0tayWGQ0EeBR033QPQcYOhCG4ZcU+6H
         xTLP2GCR3qOpcv/druIRfwQYYuHFjvMuclo70aBQYQlTKZOl/O/07r7HWE8uwzX7f8sp
         nIZAWDJ/vb7HJ8Zd7TD5hX9rjqSfgNYrjnEn8fIA25dDmovwxzxfEiVm8BlMR69wuyYT
         EvaSUN+qdsOhf8Ia7Xt3zh1DAJC57L48jDo3tx4NXmp01t9LVKjonvy9UqOqYJESePvx
         bLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=795WZ/W4WPdDcq8kKiZWiu2NEgJWT4oKxelx0R4hEO8=;
        b=J+oWPSmSE+pNySTWzj2OHQQyEE3+jIGkQwPZ7i+0Y9SUCYfQzLzDdJm5ypj7sH+YLe
         tXP8A5G2DAyGThK8PTXlR6sUYRoypF1T9i2TjbYL1X2HEroMMG3nnwhrUzE3pzzrsVb/
         gGpg5D+ZDHoNk66X9uJfInboy6Grq/3H0Nud0XjlKcNlrpYFv0ArCEzy89z+KFdL4ec1
         ePLpuKxME9F76uV5cZLhAYcl+YKrfbCZ793FiRVmspdGXKjd+zyIiP0CvVhaWtTbykW/
         ybNcOODQU6P/H3W+6aFEpJGP7Ecc26rem1UIKIcUrrOcAUJKBkR5s/6I4jm52uV0mZH5
         5SCw==
X-Gm-Message-State: AOAM530EYQSR3WZuuK+MMwICgsmu9PWNzxIQe4TJobQ8UdPBrereAr1v
        RPIxr44bn/8MbLND+A0mA+8=
X-Google-Smtp-Source: ABdhPJxVoCnWCCNm0vxBcFiQoxnCNx14ajI5glsJBXgYwhpbmFtoq5eaCOa9y/iGLdrQ9WXniVTkjQ==
X-Received: by 2002:a63:1c6:: with SMTP id 189mr37271392pgb.144.1622693126063;
        Wed, 02 Jun 2021 21:05:26 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id n129sm501962pfn.167.2021.06.02.21.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:05:25 -0700 (PDT)
Date:   Thu, 03 Jun 2021 14:05:20 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 03/16] powerpc/vas: Add platform specific user window
 operations
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <f4fb4b7bb98580ae3c025d83148a6406541de892.camel@linux.ibm.com>
In-Reply-To: <f4fb4b7bb98580ae3c025d83148a6406541de892.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622692598.4iphcb4vdf.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of May 21, 2021 7:30 pm:
>=20
> PowerNV uses registers to open/close VAS windows, and getting the
> paste address. Whereas the hypervisor calls are used on PowerVM.
>=20
> This patch adds the platform specific user space window operations
> and register with the common VAS user space interface.

Basic idea makes sense. I don't understand this code in detail though.
A couple of things,

>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/vas.h              | 14 +++++-
>  arch/powerpc/platforms/book3s/vas-api.c     | 52 ++++++++++++---------
>  arch/powerpc/platforms/powernv/vas-window.c | 46 +++++++++++++++++-
>  3 files changed, 89 insertions(+), 23 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index 6076adf9ab4f..668303198772 100644
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
> +	struct vas_window * (*open_win)(struct vas_tx_win_open_attr *,
> +				enum vas_cop_type);
> +	u64 (*paste_addr)(void *);
> +	int (*close_win)(void *);

Without looking further into the series, why do these two take void *=20
when the first returns a vas_window * which appears to be the required
argument to these?

> +static struct vas_user_win_ops vops =3D  {
> +	.open_win	=3D	vas_user_win_open,
> +	.paste_addr	=3D	vas_user_win_paste_addr,
> +	.close_win	=3D	vas_user_win_close,
> +};

const?

Thanks,
Nick
