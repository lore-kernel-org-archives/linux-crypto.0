Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908FCC32771
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Sep 2022 18:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiIOSyh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Sep 2022 14:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiIOSyg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2022 14:54:36 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3C4D69
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2022 11:54:35 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3457bc84d53so232396557b3.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2022 11:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=M9Uyr86VKp7mZacSFez6ONLouI5Cb32MK9f5LSKE/bk=;
        b=KFzrXeOqSBulwk8KcX7zrPHv6vryJOJf6+X4SU4NDJ+zCsod+4RsqGjVy7qPElLAUI
         nVP3OvzjV/W5MWpQOM9xfAzcalBw1oyFZIggHo26pI3sxc0YmFNRaFDIL3aRi8HMOxH/
         Fq03WQSY4vazoMy2/+IDE6X9eRe7G3DreocJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=M9Uyr86VKp7mZacSFez6ONLouI5Cb32MK9f5LSKE/bk=;
        b=8Pxh8JM3uqdd3SVoJ6FIxWhio/LxV013sUoAoxWamBeK6A9DvcnTRKzo+CdursqR9Y
         fCMjE365HqM1p/mGyj0wnGBJCJhR/oJis/hGty0qeL8MNm05zM1wJ5fbGupquZMNrXdO
         EUtB2s5jkX2HrW+/lRno1WUIiuTMv4xAwSaU9mL0y8DPRJxRljyfZl+gcKV/cBHkhh/o
         DxsGdDk4mnjoJNvm0PSGRp8HOf/L9acsmJoA8WClDBOeJ5129ttvaPafap6JJ76Yqwt3
         cl3+s7BTp0oLW64MsGrN/2b+yJMP7vVRAkI6UC2y6/IVlgZK9GTY6YHouXAVDMgqvYPe
         g04w==
X-Gm-Message-State: ACrzQf1b9+K23gZ3qq8kNXOBNQHYuesq21dJoF5/shY4/j7wpAdcmtw0
        ZnKf4B8JW6VGUEaMCh1i+rVucqfcA9O8X2uSypnYnQ==
X-Google-Smtp-Source: AMsMyM5mOUJ8Ad20AIrZF5CfWfFQBQcn+HO432DqRBGF/X+LbSHrHRfJddOyn5AhiLbSLa+vBcwdLnPsca/+gisVeWU=
X-Received: by 2002:a81:10c3:0:b0:349:8b81:9fb0 with SMTP id
 186-20020a8110c3000000b003498b819fb0mr1137081ywq.269.1663268074753; Thu, 15
 Sep 2022 11:54:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220915002235.v2.1.I7c0a79e9b3c52584f5b637fde5f1d6f807605806@changeid>
 <YyNIOg1mtnzQz1H7@zx2c4.com>
In-Reply-To: <YyNIOg1mtnzQz1H7@zx2c4.com>
From:   Sven van Ashbrook <svenva@chromium.org>
Date:   Thu, 15 Sep 2022 14:54:24 -0400
Message-ID: <CAG-rBijUSQ-kA0-pS=JCVX9ydeaSCd9Ub=yryGk4zsbcv3dTzQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] random: move add_hwgenerator_randomness()'s wait
 outside function
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, linux@dominikbrodowski.net
Cc:     LKML <linux-kernel@vger.kernel.org>,
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

Dominik, Jason,

On Thu, Sep 15, 2022 at 11:44 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Isn't Dominik working on the same thing, but slightly different?

I don't believe Dominik is working on quite the same thing, but his
work will conflict with mine for sure:
https://lore.kernel.org/lkml/YxiXEJ6up6XEW8SM@zx2c4.com/T/

What are the odds that two people are making changes to the hwrng
kthread at the same time?

I see two possible ways forward:
1. Dominik rebases his patch against mine (iff mine finds favour).
This may simplify his patch
quite a bit, because the delayed_work abstraction tends to have fewer
footguns than
kthread.

or

2. I rebase against Dominik's.

Both are fine with me, just let me know what you think.

-Sven
