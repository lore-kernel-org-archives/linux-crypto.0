Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f45.google.com ([209.85.166.45]:36852 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbeKIJUB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 04:20:01 -0500
Received: by mail-io1-f45.google.com with SMTP id o19-v6so41425iod.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 Nov 2018 15:42:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHmME9r=Zm4QzoRRdA88R0R56e3EJb+Psm7YeX6y2+ZhEjwYQg@mail.gmail.com>
References: <CAHmME9r=Zm4QzoRRdA88R0R56e3EJb+Psm7YeX6y2+ZhEjwYQg@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 9 Nov 2018 00:42:05 +0100
Message-ID: <CAKv+Gu8VDT0Z7j3dFAnWA_ruBHdQ9S7dZe=6Nym=sLsftLozYg@mail.gmail.com>
Subject: Re: .S_shipped unnecessary?
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc: Eric Biggers <ebiggers@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(+ Masahiro, kbuild ml)

On 8 November 2018 at 21:37, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Ard, Eric, and others,
>
> As promised, the next Zinc patchset will have less generated code! After a
> bit of work with Andy and Samuel, I'll be bundling the perlasm.
>

Wonderful! Any problems doing that for x86_64 ?

> One thing I'm wondering about, though, is the wisdom behind the current
> .S_shipped pattern. Usually the _shipped is for big firmware blobs that are
> hard (or impossible) to build independently. But in this case, the .S is
> generated from the .pl significantly faster than gcc even compiles a basic
> C file. And, since perl is needed to build the kernel anyway, it's not like
> it will be impossible to find the right tools. Rather than clutter up commits
> with the .pl _and_ the .S_shipped, what would you think if I just generated
> the .S each time as an ordinary build artifact. AFAICT, this is fairly usual,
> and it's hard to see downsides. Hence, why I'm writing this email: are there
> any downsides to that?
>

I agree 100%. When I added this the first time, it was at the request
of the ARM maintainer, who was reluctant to rely on Perl for some
reason.

Recently, we have had to add a kludge to prevent spurious rebuilds of
the .S_shipped files as well.

I'd be perfectly happy to get rid of this entirely, and always
generate the .S from the .pl, which to me is kind of the point of
carrying these files in the first place.

Masahiro: do you see any problems with this?
