Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185A6C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 08:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCFI24 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 03:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjCFI2z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 03:28:55 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0F8A5EE
        for <linux-crypto@vger.kernel.org>; Mon,  6 Mar 2023 00:28:54 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-53916ab0c6bso169791057b3.7
        for <linux-crypto@vger.kernel.org>; Mon, 06 Mar 2023 00:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=519NpLUqxOKWPBwAuOC9bU9ZvrYJvgJKHiIp383stmI=;
        b=W3sGp9tNOLk4oOb1TbBhmTVgOkfoc3jNvYh/DHNAvPgy67bZMPKLQWxrpJ0zDdcp+m
         S3wh1xHQnwUyPdXvJ2fnkADVNJh2ucQuqk4rR7iDOAB1VWSAMBZ3P5S2esv8D81mx3FE
         ySbGrtbzeZbdtXEo3ZG24oQN8iTy8LnSxuKH8dw90uG1ciqhzoJCBWUZhZsfgiv2IoPf
         aMVk4WiNShz8IChoW/yMstyhaBVYtGJ+MTlDC2Yv/xDdfulCssgz4JYckicGNUKxZrb+
         YrQT7vimpOgsn4RLRyxeyCJ1YxtNjprHA6SvcTTjvdn0BOvpVeUsEtY2+pqoxK1Svzc/
         TgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=519NpLUqxOKWPBwAuOC9bU9ZvrYJvgJKHiIp383stmI=;
        b=oN9Kd89luQ+kNUyyt3TxMjPpIesEj+8X3OP42seo/vJOn708jeNbVZBZe2wfZBV2pL
         PZWtn1cfA8tSgCplu6H+Wivv3TqS8ZlsfMMGu+u0ZEqikd8U4Y1qbPLDPEvIl9tIgy/O
         1TMJhR+eYoynNPwEtoBJEm11Tgxi/wxsGbv/HNmqAtG078TwAlq5L+g1/YFEBaz3vF0U
         DxMITpDPsyFkNWST+kskVUxrdxqs+Cn0MCCuhUhwlUujj+nIHR+Dg+/BUV+ypSmpa0xw
         zQ0ws8QTjpI9B9axNiQNHhetTe7bMBfnU5bD+Wv/5bB+fz/1wu2wk7hx6pAdu0GtimUh
         Xs4A==
X-Gm-Message-State: AO0yUKVrQLGJlZR05XWoFvzCMzX8jtcmGQLuMEJH2g4uLLYMUvTpTWaO
        VtlHvRgYQ9m9WwDBEO54Y9J+GRv43baYKxyJJKmLisofyXFxtfb2
X-Google-Smtp-Source: AK7set8qJpcrUyUWuXm2GtgPYfVJIrTfSr7hyswBMwx4xoG28NxTC5y13Rie+RRDGbzHFSPGeKUBnzA9auOnDQ4Aey0=
X-Received: by 2002:a81:b624:0:b0:52e:f77c:315d with SMTP id
 u36-20020a81b624000000b0052ef77c315dmr6476228ywh.3.1678091333277; Mon, 06 Mar
 2023 00:28:53 -0800 (PST)
MIME-Version: 1.0
References: <ZAVu/XHbL9IR5D3h@gondor.apana.org.au> <E1pZ2fj-000e1B-Kg@formenos.hmeau.com>
In-Reply-To: <E1pZ2fj-000e1B-Kg@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 6 Mar 2023 09:28:41 +0100
Message-ID: <CACRpkdbfttwCoMPQATNkj1_sbhs1H_s7vfXRQbW_dDf4d_dUBw@mail.gmail.com>
Subject: Re: [v5 PATCH 3/7] crypto: stm32 - Simplify finup
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

On Mon, Mar 6, 2023 at 5:42=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:

> The current finup code is unnecessarily convoluted.  There is no
> need to call update and final separately as update already does
> all the necessary work on its own.
>
> Simplify this by utilising the HASH_FLAGS_FINUP bit in rctx to
> indicate only finup and use the HASH_FLAGS_FINAL bit instead to
> signify processing common to both final and finup.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This "v5.5 version" indeed works!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

I had to pick the patch manually because Konstantin's b4 tool
got completely confused by the version numbering and picked
the old v5, but once I got the right one, all worked fine!

Yours,
Linus Walleij
