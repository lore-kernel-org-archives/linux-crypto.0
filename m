Return-Path: <SRS0=1Cfx=ZR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39809C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 13:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA39207FD
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 13:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hpo3eFol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfKYNV7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:21:59 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39201 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfKYNV7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Nov 2019 08:21:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so15936134wmi.4;
        Mon, 25 Nov 2019 05:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XisBj+SHJbeFlx51siwRmqy/2+k3IdPy2jfS+lbX+WU=;
        b=Hpo3eFole4LX3/xR2wq8eIO9zNvhWa7DApoERFxPKn741QUXhIZEJFt+omGwMoUeQO
         0RJsSRyALTAqaU3p6ls7mZIrs3gL3WI/jf3uKyhnpinMfqVDUN4lOlfKigs9zgGLkp5J
         WzVhjDLtZbroOh/rH1/uYeyCWd8PBFbSK+G2pi7CkaV2ORBPYA3iX3CzerHUxs4imMDl
         i/m5vsp/OLPyiKq+3RHhhlXts2mVdo5SQWU+VEuhib43Dux/sFkB3jkUTVK7jwQN3RUn
         FOW5Dh0ysE3z7s7NJBuvpAwBDGLj8Q1NYFiY3tOhflaas7LTVE0p+t+XPcH4NLKYqzGI
         X5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XisBj+SHJbeFlx51siwRmqy/2+k3IdPy2jfS+lbX+WU=;
        b=pxFGLg1Q7zTlgH88NQzuVZKv9gX8vAxors5WiLpQLzrVJ/s32dR8EidR5jgSzsYgDd
         FjATzzEERqdxZzKW7g9OCl0Cx+aDwjVY9mnTTxJUoAy9om1t4Rqolbll0faJcDkKj2oP
         Ie5yCYrrsyF6l9+fpxabeuFt+edBLPdIUSZt0xmQfmMGALwTk+0/TM5vC/vbXXlezkR3
         AkUBf74yZ/wjaKPr3cKZbqB9QIwYdQbObQxmWRYGkkJLHVRICL8nDrmp2vn9eyMUmu5D
         9YJKi+dimhIXWdCuCF/1WGp+Va00F3LVV2GC8Yw1W2Vmb+ZpvVafWdfIVHIQLuA8hK4K
         b49A==
X-Gm-Message-State: APjAAAVfuUHtsV8uyU1AoeoE1RlvByUelPesNaLzuzPTLyRVssV1EX08
        BbBpuRwcRRF2bwAFy1kTBcsj/S/DKum5NWHe2sRi9zxQ
X-Google-Smtp-Source: APXvYqyV2/1Akpai96D5l6b/PzFqLjE/Cc5Dr29NqCBC6eX6bugdkgBkeDIX1SL3YH9cXndnjXWR++vMb/E50wEPcig=
X-Received: by 2002:a1c:720b:: with SMTP id n11mr26892459wmc.60.1574688117019;
 Mon, 25 Nov 2019 05:21:57 -0800 (PST)
MIME-Version: 1.0
References: <20191121155554.1227-1-andrew.smirnov@gmail.com>
 <20191121155554.1227-2-andrew.smirnov@gmail.com> <VI1PR0402MB348579B485FC139EDA222B0C984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348579B485FC139EDA222B0C984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 25 Nov 2019 05:21:45 -0800
Message-ID: <CAHQ1cqF_SW16_cvxpDmn6kYoLQDy7CBRfkftUs=u7gR8SQ=MTw@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] crypto: caam - RNG4 TRNG errata
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 25, 2019 at 12:02 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 11/21/2019 5:56 PM, Andrey Smirnov wrote:
> > The TRNG as used in RNG4, used in CAAM has a documentation issue. The
> I assume the "erratum" consists in RTMCTL[TRNG_ACC] bit
> not being documented, correct?
>
> Is there an ID of the erratum?
> Or at least do you know what parts / SoCs have incorrect documentation?
>
> > effect is that it is possible that the entropy used to instantiate the
> > DRBG may be old entropy, rather than newly generated entropy. There is
> > proper programming guidance, but it is not in the documentation.
> >
> Is the "programming guidance" public?
>

I don't know the answers to any of those questions. I am not the
original author of this change, just ported if from NXP tree because
it seemed important. More than happy to drop this if you think it's
bogus.

Thanks,
Andrey Smirnov
