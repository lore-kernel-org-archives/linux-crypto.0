From: "Rob (William) Rice" <rob.rice@broadcom.com>
Subject: Re: [PATCH 2/3] crypto: brcm: Add Broadcom SPU driver
Date: Wed, 7 Dec 2016 10:49:22 -0500
Message-ID: <77434ed0-34de-f980-a39b-e1e0dcd6c3d5@broadcom.com>
References: <1480536453-24781-1-git-send-email-rob.rice@broadcom.com>
 <1480536453-24781-3-git-send-email-rob.rice@broadcom.com>
 <20161206141826.GC24177@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Steve Lin <steven.lin1@broadcom.com>
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:35148 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753079AbcLGPt4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 10:49:56 -0500
Received: by mail-pg0-f48.google.com with SMTP id p66so163287694pga.2
        for <linux-crypto@vger.kernel.org>; Wed, 07 Dec 2016 07:49:26 -0800 (PST)
In-Reply-To: <20161206141826.GC24177@leverpostej>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark,

Thanks for the comments. Replies below.

Rob


On 12/6/2016 9:18 AM, Mark Rutland wrote:
> On Wed, Nov 30, 2016 at 03:07:32PM -0500, Rob Rice wrote:
>> +static const struct of_device_id bcm_spu_dt_ids[] = {
>> +	{
>> +		.compatible = "brcm,spum-crypto",
>> +		.data = &spum_ns2_types,
>> +	},
>> +	{
>> +		.compatible = "brcm,spum-nsp-crypto",
>> +		.data = &spum_nsp_types,
>> +	},
>> +	{
>> +		.compatible = "brcm,spu2-crypto",
>> +		.data = &spu2_types,
>> +	},
>> +	{
>> +		.compatible = "brcm,spu2-v2-crypto",
>> +		.data = &spu2_v2_types,
>> +	},
> These last two weren't in the binding document.
yes, I'll add them.
>
>> +	{ /* sentinel */ }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, bcm_spu_dt_ids);
>> +
>> +static int spu_dt_read(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct spu_hw *spu = &iproc_priv.spu;
>> +	struct device_node *dn = pdev->dev.of_node;
>> +	struct resource *spu_ctrl_regs;
>> +	const struct of_device_id *match;
>> +	struct spu_type_subtype *matched_spu_type;
>> +	void __iomem *spu_reg_vbase[MAX_SPUS];
>> +	int i;
>> +	int err;
>> +
>> +	if (!of_device_is_available(dn)) {
>> +		dev_crit(dev, "SPU device not available");
>> +		return -ENODEV;
>> +	}
> How can this happen?
You are correct. This is unnecessary. I will remove.
>
>> +	/* Count number of mailbox channels */
>> +	spu->num_chan = of_count_phandle_with_args(dn, "mboxes", "#mbox-cells");
>> +	dev_dbg(dev, "Device has %d SPU channels", spu->num_chan);
>> +
>> +	match = of_match_device(of_match_ptr(bcm_spu_dt_ids), dev);
>> +	matched_spu_type = (struct spu_type_subtype *)match->data;
> This cast usn't necessary.
Ok, will remove.
>
>> +	spu->spu_type = matched_spu_type->type;
>> +	spu->spu_subtype = matched_spu_type->subtype;
>> +
>> +	/* Read registers and count number of SPUs */
>> +	i = 0;
>> +	while ((i < MAX_SPUS) && ((spu_ctrl_regs =
>> +		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL)) {
>> +		dev_dbg(dev,
>> +			"SPU %d control register region res.start = %#x, res.end = %#x",
>> +			i,
>> +			(unsigned int)spu_ctrl_regs->start,
>> +			(unsigned int)spu_ctrl_regs->end);
>> +
>> +		spu_reg_vbase[i] = devm_ioremap_resource(dev, spu_ctrl_regs);
>> +		if (IS_ERR(spu_reg_vbase[i])) {
>> +			err = PTR_ERR(spu_reg_vbase[i]);
>> +			dev_err(&pdev->dev, "Failed to map registers: %d\n",
>> +				err);
>> +			spu_reg_vbase[i] = NULL;
>> +			return err;
>> +		}
>> +		i++;
>> +	}
> These *really* sound like independent devices. There are no shared
> registers, and each has its own mbox.
>
> Why do we group them like this?
As I said in the previous email, I want one instance of the driver to 
register crypto algos once with the crypto API and to distribute crypto 
requests among all available SPU hw blocks.
>
> Thanks,
> Mark.
