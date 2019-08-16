Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67383C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 12:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 310DD2086C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 12:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VtMZclr4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfHPMGJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 08:06:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40211 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfHPMGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 08:06:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so3885272wmj.5
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 05:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/IOsrDjCPmyiQgDW1R1C9KY/7Kx5j4J9045NMie3Pg=;
        b=VtMZclr4fxU+PcpgonzKmiHRNi6QFaED6r7NnI/wrNzrEZNdy5NajJ2uavTnjaQo8B
         uuE+WSvSYlLx7QCsULHayeUbuL/NKvwfSQGrWwIpbZU3M+C+r11NXLoTK9H9vA2UUi1Z
         oDFPgAfoTLZ612ATViVRt5GhxF+8yQKND/w2BuEphCynGqdxVQAhZ3mzUE1uAvoAejSw
         zzd+Sj9GBunu++S29wOpygJNw2N8SYYHv1gS2sI/Sk+Evezgf6wie8S6VbwVLNbVp4F1
         TdC5GBnn0Q2D0xOlEm8vSkqmChShzcKOTtUAyQfGtmvAZFChccDORHpV80SDX8cAYc7U
         7tFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/IOsrDjCPmyiQgDW1R1C9KY/7Kx5j4J9045NMie3Pg=;
        b=FsLD3uv9Www3jqG00vyT9uMErLsEPlozR6skQx5r+XTFsaDrx0MDMhNLSPDZKFn1ej
         gCgk8NM/vgv7+OX7b/zZ929IY/t445skMp4LIFyDzUzQ5hVXhmtxSWOEPtoWtcA4nqGB
         4e4M1Eg6IHvOoHuPd2SbFNqtZrRBW4avePdxAnRjOj6H5mV6W2GaWXKmXk/czvEmsI6C
         SBqR/A//B++Fy0oNTsLUo4n0o5iMQU623TdOv9W/xkgsPK1y6gEAOP7EE2LtPgaJNnVZ
         GcrTFxymrnBjH5iEPi3xw0KZfKHZSv1Xeeo0Bd9YfMu1WPRWyKbFFi1KoWRPGHK4+r7v
         fPVA==
X-Gm-Message-State: APjAAAUSP1eq26K9pj52158SJKis68KsNg9uCussyVrGXBvZojHE/7AI
        GDnmauJahMW3fuOXRa/McFl6J5PWAByl0AjLgM0zEg==
X-Google-Smtp-Source: APXvYqxAqDamDqzKNXx3HxiYFC96DGYrR9F55fAuVQt0SRECiobSQaWvk0megvlwswetTlZuzmoGNTog0gZ8auaSChE=
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr6892444wmm.119.1565957163582;
 Fri, 16 Aug 2019 05:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190816101021.7837-1-ard.biesheuvel@linaro.org> <2570709.znztaGfihb@tauon.chronox.de>
In-Reply-To: <2570709.znztaGfihb@tauon.chronox.de>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 16 Aug 2019 15:05:52 +0300
Message-ID: <CAKv+Gu_COGP0073-d3Ksmd9Sp_5qwN0HTDcfny=COQQTpP=PDg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] crypto: aes/xts - implement support for
 ciphertext stealing
To:     Stephan Mueller <smueller@chronox.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 16 Aug 2019 at 13:22, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Freitag, 16. August 2019, 12:10:21 CEST schrieb Ard Biesheuvel:
>
> Hi Ard,
>
> > Align the x86 code with the generic XTS template, which now supports
> > ciphertext stealing as described by the IEEE XTS-AES spec P1619.
>
> After applying the patch, the boot is successful even with the extra tests.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Tested-by: Stephan Mueller <smueller@chronox.de>
>

Thanks!
