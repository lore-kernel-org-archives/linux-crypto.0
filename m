From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/2] hwrng: meson: add clock handling
Date: Sun, 19 Feb 2017 21:30:58 +0100
Message-ID: <00b2a4cc-686e-0cc0-43e8-552b70a1e868@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org
To: Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35684 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdBSUbH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2017 15:31:07 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so11123362wmu.2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2017 12:31:06 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The HW randon number generator requires a clock and we shouldn't rely
on the boot loader to enable it.

Heiner Kallweit (2):
  hwrng: meson: expose RNG0 clock via DT
  hwrng: meson: add clock handling to driver

 arch/arm64/boot/dts/amlogic/meson-gx.dtsi   |  2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi |  5 +++++
 drivers/char/hw_random/meson-rng.c          | 27 ++++++++++++++++++++++++++-
 include/dt-bindings/clock/gxbb-clkc.h       |  1 +
 4 files changed, 33 insertions(+), 2 deletions(-)

-- 
2.11.1
