Return-Path: <SRS0=Egg7=5V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B734AC2BA15
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 17:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86014206F5
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 17:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ew9379n9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgDER43 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Apr 2020 13:56:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44202 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgDER43 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Apr 2020 13:56:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id m17so14615388wrw.11;
        Sun, 05 Apr 2020 10:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=baFiJWDIXcDbqRxwMJ7sjjGENTtWwfmj+QDEOMNAPIY=;
        b=Ew9379n9xMZ0UhuAE44iezfeOMtFHGExzsbghmN1UPDmTEl1Jj4YPaBdyHT5H6dUPc
         eEZRPy0AEPX0lV6IM8Q5ezPof/RucQeZcv3vG2+wsGI+vGGS9Z7kiRR5evCGLOrklapM
         9XjMQn1dT+x3bRi4EWpwAXN9e3E275r/6d0BrxbO8jXFapcprOpsc1hrYwBDFKUX9q1/
         Z2Lkcdt2nfRmPi2ZSl0Zs8p/kKfrGpXydSIlbItSID91AX/poOE4i2Qzi8ZUq6gFAYXf
         57Pnf8j9KBduFhulx9aOm3MTA2swsxT9jVELk6LkTpgnM+Z18p+UbT3TZAqeLvZJC/DT
         hF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=baFiJWDIXcDbqRxwMJ7sjjGENTtWwfmj+QDEOMNAPIY=;
        b=dUkFuyzFcSZfOhAupvDVQWwh6JOXMnnUrE3dHeqTEWBP7lI6S6+g/LaD6JJ4ISpd9v
         rM1ZD4vdcctXFasppDoy1/ffcc5J4GqrR8LBe/MZZZHkgn38oSF7Zxkn8xdCrmZf4nXK
         VMckqJHjc5fCmDoKLJSzDzmSewER2jcGC50KIPk+gBkxQ9msCgC4qZLb89SRHkIfy+9j
         LEign8eu2ZwEddHXAafNT1rpWRpWXVqonQExfXXAP/pA8oU+Lf+W+xRjBcaxxD6eRj5R
         GK+/5I3/pvD7pPmPMWooxIBwZgoBBaSjSjd23J4/NpqEyiUOuGhLxTzvTQOcL3fqwEsv
         bGXw==
X-Gm-Message-State: AGi0PuYEqzsSz2I78fB+4B+pyjUATWwhm9YigrNy+McZiwt8zc3qQOg6
        Gjj5neD7QgFOc+IojrTF6s0=
X-Google-Smtp-Source: APiQypJpoHPcVkTc7Sbv9+VocdPMbPRFiuZ9btg2WSmTqQlCTwA2Qnv4W2UYnjlw4Hcm90XWc/aQkA==
X-Received: by 2002:adf:fdd2:: with SMTP id i18mr19348989wrs.165.1586109386897;
        Sun, 05 Apr 2020 10:56:26 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r5sm21037015wmr.15.2020.04.05.10.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 10:56:26 -0700 (PDT)
Date:   Sun, 5 Apr 2020 19:56:24 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chen-Yu Tsai <wens@csie.org>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: Re: [PATCH] crypto: sun8i-ss - Delete an error message in
 sun8i_ss_probe()
Message-ID: <20200405175624.GA24925@Red>
References: <c7e1193f-7d8b-7da3-a2a8-e92ca0fd83b2@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7e1193f-7d8b-7da3-a2a8-e92ca0fd83b2@web.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Apr 04, 2020 at 05:45:26PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 4 Apr 2020 17:34:53 +0200
> 
> The function “platform_get_irq” can log an error already.
> Thus omit a redundant message for the exception handling in the
> calling function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> index 6b301afffd11..a1fb2fbdbe7b 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> @@ -537,10 +537,8 @@ static int sun8i_ss_probe(struct platform_device *pdev)
>  		return err;
> 
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq < 0) {
> -		dev_err(ss->dev, "Cannot get SecuritySystem IRQ\n");
> +	if (irq < 0)
>  		return irq;
> -	}
> 
>  	ss->reset = devm_reset_control_get(&pdev->dev, NULL);
>  	if (IS_ERR(ss->reset)) {
> --
> 2.26.0
> 

Hello

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
