Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8A0C5519A
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 027252080C
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="n1DX+gEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgD0Iml (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgD0Imk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 04:42:40 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ABFC061A10
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2020 01:42:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so18572124wmc.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2020 01:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3OJ7zI5D/+o9PAallEctJqNG+ojY+//gD77qJQ0kIFM=;
        b=n1DX+gEvh24yHFjrn3QLssQv3ijVfIFIlGJUqwi2poGOnb8R9LuTNilUKt2z4PtmaB
         k+7nnBnv/1VHahFFTeGhcw+q+VAG6L33jnv0FdarpYF2fubsCLOHWtT/RG79D1BErI0h
         Fg1ZvXrg+EE6aTFZAizH38VLRdYRuJUS3DnqM/bJp3WL+c94prK3xPkhT4h+fWUjZXM+
         YvhyHSBdbft0ytSSQkG+ijNYNd5y9pQAKeUy2tijFJX6+fuWvsUA0OjKhxgsZuDYvPyA
         8Sz1UuO1/iDdyOTFW2kxkh1ykmq9IXxkOY5T4waGTNvA1jKWEQzy1sbG2YzGd3J4A+p6
         m9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3OJ7zI5D/+o9PAallEctJqNG+ojY+//gD77qJQ0kIFM=;
        b=cQ657M/5fYk26JBtXddCVUNNB6UdnL2V0Mx2gVgu9QRZD198qW3hgE2RcDeMV9C+RD
         h3M9kIO/ALRaMEsuv4W2GfjK8lW/sRW32Ufoznp4bpjYdw9lsY9wOkKiIN86vroUtxtO
         a2VzLCM1YINNEhMncYuZFe94RznGWDOGYRrEUm6WMoC2w65Iq2oAUK1aNp+0b+ptnmUi
         xyxc5ltUBfcDwc2rJ1G66sZo5dKc5GUVnYV+KICG7GrX0JtBs7yWAw9MIeGuME88nmJk
         xG4ZtjgXajhp3MC3bXIfrz0GOOie+D/rxjXzmSQ8gAsHqddqTC+9EqZ4TJF7+qg7uWil
         BHYA==
X-Gm-Message-State: AGi0PuZb+u9v3BJCnvyl4f/d55MEQaXcCCAB4YVdFH6ka1hjfd/cfEwf
        TaA3sc845j0kmBT5QU5kw3QeUQ==
X-Google-Smtp-Source: APiQypJrmRJxl+LFnFg2EFvUIMNK4tDN3pemq89DtMppLTkVHPD2h3aVOBLY2yibIMA36EC/SbpXgQ==
X-Received: by 2002:a1c:7c10:: with SMTP id x16mr24340968wmc.74.1587976957587;
        Mon, 27 Apr 2020 01:42:37 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm17101839wrj.70.2020.04.27.01.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 01:42:37 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:42:35 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Stephan Mueller <stephan.mueller@atsec.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 14/14] crypto: sun8i-ce: Add support for the TRNG
Message-ID: <20200427084235.GB8787@Red>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
 <1587736934-22801-15-git-send-email-clabbe@baylibre.com>
 <3693153.CBanSm0cUG@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3693153.CBanSm0cUG@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 24, 2020 at 04:34:40PM +0200, Stephan Mueller wrote:
> Am Freitag, 24. April 2020, 16:02:14 CEST schrieb Corentin Labbe:
> 
> Hi Corentin,
> 
> > This patch had support for the TRNG present in the CE.
> > Note that according to the algorithm ID, 2 version of the TRNG exists,
> > the first present in H3/H5/R40/A64 and the second present in H6.
> > This patch adds support for both, but only the second is working
> > reliabily accoridng to rngtest.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  drivers/crypto/allwinner/Kconfig              |   8 ++
> >  drivers/crypto/allwinner/sun8i-ce/Makefile    |   1 +
> >  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  18 +++
> >  .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 123 ++++++++++++++++++
> >  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  18 +++
> >  5 files changed, 168 insertions(+)
> >  create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> > 
> > diff --git a/drivers/crypto/allwinner/Kconfig
> > b/drivers/crypto/allwinner/Kconfig index 223a5823867c..6aec31f7d2be 100644
> > --- a/drivers/crypto/allwinner/Kconfig
> > +++ b/drivers/crypto/allwinner/Kconfig
> > @@ -87,6 +87,14 @@ config CRYPTO_DEV_SUN8I_CE_PRNG
> >  	  Select this option if you want to provide kernel-side support for
> >  	  the Pseudo-Random Number Generator found in the Crypto Engine.
> > 
> > +config CRYPTO_DEV_SUN8I_CE_TRNG
> > +	bool "Support for Allwinner Crypto Engine TRNG"
> > +	depends on CRYPTO_DEV_SUN8I_CE
> > +	select HW_RANDOM
> > +	help
> > +	  Select this option if you want to provide kernel-side support for
> > +	  the True Random Number Generator found in the Crypto Engine.
> > +
> >  config CRYPTO_DEV_SUN8I_SS
> >  	tristate "Support for Allwinner Security System cryptographic 
> offloader"
> >  	select CRYPTO_SKCIPHER
> > diff --git a/drivers/crypto/allwinner/sun8i-ce/Makefile
> > b/drivers/crypto/allwinner/sun8i-ce/Makefile index
> > c0ea81da2c7d..0842eb2d9408 100644
> > --- a/drivers/crypto/allwinner/sun8i-ce/Makefile
> > +++ b/drivers/crypto/allwinner/sun8i-ce/Makefile
> > @@ -2,3 +2,4 @@ obj-$(CONFIG_CRYPTO_DEV_SUN8I_CE) += sun8i-ce.o
> >  sun8i-ce-y += sun8i-ce-core.o sun8i-ce-cipher.o
> >  sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_HASH) += sun8i-ce-hash.o
> >  sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_PRNG) += sun8i-ce-prng.o
> > +sun8i-ce-$(CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG) += sun8i-ce-trng.o
> > diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> > b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c index
> > 23b9fc67d7ea..86d75789811f 100644
> > --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> > +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> > @@ -47,6 +47,7 @@ static const struct ce_variant ce_h3_variant = {
> >  		},
> >  	.esr = ESR_H3,
> >  	.prng = CE_ALG_PRNG,
> > +	.trng = CE_ID_NOTSUPP,
> >  };
> > 
> >  static const struct ce_variant ce_h5_variant = {
> > @@ -63,6 +64,7 @@ static const struct ce_variant ce_h5_variant = {
> >  		},
> >  	.esr = ESR_H5,
> >  	.prng = CE_ALG_PRNG,
> > +	.trng = CE_ID_NOTSUPP,
> >  };
> > 
> >  static const struct ce_variant ce_h6_variant = {
> > @@ -76,6 +78,7 @@ static const struct ce_variant ce_h6_variant = {
> >  	.cipher_t_dlen_in_bytes = true,
> >  	.hash_t_dlen_in_bits = true,
> >  	.prng_t_dlen_in_bytes = true,
> > +	.trng_t_dlen_in_bytes = true,
> >  	.ce_clks = {
> >  		{ "bus", 0, 200000000 },
> >  		{ "mod", 300000000, 0 },
> > @@ -83,6 +86,7 @@ static const struct ce_variant ce_h6_variant = {
> >  		},
> >  	.esr = ESR_H6,
> >  	.prng = CE_ALG_PRNG_V2,
> > +	.trng = CE_ALG_TRNG_V2,
> >  };
> > 
> >  static const struct ce_variant ce_a64_variant = {
> > @@ -99,6 +103,7 @@ static const struct ce_variant ce_a64_variant = {
> >  		},
> >  	.esr = ESR_A64,
> >  	.prng = CE_ALG_PRNG,
> > +	.trng = CE_ID_NOTSUPP,
> >  };
> > 
> >  static const struct ce_variant ce_r40_variant = {
> > @@ -115,6 +120,7 @@ static const struct ce_variant ce_r40_variant = {
> >  		},
> >  	.esr = ESR_R40,
> >  	.prng = CE_ALG_PRNG,
> > +	.trng = CE_ID_NOTSUPP,
> >  };
> > 
> >  /*
> > @@ -579,6 +585,10 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq,
> > void *v) break;
> >  		}
> >  	}
> > +#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
> > +	seq_printf(seq, "HWRNG %lu %lu\n",
> > +		   ce->hwrng_stat_req, ce->hwrng_stat_bytes);
> > +#endif
> >  	return 0;
> >  }
> > 
> > @@ -928,6 +938,10 @@ static int sun8i_ce_probe(struct platform_device *pdev)
> > if (err < 0)
> >  		goto error_alg;
> > 
> > +#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
> > +	sun8i_ce_hwrng_register(ce);
> > +#endif
> > +
> >  	v = readl(ce->base + CE_CTR);
> >  	v >>= CE_DIE_ID_SHIFT;
> >  	v &= CE_DIE_ID_MASK;
> > @@ -957,6 +971,10 @@ static int sun8i_ce_remove(struct platform_device
> > *pdev) {
> >  	struct sun8i_ce_dev *ce = platform_get_drvdata(pdev);
> > 
> > +#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
> > +	sun8i_ce_hwrng_unregister(ce);
> > +#endif
> > +
> >  	sun8i_ce_unregister_algs(ce);
> > 
> >  #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
> > diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> > b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c new file mode 100644
> > index 000000000000..5e4effe29ed3
> > --- /dev/null
> > +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> > @@ -0,0 +1,123 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * sun8i-ce-trng.c - hardware cryptographic offloader for
> > + * Allwinner H3/A64/H5/H2+/H6/R40 SoC
> > + *
> > + * Copyright (C) 2015-2020 Corentin Labbe <clabbe@baylibre.com>
> > + *
> > + * This file handle the TRNG
> > + *
> > + * You could find a link for the datasheet in
> > Documentation/arm/sunxi/README + */
> > +#include "sun8i-ce.h"
> > +#include <linux/pm_runtime.h>
> > +#include <linux/hw_random.h>
> > +/*
> > + * Note that according to the algorithm ID, 2 versions of the TRNG exists,
> > + * The first present in H3/H5/R40/A64 and the second present in H6.
> > + * This file adds support for both, but only the second is working
> > + * reliabily according to rngtest.
> > + **/
> > +
> > +int sun8i_ce_trng_read(struct hwrng *rng, void *data, size_t max, bool
> > wait) +{
> > +	struct sun8i_ce_dev *ce;
> > +	dma_addr_t dma_dst;
> > +	int err = 0;
> > +	int flow = 3;
> > +	unsigned int todo;
> > +	struct sun8i_ce_flow *chan;
> > +	struct ce_task *cet;
> > +	u32 common;
> > +	void *d;
> > +
> > +	ce = container_of(rng, struct sun8i_ce_dev, trng);
> > +
> > +	todo = max + 32;
> > +	todo -= todo % 32;
> > +
> > +	d = kzalloc(todo, GFP_KERNEL | GFP_DMA);
> > +	if (!d)
> > +		return -ENOMEM;
> > +
> > +#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
> > +	ce->hwrng_stat_req++;
> > +	ce->hwrng_stat_bytes += todo;
> > +#endif
> > +
> > +	dma_dst = dma_map_single(ce->dev, d, todo, DMA_FROM_DEVICE);
> > +	if (dma_mapping_error(ce->dev, dma_dst)) {
> > +		dev_err(ce->dev, "Cannot DMA MAP DST\n");
> > +		err = -EFAULT;
> > +		goto err_dst;
> > +	}
> > +
> > +	err = pm_runtime_get_sync(ce->dev);
> > +	if (err < 0)
> > +		goto err_pm;
> > +
> > +	mutex_lock(&ce->rnglock);
> > +	chan = &ce->chanlist[flow];
> > +
> > +	cet = &chan->tl[0];
> > +	memset(cet, 0, sizeof(struct ce_task));
> > +
> > +	cet->t_id = cpu_to_le32(flow);
> > +	common = ce->variant->trng | CE_COMM_INT;
> > +	cet->t_common_ctl = cpu_to_le32(common);
> > +
> > +	/* recent CE (H6) need length in bytes, in word otherwise */
> > +	if (ce->variant->trng_t_dlen_in_bytes)
> > +		cet->t_dlen = cpu_to_le32(todo);
> > +	else
> > +		cet->t_dlen = cpu_to_le32(todo / 4);
> > +
> > +	cet->t_sym_ctl = 0;
> > +	cet->t_asym_ctl = 0;
> > +
> > +	cet->t_dst[0].addr = cpu_to_le32(dma_dst);
> > +	cet->t_dst[0].len = cpu_to_le32(todo / 4);
> > +	ce->chanlist[flow].timeout = 2000;
> > +
> > +	err = sun8i_ce_run_task(ce, 3, "TRNG");
> > +	mutex_unlock(&ce->rnglock);
> > +
> > +	pm_runtime_put(ce->dev);
> > +
> > +err_pm:
> > +	dma_unmap_single(ce->dev, dma_dst, todo, DMA_FROM_DEVICE);
> > +
> > +	if (!err) {
> > +		memcpy(data, d, max);
> > +		err = max;
> > +	}
> > +
> > +err_dst:
> > +	kfree(d);
> 
> kzfree? I would assume d contains sensitive data, no?
> 

Like sun8i-ce, yes.
I will fix that

Thanks
