Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B73C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 12:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E02A2070B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 12:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pgMY53uD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbfJDMIv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 08:08:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55618 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbfJDMIu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 08:08:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id a6so5541593wma.5
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 05:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ezpc1TYjxOB0JkQz0kZUiCPtLiFf/EuIDYhj9bwvfPw=;
        b=pgMY53uDf+aYRVZhUeNuzdrnC2w5IYyLH5bF0d+Vb3mjTHNriMSWdu2qpIUC6x1KpS
         kVvF5lltmFTl7eAyf+uQOAHhtuPjTXllQ4EO+edYbHEB2c97Ua9yPWVkhmkSMQqrI6vw
         Y8fC7bQb0pKwztP895Ge+MaljLZn9V/1fdAJwKQfBx/L4IoMnIDp09TTehUlFERRoIqY
         J7qLShxQOk42fZakmBlVVFTownKhRHqt3SdvszkuAyi0lSaeYrlsn/dPxrOV2f8CcG3Y
         mZbgVHbHg7DOwyoK8V+CgJTMJ34oBa133LCkGd8ACHqWKqKjyuqsEibT56ud/rrXoAtF
         AY5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ezpc1TYjxOB0JkQz0kZUiCPtLiFf/EuIDYhj9bwvfPw=;
        b=k9aBM6OxARzkq8iUYDAsFC0+qGyJAYHg7TMf5rSCY5Rj389gNTWPhAQeKQpPPdXQ0d
         PYegTQoIF6/sEVAIw700sSzJaMlH9uPlD1U0vSFVR5MxlU8fbu2oTkEg3zM2N7/0ACOu
         nmHiMP9rlbcTEB5HIY2PfC4ECluZ4nDRhtP5l7e39rqbHoRv4ZM/zlkvbgDOhS9I6K1K
         EUfsJUMw48uvsI6cCxcxLOb+EyPL2aFvW6wRBEvuRQ8ggtyv1t48TmmWifRZ9KA5ve7/
         TfUaYuaVVBA3Fwfea04RVHc/w0WKt3RKwS8X2+MwQYvIoel1QIXUqOkvuNn1msMy/uni
         f8vA==
X-Gm-Message-State: APjAAAUX1vYOtnMNsu+oybhg1j9PDjm7oiHFYAk01ImWZm5SorB2zxsS
        W6SkwMNLHEnVm/lsh+R8idASs41vb7Xh+dS4X3CRRQ==
X-Google-Smtp-Source: APXvYqwMnm+C6Rr1siChqBv06atGJ3shpX+J2x1fwosaNaYId6AOnBxNnPuNAckQuVMdXOTUsRKGgEZOVNBk1261EGs=
X-Received: by 2002:a7b:cb55:: with SMTP id v21mr1525933wmj.53.1570190928139;
 Fri, 04 Oct 2019 05:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191003133921.29344-1-ard.biesheuvel@linaro.org>
 <64d5c8ec-41c5-1ef2-cc4b-a050bf4c48ba@gert.gr> <CAKv+Gu8htzzdi5=4z5-E5o+J+bAPO=N4dR75Se=3JOZw8P_tDA@mail.gmail.com>
 <b15ff36b-19dc-2f04-ff2d-f644e30cdfb6@bezdeka.de>
In-Reply-To: <b15ff36b-19dc-2f04-ff2d-f644e30cdfb6@bezdeka.de>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 14:08:37 +0200
Message-ID: <CAKv+Gu-+4z7=gcodpx-ufgvyiPRBorMt=mS2x6W33QtsOMvNyQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
To:     Florian Bezdeka <florian@bezdeka.de>
Cc:     Gert Robben <t2@gert.gr>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jelle de Jong <jelledejong@powercraft.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 12:21, Florian Bezdeka <florian@bezdeka.de> wrote:
>
> I'm facing the same problem on one of my VPN gateways.
>
> I updated the affected system from Debian Stretch to Buster.
> Therefore the kernel was updated from 4.9.x to 4.19.x
>
> The supplied patch uses some symbols / functions that were introduced
> with 4.19 (like crypto_sync_skcipher_clear_flags()) so some additional work
> has to be done for older LTS kernels.
>
> Any chance to get a patch working with 4.19?
> I would be happy to test it.
>

Just replace all occurrences of *sync_skcipher* with *skcipher*
(including upper case ones), and pass 'CRYPTO_ALG_ASYNC |
CRYPTO_ALG_NEED_FALLBACK' as the third parameter to
crypto_alloc_skcipher, then the patch should work with v4.19 as well.
