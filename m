Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9273CD37B4
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Sep 2023 16:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjIQQY4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Sep 2023 12:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbjIQQYu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Sep 2023 12:24:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B43012F
        for <linux-crypto@vger.kernel.org>; Sun, 17 Sep 2023 09:24:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4775DC433C7
        for <linux-crypto@vger.kernel.org>; Sun, 17 Sep 2023 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694967885;
        bh=+sl2lkrSu8NUZnETvkyZq5s3zUwNoDvzf/p0Y2y28sg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I8RGdQ0hBFICjZbal7eh6GYhM83ouDw4saZ2q7AuMAueKyG1GlT+z3IPb4+k6ZA6M
         0f0yJoOV/jdX4RnpEO+Xny6RC89hMfz+KXijA/ampBRDlJTbQ0a4YLrLLsXMP5DqVg
         5rhnGveeF7b7/kAnKkDbCLJ7GeoDxaZxRMVEv3lrKnwH8OtvvgNPm1wr8zSmGIm8tO
         DzV1WRfGVSQzgNaQiHnkxTFtnHtefDgBjELY5yhFmzPW6NRD3h+V08ZmdXS4pKP0hL
         w/XZZPVoYsGoUbJyjBd9HtdVL5foCs0StQB5NuBFQWHQOjgaBXP0wFBye9E+wiOHAd
         C+S9UE9gAHzsw==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-502fd1e1dd8so2307394e87.1
        for <linux-crypto@vger.kernel.org>; Sun, 17 Sep 2023 09:24:45 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx8w27XFJPEueMi9yy/S/NltyAdK9PXJL9aRvE2SO/StM8C2bM6
        OhULGAgbvXZ9amLIvFX571C5qa8Sb62RsLh5s44=
X-Google-Smtp-Source: AGHT+IHQ6Ld9WWXgxOWQzXce7JMm8OeSMCovx2MUWKHRzdOKGNVpm/jZYB/gxR58Lr6EV8Swt0zYt1rHh+8KCM/GwdU=
X-Received: by 2002:a05:6512:788:b0:4f8:7772:3dfd with SMTP id
 x8-20020a056512078800b004f877723dfdmr5818356lfr.11.1694967883460; Sun, 17 Sep
 2023 09:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
 <ZQLK0injXi7K3X1b@gondor.apana.org.au> <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
 <ZQLSlqJs///qoGCY@gondor.apana.org.au> <CAMj1kXE6mo2F7KgGmpygEs5cHf=mvUs2k3TT-xJ1wKP_YNGzFg@mail.gmail.com>
 <ZQLTl26H8TLFEP7r@gondor.apana.org.au>
In-Reply-To: <ZQLTl26H8TLFEP7r@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 17 Sep 2023 18:24:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFnZKABMdBntS3=ARJz-8BV7oG1VHnO7iiSj=5BbpJPDg@mail.gmail.com>
Message-ID: <CAMj1kXFnZKABMdBntS3=ARJz-8BV7oG1VHnO7iiSj=5BbpJPDg@mail.gmail.com>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 14 Sept 2023 at 11:34, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Sep 14, 2023 at 11:31:14AM +0200, Ard Biesheuvel wrote:
> >
> > ecb(aes)
>
> This is unnecessary as the generic template will construct an
> algorithm that's almost exactly the same as the underlying
> algorithm.  But you could register it if you want to.  The
> template instantiation is a one-off event.
>

Ported my RISC-V AES implementation here:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=riscv-scalar-aes

I will get back to this after mu holidays, early October.

Thanks,
