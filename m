Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:59057 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbeKIJWv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 04:22:51 -0500
MIME-Version: 1.0
References: <CAHmME9r=Zm4QzoRRdA88R0R56e3EJb+Psm7YeX6y2+ZhEjwYQg@mail.gmail.com>
 <CAKv+Gu8VDT0Z7j3dFAnWA_ruBHdQ9S7dZe=6Nym=sLsftLozYg@mail.gmail.com>
In-Reply-To: <CAKv+Gu8VDT0Z7j3dFAnWA_ruBHdQ9S7dZe=6Nym=sLsftLozYg@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 9 Nov 2018 00:44:42 +0100
Message-ID: <CAHmME9ojKS_NRUdDcSfMj5JerFCt3U1pWJkG73dFfYoUuUnRMA@mail.gmail.com>
Subject: Re: .S_shipped unnecessary?
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Ard,

On Fri, Nov 9, 2018 at 12:42 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Wonderful! Any problems doing that for x86_64 ?

The x86_64 is still a WIP, but hopefully we'll succeed.

> I agree 100%. When I added this the first time, it was at the request
> of the ARM maintainer, who was reluctant to rely on Perl for some
> reason.
>
> Recently, we have had to add a kludge to prevent spurious rebuilds of
> the .S_shipped files as well.
>
> I'd be perfectly happy to get rid of this entirely, and always
> generate the .S from the .pl, which to me is kind of the point of
> carrying these files in the first place.

Terrific. I'll move ahead in that direction then. It makes things _so_
much cleaner, and doesn't introduce new build modes ("should the
generated _ship go into the build directory or the source directory?
what kind of artifact is it? how to address $(srcdir) vs $(src) in
that context? bla bla") that really over complicate things.

Jason
