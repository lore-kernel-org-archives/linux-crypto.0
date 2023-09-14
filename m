Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65028EDE99C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbjINJbb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbjINJbb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:31:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2915CBB
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:31:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F86C433CA
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694683886;
        bh=Y81nEm+08vN1p4uDyRXtXGjbvYexXjVWhATeMOgu3wk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FeDdInOKVq1F+p1t4W9Djp7IiHkoUP0lh3jBMfUzIguIuwu2RTbAou0aoGZNlmFa5
         Rv9MM/PU1MxCaMY+MBzL2w5/F3iwut+CiZbQoB7shONxUR58RCnj+FEqfD1Kohf/t9
         5k/8tE4iblqRPJL6/Je/wPmgBG/S6ddoboJkpSWn+sevuOnSY4tGLwpgk1/KHYa934
         4mOPJMj0ImZ6slHXys7/H0ZKR5Av87G48uGR9RtRiC4WrTQ9b3WzSrKvwkPIvHMVkr
         HXl0C/aAANqBofZ4CfxfJKo2r9s9m38IFKE9KQcKskLUNxvHKG70cLbbiD6jbdPfTd
         tuTfdA6tP6Iig==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2bcb50e194dso11378641fa.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:31:26 -0700 (PDT)
X-Gm-Message-State: AOJu0YwgB0ju0Saz2YKWKjPaCBgYBfNClkUWGtVF+s6A9Z88NFrBiGX7
        qGnuzf3kLELVq5BjByoHn7BN5GaYPcsnajVT1z4=
X-Google-Smtp-Source: AGHT+IH0l34bfner6TrnMeFTkeCVkgRu4HJSBOlO+icM4CwAbSalKBHE8Rgkn+qrMD6ejl10tZdDHeBZIXaXMnhZ/f0=
X-Received: by 2002:a05:651c:1034:b0:2bd:d31:cf32 with SMTP id
 w20-20020a05651c103400b002bd0d31cf32mr4203792ljm.15.1694683885007; Thu, 14
 Sep 2023 02:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
 <ZQLK0injXi7K3X1b@gondor.apana.org.au> <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
 <ZQLSlqJs///qoGCY@gondor.apana.org.au>
In-Reply-To: <ZQLSlqJs///qoGCY@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Sep 2023 11:31:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE6mo2F7KgGmpygEs5cHf=mvUs2k3TT-xJ1wKP_YNGzFg@mail.gmail.com>
Message-ID: <CAMj1kXE6mo2F7KgGmpygEs5cHf=mvUs2k3TT-xJ1wKP_YNGzFg@mail.gmail.com>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 14 Sept 2023 at 11:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Sep 14, 2023 at 11:18:00AM +0200, Ard Biesheuvel wrote:
> >
> > So this means that the base name will be aes, not ecb(aes), right?
> > What about cbc and ctr? It makes sense for a single lskcipher to
> > implement all three of those at least, so that algorithms like XTS and
> > GCM can be implemented cheaply using generic templates, without the
> > need to call into the lskcipher for each block of input.
>
> You can certainly implement all three with arch-specific code
> but I didn't think there was a need to do this for the generic
> version.
>

Fair enough. So what should such an arch version implement?

aes
cbc(aes)
ctr(aes)

or

ecb(aes)
cbc(aes)
ctr(aes)

?
