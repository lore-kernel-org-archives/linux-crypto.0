Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050BEC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC2C8250D6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C8fBezDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfFCGxA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:53:00 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42945 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfFCGxA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:53:00 -0400
Received: by mail-io1-f68.google.com with SMTP id g16so13398244iom.9
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/OVv2JhwjLJ/KG70YmS1Q3YmBooNaPanlPVgmCcKqcc=;
        b=C8fBezDgI5+xjtAl8slmv35N+UP9UohlRURo1vhsWWU6dOhvH9akBS0omClTSTTl8d
         JRoQ5VEs41N6N+l9F2QeO3AKVXDf3rAUpMb5aa+akXAo0PtMbAEKgvWRDtiFhdqDR2Nn
         LbSU7UYAbCIhEC/RD+QPJNbNInL1I4/tK5KFqdLap7azkExiYr9SSlYM7gK9swOpsZss
         81VcD8FK6FNlOOwbjpLaE5azDXTQmH39YnArxfO7GUMlodTf3MONkhnV9/uZcC2i3iqM
         9bitrwJhrjDxoXHK9kNN1LoOerTa6Ai7NAP3hedGHI7Zt3nnD9/cPXewAE0uXKpUKazU
         CFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OVv2JhwjLJ/KG70YmS1Q3YmBooNaPanlPVgmCcKqcc=;
        b=U20yKrRma6hf9W4vrbnbcJWnWt/i46rQQlu6KJEJ3LkmI3GMqLbE/bJKmFJW/MtPsB
         yo6oSabKc+OYgLs9zurPoc9hWnBnxcA2FAI4gqCP+vnXFs01ufuq7Qq8Yey+7LdPYPct
         YTqvX8G3+ggu0uDXnpBa0qEEDJmZDMizwGzUY0aBDj/MAV2vH4Mj1a3xsCFJlHlzXPJM
         yzLlzrGLuK29sfHX2Mzh0FJFD9RFZ6a3ty8Tm6Z9wg1MWIiRPYpIpdqSS0VIoqpSbmrR
         Mry6cGH4kdBUF4JAafUBFWOLJjhTzpdw1VRdpspx57Xq+F6RPU8FNF4tdJcA0NWY7XNk
         BWsw==
X-Gm-Message-State: APjAAAW/TAPOFZ0Q8rX3dfmakrkcOMCFXwvc83eFXVw6r0E4jbUmnZkA
        gnZrs1xghBVNYXTZtIBOrjDf9MkNnmmNT1/DfJPDuqVIAnzHVOR4
X-Google-Smtp-Source: APXvYqw40Ugpzb/GlV8TQru2YgihQ0DkZNKHcGMYyeVCP/NyVHiN7rB16or+qHoVV35XD8+QoAp7QYs8fuWuYNhiGk4=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr13836604ion.65.1559544779436;
 Sun, 02 Jun 2019 23:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054058.5449-1-ebiggers@kernel.org>
In-Reply-To: <20190603054058.5449-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:52:47 +0200
Message-ID: <CAKv+Gu93wdEQoRo_9vRuwsQOsNFYEYG_40k+a8C-uYA7A8ZHTA@mail.gmail.com>
Subject: Re: [PATCH 0/2] crypto: make cra_driver_name mandatory
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:41, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Most generic crypto algorithms declare a driver name ending in
> "-generic".  The rest don't declare a driver name and instead rely on
> the crypto API automagically appending "-generic" upon registration.
>
> Having multiple conventions is unnecessarily confusing and makes it
> harder to grep for all generic algorithms in the kernel source tree.
> But also, allowing NULL driver names is problematic because sometimes
> people fail to set it, e.g. the case fixed by commit 417980364300
> ("crypto: cavium/zip - fix collision with generic cra_driver_name").
>
> Of course, people can also incorrectly name their drivers "-generic".
> But that's much easier to notice / grep for.
>
> Therefore, let's make cra_driver_name mandatory.  Patch 1 gives all
> generic algorithms an explicit cra_driver_name, and Patch 2 makes
> cra_driver_name required for algorithm registration.
>
> Eric Biggers (2):
>   crypto: make all generic algorithms set cra_driver_name
>   crypto: algapi - require cra_name and cra_driver_name
>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
