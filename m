Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D4EC4321E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Dec 2022 08:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiLAITW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 03:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLAITR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 03:19:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E21B5BD6E
        for <linux-crypto@vger.kernel.org>; Thu,  1 Dec 2022 00:19:07 -0800 (PST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1p0ema-00031o-H9; Thu, 01 Dec 2022 09:19:00 +0100
Message-ID: <d08447fd-cac5-3082-9eb7-22e32a9dbea5@pengutronix.de>
Date:   Thu, 1 Dec 2022 09:18:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3] crypto: caam: blob_gen.c: warn if key is insecure
Content-Language: en-US
To:     Nikolaus Voss <nikolaus.voss@haag-streit.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Gstir <david@sigma-star.at>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Nikolaus Voss <nv@vosn.de>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20221121141929.2E36427E9@mail.steuer-voss.de>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20221121141929.2E36427E9@mail.steuer-voss.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21.11.22 15:12, Nikolaus Voss wrote:
> If CAAM is not in "trusted" or "secure" state, a fixed non-volatile key
> is used instead of the unique device key. This is the default mode of
> operation without secure boot (HAB). In this scenario, CAAM encrypted
> blobs should be used only for testing but not in a production
> environment, so issue a warning.
> 
> Signed-off-by: Nikolaus Voss <nikolaus.voss@haag-streit.com>

Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

> 
> ---
> CHANGES
> =======
> v2: make warning more verbose, correct register, style fixes
> v3: fix sparse warning "dereference of noderef expression"
>     by using ioread32() to dereference iomem pointer
> 
>  drivers/crypto/caam/blob_gen.c | 9 +++++++++
>  drivers/crypto/caam/regs.h     | 3 +++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_gen.c
> index 6345c7269eb03..1f65df4898478 100644
> --- a/drivers/crypto/caam/blob_gen.c
> +++ b/drivers/crypto/caam/blob_gen.c
> @@ -6,6 +6,7 @@
>  
>  #define pr_fmt(fmt) "caam blob_gen: " fmt
>  
> +#include <linux/bitfield.h>
>  #include <linux/device.h>
>  #include <soc/fsl/caam-blob.h>
>  
> @@ -61,12 +62,14 @@ static void caam_blob_job_done(struct device *dev, u32 *desc, u32 err, void *con
>  int caam_process_blob(struct caam_blob_priv *priv,
>  		      struct caam_blob_info *info, bool encap)
>  {
> +	const struct caam_drv_private *ctrlpriv;
>  	struct caam_blob_job_result testres;
>  	struct device *jrdev = &priv->jrdev;
>  	dma_addr_t dma_in, dma_out;
>  	int op = OP_PCLID_BLOB;
>  	size_t output_len;
>  	u32 *desc;
> +	u32 moo;
>  	int ret;
>  
>  	if (info->key_mod_len > CAAM_BLOB_KEYMOD_LENGTH)
> @@ -100,6 +103,12 @@ int caam_process_blob(struct caam_blob_priv *priv,
>  		goto out_unmap_in;
>  	}
>  
> +	ctrlpriv = dev_get_drvdata(jrdev->parent);
> +	moo = FIELD_GET(CSTA_MOO, ioread32(&ctrlpriv->ctrl->perfmon.status));
> +	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
> +		dev_warn(jrdev,
> +			 "using insecure test key, enable HAB to use unique device key!\n");
> +
>  	/*
>  	 * A data blob is encrypted using a blob key (BK); a random number.
>  	 * The BK is used as an AES-CCM key. The initial block (B0) and the
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 66d6dad841bb2..66928f8a0c4b1 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -426,6 +426,9 @@ struct caam_perfmon {
>  	u32 rsvd2;
>  #define CSTA_PLEND		BIT(10)
>  #define CSTA_ALT_PLEND		BIT(18)
> +#define CSTA_MOO		GENMASK(9, 8)
> +#define CSTA_MOO_SECURE	1
> +#define CSTA_MOO_TRUSTED	2
>  	u32 status;		/* CSTA - CAAM Status */
>  	u64 rsvd3;
>  

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

