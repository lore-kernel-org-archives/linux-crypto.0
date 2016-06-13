From: Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH v2 3/3] ARM64: dts: meson-gxbb: Add Hardware Random Generator node
Date: Mon, 13 Jun 2016 15:09:55 -0700
Message-ID: <m2ziqoviz0.fsf@baylibre.com>
References: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
	<1465546915-24229-4-git-send-email-narmstrong@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
To: Neil Armstrong <narmstrong@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34955 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbcFMWJ6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 18:09:58 -0400
Received: by mail-pf0-f170.google.com with SMTP id c2so50153531pfa.2
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2016 15:09:58 -0700 (PDT)
In-Reply-To: <1465546915-24229-4-git-send-email-narmstrong@baylibre.com> (Neil
	Armstrong's message of "Fri, 10 Jun 2016 10:21:55 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Neil,

Neil Armstrong <narmstrong@baylibre.com> writes:

> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> index 832815d..8353621 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> @@ -167,6 +167,11 @@
>  			};
>  		};
>  
> +		rng {
> +			compatible = "amlogic,meson-rng";
> +			reg = <0x0 0xc8834000 0x0 0x4>;
> +		};

This should be under the periphs bus, with an offset of 0x0 instead of
at the top level.

See the for-next branch in the linux-amlogic tree[1] which has separate
busses for periphs and hiu.

Kevin

[1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-amlogic.git
