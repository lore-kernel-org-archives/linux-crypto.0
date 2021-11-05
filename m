Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFB2C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 13:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F31610FD
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 13:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhKEN25 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 09:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhKEN24 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 09:28:56 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F635C061714;
        Fri,  5 Nov 2021 06:26:17 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id bk26so13281529oib.11;
        Fri, 05 Nov 2021 06:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=SS/+GawiHt4AKQM+4dzNVtQd4ve18Yf7ZbG8yygMuQ8=;
        b=EIpAESqujtMyfMEh64OQ3A4jvZTIkxWetvJm4blYAyALH/1z9KT46AM0yJbk3EpYf4
         Z1hxc8w98ugDN+dX8C5NTkAc7i7YlYpCgIMorJMMltqIcObvxOthb0THrAzMNhIrmbha
         n5SnTqCKxjW6CjtcXV1dhOcGZc/YJDgvYM72VSRAzO9EPa4p64MDH8yagR8xy4apfNr6
         VhUryQ5bcLzqEcLWEosrQnxmjl2FfJiR3ZN0KRl7mLo+tOrWWmuBaD90EFKWjN1voqHA
         AaNzXqahv+3Wt8qoIK8bqdvDcKSZJqgMYk+EgLdpiFJ9NuxklutHxotoL4d5LUHYK+Q2
         CZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=SS/+GawiHt4AKQM+4dzNVtQd4ve18Yf7ZbG8yygMuQ8=;
        b=HudtrcRc7x+L16AELdHaXCWrTWhuX4rChjfo/CtRuG5tzKDQOvGUX6Sk7BAQFHFtmW
         JTN+6+/0fEYS3PVZOCS5eAL3JAsirI4/kxvn17pXyli5NzYWRntxyKp8PM8ALn2j/Ivw
         BKowhnmT95ZkmmTeOaGJf13kpzsyEFOncfqFBbGWwpB//8CFUSMtESiOnN3on7t1zBLz
         eGENIVouX2npcMw31/oGG7sYdpkb1KjvXT8OpJpiTMj6R8iWCFvFfaIJmsXgotxPZHkX
         2rGCFlSNHzwsaTIjpoWV/1eXIbfLFsgeDN/r6r5ryc5FvbAhs07u2gZu8BGd4sZNyynV
         buOg==
X-Gm-Message-State: AOAM531HyXuhNVW+rrtDXkcKnU8Sn8umBZ62eAQOaCBA6dpXfoT6ztUj
        lkeop126nHHvvgP4KETTC5U=
X-Google-Smtp-Source: ABdhPJzQxYMD6ED3vyItTfr3+KH21wd2coF0sEr2XvgMNrjO1G5P6FF5lP/RNtLGITHR9T0jJ7B2EA==
X-Received: by 2002:a05:6808:1483:: with SMTP id e3mr12400151oiw.83.1636118776298;
        Fri, 05 Nov 2021 06:26:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m21sm2250944otp.75.2021.11.05.06.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 06:26:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Nov 2021 06:26:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: crypto: api - Fix boot-up crash when crypto manager is disabled
Message-ID: <20211105132614.GA2791625@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 05, 2021 at 03:26:08PM +0800, Herbert Xu wrote:
> On Thu, Nov 04, 2021 at 05:18:34PM +0200, Ido Schimmel wrote:
> >
> > Attached my config. I can easily test patches.
> 
> Thanks!
> 
> Could you all try this patch please?
> 
> ---8<---
> When the crypto manager is disabled, we need to explicitly set
> the crypto algorithms' tested status so that they can be used.
> 
> Fixes: cad439fc040e ("crypto: api - Do not create test larvals if...")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> 
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index d379fd91fb7b..a366cb3e8aa1 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -284,6 +284,8 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
>  
>  	if (larval)
>  		list_add(&larval->alg.cra_list, &crypto_alg_list);
> +	else
> +		alg->cra_flags |= CRYPTO_ALG_TESTED;
>  
>  	crypto_stats_init(alg);
>  
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
