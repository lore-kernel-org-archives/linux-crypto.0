From: Scott Branden <scott.branden@broadcom.com>
Subject: Re: [PATCH 0/3] hw_random: bcm2835: Add support for Broadcom BCM5301x
Date: Wed, 22 Jun 2016 17:55:09 -0700
Message-ID: <576B336D.1000308@broadcom.com>
References: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: yendapally.reddy@broadcom.com, herbert@gondor.apana.org.au,
	eric@anholt.net, bcm-kernel-feedback-list@broadcom.com,
	devicetre@vger.kernel.org, hauke@hauke-m.de, zajec5@gmail.com,
	mpm@selenic.com, linux-arm-kernel@lists.infradead.org
To: Florian Fainelli <f.fainelli@gmail.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33898 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcFWAzR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 20:55:17 -0400
Received: by mail-pa0-f54.google.com with SMTP id bz2so21677297pad.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2016 17:55:17 -0700 (PDT)
In-Reply-To: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch series looks good.

Acked-by: Scott Branden <scott.branden@broadcom.com>

On 16-06-22 05:27 PM, Florian Fainelli wrote:
> Hi all,
>
> This patch series adds support for the Broadcom BCM5301x SoCs random number
> generator which is the same block as the one found in NSP and BCM2835.
>
> Florian Fainelli (3):
>    Documentation: devicetree: bindings: Add BCM5301x binding
>    hw_random: bcm2835: Add support for Broadcom BCM5301x
>    ARM: dts: BCM5301x: Add RNG Device Tree node
>
>   Documentation/devicetree/bindings/rng/brcm,bcm2835.txt | 3 ++-
>   arch/arm/boot/dts/bcm5301x.dtsi                        | 5 +++++
>   drivers/char/hw_random/Kconfig                         | 2 +-
>   drivers/char/hw_random/bcm2835-rng.c                   | 1 +
>   4 files changed, 9 insertions(+), 2 deletions(-)
>
