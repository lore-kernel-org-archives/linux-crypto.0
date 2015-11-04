From: Michael Turquette <mturquette@baylibre.com>
Subject: Re: [PATCH v1 2/4] clk: rockchip: set an id for crypto clk
Date: Wed, 04 Nov 2015 02:08:02 -0800
Message-ID: <20151104100802.22783.97388@quantum>
References: <1446529928-12521-1-git-send-email-zain.wang@rock-chips.com>
 <1446529928-12521-3-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, "Zain Wang" <zain.wang@rock-chips.com>
To: Zain Wang <zain.wang@rock-chips.com>, zhengsq@rock-chips.com,
	hl@rock-chips.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34157 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbbKDKIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Nov 2015 05:08:15 -0500
Received: by padhx2 with SMTP id hx2so41102513pad.1
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2015 02:08:14 -0800 (PST)
In-Reply-To: <1446529928-12521-3-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Zain Wang (2015-11-02 21:52:06)
> set an id for crypto clk, so that it can be called in other part.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>

Looks good to me. I can apply after -rc1 drops, or if you prefer to take
this series all together then you have my ack:

Acked-by: Michael Turquette <mturquette@baylibre.com>

Regards,
Mike

> ---
>  drivers/clk/rockchip/clk-rk3288.c      | 2 +-
>  include/dt-bindings/clock/rk3288-cru.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index 9040878..3fceda1 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -295,7 +295,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>                         RK3288_CLKGATE_CON(0), 4, GFLAGS),
>         GATE(0, "c2c_host", "aclk_cpu_src", 0,
>                         RK3288_CLKGATE_CON(13), 8, GFLAGS),
> -       COMPOSITE_NOMUX(0, "crypto", "aclk_cpu_pre", 0,
> +       COMPOSITE_NOMUX(SCLK_CRYPTO, "crypto", "aclk_cpu_pre", 0,
>                         RK3288_CLKSEL_CON(26), 6, 2, DFLAGS,
>                         RK3288_CLKGATE_CON(5), 4, GFLAGS),
>         GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
> diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
> index c719aac..30dcd60 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -86,6 +86,7 @@
>  #define SCLK_USBPHY480M_SRC    122
>  #define SCLK_PVTM_CORE         123
>  #define SCLK_PVTM_GPU          124
> +#define SCLK_CRYPTO                    125
>  
>  #define SCLK_MAC               151
>  #define SCLK_MACREF_OUT                152
> -- 
> 1.9.1
> 
> 
