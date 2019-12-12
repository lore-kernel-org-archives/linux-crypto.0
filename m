Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C4DC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75683214D8
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u6i604Gu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfLLO0g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:26:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55155 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbfLLO0g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 09:26:36 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so2572672wmj.4
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 06:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/DN6p2Ch7R+6bHk3UTVmBnzdRsugLPXoWrAyTdUkcw8=;
        b=u6i604GuOCZ/0XT4pJYSmeCPPhoaB8Nf6Nt1XZ/4jFfXgxRBzoSoOpyW1iVkLiaJh/
         o8bcEVve9Pw5JOmbj+4meLGvI52cyB+yUkGMpZRPAhP4/7+JnjE3Rjbp/tLiP2vu7DcB
         eDF1Q1IPKyi0A+qmExTdXWZtie++lmgp599WBoYZ/LrKsjC4aOJAOtXMQjaUIYe3SGCL
         f4g3PFQ5KHZacG+sYT4+BgHMJJ/iO95JLi0QXl94RBbveszEQDC+2iyKLvmdTg83wizG
         5VgnvW8mDhNyATj+u/KtzTcJtd1pTKayejX0sILRz+K0r5duGwV1DUPVoNW701+J8SPQ
         8mpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/DN6p2Ch7R+6bHk3UTVmBnzdRsugLPXoWrAyTdUkcw8=;
        b=t2HjrM2vaILiblMXuEneJi9LqHw98XcWgp5PC5w+BAnPZOKQ8OtiU1Et39+d0RcWdo
         ZGBBVNjI2uyt4yjwsySp0cI2NJ4/U65C1WscZrK8iILYbwc6l+trQeqsXM/nZ9IfzE8R
         1gXrKF7xSz/TsXOcmKLZNJX2yGw6Ll8/6a7j6FEq7pBzN+4ElX9bVqebZhkIwQeQtTFU
         S3EIMFrPmmQcCRihyMOyJfcJIJlEf4r6WL3glJSchO/oQ7Aw82Zyb56ANNcwzA62tc6T
         5IqnEix9u7qNHIWBW1ApQXrI2vjfEWfAGh3AddyXrWq7zR81sQJ22S5i+0CDsJV5fTzk
         Oz/Q==
X-Gm-Message-State: APjAAAUWG4VfS5Bs3G0esnaEbFT/OM4fwbXldXuP6RHsmqbCKzaz8R/Y
        LlQRq5sSswn6NBkPYYIXYEq00V3Dq2bK/QXMrtuv+tkA5HDr/w==
X-Google-Smtp-Source: APXvYqxm1kZCoWk19Tg6h5hEk2VBNoWUWzbRMXFBcOgUiOk78sPoaOQjPstajKQOAWCQpUcuIcfb0Uvvr5L0ZhIH6yA=
X-Received: by 2002:a1c:a795:: with SMTP id q143mr6684960wme.52.1576160794693;
 Thu, 12 Dec 2019 06:26:34 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
 <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com> <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
In-Reply-To: <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 12 Dec 2019 15:26:22 +0100
Message-ID: <CAKv+Gu80EVN-_aHPSYUu=0TvFJERBMKFvQS-gce3z_jx=X7www@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Martin Willi <martin@strongswan.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 12 Dec 2019 at 14:47, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Dec 12, 2019 at 2:08 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi Martin,
> >
> > On Thu, Dec 12, 2019 at 1:03 PM Martin Willi <martin@strongswan.org> wrote:
> > > Can you provide some numbers to testify that? In my tests, the 32-bit
> > > version gives me exact the same results.
> >
> > On 32-bit, if you only call update() once, then the results are the
> > same. However, as soon as you call it more than once, this new version
> > has increasing gains. Other than that, they should behave pretty much
> > identically.
>
> Oh, you asked for numbers. I just fired up an Armada 370/XP and am
> seeing a 8% increase in performance on calls to the update function.

It would help if we could get some actual numbers. I usually try to
capture the performance delta for a small set of block sizes that are
significant for the use case at hand, e.g., like so [0], and also
include blocksizes that are not 2^n. If the change improves the
general case without causing any significant regressions elsewhere, I
don't think we need to continue this debate.




[0] https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=11031c0d7d6e9bca0df233a8acfd6708d2b89470
