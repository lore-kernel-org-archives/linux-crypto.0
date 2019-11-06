Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCF3C5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 06:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C38EF217D7
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 06:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="WF6MzreX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfKFGYa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 01:24:30 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:33755 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfKFGY3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 01:24:29 -0500
Received: by mail-ua1-f65.google.com with SMTP id c16so6982235uan.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2019 22:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=swSoo5LLOSCM5bOAtsnpGaTfz+1I0oOUgretE9GnF2U=;
        b=WF6MzreXKdUcr4X4hpIfWE4By2VUvgZha5ey5ooELyQVdZiJVV4595g6nRcyOO+/0w
         OdkRfogIBsLlTCkmk8Sk0d/GR7DBTmI4KI7s5p4mjeZG2ouwxHqc0Lg3tUqqdvUaOu58
         mbHRP1Y0D6jr7Nn+iO/3WNEFw+9p5P+O2sr6IMD7dj62lSVhjDmIAYdNWQamQJIevBZp
         BqQuDbzZNtPGoiCAywtG/ITYW122jFxlnzpNOygga82jQ4mytY8Mwvbfyt9iqQ15RWjp
         9yFlNx6DxiCpWisF8Smfv/8kW02UW576i8Y9xNho3Lvx0Mnkx0v9D5JKzawHlq9UnuD4
         uMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=swSoo5LLOSCM5bOAtsnpGaTfz+1I0oOUgretE9GnF2U=;
        b=M1sP/f2cLD8NGNn97Vt+VtT5mCetM8pn17HUUs1Z4MFrFksT4LYklgf7Svk7NxhRxC
         XX/v5gjiS2hLMKbo475MckKvI+UmIMXbeZFQ/HJZOcfj8k9BgOfSCbqcbrWSh4cxbq40
         P1Hpq0THoyObUMZCHHRiEzA35NuTrnt9meiOwPgV0wW9nD87CwH3mwZ8g+R1boErXBIH
         r61X69j4ic0GKt64dPgycnXFlpr/tsAYrC1lh4FbnzN+viZu6vwZEJoVjbSETPMOhFLp
         jIB6acm3xwcD7uamHJKRUSu3/uKNYSfyi8nwCxQ1BBdnjIEnN/WO6cveMP3iAZ8nYUZW
         8Frg==
X-Gm-Message-State: APjAAAVFenjS7+Jn79deC8kdsl+iHIeVr4YAan+azn1JxlUpxB4RCbQY
        SllQLTjiWkQ0lhK4Wc/E+KiGRHzxUgK2c3RS9nnbyg==
X-Google-Smtp-Source: APXvYqwDPaLbnSIa+DbWGw3u7v3uIMLYjMx0RDJc68+rWIdVuAWudd9bWgFWcrR90nPrXkqD+nMXcr8SbejRZh52zlo=
X-Received: by 2002:ab0:2b0a:: with SMTP id e10mr479374uar.4.1573021468593;
 Tue, 05 Nov 2019 22:24:28 -0800 (PST)
MIME-Version: 1.0
References: <20191105132826.1838-1-ardb@kernel.org> <20191105132826.1838-30-ardb@kernel.org>
In-Reply-To: <20191105132826.1838-30-ardb@kernel.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 6 Nov 2019 08:24:17 +0200
Message-ID: <CAOtvUMfUqbucw4zjjyHd-qYmAMYU2aYPdy-HW2V=SM_69_xFHw@mail.gmail.com>
Subject: Re: [PATCH v3 29/29] crypto: ccree - update a stale reference to ablkcipher
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 5, 2019 at 3:29 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The ccree driver does not use the ablkcipher interface but contains
> a rudimentary reference to it in the naming of an unrelated macro.
> Let's rename it to avoid confusion.
>
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad
