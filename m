From: Heiko Stuebner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [RESEND PATCH 2/4] clk: rockchip: set an id for crypto clk
Date: Fri, 30 Oct 2015 09:54:02 +0100
Message-ID: <4280600.OxjmG17dRp@phil>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com> <1446193369-4453-3-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Chris Zhong <zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
To: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446193369-4453-3-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Zain,

Am Freitag, 30. Oktober 2015, 16:22:47 schrieb Zain Wang:
> set an id for crypto clk, so that it can be called in other part.
> 
> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index 9040878..d74bd5d 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -295,7 +295,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>  			RK3288_CLKGATE_CON(0), 4, GFLAGS),
>  	GATE(0, "c2c_host", "aclk_cpu_src", 0,
>  			RK3288_CLKGATE_CON(13), 8, GFLAGS),
> -	COMPOSITE_NOMUX(0, "crypto", "aclk_cpu_pre", 0,
> +	COMPOSITE_NOMUX(SRST_CRYPTO, "crypto", "aclk_cpu_pre", 0,

the id you want to use actually is a soft-reset index, not a clock-id.
You would need to add a real id, in this case with an sclk_ prefix.

>  			RK3288_CLKSEL_CON(26), 6, 2, DFLAGS,
>  			RK3288_CLKGATE_CON(5), 4, GFLAGS),
>  	GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
> 

It should probably look more like below, but as suggested by Stephen Boyd
in another thread, we should coordinate with Chris to add more necessary clock
ids in one go:
-------- 8< -----------
diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 9040878..9fd9f5a 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -295,7 +295,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKGATE_CON(0), 4, GFLAGS),
 	GATE(0, "c2c_host", "aclk_cpu_src", 0,
 			RK3288_CLKGATE_CON(13), 8, GFLAGS),
-	COMPOSITE_NOMUX(0, "crypto", "aclk_cpu_pre", 0,
+	COMPOSITE_NOMUX(SCLK_CRYPTO, "sclk_crypto", "aclk_cpu_pre", 0,
 			RK3288_CLKSEL_CON(26), 6, 2, DFLAGS,
 			RK3288_CLKGATE_CON(5), 4, GFLAGS),
 	GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index c719aac..9e0a5e9 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -86,6 +86,7 @@
 #define SCLK_USBPHY480M_SRC	122
 #define SCLK_PVTM_CORE		123
 #define SCLK_PVTM_GPU		124
+#define SCLK_CRYPTO		125
 
 #define SCLK_MAC		151
 #define SCLK_MACREF_OUT		152
-- 
2.6.1

-------- 8< -----------
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
