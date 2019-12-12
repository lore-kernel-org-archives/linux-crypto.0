Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FB4C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 13:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 125B52077B
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 13:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WVMYdc5p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbfLLNrF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 08:47:05 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:40379 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbfLLNrF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 08:47:05 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e2bef9ae
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 12:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=RioIjPi7ht8fNguLSmoJsPePgM0=; b=WVMYdc
        5pxqq3dCThQBw5ZZwR5qqJCm8oVdHfJcp+TwMpa3HfmsDcaHtqaj7+KbUztgsN+q
        FOr4yZ72xeuF2K/bwJiNXmBXTPOWcDTjhXDd2mqb2JBKGQEgDOfUISrxlIJNgsdq
        s/4MXBg7Z3y598t9oX0Vrp/NeAGxh3vhQh32LwZ1s/fN5/Nw2Q74Q6Ol6hQ8YOz1
        wR5WeQ8hxYKBRL6v2FiPzQbWdmDuP5YOKLHQcOAvYzPwx7S7hD1qK3OZWlDjmLlx
        VuVWExbi9qXpac74DvGXW7HRQk7X0/wu4u+VBuTVz4SP8JLA8i6W/jj34ewn5vxa
        r6zmNHZroh+BJhfg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3bb240a3 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 12:51:16 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id k14so2037561otn.4
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 05:47:03 -0800 (PST)
X-Gm-Message-State: APjAAAUKISGkTtuuzA3QGZ7IPoye1x2VEc07h2hanuonw/k0Ym+o7Ix1
        If0Ap3vvDvJNz8te2PGthhhuBirjZs8Lhk7Uq5k=
X-Google-Smtp-Source: APXvYqyGn/wAKMeU4EIod1aCONvl6fE57Fu2sypyNxNjU08dyQGE7TrLkw+8k/cW8EeYWxu4xbQjFKSzjK6Ds7G8Wdo=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr8350435otm.243.1576158423191;
 Thu, 12 Dec 2019 05:47:03 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org> <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
In-Reply-To: <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 14:46:52 +0100
X-Gmail-Original-Message-ID: <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
Message-ID: <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     Martin Willi <martin@strongswan.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 12, 2019 at 2:08 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Martin,
>
> On Thu, Dec 12, 2019 at 1:03 PM Martin Willi <martin@strongswan.org> wrote:
> > Can you provide some numbers to testify that? In my tests, the 32-bit
> > version gives me exact the same results.
>
> On 32-bit, if you only call update() once, then the results are the
> same. However, as soon as you call it more than once, this new version
> has increasing gains. Other than that, they should behave pretty much
> identically.

Oh, you asked for numbers. I just fired up an Armada 370/XP and am
seeing a 8% increase in performance on calls to the update function.
