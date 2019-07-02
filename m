Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2071DC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 10:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0ED420659
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 10:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqmSjMPd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfGBKM3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 06:12:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45240 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfGBKM2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 06:12:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so17055406wre.12
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 03:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IGo3x3nOUV8uiivQ2NiTogvfdrvYXscNtKg4aEB52G4=;
        b=HqmSjMPdCSrtgoX45iYnvwGqQBj7SMdI97zobIsCTF6y2ws0/trF8RPPXRVbKqpd6b
         Lh90lJH56Sd3/pqKZ0efvSywtMwThqoLnmi18J/wG8ZpqWWc2mghG5LtBXsj3pzp8u4R
         EcYWmx+6CxKA1eI3IYF6uEbPQphUMniyVGqY3PHD6vzFbL/huPI8p+kf3+esbw9eV5Yj
         Vn3IbqrTJnGxmsHwTwdjjouXRVHS4A2ZCOQDmJ8clP404KNWB1aCo9KEJ6/IivDrMOcb
         nzYemXeaEUWqMq4j8S6lxFs4rXok74nVogv219+EmmaMHx0lUaDhUrkn/1uQTda2Uv1q
         pTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IGo3x3nOUV8uiivQ2NiTogvfdrvYXscNtKg4aEB52G4=;
        b=qTZ5S3GecvPSljKvTbesfuoZN30G/MXIoRb0KbbB9DZPjY729kiP9D/dKIw7sYqNdm
         zyVw8JreU5E+gfvn98v4tOuTLreToUcbr5YVeg22bVGFmwc6XoAJiLr23Ib2v4mSgL7p
         z2IxROxyjG/5T5QXS3dZzrZW4chGTaPJ9hRUobXYQEd1143GJv66AFK7wQyXOT+ss2OT
         Xkqw8lVywZG6WmdAbxyufO5mKdgqdr2q3A2t04OfJHCRr3Ey2RwO251D032Sr3I3tfaO
         27Grxo3bMKg1vyBWUUQ4HQruXZLp75S3uc3uODU1wqdM2Y8p5dAe4ZXJC89ujxqhwnl1
         UZYQ==
X-Gm-Message-State: APjAAAUwrb7uCX0tVsFFLLmiGASTa2v6ppzcYTruaXY/Hkhm936uE7U6
        sNwKldNhIfoN0xQD5hwjXWc=
X-Google-Smtp-Source: APXvYqwUDg6Zj8YxLjekEuC6d/lCww0rtuHKeBN51OV2hWXwa0LhWX7OoFTL+7WuIKMvjN1LvqMjqQ==
X-Received: by 2002:a5d:6b90:: with SMTP id n16mr12395880wrx.206.1562062346815;
        Tue, 02 Jul 2019 03:12:26 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y6sm13010608wrp.12.2019.07.02.03.12.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 03:12:26 -0700 (PDT)
Date:   Tue, 2 Jul 2019 12:12:24 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, horia.geanta@nxp.com
Subject: Re: [PATCH v3 22/30] crypto: sun4i/des - switch to new verification
 routines
Message-ID: <20190702101224.GA22093@Red>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
 <20190628093529.12281-23-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628093529.12281-23-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 11:35:21AM +0200, Ard Biesheuvel wrote:
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 26 +++++---------------
>  drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
>  2 files changed, 7 insertions(+), 21 deletions(-)
> 

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
