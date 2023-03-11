Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0BDC61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 21:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjCKVp7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 16:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCKVp6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 16:45:58 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536916781B
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 13:45:57 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id e71so68035ybc.0
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 13:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678571156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIO3rO4aGCtwUEkB8d2zjOpDq8nsRdAWUmtEv8HqUxo=;
        b=tcydFMereuu6QiVey96AVlVmSth/WTgNtXhO9Ex+Fvikha6efmOWzBJk6/nlCNnDDx
         QMNI0FigegqadxnzYIGjfGHURM0kNb6Mny+7st4f867ym/B9npZBSZWLoG80BScSKtBS
         DQnflxWRufkNTJf3mCTWRnlc2Lw+NhDHX97JB+rtzrVhWnGh9o3s7AOjrUSaeBqXKE7O
         HT94zNppNjMfYW3lHuA61ZHYfLxYlkqhEWFaAP5F6vkdTgdcPYq3dPid771R2OuomXoY
         IKypPMFuNgvFqT3oX4T8XRkOPkPLOInUZrEM/Wmkxk0ZEkjZrAq1B3weXd9zSB/rYSH8
         XpJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678571156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xIO3rO4aGCtwUEkB8d2zjOpDq8nsRdAWUmtEv8HqUxo=;
        b=OZYJ+/tn0IYDciAktGRb/FM1fy0NJqF36tGwxEN2XScibNDnxdcs5ZxK/YtmXCqx6g
         SObnDCuYwrYYwDlD2IqEkyQ5GlXM2K9CpwHHp5Lu3lh6keRB+IywXxWn4iZUV4PWn1jn
         RnCEV0NJUyEgvRUYdJe7yVclbjStiVdbocLjVHTx6+YcJh8A9JJZxhMBRqFPNPZRUjPL
         bQS6qsC2OuI6CL96O9bXZYtpzTBz61RdDtV1q+F5Lj0GYQ0sWzr8EbLgt6z/0hoEe1+n
         YdY2uKOlTUUCuysNzSHv/Rm/HcOvccbizunqitmkic5YB6Cx1jM8lcXktGHLHmNKsbY5
         dsKw==
X-Gm-Message-State: AO0yUKX6H5Gwv4uPCL1wRMMWyrnYr8HOGzqKvNAPFeeUI8mCrV0rx9hA
        jB7fntPO3ReHALYLf+SqrqroNSKMGNJhEh77fctL4w==
X-Google-Smtp-Source: AK7set97TRRn5zro0f1CokXy1dp6GtRXg6jzkXUSAR5uBUJ6eQKiMW5l+rX3fqvk3vDUcvlZRQ+1eNhDn+TE93s9NLg=
X-Received: by 2002:a25:e201:0:b0:b2e:f387:b428 with SMTP id
 h1-20020a25e201000000b00b2ef387b428mr4074930ybe.5.1678571156557; Sat, 11 Mar
 2023 13:45:56 -0800 (PST)
MIME-Version: 1.0
References: <ZAxFBR3TdA7jUAgJ@gondor.apana.org.au> <E1pavED-002xbf-LL@formenos.hmeau.com>
In-Reply-To: <E1pavED-002xbf-LL@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 11 Mar 2023 22:45:44 +0100
Message-ID: <CACRpkdav9u1_YR7mc9iz2OR=6itHhgGBFobZdtniZ7TttLY0Tw@mail.gmail.com>
Subject: Re: [v7 PATCH 8/8] crypto: stm32 - Save and restore between each request
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 11, 2023 at 10:09=E2=80=AFAM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:

> The Crypto API hashing paradigm requires the hardware state to
> be exported between *each* request because multiple unrelated
> hashes may be processed concurrently.
>
> The stm32 hardware is capable of producing the hardware hashing
> state but it was only doing it in the export function.  This is
> not only broken for export as you can't export a kernel pointer
> and reimport it, but it also means that concurrent hashing was
> fundamentally broken.
>
> Fix this by moving the saving and restoring of hardware hash
> state between each and every hashing request.
>
> Fixes: 8a1012d3f2ab ("crypto: stm32 - Support for STM32 HASH module")
> Reported-by: Li kunyu <kunyu@nfschina.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
