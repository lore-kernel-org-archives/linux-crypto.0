Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB232C11D2F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6A720836
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FXnMe3te"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBXQkc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:40:32 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39055 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbgBXQkb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 11:40:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id c84so10165532wme.4;
        Mon, 24 Feb 2020 08:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iTjJbQqtwcZPIXecaEaZiFF1Xn8H3EV5tXJhCaPu0JA=;
        b=FXnMe3teoPr6pu+e9m1ZzCqlnHALTlI7EQnznms6d/iCyTWO8xqExwefnhmFcTl6cu
         yI9u/iXeV6PZuH4sYGsVZfjHWG8wLyJSs/R1fZiPbWE8E5cwpCbtr+qbPPBOpjAW5q4O
         hcQN9zSyYhx0sZp9LqIH7JrAuire1YmH5mw+Q4xvOezBYSRc5kHgaB+bpkDFP48AwwFn
         /5XO+Gd0dxxPxgIsiNAzSLqVD1KiAACTrIuK/ju8MNoMIfpHICnp5oEGLPL4Vn8YQrgD
         WU5XaGxXTto4vV/focnz93VSLWzkDxfb8sNwt0VB6wgbgfqHcOotUg11LLXrCSnBIB3g
         S1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iTjJbQqtwcZPIXecaEaZiFF1Xn8H3EV5tXJhCaPu0JA=;
        b=fJL2cVGD+JQeveJ2+yPt5BGgPWbv5KnpWj6+r0LgKgqQtNW4/yVK6LJUvxf8w9YjGr
         LdHM73y1kWnVuDmvhZStb3fPkt5En1Vk5v89A8sBQUhlk/Zj8KVHqtVlhVhCAdTIeLgF
         22xktIqK85Vb0cnW8uNG2akWObOc8fu/XOmkvI+wFjH5n9FJILsGhZ12EQkezxZyxSPq
         zx540+/6f/iBz9NP/z87LgvkCM9E6bWUCHlHinhRCLst2FzliKHRXoHrobVzWbRJUE+6
         S9euc3WT8ISAnRn7n4SzNiCKTG25tVW1yH/VMSkT9kXbNKZvwVZNCSHaWBJKdiInQJCV
         MUIw==
X-Gm-Message-State: APjAAAVfFlNv8nnQhvTOTMvo7WT7vWmbI+C00R28zpENS5LXJA+lMV+3
        9X1ZQRDfG7v+nkn/JeSgz7Esiex4tQBkhDgmaZc=
X-Google-Smtp-Source: APXvYqz1PFa7eYxHu8n2pwAXRIbHopxWJqwMVwhAXMhqkpBeiIXZPAv5LQdMm0SMO5Kuq6BMYNOMXM5zpMaptiAy9Jw=
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr23863553wmo.13.1582562428814;
 Mon, 24 Feb 2020 08:40:28 -0800 (PST)
MIME-Version: 1.0
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-2-andrew.smirnov@gmail.com> <VI1PR0402MB3485FF5402B8C0FFF48FBF2298030@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485FF5402B8C0FFF48FBF2298030@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 24 Feb 2020 08:40:17 -0800
Message-ID: <CAHQ1cqH1KOwna-8DxX1mZy4ua=56crHRXgExn0mrLZV=t2e7fg@mail.gmail.com>
Subject: Re: [PATCH v7 1/9] crypto: caam - allocate RNG instantiation
 descriptor with GFP_DMA
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 4, 2020 at 6:08 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/27/2020 6:57 PM, Andrey Smirnov wrote:
> > Be consistent with the rest of the codebase and use GFP_DMA when
> > allocating memory for a CAAM JR descriptor.
> >
> Please use GFP_DMA32 instead.
> Device is not limited to less than 32 bits of addressing
> in any of its incarnations.
>
> s/GFP_DMA/GFP_DMA32 should be performed throughout caam driver.
> (But of course, I wouldn't include this change in current patch series).
>

Will do in v8.

Thanks,
Andrey Smirnov
