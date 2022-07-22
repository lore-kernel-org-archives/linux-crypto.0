Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878AAC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jul 2022 11:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbiGVL0N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jul 2022 07:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiGVL0M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jul 2022 07:26:12 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5559927FC2
        for <linux-crypto@vger.kernel.org>; Fri, 22 Jul 2022 04:26:11 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x91so5493026ede.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 Jul 2022 04:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3M+aSErzHoSEG9jae2b5t7SFzCtNxYRjinEbHlaaEg=;
        b=Uvb4oYhPua1I3p4dj1bHinNjeOlIIo7fZIEWfnftUo+keus43ARtwRTQC1w8GcrjJr
         fA2Ozi3Vt5wqn8Y727iP8NH9X2lp4G3NU0+imLgLdrkXnHecxuMWg5A0HSk5kI7mW7IB
         7iYtUolxs79Te9W9VDsRPihPGRnoZ+3zj6pO+h2h/XLcuNrRTvpSM2HxwboxOcMSt1Ee
         wkSvhVYQpKQOtlCAyHPWjz8u4QHONY5s2C8JYLIm+dBvV0sX/gch3IF3lWYSaA6nUD+8
         C3Sp1NdQBVrkumxaXFhrtzWPOe2NHGesYa4nEYLXR1Kz64Q5l2GJ0D9hS7wbqNUTZgwS
         11tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3M+aSErzHoSEG9jae2b5t7SFzCtNxYRjinEbHlaaEg=;
        b=1dt5ngqhi3+lGIFrQ/MhpgA+em3yTcqfIefaftE2tkPwPdUS0+jHLppHKrl4I022wD
         nOTxmucYk+dBVYfx/merGww8ZqUA0ZX2cNWG4QlzJRNAVBl6FKWZm/FAANznAI4DWhjX
         clj46Go33hYf0e/TD9vMneiVZm1IL795BcC85HI4IHwYLEX0Yj2N6VHPONz71oC05Gps
         Ikj1Ix/7nRp+IWldcpc7nrB3U68gqsWco2OJypIJIxbXoE/oVaODf8kzb0oRL2USrxXM
         sIHfAPOa4qQNWIZNusln28/QCD4wU4vBVW/6WJbdYo0leHgeqUgvFR/x7h1xfTRAMun9
         r+Lw==
X-Gm-Message-State: AJIora+xC7lN4TRktTLjYduoFL5TAQXop6zyHxCmoY5fEH5DSAqo7slu
        jy0iS01cFOQN8jhuSKOuZsqBMyzsevlHMmGyG8qhY+26uyA=
X-Google-Smtp-Source: AGRyM1sV3vBgMApei403xftPsf5aD3seWxODgHl3TvETGIJW3PAXvNndZdtQbvYBFZTUwIBc5bTvt3y9E8D3rHn81JM=
X-Received: by 2002:a05:6402:5384:b0:431:6d84:b451 with SMTP id
 ew4-20020a056402538400b004316d84b451mr154393edb.46.1658489169556; Fri, 22 Jul
 2022 04:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 22 Jul 2022 13:25:57 +0200
Message-ID: <CACRpkdYi6BLwrJd9szk_vMEf_RL8E4pUQCi9i1iLk8E18DKJTQ@mail.gmail.com>
Subject: Re: [PATCH 00/15] Ux500 hash cleanup
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 21, 2022 at 3:42 PM Linus Walleij <linus.walleij@linaro.org> wrote:

> This cleans up the Ux500 hash accelerator.

There are still problems with the patch set, discovered after a few
iterations of expensive tests (and logging to netconsole to not
lose any debug messages).

I am ironing out the problems or at least making sure is is not
worse than before the patches, then I will submit v2.

Review comments are however most welcome!

Yours,
Linus Walleij
