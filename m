Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D64C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 23:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEA06611CA
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 23:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344665AbhEQXz1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 19:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbhEQXz1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 19:55:27 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B098CC061573
        for <linux-crypto@vger.kernel.org>; Mon, 17 May 2021 16:54:09 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j6so8653498lfr.11
        for <linux-crypto@vger.kernel.org>; Mon, 17 May 2021 16:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JbhlmfPa5s+HmHF2AkgVRLQaiXQBSVARBK7bDpva6h0=;
        b=G0JFaE5M3Vu3bo7EXsLiB6MuKFBihbF0+5Gj0JkCdWDC/4eI8kflgVFBuq3ERfsVHX
         S6SzU/5NmSDGhKsT9ym/tPH2muXKg0aNbFYrP2zEw1/R1lToYN6mnKThDgo/PXQkLANS
         QH54ygk7MUqpL2PyCkwlcKhqaoybOav7MybC/jzLwiNM7lyO0zcgDR7Vf6TTtvNJQmHs
         9iZfsfCKqsQLN35lVJqjoZNwYs98xrZg+FFUF75Cu87wJXiRcfoV0I1YrZE+86SdRHpN
         fMEu/pUrHPx/GFyPSmjuJTAwloseNGXOhhwlV3+UnwUg/6GUOVoqUSUA6bCO5wcwNRkz
         PBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JbhlmfPa5s+HmHF2AkgVRLQaiXQBSVARBK7bDpva6h0=;
        b=Wn0BtiLCJb3BfmNecq+b2F9I7e3t9ZJnQZ+Uc+wY6L3fH+9CBwdqG1MLiLFXnaUNV7
         19dPUrahP3DBvkfqwTtp3shJOf3q5hqvaslr9+Okn8KCO09ORQmqsW9VHGT8HtuZ6BOO
         bDNptsD/m/sqoa64RG3Sn96fW4i8zcbQMaIasuluywnZ1KrtFP3XRFm2jAYtSESqkuzx
         LGJSP4CupyBftC45t5w7JCz3Rz3BtY8ZI0XmOXm2ZI7rTysj2hah5RyZUKv3XSKVy4ER
         tANfVhnYDPY8pmh+ocyCnBNsT0BFDMWUfTD7+41joIviJyJ8AabjKukt422QgpUCJmbq
         BIlQ==
X-Gm-Message-State: AOAM531c5ZOmDepUQUx9V7eNzjqDzUxiAcTQKXKTFjhWzI8qwSElz/S4
        3okL+6MLyxHa6I4cNL6O2m2ftrhnl6hYUERewPnZNA==
X-Google-Smtp-Source: ABdhPJz7J+GqpZt/lpIho+kd7mX00GTqQd481/bCTFXSF+rls5RoKbTDY/QIdG8vSFWmcfrAMHryQevnYCUDghbS/G0=
X-Received: by 2002:a19:a418:: with SMTP id q24mr1724759lfc.649.1621295648198;
 Mon, 17 May 2021 16:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210505202618.2663889-1-clabbe@baylibre.com>
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 18 May 2021 01:53:56 +0200
Message-ID: <CACRpkdbR9mt-X-Dt9uR9vGtg_EDJCk3H5Umuh2eUX-PGZ7VBfQ@mail.gmail.com>
Subject: Re: [PATCH 00/11] crypto: start to fix ixp4xx
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     chohnstaedt@innominate.com,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 5, 2021 at 10:26 PM Corentin Labbe <clabbe@baylibre.com> wrote:

> Loading the ixp4xx crypto driver exhibits lots of error.
> All algorithm fail selftests with different reasons.
> This series start to fixes some of thoses problem.

Excellent! Thanks for taking over this Corentin!!
FWIW:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

If I merge my 3 additional patches through ARM SoC
will it work out or do I need to think about some clever
merging strategy?

Yours,
Linus Walleij
