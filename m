Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAE9C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 14:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B5220854
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 14:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cR2r+p8R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731121AbfJNOdq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 10:33:46 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:37615 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732589AbfJNOdq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 10:33:46 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c1dca13a
        for <linux-crypto@vger.kernel.org>;
        Mon, 14 Oct 2019 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=t1IWs8fn/n2sFghu1hnC9gTFAo4=; b=cR2r+p
        8RIdfVDNoYNG+YIhO3y5nirqTA0mQKzJnKPjWBLzBmL8r/g1lqKYcJBz7ddCLG20
        EzLFjLCK/REcv7WXqfF+AG8/XLQduPve9ehNL+tPA9dnwcLN+3VgqLXemUiB0vZx
        GVPS+sWwUUwP9UwaYwe7S62QKbOEOr5ctxllx9SLEj0iXlIrqrR9LYQyGBzDUeSO
        2zOSFClN4htegurcUeWGlUfSfvp2aOw9MIc5suONTB2NqE9v0k16XPUTcVdk6guJ
        RvbMVqjA/KRxG9eF3kz/IL9Yg9rFY9lhia5N8/sGZ3UW0rBPAEklcDBviP+b/zIc
        V9pco2wCx6q+5zJQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bfb78fd0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 14 Oct 2019 13:45:33 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id k32so13969413otc.4
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 07:33:44 -0700 (PDT)
X-Gm-Message-State: APjAAAV+aL3UVbENrDb5MlWqzJaTUbhX+N2oYOTYy1Esl3EYUe7zApOn
        A/aEnk8cPTqNm8ZVsiFwlc57CmiGh99j7ORBoZE=
X-Google-Smtp-Source: APXvYqxyDK8bluRYUcDPqtybNyOGRzZnOkRvV8BrzWIDPtNSUKbAmqxyCbMNQbqHITIh5iO7g3Uy7mXHZYV6azm3GcA=
X-Received: by 2002:a9d:3664:: with SMTP id w91mr25008563otb.243.1571063623525;
 Mon, 14 Oct 2019 07:33:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 14 Oct 2019 16:33:31 +0200
X-Gmail-Original-Message-ID: <CAHmME9r9o9EmDoYVV=bGs9Yici900aE2YLN8z-RahSvnP0+mRg@mail.gmail.com>
Message-ID: <CAHmME9r9o9EmDoYVV=bGs9Yici900aE2YLN8z-RahSvnP0+mRg@mail.gmail.com>
Subject: Re: [PATCH v3 00/29] crypto: crypto API library interfaces for WireGuard
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

Just to keep track of it in public, here are the things that we're
deferring from my original series for after this one is (if it is)
merged:

- Zinc's generic C implementation of poly1305, which is faster and has
separate implementations for u64 and u128. Should be uncontroversial,
but it's a code replacement, so not appropriate for this series here.
- x86_64 ChaCha20 from Zinc, which will spark interesting discussions
with Martin and might prove to be a bit controversial.
- x86_64 Poly1305 from Zinc, which I think Martin will be on board
with, but is also a code replacement.
- The big_keys patch, showing the simplification the function call
interface offers.
- WireGuard - things are quasi-ready, so when the time comes, I look
forward to submitting that to Dave's net tree as a single boring
[PATCH 1/1].

Did I leave anything out?

Jason
