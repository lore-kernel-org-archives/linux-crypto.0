From: Paul Burton <paul.burton@imgtec.com>
Subject: Re: [PATCH 2/6] crypto: jz4780-rng: Make ingenic CGU driver use syscon
Date: Fri, 18 Aug 2017 13:48:46 -0700
Message-ID: <3563032.h0vdzx9HfC@np-p-burton>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com> <20170817182520.20102-3-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1799162.5tN5njOGM8";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: <linux-mips@linux-mips.org>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <ralf@linux-mips.org>, <mturquette@baylibre.com>,
        <sboyd@codeaurora.org>, <davem@davemloft.net>,
        <paul@crapouillou.net>, <linux-crypto@vger.kernel.org>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:25125 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdHRUs6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2017 16:48:58 -0400
In-Reply-To: <20170817182520.20102-3-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart1799162.5tN5njOGM8
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi PrasannaKumar,

On Thursday, 17 August 2017 11:25:16 PDT PrasannaKumar Muralidharan wrote:
> Ingenic PRNG registers are a part of the same hardware block as clock
> and power stuff. It is handled by CGU driver. Ingenic M200 SoC has power
> related registers that are after the PRNG registers. So instead of
> shortening the register range use syscon interface to expose regmap.
> This regmap is used by the PRNG driver.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
>  arch/mips/boot/dts/ingenic/jz4740.dtsi | 14 +++++++----
>  arch/mips/boot/dts/ingenic/jz4780.dtsi | 14 +++++++----
>  drivers/clk/ingenic/cgu.c              | 46
> +++++++++++++++++++++------------- drivers/clk/ingenic/cgu.h              |
>  9 +++++--
>  drivers/clk/ingenic/jz4740-cgu.c       | 30 +++++++++++-----------
>  drivers/clk/ingenic/jz4780-cgu.c       | 10 ++++----
>  6 files changed, 73 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/mips/boot/dts/ingenic/jz4740.dtsi
> b/arch/mips/boot/dts/ingenic/jz4740.dtsi index 2ca7ce7..ada5e67 100644
> --- a/arch/mips/boot/dts/ingenic/jz4740.dtsi
> +++ b/arch/mips/boot/dts/ingenic/jz4740.dtsi
> @@ -34,14 +34,18 @@
>  		clock-frequency = <32768>;
>  	};
> 
> -	cgu: jz4740-cgu@10000000 {
> -		compatible = "ingenic,jz4740-cgu";
> +	cgu_registers {
> +		compatible = "simple-mfd", "syscon";
>  		reg = <0x10000000 0x100>;
> 
> -		clocks = <&ext>, <&rtc>;
> -		clock-names = "ext", "rtc";
> +		cgu: jz4780-cgu@10000000 {
> +			compatible = "ingenic,jz4740-cgu";
> 
> -		#clock-cells = <1>;
> +			clocks = <&ext>, <&rtc>;
> +			clock-names = "ext", "rtc";
> +
> +			#clock-cells = <1>;
> +		};
>  	};
> 
>  	rtc_dev: rtc@10003000 {
> diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi
> b/arch/mips/boot/dts/ingenic/jz4780.dtsi index 4853ef6..1301694 100644
> --- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
> +++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
> @@ -34,14 +34,18 @@
>  		clock-frequency = <32768>;
>  	};
> 
> -	cgu: jz4780-cgu@10000000 {
> -		compatible = "ingenic,jz4780-cgu";
> +	cgu_registers {
> +		compatible = "simple-mfd", "syscon";
>  		reg = <0x10000000 0x100>;
> 
> -		clocks = <&ext>, <&rtc>;
> -		clock-names = "ext", "rtc";
> +		cgu: jz4780-cgu@10000000 {
> +			compatible = "ingenic,jz4780-cgu";
> 
> -		#clock-cells = <1>;
> +			clocks = <&ext>, <&rtc>;
> +			clock-names = "ext", "rtc";
> +
> +			#clock-cells = <1>;
> +		};
>  	};
> 
>  	pinctrl: pin-controller@10010000 {
> diff --git a/drivers/clk/ingenic/cgu.c b/drivers/clk/ingenic/cgu.c
> index e8248f9..2f12c7c 100644
> --- a/drivers/clk/ingenic/cgu.c
> +++ b/drivers/clk/ingenic/cgu.c
> @@ -29,6 +29,18 @@
> 
>  #define MHZ (1000 * 1000)
> 
> +unsigned int cgu_readl(struct ingenic_cgu *cgu, unsigned int reg)
> +{
> +	unsigned int val = 0;
> +	regmap_read(cgu->regmap, reg, &val);
> +	return val;
> +}
> +
> +int cgu_writel(struct ingenic_cgu *cgu, unsigned int val, unsigned int reg)
> +{
> +	return regmap_write(cgu->regmap, reg, val);
> +}

This is going to introduce a lot of overhead to the CGU driver - each 
regmap_read() or regmap_write() call will not only add overhead from the 
indirection but also acquire a lock which we really don't need.

Could you instead perhaps:

 - Just add "syscon" as a second compatible string to the CGU node in the
   device tree, but otherwise leave it as-is without the extra cgu_registers
   node.

 - Have your RNG device node as a child of the CGU node, which should let it
   pick up the regmap via syscon_node_to_regmap() as it already does.

 - Leave the CGU driver as-is, so it can continue accessing memory directly
   rather than via regmap.

Thanks,
    Paul

> +
>  /**
>   * ingenic_cgu_gate_get() - get the value of clock gate register bit
>   * @cgu: reference to the CGU whose registers should be read
> @@ -43,7 +55,7 @@ static inline bool
>  ingenic_cgu_gate_get(struct ingenic_cgu *cgu,
>  		     const struct ingenic_cgu_gate_info *info)
>  {
> -	return readl(cgu->base + info->reg) & BIT(info->bit);
> +	return cgu_readl(cgu, info->reg) & BIT(info->bit);
>  }
> 
>  /**
> @@ -60,14 +72,14 @@ static inline void
>  ingenic_cgu_gate_set(struct ingenic_cgu *cgu,
>  		     const struct ingenic_cgu_gate_info *info, bool val)
>  {
> -	u32 clkgr = readl(cgu->base + info->reg);
> +	u32 clkgr = cgu_readl(cgu, info->reg);
> 
>  	if (val)
>  		clkgr |= BIT(info->bit);
>  	else
>  		clkgr &= ~BIT(info->bit);
> 
> -	writel(clkgr, cgu->base + info->reg);
> +	cgu_writel(cgu, clkgr, info->reg);
>  }
> 
>  /*
> @@ -91,7 +103,7 @@ ingenic_pll_recalc_rate(struct clk_hw *hw, unsigned long
> parent_rate) pll_info = &clk_info->pll;
> 
>  	spin_lock_irqsave(&cgu->lock, flags);
> -	ctl = readl(cgu->base + pll_info->reg);
> +	ctl = cgu_readl(cgu, pll_info->reg);
>  	spin_unlock_irqrestore(&cgu->lock, flags);
> 
>  	m = (ctl >> pll_info->m_shift) & GENMASK(pll_info->m_bits - 1, 0);
> @@ -190,7 +202,7 @@ ingenic_pll_set_rate(struct clk_hw *hw, unsigned long
> req_rate, clk_info->name, req_rate, rate);
> 
>  	spin_lock_irqsave(&cgu->lock, flags);
> -	ctl = readl(cgu->base + pll_info->reg);
> +	ctl = cgu_readl(cgu, pll_info->reg);
> 
>  	ctl &= ~(GENMASK(pll_info->m_bits - 1, 0) << pll_info->m_shift);
>  	ctl |= (m - pll_info->m_offset) << pll_info->m_shift;
> @@ -204,11 +216,11 @@ ingenic_pll_set_rate(struct clk_hw *hw, unsigned long
> req_rate, ctl &= ~BIT(pll_info->bypass_bit);
>  	ctl |= BIT(pll_info->enable_bit);
> 
> -	writel(ctl, cgu->base + pll_info->reg);
> +	cgu_writel(cgu, ctl, pll_info->reg);
> 
>  	/* wait for the PLL to stabilise */
>  	for (i = 0; i < timeout; i++) {
> -		ctl = readl(cgu->base + pll_info->reg);
> +		ctl = cgu_readl(cgu, pll_info->reg);
>  		if (ctl & BIT(pll_info->stable_bit))
>  			break;
>  		mdelay(1);
> @@ -243,7 +255,7 @@ static u8 ingenic_clk_get_parent(struct clk_hw *hw)
>  	clk_info = &cgu->clock_info[ingenic_clk->idx];
> 
>  	if (clk_info->type & CGU_CLK_MUX) {
> -		reg = readl(cgu->base + clk_info->mux.reg);
> +		reg = cgu_readl(cgu, clk_info->mux.reg);
>  		hw_idx = (reg >> clk_info->mux.shift) &
>  			 GENMASK(clk_info->mux.bits - 1, 0);
> 
> @@ -297,10 +309,10 @@ static int ingenic_clk_set_parent(struct clk_hw *hw,
> u8 idx) spin_lock_irqsave(&cgu->lock, flags);
> 
>  		/* write the register */
> -		reg = readl(cgu->base + clk_info->mux.reg);
> +		reg = cgu_readl(cgu, clk_info->mux.reg);
>  		reg &= ~mask;
>  		reg |= hw_idx << clk_info->mux.shift;
> -		writel(reg, cgu->base + clk_info->mux.reg);
> +		cgu_writel(cgu, reg, clk_info->mux.reg);
> 
>  		spin_unlock_irqrestore(&cgu->lock, flags);
>  		return 0;
> @@ -321,7 +333,7 @@ ingenic_clk_recalc_rate(struct clk_hw *hw, unsigned long
> parent_rate) clk_info = &cgu->clock_info[ingenic_clk->idx];
> 
>  	if (clk_info->type & CGU_CLK_DIV) {
> -		div_reg = readl(cgu->base + clk_info->div.reg);
> +		div_reg = cgu_readl(cgu, clk_info->div.reg);
>  		div = (div_reg >> clk_info->div.shift) &
>  		      GENMASK(clk_info->div.bits - 1, 0);
>  		div += 1;
> @@ -399,7 +411,7 @@ ingenic_clk_set_rate(struct clk_hw *hw, unsigned long
> req_rate, return -EINVAL;
> 
>  		spin_lock_irqsave(&cgu->lock, flags);
> -		reg = readl(cgu->base + clk_info->div.reg);
> +		reg = cgu_readl(cgu, clk_info->div.reg);
> 
>  		/* update the divide */
>  		mask = GENMASK(clk_info->div.bits - 1, 0);
> @@ -415,12 +427,12 @@ ingenic_clk_set_rate(struct clk_hw *hw, unsigned long
> req_rate, reg |= BIT(clk_info->div.ce_bit);
> 
>  		/* update the hardware */
> -		writel(reg, cgu->base + clk_info->div.reg);
> +		cgu_writel(cgu, reg, clk_info->div.reg);
> 
>  		/* wait for the change to take effect */
>  		if (clk_info->div.busy_bit != -1) {
>  			for (i = 0; i < timeout; i++) {
> -				reg = readl(cgu->base + clk_info->div.reg);
> +				reg = cgu_readl(cgu, clk_info->div.reg);
>  				if (!(reg & BIT(clk_info->div.busy_bit)))
>  					break;
>  				mdelay(1);
> @@ -661,11 +673,9 @@ ingenic_cgu_new(const struct ingenic_cgu_clk_info
> *clock_info, if (!cgu)
>  		goto err_out;
> 
> -	cgu->base = of_iomap(np, 0);
> -	if (!cgu->base) {
> -		pr_err("%s: failed to map CGU registers\n", __func__);
> +	cgu->regmap = syscon_node_to_regmap(np->parent);
> +	if (cgu->regmap == NULL)
>  		goto err_out_free;
> -	}
> 
>  	cgu->np = np;
>  	cgu->clock_info = clock_info;
> diff --git a/drivers/clk/ingenic/cgu.h b/drivers/clk/ingenic/cgu.h
> index 09700b2..86fd5b0 100644
> --- a/drivers/clk/ingenic/cgu.h
> +++ b/drivers/clk/ingenic/cgu.h
> @@ -19,7 +19,9 @@
>  #define __DRIVERS_CLK_INGENIC_CGU_H__
> 
>  #include <linux/bitops.h>
> +#include <linux/mfd/syscon.h>
>  #include <linux/of.h>
> +#include <linux/regmap.h>
>  #include <linux/spinlock.h>
> 
>  /**
> @@ -171,14 +173,14 @@ struct ingenic_cgu_clk_info {
>  /**
>   * struct ingenic_cgu - data about the CGU
>   * @np: the device tree node that caused the CGU to be probed
> - * @base: the ioremap'ed base address of the CGU registers
> + * @regmap: the regmap object used to access the CGU registers
>   * @clock_info: an array containing information about implemented clocks
>   * @clocks: used to provide clocks to DT, allows lookup of struct clk*
>   * @lock: lock to be held whilst manipulating CGU registers
>   */
>  struct ingenic_cgu {
>  	struct device_node *np;
> -	void __iomem *base;
> +	struct regmap *regmap;
> 
>  	const struct ingenic_cgu_clk_info *clock_info;
>  	struct clk_onecell_data clocks;
> @@ -186,6 +188,9 @@ struct ingenic_cgu {
>  	spinlock_t lock;
>  };
> 
> +unsigned int cgu_readl(struct ingenic_cgu *cgu, unsigned int reg);
> +int cgu_writel(struct ingenic_cgu *cgu, unsigned int val, unsigned int
> reg); +
>  /**
>   * struct ingenic_clk - private data for a clock
>   * @hw: see Documentation/clk.txt
> diff --git a/drivers/clk/ingenic/jz4740-cgu.c
> b/drivers/clk/ingenic/jz4740-cgu.c index 510fe7e..3003afb 100644
> --- a/drivers/clk/ingenic/jz4740-cgu.c
> +++ b/drivers/clk/ingenic/jz4740-cgu.c
> @@ -232,7 +232,7 @@ CLK_OF_DECLARE(jz4740_cgu, "ingenic,jz4740-cgu",
> jz4740_cgu_init);
> 
>  void jz4740_clock_set_wait_mode(enum jz4740_wait_mode mode)
>  {
> -	uint32_t lcr = readl(cgu->base + CGU_REG_LCR);
> +	uint32_t lcr = cgu_readl(cgu, CGU_REG_LCR);
> 
>  	switch (mode) {
>  	case JZ4740_WAIT_MODE_IDLE:
> @@ -244,24 +244,24 @@ void jz4740_clock_set_wait_mode(enum jz4740_wait_mode
> mode) break;
>  	}
> 
> -	writel(lcr, cgu->base + CGU_REG_LCR);
> +	cgu_writel(cgu, lcr, CGU_REG_LCR);
>  }
> 
>  void jz4740_clock_udc_disable_auto_suspend(void)
>  {
> -	uint32_t clkgr = readl(cgu->base + CGU_REG_CLKGR);
> +	uint32_t clkgr = cgu_readl(cgu, CGU_REG_CLKGR);
> 
>  	clkgr &= ~CLKGR_UDC;
> -	writel(clkgr, cgu->base + CGU_REG_CLKGR);
> +	cgu_writel(cgu, clkgr, CGU_REG_CLKGR);
>  }
>  EXPORT_SYMBOL_GPL(jz4740_clock_udc_disable_auto_suspend);
> 
>  void jz4740_clock_udc_enable_auto_suspend(void)
>  {
> -	uint32_t clkgr = readl(cgu->base + CGU_REG_CLKGR);
> +	uint32_t clkgr = cgu_readl(cgu, CGU_REG_CLKGR);
> 
>  	clkgr |= CLKGR_UDC;
> -	writel(clkgr, cgu->base + CGU_REG_CLKGR);
> +	cgu_writel(cgu, clkgr, CGU_REG_CLKGR);
>  }
>  EXPORT_SYMBOL_GPL(jz4740_clock_udc_enable_auto_suspend);
> 
> @@ -273,31 +273,31 @@ void jz4740_clock_suspend(void)
>  {
>  	uint32_t clkgr, cppcr;
> 
> -	clkgr = readl(cgu->base + CGU_REG_CLKGR);
> +	clkgr = cgu_readl(cgu, CGU_REG_CLKGR);
>  	clkgr |= JZ_CLOCK_GATE_TCU | JZ_CLOCK_GATE_DMAC | JZ_CLOCK_GATE_UART0;
> -	writel(clkgr, cgu->base + CGU_REG_CLKGR);
> +	cgu_writel(cgu, clkgr, CGU_REG_CLKGR);
> 
> -	cppcr = readl(cgu->base + CGU_REG_CPPCR);
> +	cppcr = cgu_readl(cgu, CGU_REG_CPPCR);
>  	cppcr &= ~BIT(jz4740_cgu_clocks[JZ4740_CLK_PLL].pll.enable_bit);
> -	writel(cppcr, cgu->base + CGU_REG_CPPCR);
> +	cgu_writel(cgu, cppcr, CGU_REG_CPPCR);
>  }
> 
>  void jz4740_clock_resume(void)
>  {
>  	uint32_t clkgr, cppcr, stable;
> 
> -	cppcr = readl(cgu->base + CGU_REG_CPPCR);
> +	cppcr = cgu_readl(cgu, CGU_REG_CPPCR);
>  	cppcr |= BIT(jz4740_cgu_clocks[JZ4740_CLK_PLL].pll.enable_bit);
> -	writel(cppcr, cgu->base + CGU_REG_CPPCR);
> +	cgu_writel(cgu, cppcr, CGU_REG_CPPCR);
> 
>  	stable = BIT(jz4740_cgu_clocks[JZ4740_CLK_PLL].pll.stable_bit);
>  	do {
> -		cppcr = readl(cgu->base + CGU_REG_CPPCR);
> +		cppcr = cgu_readl(cgu, CGU_REG_CPPCR);
>  	} while (!(cppcr & stable));
> 
> -	clkgr = readl(cgu->base + CGU_REG_CLKGR);
> +	clkgr = cgu_readl(cgu, CGU_REG_CLKGR);
>  	clkgr &= ~JZ_CLOCK_GATE_TCU;
>  	clkgr &= ~JZ_CLOCK_GATE_DMAC;
>  	clkgr &= ~JZ_CLOCK_GATE_UART0;
> -	writel(clkgr, cgu->base + CGU_REG_CLKGR);
> +	cgu_writel(cgu, clkgr, CGU_REG_CLKGR);
>  }
> diff --git a/drivers/clk/ingenic/jz4780-cgu.c
> b/drivers/clk/ingenic/jz4780-cgu.c index b35d6d9..8f83433 100644
> --- a/drivers/clk/ingenic/jz4780-cgu.c
> +++ b/drivers/clk/ingenic/jz4780-cgu.c
> @@ -113,11 +113,11 @@ static int jz4780_otg_phy_set_parent(struct clk_hw
> *hw, u8 idx)
> 
>  	spin_lock_irqsave(&cgu->lock, flags);
> 
> -	usbpcr1 = readl(cgu->base + CGU_REG_USBPCR1);
> +	usbpcr1 = cgu_readl(cgu, CGU_REG_USBPCR1);
>  	usbpcr1 &= ~USBPCR1_REFCLKSEL_MASK;
>  	/* we only use CLKCORE */
>  	usbpcr1 |= USBPCR1_REFCLKSEL_CORE;
> -	writel(usbpcr1, cgu->base + CGU_REG_USBPCR1);
> +	cgu_writel(cgu, usbpcr1, CGU_REG_USBPCR1);
> 
>  	spin_unlock_irqrestore(&cgu->lock, flags);
>  	return 0;
> @@ -129,7 +129,7 @@ static unsigned long jz4780_otg_phy_recalc_rate(struct
> clk_hw *hw, u32 usbpcr1;
>  	unsigned refclk_div;
> 
> -	usbpcr1 = readl(cgu->base + CGU_REG_USBPCR1);
> +	usbpcr1 = cgu_readl(cgu, CGU_REG_USBPCR1);
>  	refclk_div = usbpcr1 & USBPCR1_REFCLKDIV_MASK;
> 
>  	switch (refclk_div) {
> @@ -194,10 +194,10 @@ static int jz4780_otg_phy_set_rate(struct clk_hw *hw,
> unsigned long req_rate,
> 
>  	spin_lock_irqsave(&cgu->lock, flags);
> 
> -	usbpcr1 = readl(cgu->base + CGU_REG_USBPCR1);
> +	usbpcr1 = cgu_readl(cgu, CGU_REG_USBPCR1);
>  	usbpcr1 &= ~USBPCR1_REFCLKDIV_MASK;
>  	usbpcr1 |= div_bits;
> -	writel(usbpcr1, cgu->base + CGU_REG_USBPCR1);
> +	cgu_writel(cgu, usbpcr1, CGU_REG_USBPCR1);
> 
>  	spin_unlock_irqrestore(&cgu->lock, flags);
>  	return 0;


--nextPart1799162.5tN5njOGM8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEELIGR03D5+Fg+69wPgiDZ+mk8HGUFAlmXUq4ACgkQgiDZ+mk8
HGUSvxAApgN6YKzkJdJeiaBjAD4xsJhL01w3BAEV8Kj0Rq2yNsJwnmzFyyJeRzyO
C0lvFMM1ReoyFFsgDosMvkcWQIqkceZw+u26XFItRlplHimpYT9GgFLu/oGpfUQ7
vdmxCPK7MGrFot7mXDc8h4cbCQT0DjcQFBIk2BZ0m5bAOZ5gYEj4LUUG9Uq3pqCy
MN6bMVTGNjoIp3YvDdotd5zUvkF9vxV/xT8PiQMgFCXIePRyf+EZiTEtQwqqefOS
ilK79KjBSeu4tIeHSkD0Xt59xKhTJ/mMYgDHV8Z3FMLEDwBxzfMXJVkURajBNFfa
NGTcI392/yAyKGCOp9/F92W4tbZs6GO3/QRBqhNaluzJNUi1Po7blUkfbKeJ2S55
euFduHRTe3XF33oRqdvd39M6s/CUSIcVuM90jbZBi8Jc60YBjQ/yEvn5Lo7/b1Wh
G/8N7mgFudvWmu2AudgQR4nzzfak1HIEune6mTZhZHg2B2xCUMSzaEDGPy44tgum
j7p5uQdnc+ow3x8RBrDAsNp1pg0NXCWRvBPxrd199zIXcWMHzTIZDtgkyhKUX4Kb
+udVIPx/L0+/NiYRtsrn9TwY/ZyriWf7qcBJBEC57X2+oRub3SKIpa2LgH+s0aBc
LZOA7SpLla/9Kk4HpfQMHjBq0DeDtWPrOtwB3zzn3gR5h69+Pq4=
=SKVp
-----END PGP SIGNATURE-----

--nextPart1799162.5tN5njOGM8--
