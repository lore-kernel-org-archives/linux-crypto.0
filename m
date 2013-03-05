From: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
Date: Tue, 5 Mar 2013 08:48:19 +0100
Message-ID: <CACKLOr2kuWXMreEFA4wqyYVRNnPwmEoHPM2+V+tN5P_1bQ+iJQ@mail.gmail.com>
References: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
	<1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
	<20130304075306.GA1906@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, herbert@gondor.apana.org.au,
	kernel@pengutronix.de, gcembed@gmail.com, shawn.guo@linaro.org,
	arnd@arndb.de, swarren@nvidia.com
To: Sascha Hauer <s.hauer@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51772 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3CEHsU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Mar 2013 02:48:20 -0500
Received: by mail-we0-f170.google.com with SMTP id z53so5577874wey.15
        for <linux-crypto@vger.kernel.org>; Mon, 04 Mar 2013 23:48:19 -0800 (PST)
In-Reply-To: <20130304075306.GA1906@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sascha,

On 4 March 2013 08:53, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Fri, Mar 01, 2013 at 12:37:52PM +0100, Javier Martin wrote:
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  arch/arm/mach-imx/clk-imx27.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
>> index 4c1d1e4..0b9664a 100644
>> --- a/arch/arm/mach-imx/clk-imx27.c
>> +++ b/arch/arm/mach-imx/clk-imx27.c
>> @@ -253,6 +253,8 @@ int __init mx27_clocks_init(unsigned long fref)
>>       clk_register_clkdev(clk[nfc_baud_gate], NULL, "imx27-nand.0");
>>       clk_register_clkdev(clk[vpu_baud_gate], "per", "coda-imx27.0");
>>       clk_register_clkdev(clk[vpu_ahb_gate], "ahb", "coda-imx27.0");
>> +     clk_register_clkdev(clk[sahara_ahb_gate], "ahb", "sahara-imx27.0");
>> +     clk_register_clkdev(clk[sahara_ipg_gate], "ipg", "sahara-imx27.0");
>
> One of the first patches I want to push upstream for the next merge
> window is this one:
>
> https://patchwork.kernel.org/patch/1817741/
>
> So the change above becomes unnecessary

Very good. Then this patch can be safely dropped.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
