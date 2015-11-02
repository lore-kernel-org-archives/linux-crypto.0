From: Zain <zain.wang@rock-chips.com>
Subject: Re: [RESEND PATCH 2/4] clk: rockchip: set an id for crypto clk
Date: Mon, 2 Nov 2015 15:54:18 +0800
Message-ID: <563716AA.5050809@rock-chips.com>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com>
 <1446193369-4453-3-git-send-email-zain.wang@rock-chips.com>
 <4280600.OxjmG17dRp@phil>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com, Chris Zhong <zyw@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4280600.OxjmG17dRp@phil>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Heiko,

On 2015=E5=B9=B410=E6=9C=8830=E6=97=A5 16:54, Heiko Stuebner wrote:
> Hi Zain,
>
> Am Freitag, 30. Oktober 2015, 16:22:47 schrieb Zain Wang:
>> set an id for crypto clk, so that it can be called in other part.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchi=
p/clk-rk3288.c
>> index 9040878..d74bd5d 100644
>> --- a/drivers/clk/rockchip/clk-rk3288.c
>> +++ b/drivers/clk/rockchip/clk-rk3288.c
>> @@ -295,7 +295,7 @@ static struct rockchip_clk_branch rk3288_clk_bra=
nches[] __initdata =3D {
>>  			RK3288_CLKGATE_CON(0), 4, GFLAGS),
>>  	GATE(0, "c2c_host", "aclk_cpu_src", 0,
>>  			RK3288_CLKGATE_CON(13), 8, GFLAGS),
>> -	COMPOSITE_NOMUX(0, "crypto", "aclk_cpu_pre", 0,
>> +	COMPOSITE_NOMUX(SRST_CRYPTO, "crypto", "aclk_cpu_pre", 0,
> the id you want to use actually is a soft-reset index, not a clock-id=
=2E
> You would need to add a real id, in this case with an sclk_ prefix.
ok! done!
>
>>  			RK3288_CLKSEL_CON(26), 6, 2, DFLAGS,
>>  			RK3288_CLKGATE_CON(5), 4, GFLAGS),
>>  	GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
>>
> It should probably look more like below, but as suggested by Stephen =
Boyd
> in another thread, we should coordinate with Chris to add more necess=
ary clock
> ids in one go:
> -------- 8< -----------
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip=
/clk-rk3288.c
> index 9040878..9fd9f5a 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -295,7 +295,7 @@ static struct rockchip_clk_branch rk3288_clk_bran=
ches[] __initdata =3D {
>  			RK3288_CLKGATE_CON(0), 4, GFLAGS),
>  	GATE(0, "c2c_host", "aclk_cpu_src", 0,
>  			RK3288_CLKGATE_CON(13), 8, GFLAGS),
> -	COMPOSITE_NOMUX(0, "crypto", "aclk_cpu_pre", 0,
> +	COMPOSITE_NOMUX(SCLK_CRYPTO, "sclk_crypto", "aclk_cpu_pre", 0,
>  			RK3288_CLKSEL_CON(26), 6, 2, DFLAGS,
>  			RK3288_CLKGATE_CON(5), 4, GFLAGS),
>  	GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
> diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bind=
ings/clock/rk3288-cru.h
> index c719aac..9e0a5e9 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -86,6 +86,7 @@
>  #define SCLK_USBPHY480M_SRC	122
>  #define SCLK_PVTM_CORE		123
>  #define SCLK_PVTM_GPU		124
> +#define SCLK_CRYPTO		125
> =20
>  #define SCLK_MAC		151
>  #define SCLK_MACREF_OUT		152
