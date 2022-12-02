Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2825C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 18:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiLBSyb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 13:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiLBSyP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 13:54:15 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFF3E347E
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 10:54:07 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x66so5726219pfx.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Dec 2022 10:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6iMOnyAeQsAPxih1P0qQQ/qb4Uyj+szfK6Khgj7UVBM=;
        b=gaQZ/2L0TZuF0vlG6F8FXYeQZ1QCiQ4oPOli05DX+LfBfEE/JCeOzeHyX4Rb4cAwh+
         k/u4J+C9Mk52XWfLFmd75lNLMXGn7Dx0sqmr8dAuRkfhivo330YgFt/EmYYp+wtltMgH
         uMFEkb6J4hTL10CrJZ9fffzLbBIQhIHL9CBLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6iMOnyAeQsAPxih1P0qQQ/qb4Uyj+szfK6Khgj7UVBM=;
        b=LSyXaNaYImmRPBc5spbBHNu2xwA7KEi9tBnBfCt7tN2EQntaWtTxK+7FAyjBj1KFDc
         sHn63WBi7QJUvrEUCrIzCADmfwGMcjHA/HUJVf5IskU/0J+UXHBdCdABsmOawIx+g57j
         V7Vh4+GdLOawP0tu5xdwPup56X8HhLFo6n20uavAIn1hg8QgCos8DtKFGJPQmqBY7foS
         SpV0PeexN4hG8JIwDTYOWLxiuwlAcK+s7MHMDD/7D/E8qUEb9jc++JKis/A2j9SQbwKm
         OuI+vHVVQvTQcvvIFaGaWRgp2j6snrSa+2kN7l15zzzZDoVvhxX2umyedCXoW7HvRv0I
         nm+g==
X-Gm-Message-State: ANoB5pm8I19RPHmIRQD/fGaWfBqE4JeEQOu6q+eItb6QA55H9T9I/7i6
        Zq+iQ9cvms85+Dq5+FZm9t7UlA==
X-Google-Smtp-Source: AA0mqf4oA/ZhqGNXZKsEB/aIA5GakcxaJJXeeAgFZIxsVTNBPLoZ+SknjDWJAkfMNj9dEspJpOKx4Q==
X-Received: by 2002:a63:cd10:0:b0:476:c36a:42b9 with SMTP id i16-20020a63cd10000000b00476c36a42b9mr48440644pgg.235.1670007246921;
        Fri, 02 Dec 2022 10:54:06 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s20-20020a170902a51400b001894dc5fdf2sm5859890plq.296.2022.12.02.10.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 10:54:06 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:54:05 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] crypto/caam: Avoid GCC constprop bug warning
Message-ID: <202212021049.16C438A@keescook>
References: <20221202010410.gonna.444-kees@kernel.org>
 <Y4loCFGhxecG6Ta0@gondor.apana.org.au>
 <202212011928.97A43D01@keescook>
 <Y4mHjKXnF/4Pfw5I@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4mHjKXnF/4Pfw5I@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 02, 2022 at 01:05:16PM +0800, Herbert Xu wrote:
> On Thu, Dec 01, 2022 at 07:30:22PM -0800, Kees Cook wrote:
> >
> > Getting rid of the if doesn't solve the warning. I can switch it to just
> > "if (data)", though. That keeps GCC happy.
> 
> OK I misread the thread.
> 
> Anyhow, it appears that this warning only occurs due to a debug
> printk in caam.  So how about something like this?

What? I don't think that's true? I think
CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG only controls "PRINT_POS", which is
unrelated?

The call path is:

drivers/crypto/caam/key_gen.c: gen_split_key()
	append_fifo_load_as_imm(..., NULL, ...) <- literal NULL
		append_cmd_data(..., data, ...)
			memcpy(..., data, ...)

and doesn't seem affected at all by CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG.

-Kees

> 
> diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
> index 62ce6421bb3f..b49c995e1cc6 100644
> --- a/drivers/crypto/caam/desc_constr.h
> +++ b/drivers/crypto/caam/desc_constr.h
> @@ -163,7 +163,7 @@ static inline void append_data(u32 * const desc, const void *data, int len)
>  {
>  	u32 *offset = desc_end(desc);
>  
> -	if (len) /* avoid sparse warning: memcpy with byte count of 0 */
> +	if (!IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG) || data)
>  		memcpy(offset, data, len);
>  
>  	(*desc) = cpu_to_caam32(caam32_to_cpu(*desc) +

-- 
Kees Cook
