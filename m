From: Zain <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v3 2/4] clk: rockchip: set an ID for crypto clk
Date: Fri, 13 Nov 2015 14:53:00 +0800
Message-ID: <564588CC.8030300@rock-chips.com>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
 <1790934.FgjVNmeB1J@phil> <5643E7B0.2080901@rock-chips.com>
 <1838616.4qxqO6ir89@phil>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org
To: Heiko Stuebner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1838616.4qxqO6ir89@phil>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org



On 2015=E5=B9=B411=E6=9C=8812=E6=97=A5 16:40, Heiko Stuebner wrote:
> Am Donnerstag, 12. November 2015, 09:13:20 schrieb Zain:
>> On 2015=E5=B9=B411=E6=9C=8812=E6=97=A5 07:57, Heiko Stuebner wrote:
>>> Am Mittwoch, 11. November 2015, 14:35:57 schrieb Zain Wang:
>>>> Set an ID for crypto clk, so that it can be called in other part.
>>>>
>>>> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>>> this should go in together with patch4, the dts change, so an Ack f=
rom the
>>> clock-maintainers would be nice :-)
>>>
>>>
>>> Heiko
>> Ok! Done!
>> Thanks.
> I'm not sure I understand that.
>
> There is nothing to do for you here, I was merely stating the fact th=
at
> we will need to get an Acked-by from the clock maintainers, to allow
> me to take both this and the devicetree patch :-)
>
>
> Heiko
I am sorry that I think you told me to put the two patches together in
next version at first.
Thanks for your writing back.

Zain
>
>>>> ---
>>>>
>>>> Changed in v3:
>>>> - None
>>>>
>>>> Changed in v2:=20
>>>> - None
>>>>
>>>> Changed in v1:
>>>> - define SCLK_CRYPTO in rk3288-cru.h
>>>> - use SCLK_CRYPTO instead of SRST_CRYPTO
>>>>
>>>>  drivers/clk/rockchip/clk-rk3288.c      | 2 +-
>>>>  include/dt-bindings/clock/rk3288-cru.h | 1 +
>>>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockc=
hip/clk-rk3288.c
>>>> index 9040878..3fceda1 100644
>>>> --- a/drivers/clk/rockchip/clk-rk3288.c
>>>> +++ b/drivers/clk/rockchip/clk-rk3288.c
>>>> @@ -295,7 +295,7 @@ static struct rockchip_clk_branch rk3288_clk_b=
ranches[] __initdata =3D {
>>>>  			RK3288_CLKGATE_CON(0), 4, GFLAGS),
>>>>  	GATE(0, "c2c_host", "aclk_cpu_src", 0,
>>>>  			RK3288_CLKGATE_CON(13), 8, GFLAGS),
>>>> -	COMPOSITE_NOMUX(0, "crypto", "aclk_cpu_pre", 0,
>>>> +	COMPOSITE_NOMUX(SCLK_CRYPTO, "crypto", "aclk_cpu_pre", 0,
>>>>  			RK3288_CLKSEL_CON(26), 6, 2, DFLAGS,
>>>>  			RK3288_CLKGATE_CON(5), 4, GFLAGS),
>>>>  	GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
>>>> diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-b=
indings/clock/rk3288-cru.h
>>>> index c719aac..30dcd60 100644
>>>> --- a/include/dt-bindings/clock/rk3288-cru.h
>>>> +++ b/include/dt-bindings/clock/rk3288-cru.h
>>>> @@ -86,6 +86,7 @@
>>>>  #define SCLK_USBPHY480M_SRC	122
>>>>  #define SCLK_PVTM_CORE		123
>>>>  #define SCLK_PVTM_GPU		124
>>>> +#define SCLK_CRYPTO			125
>>>> =20
>>>>  #define SCLK_MAC		151
>>>>  #define SCLK_MACREF_OUT		152
>>>>
>>>
>>>
>>
>>
>
>
>


--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
