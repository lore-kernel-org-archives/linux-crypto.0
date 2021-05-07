Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86734C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 06:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F0F613EA
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 06:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhEGGNr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 02:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhEGGNr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 02:13:47 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34030C061574
        for <linux-crypto@vger.kernel.org>; Thu,  6 May 2021 23:12:48 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id o5so7471226qkb.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 May 2021 23:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=CzbCCZ6Zre6aJu1FfMOWI8mPWtp4+EWTeIofxDtbSp0=;
        b=RgyC/Z2qNiTD1vKuniSLbLKMCU5tSF5aE7LdL3TurQn8Zkff54gzBYZVajWtBxUrxY
         oqMWMxpBNXhoTySxgGwV3EQI/jl6ZSZ3at46tUqzq5pzHS69SC6FJY1geRYcM9DTC9tH
         JPdFC/VhuwockLhWDVj5aQqIjdUjyka+5aYeVgmNjWWA70DTEcAArnpeISnjZmMZbv7l
         HgXEGV3YzUbQDTMslVcBfFKp6BBVxRfJDrPKbanihC9LSuo0BYgijbNhvyJPUfBEtwer
         Ch52hH9ofekIWIf09F9yRiDzCMhpUiHYSL57KIDJ7EcljeV6BtYSKi4o+Ly6Op5cqs38
         7XUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CzbCCZ6Zre6aJu1FfMOWI8mPWtp4+EWTeIofxDtbSp0=;
        b=UGoCXIoNU9dLYHDJRuj5MUWJieOIB3r3dAyq5C+6/PF83RMUN0WtcqBtczFc4k9x2l
         E/xAzHPUvFiom2xUt98JAt0lxzdr+XyJ6nmAJJjwXnohuGepML9uWsaCRxd4nb0VqWg8
         SIzZDyGtHs8qj3/Alc/jgCAQVjL23YTmfstmQJeMglgccluX6sp2m8X4DVwTjIo6T/30
         tiro01Ajk/aSbLLADxM2b3pLEWCv25xE0/Z/M7VEEuGzNp7ivb0BOzGQjzEfuFJOKdNW
         oHxg0RHj8djs9INQPDkM4EMLdYy3FxK3wLywyc1S2GkiOscx77if/kU1U3p5vDK3oqRt
         9cfg==
X-Gm-Message-State: AOAM532g0ro5aQYLSn0kKkS9EaDE7HvTTQRhvp+VaOJOJXbhs80U/TW3
        rpTPldC9HJUgi8Cr7qGD4aRTxeupORTSzUKOrWyXkhqgrNw=
X-Google-Smtp-Source: ABdhPJxDKx6fDrOoeZJSNGgiTTJeNWP+UETl9BiimnnkH2WxXNDB3o4TdAc74AIANuqdSHWqfSYPvwym/otUySGEWAU=
X-Received: by 2002:a37:62cf:: with SMTP id w198mr7832038qkb.126.1620367967558;
 Thu, 06 May 2021 23:12:47 -0700 (PDT)
MIME-Version: 1.0
From:   Kestrel seventyfour <kestrelseventyfour@gmail.com>
Date:   Fri, 7 May 2021 08:12:36 +0200
Message-ID: <CAE9cyGTQZXW-6YsmHu3mGSHonTztBszqaYske7PKgz0pWHxQKA@mail.gmail.com>
Subject: or should block size for xts.c set to 1 instead of AES block size?
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

one more thought, shouldn't the block size for generic xts set to 1 in
order to reflect that any input size length is allowed to the
algorithm?

Thanks.
