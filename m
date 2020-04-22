Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E98C55185
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 23:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF7F2076E
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 23:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pqGPYYI6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgDVXJo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:09:44 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:44301 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVXJo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 19:09:44 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5ed688f5;
        Wed, 22 Apr 2020 22:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=OZjfePK0HjGa7K40j3VsVBNVeW8=; b=pqGPYY
        I6OfH9mtLpwBzieGqQLl5mWJ5oYrOyRdSfepMvLVLZJcKB03nJlST6tuTqdGjOId
        nYD6iUk+MtVnyEeJBsycLkELMFep7VUnldTCipZJyPjnYuqCJSojHxbSx/XqTntb
        H0Ze9QMgIkz7rS63WXeB2papPpPr5zNl+6+4cmGoewuMM+x2O7QZtPYwh6TfmSb7
        h21KdBIR+emjEZXInBgRRPuiJlqX+uj70iZVWBP38Bgp4s/Gf3couQN2ED5/EONC
        XGxGnb71rQZPuIUdHAQShjAQsdN+RpdamZem0hOmaDbe4S+iaAJEqRmx1Xry8xu4
        NU+pmYwF9DZoUg1Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id caee6694 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Apr 2020 22:58:45 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id z2so4358104iol.11;
        Wed, 22 Apr 2020 16:09:40 -0700 (PDT)
X-Gm-Message-State: AGi0PuZOz0mJmPoABOjBkqz9XsdQLXj5sQ16cNw9Ua/3Kt1+7gGYKFHb
        3miO10PtbB5UgAqQSk3/OMc8xCF1Hr150Wm353k=
X-Google-Smtp-Source: APiQypJXmmE/5uCkig09fHm1CEMbQRCNqkZvWR+p7JrW4J4CdSWRYWSdK8h/04PbRd7vzbEJL5Wh2LnLdC3VVxp8o/Q=
X-Received: by 2002:a02:b88e:: with SMTP id p14mr744905jam.36.1587596980023;
 Wed, 22 Apr 2020 16:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <20200422200344.239462-1-Jason@zx2c4.com>
 <20200422223925.GA96474@gmail.com>
In-Reply-To: <20200422223925.GA96474@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 22 Apr 2020 17:09:29 -0600
X-Gmail-Original-Message-ID: <CAHmME9q4qyUiR5o4BiCKYrOvfpBbOpag+m2+dE+dSPqm0M5Jhw@mail.gmail.com>
Message-ID: <CAHmME9q4qyUiR5o4BiCKYrOvfpBbOpag+m2+dE+dSPqm0M5Jhw@mail.gmail.com>
Subject: Re: [PATCH crypto-stable v2] crypto: arch - limit simd usage to 4k chunks
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 22, 2020 at 4:39 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Can you split the nhpoly1305 changes into a separate patch?  They're a bit
> different from the rest of this patch, which is fixing up the crypto library
> interface that's new in v5.5.  The nhpoly1305 changes apply to v5.0 and don't
> have anything to do with the crypto library interface, and they're also a bit
> different since they replace PAGE_SIZE with 4K rather than unlimited with 4K.

Good point about the nhpoly change not being part of the library
interface and thus backportable differently. I'll split that out and
send a v3 shortly.

Jason
