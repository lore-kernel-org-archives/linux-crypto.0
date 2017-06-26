From: Frans Klaver <fransklaver@gmail.com>
Subject: Re: [PATCH v4] crypto: sun4i-ss: support the Security System PRNG
Date: Mon, 26 Jun 2017 14:36:43 +0200
Message-ID: <CAH6sp9Nm-hDxNSNNYxonBzSGyM769WoKQwjX2CN-RPRr=Oxu4g@mail.gmail.com>
References: <20170626122055.5253-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com, linux-crypto@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:32949 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdFZMgz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 08:36:55 -0400
In-Reply-To: <20170626122055.5253-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Mon, Jun 26, 2017 at 2:20 PM, Corentin Labbe
<clabbe.montjoie@gmail.com> wrote:
> The Security System have a PRNG, this patch add support for it via
> crypto_rng.

s,have,has,
s,add,adds,

>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>
> Changes since v3 (note: the v3 miss changes and version tag sorry)
> - Replaced all len values with bits / BITS_PER_LONG or BITS_PER_BYTE
>
> Changes since v2
>  - converted to crypto_rng
>
> Changes since v1:
>  - Replaced all spin_lock_bh by simple spin_lock
>  - Removed handling of size not modulo 4 which will never happen
>  - Added add_random_ready_callback()
>
>  drivers/crypto/Kconfig                  |  8 +++++
>  drivers/crypto/sunxi-ss/Makefile        |  1 +
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c | 30 ++++++++++++++++++
>  drivers/crypto/sunxi-ss/sun4i-ss-prng.c | 56 +++++++++++++++++++++++++++++++++
>  drivers/crypto/sunxi-ss/sun4i-ss.h      | 11 +++++++
>  5 files changed, 106 insertions(+)
>  create mode 100644 drivers/crypto/sunxi-ss/sun4i-ss-prng.c
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index ab82536d64e2..bde0b102eb70 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -618,6 +618,14 @@ config CRYPTO_DEV_SUN4I_SS
>           To compile this driver as a module, choose M here: the module
>           will be called sun4i-ss.
>
> +config CRYPTO_DEV_SUN4I_SS_PRNG
> +       bool "Support for Allwinner Security System PRNG"
> +       depends on CRYPTO_DEV_SUN4I_SS
> +       select CRYPTO_RNG
> +       help
> +         Select this option if you to provides kernel-side support for
> +         the Pseudo-Random Number Generator found in the Security System.

This sentence does not parse. "Select this option if you want to
provide kernel-side for ...". Alternatively: "This option enables
kernel-side support for ..."

Frans
