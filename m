Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A490DC2D0CE
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 08:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73CBD206DA
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 08:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xW+LbBKx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbfLaIO1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Dec 2019 03:14:27 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54048 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfLaIO1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Dec 2019 03:14:27 -0500
Received: by mail-wm1-f65.google.com with SMTP id m24so1330532wmc.3
        for <linux-crypto@vger.kernel.org>; Tue, 31 Dec 2019 00:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g0Pdjud1VU0ZUxaakoki+l3FmURlkZsw8p9lGLeQCSM=;
        b=xW+LbBKxSfggvu3XNYEd7trF1IxVexJk5QFxRLRHLXT7WvkLh2yDDQ1RdDj0E1qDOG
         z9HcZ2zXIQuFYmiiTUeymrsPCmy3/vdrSr5ar3WK3Ru4IEMZUXYZIWjQ4z8CEyb+bdWR
         KC/ZCG4F7mZAcEtDA1jDkIDxsm0BEHWGhX7TlwozN8qXoD4z7aVjHxWSrZtquXbVBsHk
         8f3+eAjKTC+Jk3PqgJcfVA2tQ5p2C9SC8hb6DgpnuYnYOeoQ5enmoCqfrbkdx14hUrgh
         WPngXQqm+1YaFGDGj2LZjissxSJCL3MYAaowfoh85kYV9YaTGjq7nzIu64pSmZOr59o4
         /6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g0Pdjud1VU0ZUxaakoki+l3FmURlkZsw8p9lGLeQCSM=;
        b=N7HCdJXPW6LwQ8lGQvCCrn0cRiJXoSApdJSBFh64EblfdCkvagQYq1/b69v9EtcQIK
         BWflfkz55F5hzorM2GEHJQId7QEjnzM7PyXTwbYj35kZdk/I3h0or5nGKfk4RCr64IRE
         DoKnPhi7UgAzPgrxoNzBpsC5bwXNhoFXz8YvV+E7gv2xbDZcd1hY2WSLS1ukS1OOl2iA
         AuIjRD3s8KKTNQbPj5O2bThdhlZidNlZXPpsSK9CkaWDdpWJyE2RiDIT9bxIdcyXJNdi
         p0mcvSAndWLiWDQhRi40aGcZhkSsbhGLR7de86rGqyidkDJROj523P+5Vb/lw0t2Gg7j
         1L/g==
X-Gm-Message-State: APjAAAWEGff7GxrzJq8iiRdECU/JvqkiK6eGRBzxOVD/bQnmkONyv+a0
        WeNKiTGLL6js965K/78UNUMTDkq56l8swHr8NYtYiA==
X-Google-Smtp-Source: APXvYqxv85mrtKv76S+ibADVtMLJB2/21m0hmW1PIbdFMHTBF2rjWZYpN46Hg/xnEI7D+VU0ALY/XTe5nOUT8ku7Dsk=
X-Received: by 2002:a1c:a795:: with SMTP id q143mr2928370wme.52.1577780065223;
 Tue, 31 Dec 2019 00:14:25 -0800 (PST)
MIME-Version: 1.0
References: <20191231031938.241705-1-ebiggers@kernel.org>
In-Reply-To: <20191231031938.241705-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 31 Dec 2019 09:14:14 +0100
Message-ID: <CAKv+Gu8F-u4-DNFFZBWpfVwbJ_ARMC3vnPk4Vzz5Q2WYK9nVhg@mail.gmail.com>
Subject: Re: [PATCH 0/8] crypto: remove the CRYPTO_TFM_RES_* flags
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 31 Dec 2019 at 04:21, Eric Biggers <ebiggers@kernel.org> wrote:
>
> The CRYPTO_TFM_RES_* flags are pointless since they are never checked
> anywhere.  And it's not really possible for anyone to start using them
> without a lot of work, since many drivers aren't setting them or are
> setting them when they shouldn't.
>
> Also, if we ever actually need to start distinguishing ->setkey() errors
> better (which is somewhat unlikely, as it's been a long time with no one
> caring), we'd probably be much better off just using different return
> values, like -EINVAL if the key is invalid for the algorithm vs.
> -EKEYREJECTED if the key was rejected by a policy like "no weak keys".
> That would be much simpler, less error-prone, and easier to test.
>
> So let's just remove these flags for now.  This gets rid of a lot of
> pointless boilerplate code.
>
> Patches 6 and 8 are a bit large since they touch so many drivers, though
> the changes are straightforward and it would seem overkill to do this as
> a series of 70 separate patches.  But let me know if it's needed.
>
> Eric Biggers (8):
>   crypto: chelsio - fix writing tfm flags to wrong place
>   crypto: artpec6 - return correct error code for failed setkey()
>   crypto: atmel-sha - fix error handling when setting hmac key
>   crypto: remove unused tfm result flags
>   crypto: remove CRYPTO_TFM_RES_BAD_BLOCK_LEN
>   crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN
>   crypto: remove CRYPTO_TFM_RES_WEAK_KEY
>   crypto: remove propagation of CRYPTO_TFM_RES_* flags
>
...
>  108 files changed, 218 insertions(+), 917 deletions(-)
>

For the series:
Acked-by: Ard Biesheuvel <ardb@kernel.org>
