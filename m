Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CCDFA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1842720854
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BAyU5dpl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393402AbfJPNBj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 09:01:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45729 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393401AbfJPNBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 09:01:39 -0400
Received: by mail-qt1-f193.google.com with SMTP id c21so35867808qtj.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 06:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jnE8lBSLY3wNnqyY4G8WlYMgwsueTd/EoUksCVuD65E=;
        b=BAyU5dplrFadafcQV8wzsDzA1AsMPOKwhq1dJebWhm730gL3t0WiDFQHtMnfwYBf5T
         4Q3eSK6Qq4ex1FD2/Q5f/ZdJRQSYJ1upnqdfq3Y9yHAx9LPaJFHmMZqahRBIUgFvjzG7
         kyskQIhOvG9uaorqTV6HcCGjVmLrbZ2w962+QDCXzJ0IcaDaXG4uCWBfNqNI7CzZMpMm
         KfYK2f7WJ819fImO5EARWvL30f98knyldXDIOVxA13Gm0P7QnI/xQLDZmA5o0ZP+3CEZ
         7FaSVGt6ptwWaA+rQepImmf1YT97mShCV2ZnEtliGHHwPrzqBbDrhpGaTFsBaPbXHvGt
         4Rvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jnE8lBSLY3wNnqyY4G8WlYMgwsueTd/EoUksCVuD65E=;
        b=KFWq9kCwydpwpMaBjvSys3HTFhc6yfhaBDNJcXMokZUwoevAfZ58MkIGYldSH8SuFK
         8I/Kzy+pQ30objq/XuAzbzOtMJ4PvumAxFDpzcTKKoa837UlUBMHicsVDXup5kLzb32s
         vUgQHoap6CanijkHL2xG6x4x9IV039BGJzfugimQbkBfWXv/1ExDBgqLg8zqulcTwahz
         5uSPizPqgnl99oyOha4oL0O9cA3irXgFtUjb1JfD1OK/y/L8pvs+tFOBZsxXwj+ZxnYx
         vgfco6vAgXk8r9rmYce066HIc6m9VzIPv/nCCANYlkGzqPabf99Nt+zi+g/xYQSIdU7m
         x0lw==
X-Gm-Message-State: APjAAAWekt6kInn5ugXb2lToT+CdZ+5Y+URFUvG4hyAgpPdMIwregW0L
        FaM6k0dRb82yt1Yy+sX/wEo3I32RDA5mq6mx4+52ho9E
X-Google-Smtp-Source: APXvYqwW5pJtOTNrnLrO03T1G9+Fcg/NuG1gN7wmIq4pJ8cxsc7jBg6TJfq5ooHjs4qjHlf1A3fmee9vr4kyD9kiJvg=
X-Received: by 2002:ac8:2a38:: with SMTP id k53mr13105733qtk.387.1571230897593;
 Wed, 16 Oct 2019 06:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org> <20191014121910.7264-7-ard.biesheuvel@linaro.org>
In-Reply-To: <20191014121910.7264-7-ard.biesheuvel@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 16 Oct 2019 15:01:26 +0200
Message-ID: <CACRpkdZVTG-kKp0790uFU1-SRsq5tZ1ibPqm7hoCqXHJVYfuGw@mail.gmail.com>
Subject: Re: [PATCH 06/25] crypto: ux500 - switch to skcipher API
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 2:19 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:

> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> dated 20 august 2015 introduced the new skcipher API which is supposed to
> replace both blkcipher and ablkcipher. While all consumers of the API have
> been converted long ago, some producers of the ablkcipher remain, forcing
> us to keep the ablkcipher support routines alive, along with the matching
> code to expose [a]blkciphers via the skcipher API.
>
> So switch this driver to the skcipher API, allowing us to finally drop the
> blkcipher code in the near future.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
