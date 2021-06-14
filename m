Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2F6C48BE8
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5331613AB
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhFNDJs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 23:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhFNDJr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 23:09:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD43CC061574
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:07:45 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id q25so9508088pfh.7
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=U3YHNE7P8lYSeBC7M0hGaNUcPpPrqIycgAPOdK5k1ro=;
        b=slqQDRxKx07A3y40pwqVKMzKhY8rALLhgSDkxnY3eibTM33nOMR1V76tOw7MPxgNyG
         v+o0dx6P5P3RnArysF8N+4T5l/OwGuWZ7SQ4xO1RxAg24fmVFysJcN2toWwbQoYv4XoZ
         /7vj9bwbWTTd/dDpeumpwR5UMOZIgrzNSrIox/opPKUKyC1lLZ6suy0vC/l9lRjlwb3c
         QJ0WRgGUTX2OkCuXZHcDAB2PB7xqQZsFH6EX27tReyKs3qL1s74211+jqQDOgO7WgwoV
         uceLQ+QCqD6m91UssWgHwXAP6MsJ7r3lJVkzjcfq7Mc6t6Yt4eDanQ76OeWE35l4d9tO
         ZG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=U3YHNE7P8lYSeBC7M0hGaNUcPpPrqIycgAPOdK5k1ro=;
        b=lWQ4EWq1RWm7RJscxgCEFdM+iJYDduA/sN/S7lHqivnqBLIr0Qlz5zgCXnt8rfdVvx
         fgaTkkitsFi/zjrGbB+ykiRbOlvWxPquz+j3mhQ6qyvcXUQun8Xy5tAU1/2VTkCw6ui+
         PpK2iFLQ2uhgN4Sms8IfClueR0RWoYX7IazaaD6Hl7siVBzP0PdNubHzXqxc2R7c1Xk1
         dsSl/ngPg4paQ5aH/vUkomnk9Fh8vF995TXjpBwEoLskYvnNTeLrMWaD2Jpfb4bTOyrv
         LKo+0iB1+0C+2eBA+FCU/lf+Ms22RKPrApKgHswL+NSjjaWvTKCrDmF0j4xf6ccZafIN
         A8aw==
X-Gm-Message-State: AOAM533wE441yh5RFlqjA3c/wTvR7Uz2dGBU4LypzAOld4e2A7di0D1z
        Q4JVVn2djvYR9Npj6/jQpGM=
X-Google-Smtp-Source: ABdhPJwQSnAOsdo9zi/xhttLEkQEUrGe+VI+hb/1JesOdcE5zeabFZfBn5GyJrp73uw+xJd+wpPfRA==
X-Received: by 2002:a05:6a00:bd0:b029:2f1:3fbb:317f with SMTP id x16-20020a056a000bd0b02902f13fbb317fmr19610792pfu.17.1623640065433;
        Sun, 13 Jun 2021 20:07:45 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id ev11sm15564103pjb.36.2021.06.13.20.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 20:07:45 -0700 (PDT)
Date:   Mon, 14 Jun 2021 13:07:40 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 14/17] crypto/nx: Rename nx-842-pseries file name to
 nx-common-pseries
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <03731a80b5af5f8cea95579215c6d2241c291b70.camel@linux.ibm.com>
In-Reply-To: <03731a80b5af5f8cea95579215c6d2241c291b70.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623640035.t3tk2uz8r4.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 13, 2021 9:03 pm:
>=20
> Rename nx-842-pseries.c to nx-common-pseries.c to add code for new
> GZIP compression type. The actual functionality is not changed in
> this patch.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  drivers/crypto/nx/Makefile                                  | 2 +-
>  drivers/crypto/nx/{nx-842-pseries.c =3D> nx-common-pseries.c} | 0
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename drivers/crypto/nx/{nx-842-pseries.c =3D> nx-common-pseries.c} (10=
0%)
>=20
> diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
> index bc89a20e5d9d..d00181a26dd6 100644
> --- a/drivers/crypto/nx/Makefile
> +++ b/drivers/crypto/nx/Makefile
> @@ -14,5 +14,5 @@ nx-crypto-objs :=3D nx.o \
>  obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) +=3D nx-compress-pseries.o =
nx-compress.o
>  obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) +=3D nx-compress-powernv.o =
nx-compress.o
>  nx-compress-objs :=3D nx-842.o
> -nx-compress-pseries-objs :=3D nx-842-pseries.o
> +nx-compress-pseries-objs :=3D nx-common-pseries.o
>  nx-compress-powernv-objs :=3D nx-common-powernv.o
> diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-co=
mmon-pseries.c
> similarity index 100%
> rename from drivers/crypto/nx/nx-842-pseries.c
> rename to drivers/crypto/nx/nx-common-pseries.c
> --=20
> 2.18.2
>=20
>=20
>=20
