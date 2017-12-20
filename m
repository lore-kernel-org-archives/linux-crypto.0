From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFT] crypto: aes-generic - turn off -ftree-pre and -ftree-sra
Date: Wed, 20 Dec 2017 22:31:08 +0100
Message-ID: <CAK8P3a0sFKB0Zs=R_Ban7R-Xgydd4ptxmPj03fS7B364abkOHg@mail.gmail.com>
References: <20171220205213.1025257-1-arnd@arndb.de> <CAKv+Gu_2V1C61N6iRQaarpb_dF+bDWVJTG3YLXF5Hzd04v72uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <james.l.morris@oracle.com>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:46092 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756004AbdLTVbJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 16:31:09 -0500
In-Reply-To: <CAKv+Gu_2V1C61N6iRQaarpb_dF+bDWVJTG3YLXF5Hzd04v72uw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 10:14 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 20 December 2017 at 20:52, Arnd Bergmann <arnd@arndb.de> wrote:
>
> You can use the tcrypt.ko module to benchmark AES.
>
> modprobe tcrypt mode=200 sec=1

Ok, that's what I was looking for. I don't think I'll have time to
analyze this before
my Christmas break (I'm only here one more day, and have not set up a test
environment for this)

> to run a (lengthy) AES benchmark in various modes. AES-128 in ECB mode
> using the largest block size tested is what I usually use for
> comparison.
>
> On my Cortex-A57, the generic AES code runs at ~18 cycles per byte.
> Note that we have alternative scalar implementations on ARM and arm64
> that are faster so the performance of aes-generic is not really
> relevant (and so it is essentially dead code)

Ok. arm64 is also the least affected by this problem out of all architectures,
but it most architectures don't have an optimized implementation.

      Arnd
