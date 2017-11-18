From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 0/2] ARM: bcm283x: Add missing interrupt for RNG block
Date: Sat, 18 Nov 2017 14:04:11 +0100
Message-ID: <1511010253-5006-1-git-send-email-stefan.wahren@i2se.com>
Cc: Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        Stefan Wahren <stefan.wahren@i2se.com>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:49413 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424309AbdKRNF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Nov 2017 08:05:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Florian,

i do not know your plans for V3 of your RNG consolidation series, but
there is the wish of the FreeBSD guys to add the interrupt property to
the DTS file [1].

There is no high prio, so feel free to squash it into your series or
i could rebase on your next version.

[1] - https://github.com/raspberrypi/linux/issues/2195

Stefan Wahren (2):
  dt-binding: rng: Add interrupt property for BCM2835
  ARM: bcm283x: Add missing interrupt for RNG block

 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt | 9 +++++++--
 arch/arm/boot/dts/bcm283x.dtsi                         | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.7.4
