Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBC2C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 12:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B13720693
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 12:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbfGaM0e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 08:26:34 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:56067 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387502AbfGaM0e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 08:26:34 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 54D03200012;
        Wed, 31 Jul 2019 12:26:30 +0000 (UTC)
Date:   Wed, 31 Jul 2019 14:26:29 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCHv2 3/3] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Message-ID: <20190731122629.GC3579@kwain>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-4-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564145005-26731-4-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

Thanks for reworking this not to include the firmware blob, the patch
looks good and I only have minor comments.

On Fri, Jul 26, 2019 at 02:43:25PM +0200, Pascal van Leeuwen wrote:
> +
> +static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
> +				  const struct firmware *fw)
> +{
> +	const u32 *data = (const u32 *)fw->data;
> +	int i;
>  
>  	/* Write the firmware */
>  	for (i = 0; i < fw->size / sizeof(u32); i++)
>  		writel(be32_to_cpu(data[i]),
>  		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
>  
> -	/* Disable access to the program memory */
> -	writel(0, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
> +	return i - 2;

Could you add a comment (or if applicable, a define) for this '- 2'?
What happens if i < 2 ?

> +	for (pe = 0; pe < priv->config.pes; pe++) {
> +		base = EIP197_PE_ICE_SCRATCH_RAM(pe);
> +		pollcnt = EIP197_FW_START_POLLCNT;
> +		while (pollcnt &&
> +		       (readl(EIP197_PE(priv) + base +
> +			      pollofs) != 1)) {
> +			pollcnt--;
> +			cpu_relax();

You can probably use readl_relaxed() here.

> +		}
> +		if (!pollcnt) {
> +			dev_err(priv->dev, "FW(%d) for PE %d failed to start",
> +				fpp, pe);

A \n is missing at the end of the string.

> +static bool eip197_start_firmware(struct safexcel_crypto_priv *priv,
> +				  int ipuesz, int ifppsz, int minifw)
> +{
> +	int pe;
> +	u32 val;
> +
> +	for (pe = 0; pe < priv->config.pes; pe++) {
> +		/* Disable access to all program memory */
> +		writel(0, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
> +
> +		/* Start IFPP microengines */
> +		if (minifw)
> +			val = 0;
> +		else
> +			val = (((ifppsz - 1) & 0x7ff0) << 16) | BIT(3);

Could you define the mask and the 'BIT(3)'?

> +		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_FPP_CTRL(pe));
> +
> +		/* Start IPUE microengines */
> +		if (minifw)
> +			val = 0;
> +		else
> +			val = ((ipuesz - 1) & 0x7ff0) << 16 | BIT(3);

Ditto.

>  
> +	if (!minifw) {
> +		/* Retry with minifw path */
> +		dev_dbg(priv->dev, "Firmware set not (fully) present or init failed, falling back to BCLA mode");

A \n is missing here.

> +		dir = "eip197_minifw";
> +		minifw = 1;
> +		goto retry_fw;
> +	}
> +
> +	dev_dbg(priv->dev, "Firmware load failed.");

Ditto.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
