From: Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH 0/2] hwrng: meson: add clock handling
Date: Tue, 21 Feb 2017 02:58:14 +0100
Message-ID: <cac8bb2c-1a78-c710-ee12-46532c3d8d2e@baylibre.com>
References: <00b2a4cc-686e-0cc0-43e8-552b70a1e868@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org
To: Heiner Kallweit <hkallweit1@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36249 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdBUB62 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 20:58:28 -0500
Received: by mail-pg0-f48.google.com with SMTP id s67so15627375pgb.3
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2017 17:58:28 -0800 (PST)
In-Reply-To: <00b2a4cc-686e-0cc0-43e8-552b70a1e868@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/19/2017 09:30 PM, Heiner Kallweit wrote:
> The HW randon number generator requires a clock and we shouldn't rely
> on the boot loader to enable it.
> 
> Heiner Kallweit (2):
>   hwrng: meson: expose RNG0 clock via DT
>   hwrng: meson: add clock handling to driver
> 
>  arch/arm64/boot/dts/amlogic/meson-gx.dtsi   |  2 +-
>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi |  5 +++++
>  drivers/char/hw_random/meson-rng.c          | 27 ++++++++++++++++++++++++++-
>  include/dt-bindings/clock/gxbb-clkc.h       |  1 +
>  4 files changed, 33 insertions(+), 2 deletions(-)
> 

Hi Heiner,

Thanks for the fix, but can you also update the dt-bindings document ?
Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt

I also think this clock should be optional, to keep driver working using old bindings, set the core_clk to NULL if not available, clock_prepare_enable and clock_disable_unprepare won't fail with a NULL clock

Neil
