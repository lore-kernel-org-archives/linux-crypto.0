Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC1CECAAD3
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 17:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiISRT5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 13:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiISRTz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 13:19:55 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66681658D
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 10:19:53 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a8so47979908lff.13
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 10:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dRf0ty06/uotKyN1jAoSPPbSnVAvm0buWGfL71jirrE=;
        b=RC/Vi3Kc9McNRFaLh5HLy+9shoIAOcCiokeINHvd0TsUg1EChRhJCYFS3Nf3K+9Q7G
         fvg0JgltwdUiR9FsG9L97XUYl6DR6T2vKj56jFI86zKWmD3c4bw/C1KoPyJ0dLxbYWUW
         m6ST2MtAyJxyFlVpsgSOXIzQ3pV7NTOo4sSqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dRf0ty06/uotKyN1jAoSPPbSnVAvm0buWGfL71jirrE=;
        b=0wkNtYyJkbHjzVT46dZbbjhAV4eYOC3EU5OXKFnCcOA0qvNRSjJrgwOki3VMWc8V0L
         NgH+Jnu95wZo3jXEoEB3g+0f+Dg/f1rD+PjirMUkovcWEOoHwNA2oltx0NfldMvLjF5x
         M2CNiX0hwo9UwvEysmZcmbgqSS5GEkvzZhm7S59S2BIHj4VFcyQPj1Hw7W1Xcz978+Ln
         R0ZvnnT+6vAPfXLHaNdQAiy6sHroOF4lvv3GHScp/66XIk6GaeYF/Rlynt5okNc20mN0
         9NmS0PCGSLl2bsEZY++eZ/kFkgnWTh0wziQ/a0E+Ngl7uxnwx3SFBJCl5JvSLqe+jj7G
         DDBw==
X-Gm-Message-State: ACrzQf0duhET/LD8FVXzkH5s5BYr1m+6c5dbRhPO1wul0D2SGGJCYrzy
        nNZiA7WHVs+xStDiSvxCzR0+K7/tUl69MHIaz14=
X-Google-Smtp-Source: AMsMyM4PTUAYIoyJbf9IJoA999ACzTT3axPBfTiPntazgMNWIIPjiWx57pMdxIQfoPrf8URPLr1Vxw==
X-Received: by 2002:a05:6512:22c7:b0:49f:c780:4886 with SMTP id g7-20020a05651222c700b0049fc7804886mr945356lfu.389.1663607992323;
        Mon, 19 Sep 2022 10:19:52 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id s9-20020ac25c49000000b0049493c14b17sm5264131lfp.181.2022.09.19.10.19.51
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 10:19:52 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id h3so26299978lja.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 10:19:51 -0700 (PDT)
X-Received: by 2002:a05:651c:178d:b0:261:bd23:a5f8 with SMTP id
 bn13-20020a05651c178d00b00261bd23a5f8mr5202580ljb.411.1663607990563; Mon, 19
 Sep 2022 10:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220915002235.v2.1.I7c0a79e9b3c52584f5b637fde5f1d6f807605806@changeid>
 <CAHmME9rhunb05DEnc=UfGr8k9_LBi1NW2Hi0OsRbGwcCN2NzjQ@mail.gmail.com>
 <CAM7w-FXHWzcN1Y7pwb6+1KA6A2oZRrfpOJdWFVWjRvjbp+DEOg@mail.gmail.com> <CAHmME9qmiNcs6iye=Yjnpfx7vy6QMd8t8nuVOg7omOhOdkN-Hw@mail.gmail.com>
In-Reply-To: <CAHmME9qmiNcs6iye=Yjnpfx7vy6QMd8t8nuVOg7omOhOdkN-Hw@mail.gmail.com>
From:   Sven van Ashbrook <svenva@chromium.org>
Date:   Mon, 19 Sep 2022 13:19:39 -0400
X-Gmail-Original-Message-ID: <CAM7w-FULuCCww8DMyvTuU_SLuyZWqfv3sVbvPtBorYEbhGUuUA@mail.gmail.com>
Message-ID: <CAM7w-FULuCCww8DMyvTuU_SLuyZWqfv3sVbvPtBorYEbhGUuUA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] random: move add_hwgenerator_randomness()'s wait
 outside function
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>,
        Alex Levin <levinale@google.com>,
        Andrey Pronin <apronin@google.com>,
        Stephen Boyd <swboyd@google.com>,
        Rajat Jain <rajatja@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 19, 2022 at 11:06 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> By the way, there was a recent ath9k patch that kind of went to a
> similar tune. [...] Maybe that's a potential solution here, or
> something similar to it.

Jason was kind enough to point me to the patch in question:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=36cb6494429bd64b27b7ff8b4af56f8e526da2b4

This patch limits the long sleep inside the fillfn kthread, by
terminating the sleep on
hwrng_unregister().

This doesn't appear like a viable approach for the suspend/resume issue?
- there is a great multitude of tpm_msleep()/msleep() calls in the tpm's
  rng_get_data() path. They would all have to be made interruptible.
- even if interrupted successfully, now the kthread must be blocked until
  after resume. If so, what is the point of using a non-freezable kthread.
