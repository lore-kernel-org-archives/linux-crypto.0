Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0784EC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 06:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbiBKG1Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:27:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237282AbiBKG1X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 01:27:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06A3FC5
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 22:27:22 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k60-20020a17090a4cc200b001b932781f3eso3536666pjh.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 22:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=JhnvwkrC36+ZtBCSmsX8E71vUbd01PT5UHf/8Lx3bYI=;
        b=PhKG9VFn/JmTyURd15Sm5JvSvvHeDltFHCnOaYECW9yQEcKi7QXtGCXEjjcrWiaM+V
         St3/XiNEFe8yGswKO4+6+jemFpF28TMNolHqtVhi/zNuu1HMKrZUkbpdXnRIkd9LotAY
         OGj5EppaCiBgFVN+OJdqIxuwLEsVNYY4dsgu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JhnvwkrC36+ZtBCSmsX8E71vUbd01PT5UHf/8Lx3bYI=;
        b=ECSDLqnYSGV2S8o+76A/NXQT0Soqynu6TT+Awy3xdzQAzu8nLGUoQfJjiWttk49Y8j
         j5FdokSgL91NGaK0e7BMZazVZ75mW7mCRdPnEhRVNA1TtJh/s8eNzCTXsVHX6i87ops9
         u2mGnaMcwaGJMcIOFqZLSGsuBWkrv8NqxVS4k8MN0t5esYb2Z4s+lOgfYEBeBpTFv7gw
         WsAtkQyFE3YQI0Il6vUvp669C3wvNmBWH+zj+04QQ7nnWXIi9fptvWRymuzalifvR3/Q
         ZTBjfMAgZS8Zc0Jk90/z3AwIBNvy/hqqzdYS8eqUKAlPfAFQ750yICc2xUSBKzoYMgfo
         jdvw==
X-Gm-Message-State: AOAM5339HfFYsDWfQT2F3VO4nL7fm3QF4mkQDYfGRaId7rBlvt8VpPpt
        GWBQOwagEikfMi7wvVfN/N5LqA==
X-Google-Smtp-Source: ABdhPJz5ANcTe3+INLtHZyy5LDDfipqUtY9os4gw6Lm8N3C26gsFfqTBRgoChXV9aGU8ErX1TizrTQ==
X-Received: by 2002:a17:90b:380f:: with SMTP id mq15mr300828pjb.84.1644560842505;
        Thu, 10 Feb 2022 22:27:22 -0800 (PST)
Received: from localhost ([2001:4479:e300:600:d3de:3045:38b4:5296])
        by smtp.gmail.com with ESMTPSA id u33sm25826267pfg.195.2022.02.10.22.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 22:27:22 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto/nx: Constify static attribute_group structs
In-Reply-To: <20220210202805.7750-4-rikard.falkeborn@gmail.com>
References: <20220210202805.7750-1-rikard.falkeborn@gmail.com>
 <20220210202805.7750-4-rikard.falkeborn@gmail.com>
Date:   Fri, 11 Feb 2022 17:27:19 +1100
Message-ID: <87tud5rk8o.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Rikard,

> The only usage of these is to pass their address to
> sysfs_{create,remove}_group(), which takes pointers to const struct
> attribute_group. Make them const to allow the compiler to put them in
> read-only memory.

I checked the file. Indeed, those structs are only used in
sysfs_{create,remove}_group. So I agree that they can be constified.

They also pass all the automated tests:
https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220210202805.7750-4-rikard.falkeborn@gmail.com/

Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel

>
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> ---
>  drivers/crypto/nx/nx-common-pseries.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
> index 4e304f6081e4..7584a34ba88c 100644
> --- a/drivers/crypto/nx/nx-common-pseries.c
> +++ b/drivers/crypto/nx/nx-common-pseries.c
> @@ -962,7 +962,7 @@ static struct attribute *nx842_sysfs_entries[] = {
>  	NULL,
>  };
>  
> -static struct attribute_group nx842_attribute_group = {
> +static const struct attribute_group nx842_attribute_group = {
>  	.name = NULL,		/* put in device directory */
>  	.attrs = nx842_sysfs_entries,
>  };
> @@ -992,7 +992,7 @@ static struct attribute *nxcop_caps_sysfs_entries[] = {
>  	NULL,
>  };
>  
> -static struct attribute_group nxcop_caps_attr_group = {
> +static const struct attribute_group nxcop_caps_attr_group = {
>  	.name	=	"nx_gzip_caps",
>  	.attrs	=	nxcop_caps_sysfs_entries,
>  };
> -- 
> 2.35.1
