Return-Path: <SRS0=WjNG=6M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF80C83000
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 10:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB3B206D6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 10:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJLlb8pG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgD1KKB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Apr 2020 06:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726932AbgD1KKB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Apr 2020 06:10:01 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C84EC03C1A9;
        Tue, 28 Apr 2020 03:10:01 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id l19so20827704lje.10;
        Tue, 28 Apr 2020 03:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19uFzSxLeuYQo/dKtnMC70gpecW9P25YRkIG/IdYFis=;
        b=BJLlb8pGzYfEp6GzCKqh5hyRb9Z+CFHu82/QjzKSLTRBmYUaEzwgh0qywfT0Sblbp1
         omsHg2O5c7shROC3AUhKXNpufAPD5s+ItTFajDZQBJkaT6+HjvfMzn2r9547lElYxoT+
         gDIrVOfSQnJTs3hlqn5534veK7YCvfZ0QAyYstsR48rq6bYRM5WDFTB7k6X3i90OiQih
         hTZzRtKcAYdNVbw8q6eTgiNIjd6cRs2StGDirAjC0hmbQjN85xMB4CNayu6CiBkRE+dO
         CygZEHFQ7LtOVzcPxnHBuG0HSQ7Xl2p64VntOXCWtUgX94zMzb+VVvvxhRHLzpBfiD6x
         Mc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19uFzSxLeuYQo/dKtnMC70gpecW9P25YRkIG/IdYFis=;
        b=SYjyLGto8fN7Moeiw6SjTpS9NWPsB9ZDou824L1Dq2wZywQqq4bk4u61SUrGwn+5GJ
         42AXzj0Z4bxzV+JWWySfxcFtJxuEfqtcElLkBdLx0GSqBzHfkDxJvjpxxyYOgmasyUnT
         q3opn+T6Jwn5Umw8ELsHEVZoRmlrHxZ5WKS455Tnt/sCXqH0LFXFB8bET/BScgEKt80F
         8qsNaHGw/9m+z9lYL3hYm2WvxiuaQx79fU7bMQcTyujpuimaUmJPFrMH6JzyNNkMXYKw
         c3pl7PbKRWp5ab3GlVTkqCo/v57VTfrEllYHe0Y3AmHSVLpHDv7je0vTeCt7VRYhbPMO
         udlA==
X-Gm-Message-State: AGi0Puavw3WIsuFIxPGCrlHXzLiRMeA4MP1QvlSdl+1XwNKIDeKbRSMV
        C5VtEZJ4nyUJZmOA2J+pQfeb+W3eo1pyi8RhgjO1rw==
X-Google-Smtp-Source: APiQypJe2PkJOFZo9zF8z5P0O73Y7zbxiut5ZHV8HfaSyjKy7JscKmMYL/c5BV3VIprd7rb3JSoj0nmvvew7v+yHzQI=
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr17471735lji.44.1588068599776;
 Tue, 28 Apr 2020 03:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200428051427.508-1-zhenzhong.duan@gmail.com> <VI1PR0402MB3712A2A328540479261ACCA68CAC0@VI1PR0402MB3712.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3712A2A328540479261ACCA68CAC0@VI1PR0402MB3712.eurprd04.prod.outlook.com>
From:   Zhenzhong Duan <zhenzhong.duan@gmail.com>
Date:   Tue, 28 Apr 2020 18:09:48 +0800
Message-ID: <CAFH1YnMW8YSyiBg6+A8QxYfroVEZr_KELpXcogPemvM=aNFD0Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - fix use after free issue in *_crypt_done
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 28, 2020 at 3:48 PM Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> On 4/28/2020 8:14 AM, Zhenzhong Duan wrote:
> > In both aead_crypt_done and skcipher_crypt_done, edesc->bklog is
> > referenced after the structure pointed by edesc is freed.
> >
> > Fix them by moving kfree(edesc) to the end of function call.
> >
> > Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
>
> These issues were already fixed, and applied on cryptodev, by this
> series: https://patchwork.kernel.org/cover/11476799/

I see, thanks

Zhenzhong
