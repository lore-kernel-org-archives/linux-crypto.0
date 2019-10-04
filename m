Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A71BC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B1A2222C2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zPVDZCeJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389487AbfJDO7i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:59:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36282 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389598AbfJDO7i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:59:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so7640477wrd.3
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RLniEQxAH4/gfhYKz1Mqv7ZTj9FDz7v+FD5BGhHrkMM=;
        b=zPVDZCeJ4kuATkm+D9lHaW4RXOz/dmF4dM5BAKgFfZ5jq/X6d/oskwqG1GJ9r7lOwm
         UQQxoOPiVrTIeGI9COY+TZbLF8V/vv+StaNGFZHZJp07UbPTDUMuq3QE0u5/Ey6ft5ZK
         2z6UrPqlnGpp77h7jgXJPIuBG21HnhNhs6efsIZfHLprqkBLXjlJyht1Dbm/nmhol31O
         ZJXTcHo8aP5bF8c/wjLS3p3rwPAGPG81GwXfRfBUv2YDILycWuUkHkgHOiLxTZW9RO5A
         6fA5kjINCYoqtAqG2D8ZjDpN0yq8RcnNS8umHKSbuIbprfCXl2m0nZdS1bguJDyYbDO3
         y/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RLniEQxAH4/gfhYKz1Mqv7ZTj9FDz7v+FD5BGhHrkMM=;
        b=T05OAmloZJ8n0dITSoRA4HQjOOb5h1AaVVl6YhoPERuST+uHSMRKbPno/dzCyVfE6S
         RUJpvZHBjG8JiZmHYlsD/CVEcZgi0T9j02QPSXU6i3CA+qtffhFcg4o/4KuSD8M7qRRM
         CP6vyCuSjk/0HthaBgV1KXnCzdGT7YMEkIfpkZcdkwfcTEio/w8zQlIjJbQlC2NxBhb2
         CLPaBVmoltfq/C1y0XHHcI7HTaDYC+ccXClk2BZ4iOmjbQkEqjVwKVs7Jfh3bA9fl7be
         lohpfxlDQy+ue9jojq9V1UuudO7ZtkyQIJaA2CbsHaA6PrnJz8wq5uLj6VRlq5tNZjLU
         Aa6w==
X-Gm-Message-State: APjAAAVYVAOZIjFXTJqRtz3zX/uxq6kc0rum0uiCWchJyApLLNNtVVoP
        674tLL5dOVv2VqQ0W939GEV14pBXEI0dsTHTKHdKbc7ibNKQeQ==
X-Google-Smtp-Source: APXvYqzDfcN3qCMIDJWnE73Rz5HNGzWVFddcomQeUluwgy+eFHBfcJMGVV9gtbW0kuRdSw476eV5qXLGXSGWny1H56M=
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr11769702wrn.200.1570201176479;
 Fri, 04 Oct 2019 07:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-Xe-BfYzVDqDaZZ2wawYs8HHHc-CMYPPOU3E=6CPgccA@mail.gmail.com>
 <BE18E4E0-D4CC-40B9-96E1-C44D25B879D9@amacapital.net> <CAHmME9rMAytP32kHRjWyoyS8LTugG5qf5drok+H-k9K-TkVXew@mail.gmail.com>
In-Reply-To: <CAHmME9rMAytP32kHRjWyoyS8LTugG5qf5drok+H-k9K-TkVXew@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:59:24 +0200
Message-ID: <CAKv+Gu9oza5+P3UaWszrkw=059YM1WubjYV9wAEXqu+mGvXhtg@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 16:55, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Fri, Oct 4, 2019 at 4:53 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > I think it might be better to allow two different modules to export the same symbol but only allow one of them to be loaded. Or use static calls.
>
> Static calls perform well and are well understood. This would be my preference.

How so? No code exists yet in mainline, and the x86 code is still
heavily being discussed, requires voodoo code patching and tooling
changes. Implementations for other architectures have not even been
proposed yet, with the exception of the code I wrote for arm64.
