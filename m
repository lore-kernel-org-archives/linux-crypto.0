Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B71EE6456
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 10:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjIOKis (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjIOKir (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 06:38:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044E819F;
        Fri, 15 Sep 2023 03:38:20 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68fbbea0dfeso1638381b3a.0;
        Fri, 15 Sep 2023 03:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694774299; x=1695379099; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y9qd5TG0mLAAIWzVGk4wlbnBM+V6JIF27KgRj2Toq+M=;
        b=kMEzTLSjoQ7qIfSsrFMS6EHuTJDPTT/7FxKcx2LRFZ2A2LQnvwKOyerLlLqAuP9GMY
         fACwiUcLmLLlkHDxiJZlfRw4+1S+KftJApKjNPJWu2qKnraRVRrvmtz5q1Te1sX8o7hS
         1iu4t5+64PUOolLT2qNHng5cSa6C7GEQ1j8yiBHnZmU4IffiiqCdrW6JUj8poEoI99Bc
         MCD0hFv+zroekSy2XcBuwJwQAg9Xfekw1dQy+1KeoZlPlw1riOKgqd2y4jHg6NIuNP1J
         lT3QcJbD4FaVWFApDZDuPBM2Y7v3zjJZRgHavmlXcfIgvRQME3wOmYHpfXQ8XHwCD+8/
         lTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694774299; x=1695379099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9qd5TG0mLAAIWzVGk4wlbnBM+V6JIF27KgRj2Toq+M=;
        b=dotTG9yiz8X4xv7BcouIQ8Avwo+Aej/HL1zt8alOcCrF9sUHZPGryUOAALkZnFBpPY
         AqJ1qE46Pc3gpJJudVgDLy5De4YqP0yDNgpmvidNNFOtlblhee+jhQ+yP6g4JGRU2gmX
         g9lB3Eq+xdjDyYmnYjXjETjmwGu+oV5znM64DaZ3WKR5IkvJK8x9a8INIeBh2L2tRS2h
         GGkeH99m8m9Q84LbiOkw0AKaQjUeAhscPflGPh/6XZkaU+NGXM/QPxJSxfrB9AySQciD
         YdoSpzCBnSep13nYOn+NjWG3eZlmCuZCaKp+na2TSdXbRtUDXOxTYAGJi7UtQ35eM/jc
         9C1Q==
X-Gm-Message-State: AOJu0YzbaHssgKaJjevAbxsHlVOkwbB7t6qta/KzvKoDmwnofz468wSH
        F/L097T6bE65+/oSpsN2z7w=
X-Google-Smtp-Source: AGHT+IHFoOuhtVid+hlwjtb0Ho5WGWJ4gxnlHjsWUVJk29eZz5y5ViZErdFA+6wq5e3cUcotktuHuA==
X-Received: by 2002:a05:6a20:430d:b0:14d:6309:fc96 with SMTP id h13-20020a056a20430d00b0014d6309fc96mr1237272pzk.4.1694774299429;
        Fri, 15 Sep 2023 03:38:19 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a1a0c00b0026b0b4ed7b1sm4946696pjk.15.2023.09.15.03.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 03:38:19 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Fri, 15 Sep 2023 18:38:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrei Coardos <aboutphysycs@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        yuzhe@nfschina.com, u.kleine-koenig@pengutronix.de,
        olivia@selenic.com, alex@shruggie.ro
Subject: Re: [PATCH] char: hw_random: xgene-rng: removed unneeded call to
 platform_set_drvdata()
Message-ID: <ZQQ0Gj66QwS4wQkg@gondor.apana.org.au>
References: <20230828102329.20867-1-aboutphysycs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828102329.20867-1-aboutphysycs@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 28, 2023 at 01:23:29PM +0300, Andrei Coardos wrote:
> This function call was found to be unnecessary as there is no equivalent
> platform_get_drvdata() call to access the private data of the driver. Also,
> the private data is defined in this driver, so there is no risk of it being
> accessed outside of this driver file.
> 
> Signed-off-by: Andrei Coardos <aboutphysycs@gmail.com>
> ---
>  drivers/char/hw_random/xgene-rng.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
