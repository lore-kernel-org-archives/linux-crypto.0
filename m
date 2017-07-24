From: zain wang <wzz@rock-chips.com>
Subject: [RESEND PATCH 0/2] crypto/rockchip: fix some issue which causes crypto failed
Date: Mon, 24 Jul 2017 09:23:12 +0800
Message-ID: <1500859394-1799-1-git-send-email-wzz@rock-chips.com>
Cc: jekarlson@gmail.com, shawn.lin@rock-chips.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        zain wang <wzz@rock-chips.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Stuebner <heiko@sntech.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.134]:34784 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdGXBXW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jul 2017 21:23:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These patches fix some bugs on rockchip's crypto which would cause crypto failed.

zain wang (2):
  crypto: rockchip - move the crypto completion from interrupt context
  crypto: rockchip - return the err code when unable dequeue the crypto
    request

 drivers/crypto/rockchip/rk3288_crypto.c            | 58 +++++++++++-----------
 drivers/crypto/rockchip/rk3288_crypto.h            |  4 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 17 ++++++-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 16 +++++-
 4 files changed, 62 insertions(+), 33 deletions(-)

-- 
1.9.1
