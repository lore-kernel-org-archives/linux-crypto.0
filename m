From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/2] crypto: arm64/ARM: NEON accelerated ChaCha20
Date: Tue, 27 Dec 2016 19:17:54 +0000
Message-ID: <CAKv+Gu8WphgNzb-2cBUgyh58goW0a0LOnfBgWsVu-J74Cd=_zQ@mail.gmail.com>
References: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org> <CAH8yC8kJiKc4Oz8RAob_5oRoQeACqvqXyj2UAsfv4bQ_TmKG-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:33610 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753749AbcL0TRz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 14:17:55 -0500
Received: by mail-it0-f41.google.com with SMTP id c20so58266571itb.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2016 11:17:55 -0800 (PST)
In-Reply-To: <CAH8yC8kJiKc4Oz8RAob_5oRoQeACqvqXyj2UAsfv4bQ_TmKG-w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 27 December 2016 at 15:36, Jeffrey Walton <noloader@gmail.com> wrote:
>> ChaCha20 is a stream cipher described in RFC 7539, and is intended to be
>> an efficient software implementable 'standby cipher', in case AES cannot
>> be used.
>
> That's not quite correct.
>
> The IETF changed the algorithm a bit, and its not compatible with
> Bernstein's ChaCha. They probably should have differentiated the name
> to avoid this sort of confusion.
>
> You can find Bernstein's specification for ChaCha at
> https://cr.yp.to/chacha.html, and the test vectors for Bernstein's
> specification at
> http://tools.ietf.org/html/draft-strombergson-chacha-test-vectors.
>

Thanks for the clarification. However, this should not affect the
content of the patches: they simply reimplement in ARM SIMD what the
kernel already knows as "chacha20", which is the IETF derivative
rather than djb's original. I will mention this in the cover letter of
the next respin (given that I need to respin these anyway)
