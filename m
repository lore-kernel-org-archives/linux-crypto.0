Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E492C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EEE020675
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fL1KxJvJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfLCQfK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:35:10 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55923 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLCQfK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 11:35:10 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so2548381wmj.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 08:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qki1kFwomd0lgwLHyeLYaFv3ItxP8SIANr+bVFHvp2I=;
        b=fL1KxJvJQUZ/p6Bk8hmJoChCoYbTxPf8sfHJC+Mt0aAmjHSVKc/4TY3azt7W+N4LlH
         gv2H8wKCeHweBfRmnBh/QNRGwrGFZZvWoq8dGxKle4pYO7+Iz2C5s1MPTFk/7jkibxiS
         59rjSgfKYXVCZBp3IpjyuQRgSNGKao5xP5wfNvDguan89V762r/clfxYkt/yDlMVm1pT
         Nvh+6B/WmgmLZJM+3HFM/N8NSR0ppcUUVXgTVLSIIigkePOvco0C4SjaTK0sDndwzEzk
         1yzc5kmCahDh3UljavLpdP9s4LDDYZDy+ZlB8tjfPH8HylE//yUznhl9QoDI9yvYLMCA
         RO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qki1kFwomd0lgwLHyeLYaFv3ItxP8SIANr+bVFHvp2I=;
        b=DZbtYQoLLVnZ7ncnoZKDlXWqD5f0JJzK4P0mafTTiWmYWXzPwVkoz7/Aoed/Zn9DSy
         J1j/wUxK3m1I/XDvrBR3q9IJ5+QByI8miTIGYhgtDzX8kLYdj8InrdccrLX691ay3RU9
         XcDurxdc1J0ug0XdpRfa/Np+Du/M3GH77wWOrCGh43U+GFcwmTwWC24ZP8MClhPAOapa
         ymSUquBFbvQBRZZ2inIrAQbCBWOQnrQgmEjWyDLoQDuRZCwlG+BAm0b/lIsO8RJALDWo
         hv5stsbi4i+Grk6tdadjknwk3VUvK+AO3cRbuAtRbhgZ2e15OBsPM/gfJV81pU6gKENL
         ctNA==
X-Gm-Message-State: APjAAAVwGz2NZawwV1fjgsE6W37NYk5xcUJGnlVk43Sdi1AePOkaSer5
        m3N0HYz6wIucF0WxTTq2toard1B4wqNmOT03CM5LNbs5exAgBg==
X-Google-Smtp-Source: APXvYqzzh2cp4fXu3XTO8mnQUJrwzWSOxhl32XcXp0bM+wKZFYfxHTpMo+mGYZHooKSr2XA+zUTZv/wlAK3xp35G4I8=
X-Received: by 2002:a05:600c:141:: with SMTP id w1mr15353169wmm.61.1575390908944;
 Tue, 03 Dec 2019 08:35:08 -0800 (PST)
MIME-Version: 1.0
References: <20191129182308.53961-1-ebiggers@kernel.org>
In-Reply-To: <20191129182308.53961-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 3 Dec 2019 16:35:04 +0000
Message-ID: <CAKv+Gu9vOsQ9zL6s6T8ALywgn80HtDoKfoviebwpJmEtK3zhxw@mail.gmail.com>
Subject: Re: [PATCH 0/6] crypto: skcipher - simplifications due to
 {,a}blkcipher removal
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 29 Nov 2019 at 18:24, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series makes some simplifications to the skcipher algorithm type
> that are possible now that blkcipher and ablkcipher (and hence also the
> compatibility code to expose them via the skcipher API) were removed.
>
> Eric Biggers (6):
>   crypto: skcipher - remove crypto_skcipher::ivsize
>   crypto: skcipher - remove crypto_skcipher::keysize
>   crypto: skcipher - remove crypto_skcipher::setkey
>   crypto: skcipher - remove crypto_skcipher::encrypt
>   crypto: skcipher - remove crypto_skcipher::decrypt
>   crypto: skcipher - remove crypto_skcipher_extsize()
>

For the series,

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

>  crypto/skcipher.c         | 22 ++++++----------------
>  crypto/testmgr.c          | 10 ++++++----
>  fs/ecryptfs/crypto.c      |  2 +-
>  fs/ecryptfs/keystore.c    |  4 ++--
>  include/crypto/skcipher.h | 20 +++++---------------
>  5 files changed, 20 insertions(+), 38 deletions(-)
>
> --
> 2.24.0
>
