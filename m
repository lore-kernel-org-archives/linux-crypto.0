Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F0DC31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 09:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49204205F4
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 09:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z1tFpZVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731347AbfFSJOT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 05:14:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41248 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbfFSJOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 05:14:19 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so36434623ioc.8
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 02:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qu2Wc9HSIWJ2oV3uEIa9Pnf61IRfW5CUxnsT2crY2Kg=;
        b=z1tFpZVK/HK0VY5eVY2WNvMLU6ctmJ2nrKm2YDzlh2fQVAcbG9Ua06wIbyg5Sra6Rz
         IIUhspyguXILIOXCfjypHWkxJWVav8CtN9xD3OAAKJ2AGIRv9Urkb7vqHBcKHKANLrsi
         REUj6s1MB+naHoxaDD4/5eeah0fLrf/nlCGCqjwry2ck6rSNfmtizUoe0yT0/C23RMuM
         Ze3XoVCzxsKpFf4xNO9eSlF4P/b4i45AjLo/eA5bERnlvt1voC0FiV3q+gxPD96ct9qk
         UEWbs2XdqT0OjJd5IY3FOS/6l69+NitTE1kyXcAu3Co5k/UgvPWEs3mp94VrESBRNwlL
         Gn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qu2Wc9HSIWJ2oV3uEIa9Pnf61IRfW5CUxnsT2crY2Kg=;
        b=t+Ee8/XkpE07KzbBGsR/DPKSTsY4p5Y7JCMHIKrHmayYZ72UHzD7OSoa7WDTMfMNt0
         lJjfpEO6Tdr3ekisMg4fjUww9SYAwBtL42WYcC+YAqzRXhzv+S0X0jB7kh62SVjf5Ndm
         8pO0s5RcWGFb1dcywm0vbq/B45JZy8z2BA+bGdCG1lTmT0rW+grKEE13R3S79oO1N3Mj
         c/n/TO78Nkg2eWE1eah7no/CrzdU7KfT/tbZnT/kfpPMhNEco3f+obSP7+ThwDAaSb9k
         qRfb+WGGdZ/khpt5utr0x0FqcDuun5186MQGYvXz2i2k0MJHYwucCkbeBFjlA8NK6265
         0S9w==
X-Gm-Message-State: APjAAAWkysrvmo5RfmcTWDVCXG51zbn8+SE2FqXcXgf4UPhWER+Tfz/8
        A8YSv6dGo6sXsSXo+B1qgl05dpkAIpfKOhJv0DRpbQ==
X-Google-Smtp-Source: APXvYqxjashyDDd0tqlY6wyY6sA4zhIOYDGA7twoLsRYMoBDPncQojd0OT5uVJY8+apNN8wWb615gJIBsnmgOteEZV0=
X-Received: by 2002:a6b:7312:: with SMTP id e18mr4106503ioh.156.1560935658152;
 Wed, 19 Jun 2019 02:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
 <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com> <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
In-Reply-To: <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 11:14:07 +0200
Message-ID: <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Jun 2019 at 09:11, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 19 Jun 2019 at 08:56, Milan Broz <gmazyland@gmail.com> wrote:
> >
> > On 18/06/2019 23:27, Ard Biesheuvel wrote:
> > > This series creates an ESSIV template that produces a skcipher or AEAD
> > > transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> > > (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> > > encapsulated sync or async skcipher/aead by passing through all operations,
> > > while using the cipher/shash pair to transform the input IV into an ESSIV
> > > output IV.
> > >
> > > This matches what both users of ESSIV in the kernel do, and so it is proposed
> > > as a replacement for those, in patches #2 and #4.
> > >
> > > This code has been tested using the fscrypt test suggested by Eric
> > > (generic/549), as well as the mode-test script suggested by Milan for
> > > the dm-crypt case. I also tested the aead case in a virtual machine,
> > > but it definitely needs some wider testing from the dm-crypt experts.
> >
> > Well, I just run "make check" on cyptsetup upstream (32bit VM, Linus' tree
> > with this patcheset applied), and get this on the first api test...
> >
>
> Ugh. Thanks for trying. I will have a look today.
>
>
> > Just try
> > cryptsetup open --type plain -c aes-cbc-essiv:sha256 /dev/sdd test
> >

Apologies, this was a rebase error on my part.

Could you please apply the hunk below and try again?

diff --git a/crypto/essiv.c b/crypto/essiv.c
index 029a65afb4d7..5dc2e592077e 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -243,6 +243,8 @@ static int essiv_aead_encrypt(struct aead_request *req)
 static int essiv_skcipher_decrypt(struct skcipher_request *req)
 {
        struct essiv_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+
+       essiv_skcipher_prepare_subreq(req);
        return crypto_skcipher_decrypt(&rctx->blockcipher_req);
 }
