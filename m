Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B662EECDE28
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CC91222C5
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u0pbm4Yk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfIKI30 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 04:29:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37866 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfIKI30 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 04:29:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so22879593wro.4
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 01:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zw/nRHbA6gamXFMmZttwtsUXOgGchhd99CivFz+b1ms=;
        b=u0pbm4YkiCRxVqqTlQ17p+Il0Iq7bPi7W8wjju8PlHbUVeulbXKRqd9omxqw5yeMVe
         /4ZRs6QTvbxt6r3tPNXanJbHRqH8t2HYKXN8n5Yf3Y/bfPCgSFYzjmwJejNbVJVzZEtl
         GsfTsXrQ9kKT/+4AjWaDBEWjJYJALxmMyhFSQ6V7Lu3IeeR5l7yGBrGdeLSAX5E/dVyD
         0sqhmY1l0mg7KjOVKiw6XfTWzvAFqWDg9tuaAINSjscPW8bxXY+3NdNAAp/EdsvGoDAP
         Et1IKxclqpqnG4r/ju0lJkqb2EstcCx0tsWb+mLBtc2E5x0IlxUnHhlxfw/wtyKMIb/M
         BueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zw/nRHbA6gamXFMmZttwtsUXOgGchhd99CivFz+b1ms=;
        b=cVG7+JBqCwkp9t1MSChrYYX+07cFmjO6iU4u27Aecx8L3LEZXQdAtuQPDNxlM81Pk/
         oRk56lNO8PhAke9/P1tNUEY1jCdnVJfTOq7RaShiNuuZYoSkR0t/7DnS+sZz9uM8Faux
         FuzGvhoKI93p8zXamR/gphD9GqFN9YOLhGkQKoET5185nlAbqx7V1IDYNSaeAEL4TukK
         PjJLllmdcyWUq+i7Z+dPfGhiGMU57nmdGrIon1zI0MxqVsqOhgErvImp7CIWR7XobTVf
         Gi0RnfleTEGHxhlYEXk627WFCdp9yfZmCQ01pDNj7Nv12eSZ7B8QS9D33V6/XzLlkw2o
         L4kQ==
X-Gm-Message-State: APjAAAVBiUDOMfttDIjjHyMvcddQVTXTxrKZK089GRVKSEF+FUXY7WtD
        ZQAFB31F+f3ZQOMpgmrIlASiGw==
X-Google-Smtp-Source: APXvYqzitrYD1GNdHxRYy6bTZs5uxP1EO8paIe/T9nQnXD2+EkqWuheIGfM1+1JX7yJBlp5XGl+wLA==
X-Received: by 2002:a5d:43cc:: with SMTP id v12mr2981046wrr.75.1568190563862;
        Wed, 11 Sep 2019 01:29:23 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id a13sm36205561wrf.73.2019.09.11.01.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 01:29:22 -0700 (PDT)
Date:   Wed, 11 Sep 2019 09:29:20 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Milton Miller II <miltonm@us.ibm.com>
Cc:     Tomer Maimon <tmaimon77@gmail.com>, mpm@selenic.com,
        herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        mark.rutland@arm.com, avifishman70@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au, devicetree@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 2/2] hwrng: npcm: add NPCM RNG driver
Message-ID: <20190911082920.4vxw7om5aqcfrxmy@holly.lan>
References: <20190909123840.154745-3-tmaimon77@gmail.com>
 <20190909123840.154745-1-tmaimon77@gmail.com>
 <OFDC101E51.54765CB8-ON00258471.006F34B7-00258471.0072BCA7@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFDC101E51.54765CB8-ON00258471.006F34B7-00258471.0072BCA7@notes.na.collabserv.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 10, 2019 at 08:53:13PM +0000, Milton Miller II wrote:
> On September 9, 2019 around 7:40AM in somet timezone, Tomer Maimon wrote:
> >+#define NPCM_RNG_TIMEOUT_USEC	20000
> >+#define NPCM_RNG_POLL_USEC	1000
> 
> ...
> 
> >+static int npcm_rng_init(struct hwrng *rng)
> >+{
> >+	struct npcm_rng *priv = to_npcm_rng(rng);
> >+	u32 val;
> >+
> >+	val = readl(priv->base + NPCM_RNGCS_REG);
> >+	val |= NPCM_RNG_ENABLE;
> >+	writel(val, priv->base + NPCM_RNGCS_REG);
> >+
> >+	return 0;
> >+}
> >+
> >+static void npcm_rng_cleanup(struct hwrng *rng)
> >+{
> >+	struct npcm_rng *priv = to_npcm_rng(rng);
> >+	u32 val;
> >+
> >+	val = readl(priv->base + NPCM_RNGCS_REG);
> >+	val &= ~NPCM_RNG_ENABLE;
> >+	writel(val, priv->base + NPCM_RNGCS_REG);
> >+}
> >+
> >+static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max,
> >bool wait)
> >+{
> >+	struct npcm_rng *priv = to_npcm_rng(rng);
> >+	int retval = 0;
> >+	int ready;
> >+
> >+	pm_runtime_get_sync((struct device *)priv->rng.priv);
> >+
> >+	while (max >= sizeof(u32)) {
> >+		ready = readl(priv->base + NPCM_RNGCS_REG) &
> >+			NPCM_RNG_DATA_VALID;
> >+		if (!ready) {
> >+			if (wait) {
> >+				if (readl_poll_timeout(priv->base + NPCM_RNGCS_REG,
> >+						       ready,
> >+						       ready & NPCM_RNG_DATA_VALID,
> >+						       NPCM_RNG_POLL_USEC,
> >+						       NPCM_RNG_TIMEOUT_USEC))
> >+					break;
> >+			} else {
> >+				break;
> 
> This break is too far from the condition and deeply nested to follow.
> 
> And looking further, readl_poll_timeout will read and check the condition before
> calling usleep, so the the initial readl and check is redundant
> 
> Rearrange to make wait determine if you call readl_poll_timeout or 
> readl / compare / break.
> 
> >+			}
> >+		}
> >+
> >+		*(u32 *)buf = readl(priv->base + NPCM_RNGD_REG);
> >+		retval += sizeof(u32);
> >+		buf += sizeof(u32);
> >+		max -= sizeof(u32);
> >+	}
> >+
> >+	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
> >+	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
> >+
> >+	return retval || !wait ? retval : -EIO;
> >+}
> >+
> >+static int npcm_rng_probe(struct platform_device *pdev)
> >+{
> >+	struct npcm_rng *priv;
> >+	struct resource *res;
> >+	bool pm_dis = false;
> >+	u32 quality;
> >+	int ret;
> >+
> >+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> >+	if (!priv)
> >+		return -ENOMEM;
> >+
> >+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >+	priv->base = devm_ioremap_resource(&pdev->dev, res);
> >+	if (IS_ERR(priv->base))
> >+		return PTR_ERR(priv->base);
> >+
> >+	priv->rng.name = pdev->name;
> >+#ifndef CONFIG_PM
> >+	pm_dis = true;
> >+	priv->rng.init = npcm_rng_init;
> >+	priv->rng.cleanup = npcm_rng_cleanup;
> >+#endif
> 
> if you move this down you can use one if (ENABLED_CONFIG_PM) {}
> 
> >+	priv->rng.read = npcm_rng_read;
> >+	priv->rng.priv = (unsigned long)&pdev->dev;
> >+	if (of_property_read_u32(pdev->dev.of_node, "quality", &quality))
> >+		priv->rng.quality = 1000;
> >+	else
> >+		priv->rng.quality = quality;
> >+
> >+	writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
> >+	if (pm_dis)
> >+		writel(NPCM_RNG_CLK_SET_25MHZ, priv->base + NPCM_RNGCS_REG);
> >+	else
> >+		writel(NPCM_RNG_CLK_SET_25MHZ | NPCM_RNG_ENABLE,
> >+		       priv->base + NPCM_RNGCS_REG);
> 
> wait ... if we know the whole value here, why read/modify/write the value
> in the init and cleanup hook?   Save the io read and write the known value
>  ... define the value to be written for clarity between enable/disable if
> needed
> 
> 
> 
> >+
> >+	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
> >+	if (ret) {
> >+		dev_err(&pdev->dev, "Failed to register rng device: %d\n",
> >+			ret);
> 
> need to disable if CONFIG_PM ?
> 
> >+		return ret;
> >+	}
> >+
> >+	dev_set_drvdata(&pdev->dev, priv);
> 
> This should probably be before the register.
> 
> >+	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
> 
> So every 100ms power off, and if userspace does a read we
> will poll every 1ms for upto 20ms.
> 
> If userspace says try once a second with -ENODELAY so no wait,
> it never gets data.

I didn't follow this.

In the time before the device is suspended it should have generated
data and this can be sent to the userspace. Providing the suspend delay
is longer than the buffer size of the hardware then there won't
necessarily be performance problems because the device is "full" when
it is suspended.

Of course if the hardware loses state when it is suspended then the
driver would need extra code on the PM paths to preserve the data...


Daniel.
