Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51255C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 00:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E28A61355
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 00:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhETAFi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 20:05:38 -0400
Received: from mail-oo1-f43.google.com ([209.85.161.43]:42782 "EHLO
        mail-oo1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhETAFh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 20:05:37 -0400
Received: by mail-oo1-f43.google.com with SMTP id v13-20020a4ac00d0000b029020b43b918eeso3398142oop.9;
        Wed, 19 May 2021 17:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VelUL5MXuP2To1E/8nN6I3+q3PZvbe/mxHKHAkgvihE=;
        b=natrO9iTBjAonPqGiCUC7D0lZQlwFx4WuDbBeSkyHkPpNvhWMKNjZOmUcma+ESkM//
         XS7PFyjLqAesAVGzxbDwzOWwyx6PvMU2unNJBHdqHWEFQO4vyPvmR5RYGcK10HVgOHzx
         yzep3GVNDjaAJuWCbneyWyR+Bs0tQ7/oq87Sr2p6CKZ26yxZF9lM8DHRk5RjT1+WGCgw
         Cx6zY4d89gkDBhq0CPZLl/eMS9ykZElnZi7CfaM0BVY03LJORGOVCDhJUEUkgBjLKJFS
         Z6nWrmBPsyyzupwyfVtYqBMKYLMxmeGracXbJaRfPawaJc28ZIMkbqvJDXxnaesGQYFs
         S5gQ==
X-Gm-Message-State: AOAM53239ZGoNMUu/LgLdVAb9lCJkqi8w7rwC29YpQ3qg9t7+bJd8E3i
        Q7yqBJcvqHoWD1QWm0itLbYku1sLYg==
X-Google-Smtp-Source: ABdhPJzAhRPNx+KYap3sAh7MHV7kxbGwqa5FzdKK/ptx4G8B4zL36npqz/wkXR3QkICcaFuPL2cXVw==
X-Received: by 2002:a4a:dc4e:: with SMTP id q14mr1576291oov.43.1621469056126;
        Wed, 19 May 2021 17:04:16 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i23sm228104oik.22.2021.05.19.17.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 17:04:14 -0700 (PDT)
Received: (nullmailer pid 3924438 invoked by uid 1000);
        Thu, 20 May 2021 00:04:13 -0000
Date:   Wed, 19 May 2021 19:04:13 -0500
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <linux@armlinux.org.uk>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] db-dinding: crypto: Add DT bindings documentation
 for sl3516-ce
Message-ID: <20210520000413.GA3921068@robh.at.kernel.org>
References: <20210518151655.125153-1-clabbe@baylibre.com>
 <20210518151655.125153-2-clabbe@baylibre.com>
 <CACRpkdZ5ced+S6fQBAMeMuYhC3RN1q88DLyEr=gaPO6h=i26vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ5ced+S6fQBAMeMuYhC3RN1q88DLyEr=gaPO6h=i26vA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 11:38:38PM +0200, Linus Walleij wrote:
> On Tue, May 18, 2021 at 5:17 PM Corentin Labbe <clabbe@baylibre.com> wrote:
> 
> > This patch adds documentation for Device-Tree bindings for the
> > SL3516-ce cryptographic offloader driver.
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> 
> Apart from misspelled subject "db-binding" I don't see any problems
> so

And try not to say 'dt binding' twice in the subject and 'documentation' 
is redundant as that's all bindings.

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Rob Herring <robh@kernel.org>

> 
> Yours,
> Linus Walleij
