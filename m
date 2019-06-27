Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E35C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 11:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 611E52085A
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 11:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LLlSktgg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfF0LAJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 07:00:09 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40476 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfF0LAI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 07:00:08 -0400
Received: by mail-io1-f65.google.com with SMTP id n5so3741358ioc.7
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 04:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bccD3CY+ZihZmVNDRSFt5dJb8GAe914d2ffUA0KhI5E=;
        b=LLlSktggTIkG8q6jlvkkgqmdi7cJsRFMs6gc48pHJ3DBUVRpgU9nVUr5fVoH9+E3as
         27dqx2E28nM2sXw5ZeZGkuhzTgkKP2E2Nv/5t2FK7POnA0R21F7NxZdyNUCm3o3B1iPr
         VrRuXzacC9IMb1wblx7u6kK1TmbsSVK9oWa9pUUpeJ30wUGbXq4MScuHo9EFHiTvXH+V
         iEibwmaT6vCxtlb+hepg/0rsZPd21SeAva9NUwA4S3pHXjFqMtcMyszUB9I+QjPKMGPb
         hKjBjApIApOxPYFrqbLkQZ8JXac360iF4uG+/rsgrQg7aYuT6btv/0Rn3wnm0yjRLrr2
         yNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bccD3CY+ZihZmVNDRSFt5dJb8GAe914d2ffUA0KhI5E=;
        b=YKn6jDu+mN7IH9KMyI2YsVpO9UD5zGfTZQebCu9f6OM3w4gLNjm4SdUKZR6bEd6TSK
         YU+ZvICSFNwn/SSqO/SCojoKY0khYH5mlLh5AM9wBlJDKkvF6yXxTd7NmdaYnuCehrSB
         TgZsA4j9StFkZGpWTmvXVOCbbQCqlKaOf1tkvOI7pGGgdUmqf00K9LouI5B8IdWvLkOI
         Sl+Mio28ulpVVu9TVYy4siPgkEXaWR4vXwly6J7TdB6r90XvGImPe5+GfTptKkL1h4Fo
         zuApIE9AXj/W5aNsrnCuUy77TJQ/5kgMCbW63PQ4pyLzzPwkOqBJDBgF2R4mmyRkzcSS
         NoZA==
X-Gm-Message-State: APjAAAWqpJjEDKvNVmP1dwx1JR7SHpJpwotT1BiHzxXaicuZPkyyWube
        TlY5aN2fd9tUmGhfe5leZ0giS2YjWJr4lMW8FflGzQ==
X-Google-Smtp-Source: APXvYqwFcLYN+ReFr/stTqs57u8bTPIfpYSHFy1WojOkAdADHcwRoclWJ0LCzVqXmlq8vWuWb78p/MI0udFWhZowgic=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr3659137ion.65.1561633207925;
 Thu, 27 Jun 2019 04:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-6-ard.biesheuvel@linaro.org> <VI1PR0402MB34856DCDAD66524FB58F165E98FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34856DCDAD66524FB58F165E98FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 12:59:56 +0200
Message-ID: <CAKv+Gu-v4ztQ+-FR_31GZ+sYO-a8d7GsJxY0BSjPmEmXDP+hVQ@mail.gmail.com>
Subject: Re: [RFC PATCH 05/30] crypto: bcm/des - switch to new verification routines
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@google.com" <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jun 2019 at 11:14, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 6/22/2019 3:31 AM, Ard Biesheuvel wrote:
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/crypto/bcm/cipher.c   | 82 +++++---------------
> >  drivers/crypto/caam/caamalg.c | 31 ++++----
> >  2 files changed, 37 insertions(+), 76 deletions(-)
> >
> Typo: caam changes should be part of next patch (06/30).
>

Thanks, will fix.
