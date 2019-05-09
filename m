Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7982DC04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 20:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48929217D6
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 20:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kixquv3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfEIUmg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 16:42:36 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39766 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfEIUmg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 16:42:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id q10so3211040ljc.6
        for <linux-crypto@vger.kernel.org>; Thu, 09 May 2019 13:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j30FMQP1dgYb/Un5HEphzZohlJD8ALE8cV48KT6l/GQ=;
        b=kixquv3w2BJhTcwfRO6CnKo+0nPaPMg8+tNo9sE7QMH4fSM6CxuqdIRuZaIXEVlgbE
         P3iSYuflXmblpmyjsGxBM7+SrK1olw2cEu2iLXT4GQIwb0mRjaAkbcqzgETMjZka3hSZ
         wUWALygyCtBr0+QuQ2jiIxa/bF1RTIhYtleXKP3zYooocCxuhuctc1pVo0CxImm552OX
         xv9veZFaBnuKaeExHzwtt+2QhLbXEz6Dm/mKaG2t2AJ/UKN02fQgLtraDiuFQZt8hly5
         WRC9QOg53hKMoM+syha4MsySqFRRa/PzQk+Z0Lu5oKGGKnPop9/nuJcW80gfU8iiWiDE
         QZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j30FMQP1dgYb/Un5HEphzZohlJD8ALE8cV48KT6l/GQ=;
        b=MWAAzKy4x0+hZQYjJ1R6v8OrytAOY6Eykro0lwmhZUnJkFZ4+7yFxA7bTnq4v2pLcW
         jJLcbwAAFJv8JKV4nv62XtYko1fNqw9zLqSGAZ7biPIyxYTSblA7JhjcN6ylNUOmCObW
         y4M7K313JRlVhbv65KAK0VqBuU7SLYMQcbLo7hFinTF/tbDr9IlTe7HMTbmvonj/TB55
         edKW+rnMqtfRLxijeh7Shnz75X9mb5ge8H4e/VTcSB02d7td24GomUo5MD/QNN8vbEYK
         lVIT5e8DfuhYJOZ5opvn+ZjvtE6RLwiruOzhqJEcLAKq4OyFa7Vlh6+5lANnLMNY7bz7
         PrVQ==
X-Gm-Message-State: APjAAAWsMohtvqBHcH+HNRWHAMph4m1FSAbhVZElp6P9FxHE8BwNpjDl
        u0olEmcnUl97SmlREHI1ckCMSY/1NMnfMPAgi0KrEQ==
X-Google-Smtp-Source: APXvYqyosZEOpSbBcKCJAA0eCC9XPuixVltOZ0BUIHDZ+lSF1J5DphdLpbqqYQTpSgXqAFCxwa+fISTaTJ6Ht0Q2b7Y=
X-Received: by 2002:a2e:9547:: with SMTP id t7mr3558183ljh.153.1557434554357;
 Thu, 09 May 2019 13:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org> <20190430162910.16771-4-ard.biesheuvel@linaro.org>
In-Reply-To: <20190430162910.16771-4-ard.biesheuvel@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 May 2019 22:42:23 +0200
Message-ID: <CACRpkdY=1TZ_GBCEBsJ0teBcJeoXDEJ7=J8hHhzCRRQBUYxddQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] crypto: atmel-ecc: factor out code that can be shared
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Joakim Bech <joakim.bech@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 30, 2019 at 6:29 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:

> In preparation of adding support for the random number generator in
> Atmel atsha204a devices, refactor the existing atmel-ecc driver (which
> drives hardware that is closely related) so we can share the basic
> I2C and command queuing routines.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This looks good to me.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
