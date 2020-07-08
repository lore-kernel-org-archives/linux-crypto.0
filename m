Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71235C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 02:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4908C2078A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 02:29:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="isZVmxyb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgGHC3x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgGHC3x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jul 2020 22:29:53 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01DCC061755
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2020 19:29:52 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c16so45393205ioi.9
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2020 19:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5k/JGsyD2+esKCntA7d0GqlyFPWtT12zUQKTXZD4ijE=;
        b=isZVmxybBp1KSJIveFgxL3srASfZzBCe64vST1INaL9Tt0Cmc6eXvQpO4B1dFJ+Cxc
         5Tuih8iZIYCJd4H10Mtd6qVhyU1X0BkJJkRfx4yU084021EkVBccQIyas6oYs84CTpXI
         Bdig1CwUdpMuHwPdRHXj0iV0oBb3TpJcaSjS3tySv5jlSoYEWiiVx1TsvFfoWONXicbh
         y81teS+Q9Pm9GHmghEJw1LwzyBbyD/VGRf50t/K6S3iQQs4BsiAyPpv2yyMNa45WuUFt
         wwEEvCqTDvm0aPKIaS5lYv9vWOm1gJaF2RUw9C5feZiLgyh0+QMvydwCJPWsu+Q7iG1g
         z2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5k/JGsyD2+esKCntA7d0GqlyFPWtT12zUQKTXZD4ijE=;
        b=FQSJJcs8G1AC1ArieRDFNiPgqBt1yXQ8s242lT6NnJc7ag4TWAtqVB6CKHufvxmINM
         CHx2BPYq3m18G+bP341CAimwHzzXdJcGkpX/UaxfPj6RNz+/J50StaxWaKEuiK6QG3TU
         LDP780/dfhOKG3lTI9mriqgf1piVc6WWHKGyCskesc9p3zMaVOIIHAjoFAEFvKz1HiOJ
         rNhfmZ10gmxlZzhPtIC0CO51zr/XG0KoDG+StCY3mctGhC8zHYCpIe9+GsGC+ceilE/V
         EYA4+ojJZ9fLuDkIxb2HldKO1hPEFRaKtBzye8xk99Mu2sGS4gtIBseCCiZ8jcHF8yLY
         JqNA==
X-Gm-Message-State: AOAM532pYoV4lKdI/kfutdpoOoGue9krWxtYcVO/T8aMFZzXXS1hAHpH
        wj5gwBC7GgjhiP8AS/wGKuTkIX+3qP3HxkG837DQqw==
X-Google-Smtp-Source: ABdhPJwNzd2zl5gOvT8AIEAOM+a58ORD2lFo8Gb3Ecuyf8uk0eDHHCA3AHnwqPXeDdhypjO8OflVcKhLfxbFpnb+rX8=
X-Received: by 2002:a05:6602:2dd4:: with SMTP id l20mr34268706iow.13.1594175391947;
 Tue, 07 Jul 2020 19:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200707185818.80177-1-ebiggers@kernel.org> <20200707185818.80177-5-ebiggers@kernel.org>
In-Reply-To: <20200707185818.80177-5-ebiggers@kernel.org>
From:   Tzung-Bi Shih <tzungbi@google.com>
Date:   Wed, 8 Jul 2020 10:29:40 +0800
Message-ID: <CA+Px+wUTqgbT6tAWg+5mek_ZtQdH4=7-ta6ned7PeYy8r_3rVw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ASoC: cros_ec_codec: use sha256() instead of open coding
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        ALSA development <alsa-devel@alsa-project.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 8, 2020 at 2:59 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Now that there's a function that calculates the SHA-256 digest of a
> buffer in one step, use it instead of sha256_init() + sha256_update() +
> sha256_final().
>
> Also simplify the code by inlining calculate_sha256() into its caller
> and switching a debug log statement to use %*phN instead of bin2hex().
>
> Cc: alsa-devel@alsa-project.org
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Cheng-Yi Chiang <cychiang@chromium.org>
> Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Tzung-Bi Shih <tzungbi@google.com>
