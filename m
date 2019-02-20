Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B42C10F0B
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 15:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91DE42086A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 15:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfBTPZU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:25:20 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38785 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfBTPZU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 10:25:20 -0500
Received: by mail-qk1-f196.google.com with SMTP id p15so2202783qkl.5;
        Wed, 20 Feb 2019 07:25:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PHFmPCfpFDSLjmOxBT4coUCppxIzjU/lbJI0xUw0R9k=;
        b=Ic2IL+1SdYlpZtfe9XdgYqxiLlXJgpGS9tRzzheoDcJtFscMkDXJ5Omsui6Geo8BnW
         OonygHNgRtzEADr/uWxqWWSkQ3jda17nvZ0oNvRwpm11hPNG3JWipUTQ3U5YyR51ZDad
         steuSNFC/Ojxalm6Kkmmx50IoeVsyByfJqwC7DkBXqm0gG+M0Qpb4UsY5n40MZMGMJeL
         40vPBsHBtP3gDdtCSfwP11AOv8i088hEXzyBhCeC7puthwaSlYJSbzCNWr7j0MrAYR/K
         l+CdfYnQxI0RwAEgnRcjE545i55H7wmRy8G+LKXJsSXHEyWCG6LyZwWQpIneVfz0txVt
         P2Zw==
X-Gm-Message-State: AHQUAuZHhA7sGRS74LxJWNwKeqUB6hI2lxsuDULtrut/b86SlcOSOiBh
        MbmzbxdLPVoPr/DHzl1ZEILnEEHewzAIBia+/S1H8w==
X-Google-Smtp-Source: AHgI3IY36PuceNa8RAnsxICV6zr3k5FR0qqd++BZ2TYtG76Hx5vtZ4NQ4ZJTlX0hEqpCEetdp4pEAlOVVd8cvzxYDvQ=
X-Received: by 2002:a37:7cf:: with SMTP id 198mr25294675qkh.173.1550676319414;
 Wed, 20 Feb 2019 07:25:19 -0800 (PST)
MIME-Version: 1.0
References: <20190219032240.22935-1-natechancellor@gmail.com> <CAFA6WYNS3JckLR3=EzhbbO9G-emjXnQTGAzY2j8QoAJsteamSg@mail.gmail.com>
In-Reply-To: <CAFA6WYNS3JckLR3=EzhbbO9G-emjXnQTGAzY2j8QoAJsteamSg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Feb 2019 16:25:03 +0100
Message-ID: <CAK8P3a11ZVxc803z2iRUiE3Q6oBYa4dVvFC343LyVLHHKT=gSg@mail.gmail.com>
Subject: Re: [PATCH] hwrng: optee: Initialize some structs using memset
 instead of braces
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 19, 2019 at 6:11 AM Sumit Garg <sumit.garg@linaro.org> wrote:
> On Tue, 19 Feb 2019 at 08:52, Nathan Chancellor
> <natechancellor@gmail.com> wrote:

> >
> > Fixes: 5fe8b1cc6a03 ("hwrng: add OP-TEE based rng driver")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/369
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
>

Applied this one as well to arm/drivers, thanks for the fixes!

      Arnd
