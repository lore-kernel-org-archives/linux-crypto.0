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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C75CC433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E4B061432
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhEJFLf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 01:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJFLf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 01:11:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE205C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 22:10:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so9357638pjn.5
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 22:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=FxTICue1UIi0l6FvFNJ5xfSFW4OZSuAmCKdc+189Vu8=;
        b=rpayvgMn/iMHyrkg9plXID9RHfmhhzy/hogrG5VatmdYKKzCr1HXTQOiQ1q5txV0pa
         Sc7N+ZdtjmPrBKIhBCjm41F25UMvHXtg+SQkeHih7heedANMJaX0jiGM0c6vcDVsnyGJ
         oUbe0N24XEX+x7niTeqFqNT1CBd14EIzPOZkwmsYfIA0YGDYtWiM8pTPwwCv7J2Kam0M
         Qf/DPs4TX1FO824RBffHYIafz5bpJuZxuOnUSF4UZS2PgE72C28Z/txWwQ64I45dOpj9
         X8KdxWzTup6+QUYEoUkzowwIAWkVuNbPplxFmIztHPtlHB0R7SmovF2WTmUdkJK3Cum6
         0iSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=FxTICue1UIi0l6FvFNJ5xfSFW4OZSuAmCKdc+189Vu8=;
        b=sHBJNevNAQ2vuSTNlK8yr/xo0gHknzp+565hCii3dGxMmmlynLJPThThHFjrOxmel+
         ew/oHnudzPWrXKnMbJnDLffeJqoMkQ/eCDrCUtWb3EpTcSNUg9g6IJL4e7K9lLGl6TD3
         IasRwD7QZrpptnL74M2rRqJgnTzkJxpdidJ4s+ABEw08hQPk1QwYuCl1SKJMEikRJBB0
         KwiZ6Eiaf/asGn2vvJI+8jWhWmDpw3rmqKgfPQJiUg3rQhuTUVbhqR7uOfnjIABIw9OH
         oNwzvFv0pla4HRH3+dWqSTR+wzBeV/h5NW9syoNjHAoln1gBWmlziIXikZzps+8b5Pum
         USqQ==
X-Gm-Message-State: AOAM532BJBts38/vBsbaWCR/1G9rOGPQf134zTzuOHNz70ea66xmHCQj
        5s6UndWP2cpxz8AmjApkQ2s=
X-Google-Smtp-Source: ABdhPJzhQ94aOySpS7UxrylGMNA4QpqH5/L0J3s6QpGxSCqgmoNNbWWG6x4yq8NgJsRrBOLzhjleZw==
X-Received: by 2002:a17:902:a70f:b029:ea:d4a8:6a84 with SMTP id w15-20020a170902a70fb02900ead4a86a84mr23193876plq.42.1620623430168;
        Sun, 09 May 2021 22:10:30 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id k14sm10046982pgl.2.2021.05.09.22.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 22:10:29 -0700 (PDT)
Date:   Mon, 10 May 2021 15:10:24 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 01/16] powerpc/powernv/vas: Rename register/unregister
 functions
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <86bae80a92b8465d663f72e7fadc1fa3671e8a4f.camel@linux.ibm.com>
In-Reply-To: <86bae80a92b8465d663f72e7fadc1fa3671e8a4f.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620622742.tr9lqg4vzz.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:00 am:
>=20
> powerNV and pseries drivers register / unregister to the corresponding
> VAS code separately. So rename powerNV VAS API register/unregister
> functions.

The pseries VAS driver will have different calls for registering a
coprocessor driver, you mean?

It certainly looks the same=20

(from patch 13)
	ret =3D vas_register_api_pseries(THIS_MODULE, VAS_COP_TYPE_GZIP,
				       "nx-gzip");

So I guess it's just a matter of the driver being different enough that=20
there is no benefit to making this call common (and branching to pseries
or powernv dynamically).

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/vas.h           |  6 +++---
>  arch/powerpc/platforms/powernv/vas-api.c | 10 +++++-----
>  drivers/crypto/nx/nx-common-powernv.c    |  6 +++---
>  3 files changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index e33f80b0ea81..41f73fae7ab8 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -170,8 +170,8 @@ int vas_paste_crb(struct vas_window *win, int offset,=
 bool re);
>   * Only NX GZIP coprocessor type is supported now, but this API can be
>   * used for others in future.
>   */
> -int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_ty=
pe,
> -				const char *name);
> -void vas_unregister_coproc_api(void);
> +int vas_register_api_powernv(struct module *mod, enum vas_cop_type cop_t=
ype,
> +			     const char *name);
> +void vas_unregister_api_powernv(void);
> =20
>  #endif /* __ASM_POWERPC_VAS_H */
> diff --git a/arch/powerpc/platforms/powernv/vas-api.c b/arch/powerpc/plat=
forms/powernv/vas-api.c
> index 98ed5d8c5441..72d8ce39e56c 100644
> --- a/arch/powerpc/platforms/powernv/vas-api.c
> +++ b/arch/powerpc/platforms/powernv/vas-api.c
> @@ -207,8 +207,8 @@ static struct file_operations coproc_fops =3D {
>   * Supporting only nx-gzip coprocessor type now, but this API code
>   * extended to other coprocessor types later.
>   */
> -int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_ty=
pe,
> -				const char *name)
> +int vas_register_api_powernv(struct module *mod, enum vas_cop_type cop_t=
ype,
> +			     const char *name)
>  {
>  	int rc =3D -EINVAL;
>  	dev_t devno;
> @@ -262,9 +262,9 @@ int vas_register_coproc_api(struct module *mod, enum =
vas_cop_type cop_type,
>  	unregister_chrdev_region(coproc_device.devt, 1);
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(vas_register_coproc_api);
> +EXPORT_SYMBOL_GPL(vas_register_api_powernv);
> =20
> -void vas_unregister_coproc_api(void)
> +void vas_unregister_api_powernv(void)
>  {
>  	dev_t devno;
> =20
> @@ -275,4 +275,4 @@ void vas_unregister_coproc_api(void)
>  	class_destroy(coproc_device.class);
>  	unregister_chrdev_region(coproc_device.devt, 1);
>  }
> -EXPORT_SYMBOL_GPL(vas_unregister_coproc_api);
> +EXPORT_SYMBOL_GPL(vas_unregister_api_powernv);
> diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx=
-common-powernv.c
> index 13c65deda8e9..88d728415bb2 100644
> --- a/drivers/crypto/nx/nx-common-powernv.c
> +++ b/drivers/crypto/nx/nx-common-powernv.c
> @@ -1090,8 +1090,8 @@ static __init int nx_compress_powernv_init(void)
>  		 * normal FIFO priority is assigned for userspace.
>  		 * 842 compression is supported only in kernel.
>  		 */
> -		ret =3D vas_register_coproc_api(THIS_MODULE, VAS_COP_TYPE_GZIP,
> -						"nx-gzip");
> +		ret =3D vas_register_api_powernv(THIS_MODULE, VAS_COP_TYPE_GZIP,
> +					       "nx-gzip");
> =20
>  		/*
>  		 * GZIP is not supported in kernel right now.
> @@ -1127,7 +1127,7 @@ static void __exit nx_compress_powernv_exit(void)
>  	 * use. So delete this API use for GZIP engine.
>  	 */
>  	if (!nx842_ct)
> -		vas_unregister_coproc_api();
> +		vas_unregister_api_powernv();
> =20
>  	crypto_unregister_alg(&nx842_powernv_alg);
> =20
> --=20
> 2.18.2
>=20
>=20
>=20
