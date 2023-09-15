Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7B4EEAA42
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 03:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjIODk0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 23:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjIODkZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 23:40:25 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D371BF4
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 20:40:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-27489f78e52so665834a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 20:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694749221; x=1695354021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=emL8gA7NYvcjlfqjFCfssMU1Dd1/VuC6P+GxTP1jKsg=;
        b=MyP9D0dSZY+fWf4QeF4UdYcx2K6f4ifR/RvqMLfDWZFAoiEbVe40OpTeNjLZBffFvt
         PXF/RkkUs9nETu7y8+Ew2+kq2I6i7L2qBiiw/Tsg8kKwUXGfZrPFJEg7v8STx/lEsbl1
         jbYqFT/1Z6Db4eklu8RuKWI9x3rSEhtPtA+qc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694749221; x=1695354021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emL8gA7NYvcjlfqjFCfssMU1Dd1/VuC6P+GxTP1jKsg=;
        b=nOUzJkM7r/Qe0SSAJrkGpos93FhLjLojDJpMsqNPZqzmLMNcuL1H5ZLF85QNZeNZuf
         dvP6LOXv1ryM0b+eBmXhSrwhhVh1dJyj0j+pUMVpLUzKoDZn7YscuagsdtShYlSm5sZF
         1zclScO56FIs8/GuB1OecU/0TgycKG/qpwhBMwmlNRstJfJo0G2mD6WePk9LEXonIECO
         KXOzVy8EWJ3eKiXI0a5n/R6R8xqsNlgRNM+xe60ZWjj7TESKasGuv3pH90Oqe2CCXpX+
         hS4VQTziYJAx/3NCHRpDrZ64Cgk3QL2eHVYgqfb3jYh5T3uKrGq/Q+9zGFxAHXWeraFM
         9FZA==
X-Gm-Message-State: AOJu0Yw7YGv7GQShHIBKHaq9w+IB6yK/mEeXoW8Y/Uv4agCLRTEgJxnz
        6Xst8L9K5Tl3RckXV0yHxlQ73A==
X-Google-Smtp-Source: AGHT+IHrCMHvgrUBjySOfb5emjIZgc6gpCkZ0ynmYN2q5pu+0IiNfABJI4OWAU5wgyM1LCCux4SH3A==
X-Received: by 2002:a17:90b:3583:b0:268:7be6:29a5 with SMTP id mm3-20020a17090b358300b002687be629a5mr373511pjb.9.1694749221378;
        Thu, 14 Sep 2023 20:40:21 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902748c00b001b246dcffb7sm2330294pll.300.2023.09.14.20.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 20:40:20 -0700 (PDT)
Date:   Thu, 14 Sep 2023 20:40:20 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - refactor deprecated strncpy
Message-ID: <202309142039.F903B1C@keescook>
References: <20230913-strncpy-drivers-crypto-intel-qat-qat_common-qat_uclo-c-v1-1-88a6c07fc924@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913-strncpy-drivers-crypto-intel-qat-qat_common-qat_uclo-c-v1-1-88a6c07fc924@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 13, 2023 at 12:51:05AM +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings [1].
> 
> We should prefer more robust and less ambiguous string interfaces.
> 
> `buf` is expected to be NUL-terminated for its eventual use in
> `kstrtoul()` and NUL-padding is not required.
> 
> Due to the above, a suitable replacement is `strscpy` [2] due to the
> fact that it guarantees NUL-termination on the destination buffer.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
> Note: build-tested only.
> ---
>  drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> index ce837bcc1cab..e2f82128043e 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
> @@ -200,7 +200,7 @@ static int qat_uclo_parse_num(char *str, unsigned int *num)
>  	unsigned long ae = 0;
>  	int i;
>  
> -	strncpy(buf, str, 15);
> +	strscpy(buf, str, sizeof(buf));
>  	for (i = 0; i < 16; i++) {
>  		if (!isdigit(buf[i])) {

I was initially worried when I saw this walking the entire contents, but
I see it is explicitly zeroed on the stack first, so this is fine:

        char buf[16] = {0};


Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>  			buf[i] = '\0';
> 
> ---
> base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
> change-id: 20230913-strncpy-drivers-crypto-intel-qat-qat_common-qat_uclo-c-0f4b16830f59
> 
> Best regards,
> --
> Justin Stitt <justinstitt@google.com>
> 

-- 
Kees Cook
