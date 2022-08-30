Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80827ECAAD4
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Aug 2022 10:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiH3Ksi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Aug 2022 06:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiH3Ksf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2022 06:48:35 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90599DCFCE
        for <linux-crypto@vger.kernel.org>; Tue, 30 Aug 2022 03:48:34 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id q81so8859427iod.9
        for <linux-crypto@vger.kernel.org>; Tue, 30 Aug 2022 03:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=D+Zr5m06Dz7pd1eCr8Zp9JUK+jm0toq4g0HWVGImRYA=;
        b=abgFhPl46C8ei+7f36OH7DAnCzAMmjSmJbnkvTvPumKxM3f1C6WzRbefKGvkLMtYsA
         NxpwF8HNjVwrUZ6K95DrwmzLJHXoauPusJCJ4avSH0MRD+rplq5ciQoaVkW+htEFWz4W
         sYCigAomDmWEBjn4ZQLux3KreIkC02bze3h9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=D+Zr5m06Dz7pd1eCr8Zp9JUK+jm0toq4g0HWVGImRYA=;
        b=ZvfMMpW5tUmR7zPHaRrV0ImeMmtQZbV3/+wch77eoEse9dDvVj8VZmN2QmAPeg5rKn
         cxn/KOMRq/wQ6lmz899vjjRHTvtHycgfP6FaCL/2UHu/dnB/vImqaENh89aWvIj7QSLD
         2ySOGczDGoGB62NqPo+als3NGS2+zYy8qomxnpnud2mABzdiR3/jvpfZtbWMl8oxRSIS
         CIbNnsDhUV/xBUaJ5fvjBykoc4s/XWinzQoL6Non5yBcr7DDLOcjZ1797fscVtEua6w1
         YaioQPTxM3gUsc8WzIz4yUGGTbdBzP/Dx6IZg0kBf6tklEgjoxKU1/GKNEWv3eviwB1X
         F8qA==
X-Gm-Message-State: ACgBeo3JQY0cpQuXDLv3kA1ZiOQao5iEQBw0og7Tu5w//Jgz+b5lbdOZ
        4opy2pgbYXYVldUg3SmzLhznvImy89DC64xvv8LWbq1NcgRqiAmX
X-Google-Smtp-Source: AA6agR6iliUyUmz+S8kqdlyWYTe+420xcq+qusgU+R+5fk0mgQgTG3lhPxjIa7eRDTILKtYwB+ryOdEjtuc+NxjSFFc=
X-Received: by 2002:a05:6602:15ce:b0:688:e4fd:bbfc with SMTP id
 f14-20020a05660215ce00b00688e4fdbbfcmr10180294iow.121.1661856513754; Tue, 30
 Aug 2022 03:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220729165954.991-1-ignat@cloudflare.com> <Yv9dvvy0rK/1T0sU@gondor.apana.org.au>
 <CALrw=nEh7LX3DSCa3FTu8BYr4QWx+W2h3Jei9Qo67+XXH-Vegw@mail.gmail.com> <Yw3Rneo6Ik1QEfbG@gondor.apana.org.au>
In-Reply-To: <Yw3Rneo6Ik1QEfbG@gondor.apana.org.au>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 30 Aug 2022 11:48:23 +0100
Message-ID: <CALrw=nGJgMACrFVy+FVVCDb4H3wNUN2E-GLZaXzLsm3ReOUeVg@mail.gmail.com>
Subject: Re: [PATCH] crypto: akcipher - default implementations for setting
 private/public keys
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 30, 2022 at 10:00 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 29, 2022 at 11:48:23AM +0100, Ignat Korchagin wrote:
> >
> > I can only elaborate here as I didn't encounter any real-world
> > use-cases, but may assume some limited crypto hardware device, which
> > may somehow "encourage" doing public key operations in software and
> > providing only "private-key" operations due to its limited resources.
>
> In general if a hardware is missing a piece of the functinoality
> required by the API then it should implement a software fallback.
>
> The only time such a NULL helper would make sense if an algorithm
> had no public key.

I vaguely remember some initial research in quantum-resistant
signatures, which used HMAC for "signing" thus don't have any public
keys. But it is way beyond my expertise to comment on the practicality
and availability of such schemes.

I'm more concerned here about a buggy "third-party" RSA driver, which
may not implement the callback and which gets prioritised by the
framework, thus giving the ability to trigger a NULL-ptr dereference
from userspace via keyctl(2). I think the Crypto API framework should
be a bit more robust to handle such a case, but I also understand that
there are a lot of "if"s in this scenario and we can say it is up to
crypto driver not to be buggy. Therefore, consider my opinion as not
strong and I can post a v2, which does not provide a default stub for
set_pub_key, if you prefer.

Ignat
