From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/3] crypto: brcm: Add Broadcom SPU driver
Date: Tue, 6 Dec 2016 14:18:26 +0000
Message-ID: <20161206141826.GC24177@leverpostej>
References: <1480536453-24781-1-git-send-email-rob.rice@broadcom.com>
 <1480536453-24781-3-git-send-email-rob.rice@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480536453-24781-3-git-send-email-rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 30, 2016 at 03:07:32PM -0500, Rob Rice wrote:
> +static const struct of_device_id bcm_spu_dt_ids[] = {
> +	{
> +		.compatible = "brcm,spum-crypto",
> +		.data = &spum_ns2_types,
> +	},
> +	{
> +		.compatible = "brcm,spum-nsp-crypto",
> +		.data = &spum_nsp_types,
> +	},
> +	{
> +		.compatible = "brcm,spu2-crypto",
> +		.data = &spu2_types,
> +	},
> +	{
> +		.compatible = "brcm,spu2-v2-crypto",
> +		.data = &spu2_v2_types,
> +	},

These last two weren't in the binding document.

> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, bcm_spu_dt_ids);
> +
> +static int spu_dt_read(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct spu_hw *spu = &iproc_priv.spu;
> +	struct device_node *dn = pdev->dev.of_node;
> +	struct resource *spu_ctrl_regs;
> +	const struct of_device_id *match;
> +	struct spu_type_subtype *matched_spu_type;
> +	void __iomem *spu_reg_vbase[MAX_SPUS];
> +	int i;
> +	int err;
> +
> +	if (!of_device_is_available(dn)) {
> +		dev_crit(dev, "SPU device not available");
> +		return -ENODEV;
> +	}

How can this happen?

> +	/* Count number of mailbox channels */
> +	spu->num_chan = of_count_phandle_with_args(dn, "mboxes", "#mbox-cells");
> +	dev_dbg(dev, "Device has %d SPU channels", spu->num_chan);
> +
> +	match = of_match_device(of_match_ptr(bcm_spu_dt_ids), dev);
> +	matched_spu_type = (struct spu_type_subtype *)match->data;

This cast usn't necessary.

> +	spu->spu_type = matched_spu_type->type;
> +	spu->spu_subtype = matched_spu_type->subtype;
> +
> +	/* Read registers and count number of SPUs */
> +	i = 0;
> +	while ((i < MAX_SPUS) && ((spu_ctrl_regs =
> +		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL)) {
> +		dev_dbg(dev,
> +			"SPU %d control register region res.start = %#x, res.end = %#x",
> +			i,
> +			(unsigned int)spu_ctrl_regs->start,
> +			(unsigned int)spu_ctrl_regs->end);
> +
> +		spu_reg_vbase[i] = devm_ioremap_resource(dev, spu_ctrl_regs);
> +		if (IS_ERR(spu_reg_vbase[i])) {
> +			err = PTR_ERR(spu_reg_vbase[i]);
> +			dev_err(&pdev->dev, "Failed to map registers: %d\n",
> +				err);
> +			spu_reg_vbase[i] = NULL;
> +			return err;
> +		}
> +		i++;
> +	}

These *really* sound like independent devices. There are no shared
registers, and each has its own mbox.

Why do we group them like this?

Thanks,
Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
