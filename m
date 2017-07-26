From: Emil Karlson <jekarlson@gmail.com>
Subject: Re: [RESEND PATCH 0/2] crypto/rockchip: fix some issue which causes
 crypto failed
Date: Wed, 26 Jul 2017 20:44:18 +0300
Message-ID: <CAELSAVZAs=Tqz_yHb2u8StXFeC550Tm98jqmnRFZLRmFCqs0bA@mail.gmail.com>
References: <1500859394-1799-1-git-send-email-wzz@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Stuebner <heiko@sntech.de>, shawn.lin@rock-chips.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
To: zain wang <wzz@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38087 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750897AbdGZRoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jul 2017 13:44:19 -0400
In-Reply-To: <1500859394-1799-1-git-send-email-wzz@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Greetings

While I am not getting the original error anymore, using dm-crypt
still fails at cryptsetup luksOpen with [rk_ablk_rx:331] Lack of data
https://users.aalto.fi/~jkarlson/files/rk3288-fail_2017-07-24.jpg

Test platform: Asus chromebook C201/rk3288 linux-4.12.3+ this patchset

Best Regards
-Emil

On Mon, Jul 24, 2017 at 4:23 AM, zain wang <wzz@rock-chips.com> wrote:
> These patches fix some bugs on rockchip's crypto which would cause crypto failed.
>
> zain wang (2):
>   crypto: rockchip - move the crypto completion from interrupt context
>   crypto: rockchip - return the err code when unable dequeue the crypto
>     request
>
>  drivers/crypto/rockchip/rk3288_crypto.c            | 58 +++++++++++-----------
>  drivers/crypto/rockchip/rk3288_crypto.h            |  4 +-
>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 17 ++++++-
>  drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 16 +++++-
>  4 files changed, 62 insertions(+), 33 deletions(-)
>
> --
> 1.9.1
>
>
