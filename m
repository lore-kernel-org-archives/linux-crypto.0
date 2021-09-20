Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9C4C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 03:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F25561100
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 03:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhIUDWL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 23:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbhIUCcZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 22:32:25 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F88C04F345
        for <linux-crypto@vger.kernel.org>; Mon, 20 Sep 2021 13:25:02 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id dj4so10195821edb.5
        for <linux-crypto@vger.kernel.org>; Mon, 20 Sep 2021 13:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AewO3aO3+z4hlxCwFUZ9p0OHCR2EQKSX+iYFMao6nc0=;
        b=WlFs5oPPaUXTN+8fM3tZZ4yFpm8r8IgTSFP1cJLfWFwUQqjOYBaREpxJ5wY1VgC+Jc
         Dh7y5DzfBQ7pEYF3w51CtovgkKI68ReEkdlCSOK/dgJag7xi9DrC/MC4rVEnq8fQ0ivB
         wPKWiqB1+UGDojR6HGuMEiJOhdNGv7/2wpZ/Tcn+l9WojxeOx2ZzxKOapLN7aEWKm9LZ
         Q8hCNZzkkpAY9pF+37I9UTj4esgXe3fjAf9sVG7VnMOEpEoRDuMCLHW96wgqpSIxKzpC
         8G9DgMDfr3zUZi9SwzFqT5MtiCUmXwgSIPS1258EfUig6QeLWqMfMsduf/yqypk2dgUO
         YLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AewO3aO3+z4hlxCwFUZ9p0OHCR2EQKSX+iYFMao6nc0=;
        b=A2LYKyCGGa+8EXS9V0+CtCm2ZPlEMv5Q5zTuz5CW2KNbUcHCef7U2srcELv9+/rNyP
         m8hygWP3/tPdH0lrQFN5GZLhNHYxR/j8YrXXB56sCjZYtVkPfA4M+DMkymtbQvFNNcAC
         M0Qg2qDLZakmoSR6F4Odeo9vymuwc/x2WQq/LOw1bPf66FwAqXf8QUJ9pTnxZXFzeWZo
         qqY+kF6kXwDIdMCD4aJ9zhJWzWV0fVWOaDpOxhEnfFZ55QLuqDq9e0YxR8apAWc7whBc
         r/9OxZ3kGu1Qn+ANLkJWmC7OX7ysfRKaF6QvNagwHEv59/McEkegPfo8DoBAvvlDE2Mk
         hxlA==
X-Gm-Message-State: AOAM532FEMEJacrw94qCWQUatc3m1HJeoQ1/MWJQZL6Za3mmm42HO+oP
        x1TiAPSw2Qde6VFiui/PFqNIJkYhRO4Wsd4giu4=
X-Google-Smtp-Source: ABdhPJwkUmyH5gYMjWJ2V2eDW+BhQLLZjiG5GzSZPFfz145M9TBUTN1XRqXTHJlhfKSmof0VVXdttq5fa/CP+dW00Hg=
X-Received: by 2002:a17:906:9747:: with SMTP id o7mr30754181ejy.486.1632169500694;
 Mon, 20 Sep 2021 13:25:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210920074405.252477-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210920074405.252477-1-u.kleine-koenig@pengutronix.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 20 Sep 2021 22:24:49 +0200
Message-ID: <CAFBinCA2yjQnRyaU3WKd5wiQE9b4nNMVMac5XePJ1DG1QCeeNw@mail.gmail.com>
Subject: Re: [PATCH v2] hwrng: meson - Improve error handling for core clock
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Jerome Brunet <jbrunet@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 20, 2021 at 9:44 AM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> -ENOENT (ie. "there is no clock") is fine to ignore for an optional
> clock, other values are not supposed to be ignored and should be
> escalated to the caller (e.g. -EPROBE_DEFER). Ignore -ENOENT by using
> devm_clk_get_optional().
>
> While touching this code also add an error message for the fatal errors.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
as well as:
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com> #
on Odroid-C1

Thank you Uwe!


Best regards,
Martin
