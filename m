Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455F91411DE
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 06:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725605763; cv=none; b=B4xANTZjpW0Er0jIKyzWBuGBp+Hc+IUbjCEZ9E26/eYPAlSdCUbhI3eAnUQjfy1HuanH0pbRNQwYRFqosw9Zp/1Wk5kOzVg4gyMZwevd0G9ZVkxzYjdB1OORuw9VULmMG2VnMbGcyryQhB+4ZbaIYcY0mVyK9I6Nl4ajUg1zZNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725605763; c=relaxed/simple;
	bh=cqdsgsuFlkbtMspJl8duJYFgrvE2t5tFdmnNlLT4ilg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ralxGgLzdpJZ7WEnzPKUrAovSdK5NYSoWXpg/nsMDkxF7gSHJCoGVjcil+7yObfGAUs2d80gRnIPPap2KISJELCV3JFN+wWySgKGWnoAunnJU8ehx+viqIsHBav/+c5S3fOi15+6xq7U4yLc+Q8iYGzksRcR+N17dzhCCHNXPUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=CLvTshsr; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="CLvTshsr"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6daf1c4aa86so14638237b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 23:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725605760; x=1726210560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDqn/tIBk2qKFtV4bjgRb/uE5EO1xjlqbotUgqWUHIw=;
        b=CLvTshsr0I+q9QvCCQe/iNjOJpPu/wdon0smMjJ6tLnAjcLfXlM1Ackq41zIg9ymCS
         Z4GZwndyO3wp8MrtdWxlQl6G+ZPEyJggyi0uRYg3oRQc/89nWyK/iSynmd7WntjfZjq7
         No2827SgbNrJ0x3xR76GcQljoXSDZTtAFTVUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725605760; x=1726210560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cDqn/tIBk2qKFtV4bjgRb/uE5EO1xjlqbotUgqWUHIw=;
        b=ovfiSFmSBeJJznDONhsJhR1z5OBEo50+4Rf1CiKS2KqbsdTDL4kar+9X51r8+oCzuF
         Mi3ExGx/OUdb1T7roSSxGQkCKuMv2EnevFV4jj8Ro6MvjRYxltLsympRpksub/LQbmfg
         x4ntkRdJVp0nQzBesh9juPfHXmioZxlwySRTXpdphXA5eBNfyJB9WsxzalYLFHW4lzGD
         Hz2jESKmxTDRuh2okkGHYxUJKiPBTy8Mgo2pCPpGLQxWbqb/aUQtkxDTraQ/EZkfgyUn
         9SLLG8B2ETBkUzdQG5/I2THi7agNL39z01nw/Mg54ehk6zjDrT2C7+6CFqgaJdgNmOsh
         5WQg==
X-Forwarded-Encrypted: i=1; AJvYcCWKdZuWd+/ckJjf+RTU6Dw0WXzicYqI4PVgI6mBVNvNaEbBHrs9XPWXyo682yfZgmWUcBg4IaT1mOmFl4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiIMz3yAoeqXQfqQ9+olVYxw/WkAteX0+4WGzw3h84UbBFIwD8
	Q/MF85j+JALKSvg7IGojsnffa2IYtY/XrkYf+P4M4xdJx3tf+x/Saw//tDNhUUvB9DZOaabNz1h
	/DGMf5fONdFflyOCNNEbF8wBfXXNRQct0qRaGkmBhAoclzEeh
X-Google-Smtp-Source: AGHT+IEa9zBU8mMYgQ/UorJhRwPuWjQSA/vE7rWdEWDTR8mm0sKTpXwRDcw0YQNPxup/L1EYY/0Na/2ZY+ZgGqGid5M=
X-Received: by 2002:a05:690c:6382:b0:6b0:488a:5056 with SMTP id
 00721157ae682-6db44f1c116mr20042927b3.22.1725605760060; Thu, 05 Sep 2024
 23:56:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905113050.237789-1-pavitrakumarm@vayavyalabs.com>
 <20240905113050.237789-2-pavitrakumarm@vayavyalabs.com> <20240905200047.GA2451375-robh@kernel.org>
In-Reply-To: <20240905200047.GA2451375-robh@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 6 Sep 2024 12:25:48 +0530
Message-ID: <CALxtO0kMa0LLUzZOFFuH0bkUW-814=gbFouV3um6KSMHdGT=9A@mail.gmail.com>
Subject: Re: [PATCH v8 1/6] Add SPAcc Skcipher support
To: Rob Herring <robh@kernel.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rob,
   Thanks for the review and comments. I will update and push the patches
    based on your inputs.

Warm regards,
PK

On Fri, Sep 6, 2024 at 1:30=E2=80=AFAM Rob Herring <robh@kernel.org> wrote:
>
> On Thu, Sep 05, 2024 at 05:00:45PM +0530, Pavitrakumar M wrote:
> > Add SPAcc Skcipher support to Synopsys Protocol Accelerator(SPAcc) IP,
> > which is a crypto accelerator engine.
> > SPAcc supports ciphers, hashes and AEAD algorithms such as
> > AES in different modes, SHA variants, AES-GCM, Chacha-poly1305 etc.
> >
> > Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > ---
> >  drivers/crypto/dwc-spacc/spacc_core.c      | 1130 ++++++++++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.h      |  819 ++++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_device.c    |  304 ++++++
> >  drivers/crypto/dwc-spacc/spacc_device.h    |  228 ++++
> >  drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++++++
> >  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 ++
> >  drivers/crypto/dwc-spacc/spacc_interrupt.c |  317 ++++++
> >  drivers/crypto/dwc-spacc/spacc_manager.c   |  658 ++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  716 +++++++++++++
> >  9 files changed, 4653 insertions(+)
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
>
>
> > diff --git a/drivers/crypto/dwc-spacc/spacc_device.c b/drivers/crypto/d=
wc-spacc/spacc_device.c
> > new file mode 100644
> > index 000000000000..b9b6495fb5e3
> > --- /dev/null
> > +++ b/drivers/crypto/dwc-spacc/spacc_device.c
> > @@ -0,0 +1,304 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/module.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/platform_device.h>
> > +#include "spacc_device.h"
> > +
> > +static struct platform_device *spacc_pdev[MAX_DEVICES];
>
> Generally drivers aren't limited to some number of instances (except 1
> perhaps).
PK: Agreed, will remove this as it's not needed anymore.
>
> > +
> > +#define VSPACC_PRIORITY_MAX 15
> > +
> > +void spacc_cmd_process(struct spacc_device *spacc, int x)
> > +{
> > +     struct spacc_priv *priv =3D container_of(spacc, struct spacc_priv=
, spacc);
> > +
> > +     /* run tasklet to pop jobs off fifo */
> > +     tasklet_schedule(&priv->pop_jobs);
> > +}
> > +void spacc_stat_process(struct spacc_device *spacc)
> > +{
> > +     struct spacc_priv *priv =3D container_of(spacc, struct spacc_priv=
, spacc);
> > +
> > +     /* run tasklet to pop jobs off fifo */
> > +     tasklet_schedule(&priv->pop_jobs);
> > +}
> > +
>
> > +static const struct of_device_id snps_spacc_id[] =3D {
> > +     {.compatible =3D "snps,dwc-spacc" },
> > +     { /*sentinel */        }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(of, snps_spacc_id);
>
> You can move the table to where it is used since you no longer use it in
> spacc_init_device.
PK: Will move it.
>
> > +
> > +static int spacc_init_device(struct platform_device *pdev)
> > +{
> > +     int vspacc_idx =3D -1;
> > +     struct resource *mem;
> > +     void __iomem *baseaddr;
> > +     struct pdu_info   info;
> > +     int vspacc_priority =3D -1;
> > +     struct spacc_priv *priv;
> > +     int x =3D 0, err, oldmode, irq_num;
> > +     u64 oldtimer =3D 100000, timer =3D 100000;
> > +
> > +     /* Initialize DDT DMA pools based on this device's resources */
> > +     if (pdu_mem_init(&pdev->dev)) {
> > +             dev_err(&pdev->dev, "Could not initialize DMA pools\n");
> > +             return -ENOMEM;
> > +     }
> > +
> > +     mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> You don't need this as devm_platform_get_and_ioremap_resource() does
> this and more.
PK: Will fix it.
>
> > +     if (!mem) {
> > +             dev_err(&pdev->dev, "no memory resource for spacc\n");
> > +             err =3D -ENXIO;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > +     if (!priv) {
> > +             err =3D -ENOMEM;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     /* Read spacc priority and index and save inside priv.spacc.confi=
g */
> > +     if (of_property_read_u32(pdev->dev.of_node, "vspacc-priority",
> > +                              &vspacc_priority)) {
> > +             dev_err(&pdev->dev, "No virtual spacc priority specified\=
n");
> > +             err =3D -EINVAL;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     if (vspacc_priority < 0 && vspacc_priority > VSPACC_PRIORITY_MAX)=
 {
> > +             dev_err(&pdev->dev, "Invalid virtual spacc priority\n");
> > +             err =3D -EINVAL;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +     priv->spacc.config.priority =3D vspacc_priority;
> > +
> > +     if (of_property_read_u32(pdev->dev.of_node, "vspacc-index",
> > +                              &vspacc_idx)) {
> > +             dev_err(&pdev->dev, "No virtual spacc index specified\n")=
;
>
> This property was not required in the binding, so why does the driver
> require it?
PK: I will change it to virtual spacc ID (vspacc-id) as explained in
DT bindings patch
>
> > +             err =3D -EINVAL;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +     priv->spacc.config.idx =3D vspacc_idx;
> > +
> > +     priv->spacc.config.spacc_endian =3D of_property_read_bool(
> > +                             pdev->dev.of_node, "little-endian");
>
> Lack of "little-endian" doesn't equal BE.
PK: Agreed. All testing is done on Little endian CPUs.
       Will add BE support based on the platforms.
>
>
> > +
> > +     priv->spacc.config.oldtimer =3D oldtimer;
> > +
> > +     if (of_property_read_u64(pdev->dev.of_node, "spacc-wdtimer", &tim=
er)) {
> > +             dev_dbg(&pdev->dev, "No spacc wdtimer specified\n");
> > +             dev_dbg(&pdev->dev, "Default wdtimer: (100000)\n");
> > +             timer =3D 100000;
> > +     }
> > +     priv->spacc.config.timer =3D timer;
> > +
> > +     baseaddr =3D devm_platform_get_and_ioremap_resource(pdev, 0, &mem=
);
>
> You never use 'mem' that I see, so use devm_platform_ioremap_resource()
> instead.
PK: Will fix it.
>
> > +     if (IS_ERR(baseaddr)) {
> > +             dev_err(&pdev->dev, "unable to map iomem\n");
> > +             err =3D PTR_ERR(baseaddr);
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     pdu_get_version(baseaddr, &info);
> > +
> > +     dev_dbg(&pdev->dev, "EPN %04X : virt [%d]\n",
> > +                             info.spacc_version.project,
> > +                             info.spacc_version.vspacc_idx);
> > +
> > +     /* Validate virtual spacc index with vspacc count read from
> > +      * VERSION_EXT.VSPACC_CNT. Thus vspacc count=3D3, gives valid ind=
ex 0,1,2
> > +      */
> > +     if (vspacc_idx !=3D info.spacc_version.vspacc_idx) {
> > +             dev_err(&pdev->dev, "DTS vspacc_idx mismatch read value\n=
");
> > +             err =3D -EINVAL;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     if (vspacc_idx < 0 || vspacc_idx > (info.spacc_config.num_vspacc =
- 1)) {
> > +             dev_err(&pdev->dev, "Invalid vspacc index specified\n");
> > +             err =3D -EINVAL;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     err =3D spacc_init(baseaddr, &priv->spacc, &info);
> > +     if (err !=3D CRYPTO_OK) {
> > +             dev_err(&pdev->dev, "Failed to initialize device %d\n", x=
);
> > +             err =3D -ENXIO;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     spin_lock_init(&priv->hw_lock);
> > +     spacc_irq_glbl_disable(&priv->spacc);
> > +     tasklet_init(&priv->pop_jobs, spacc_pop_jobs, (unsigned long)priv=
);
> > +
> > +     priv->spacc.dptr =3D &pdev->dev;
> > +     platform_set_drvdata(pdev, priv);
> > +
> > +     irq_num =3D platform_get_irq(pdev, 0);
> > +     if (irq_num < 0) {
> > +             dev_err(&pdev->dev, "no irq resource for spacc\n");
> > +             err =3D -ENXIO;
> > +             goto free_ddt_mem_pool;
> > +     }
> > +
> > +     /* Determine configured maximum message length. */
> > +     priv->max_msg_len =3D priv->spacc.config.max_msg_size;
> > +
> > +     if (devm_request_irq(&pdev->dev, irq_num, spacc_irq_handler,
> > +                          IRQF_SHARED, dev_name(&pdev->dev),
> > +                          &pdev->dev)) {
> > +             dev_err(&pdev->dev, "failed to request IRQ\n");
> > +             err =3D -EBUSY;
> > +             goto err_tasklet_kill;
> > +     }
> > +
> > +     priv->spacc.irq_cb_stat =3D spacc_stat_process;
> > +     priv->spacc.irq_cb_cmdx =3D spacc_cmd_process;
> > +     oldmode                 =3D priv->spacc.op_mode;
> > +     priv->spacc.op_mode     =3D SPACC_OP_MODE_IRQ;
> > +
> > +     spacc_irq_stat_enable(&priv->spacc, 1);
> > +     spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> > +     spacc_irq_stat_wd_disable(&priv->spacc);
> > +     spacc_irq_glbl_enable(&priv->spacc);
> > +
> > +
> > +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
> > +     err =3D spacc_autodetect(&priv->spacc);
> > +     if (err < 0) {
> > +             spacc_irq_glbl_disable(&priv->spacc);
> > +             goto err_tasklet_kill;
> > +     }
> > +#else
> > +     err =3D spacc_static_config(&priv->spacc);
> > +     if (err < 0) {
> > +             spacc_irq_glbl_disable(&priv->spacc);
> > +             goto err_tasklet_kill;
> > +     }
> > +#endif
> > +
> > +     priv->spacc.op_mode =3D oldmode;
> > +
> > +     if (priv->spacc.op_mode =3D=3D SPACC_OP_MODE_IRQ) {
> > +             priv->spacc.irq_cb_stat =3D spacc_stat_process;
> > +             priv->spacc.irq_cb_cmdx =3D spacc_cmd_process;
> > +
> > +             spacc_irq_stat_enable(&priv->spacc, 1);
> > +             spacc_irq_cmdx_enable(&priv->spacc, 0, 1);
> > +             spacc_irq_glbl_enable(&priv->spacc);
> > +     } else {
> > +             priv->spacc.irq_cb_stat =3D spacc_stat_process;
> > +             priv->spacc.irq_cb_stat_wd =3D spacc_stat_process;
> > +
> > +             spacc_irq_stat_enable(&priv->spacc,
> > +                                   priv->spacc.config.ideal_stat_level=
);
> > +
> > +             spacc_irq_cmdx_disable(&priv->spacc, 0);
> > +             spacc_irq_stat_wd_enable(&priv->spacc);
> > +             spacc_irq_glbl_enable(&priv->spacc);
> > +
> > +             /* enable the wd by setting the wd_timer =3D 100000 */
> > +             spacc_set_wd_count(&priv->spacc,
> > +                                priv->spacc.config.wd_timer =3D
> > +                                             priv->spacc.config.timer)=
;
> > +     }
> > +
> > +     /* unlock normal*/
> > +     if (priv->spacc.config.is_secure_port) {
> > +             u32 t;
> > +
> > +             t =3D readl(baseaddr + SPACC_REG_SECURE_CTRL);
> > +             t &=3D ~(1UL << 31);
> > +             writel(t, baseaddr + SPACC_REG_SECURE_CTRL);
> > +     }
> > +
> > +     /* unlock device by default */
> > +     writel(0, baseaddr + SPACC_REG_SECURE_CTRL);
>
> So writel/readl are always little endian (because PCI is always LE).
> Either you aren't handling endianness or you are using "little-endian"
> to refer to something else besides the registers?
PK: The internal "sg DMA" and the "Context Memory" needs to know
       the endianness. We will default to little endian. If the big-endian
       support comes, it will come with a "big-endian" property in DT bindi=
ngs.
>
> > +
> > +     return err;
> > +
> > +err_tasklet_kill:
> > +     tasklet_kill(&priv->pop_jobs);
> > +     spacc_fini(&priv->spacc);
> > +
> > +free_ddt_mem_pool:
> > +     pdu_mem_deinit(&pdev->dev);
> > +
> > +     return err;
> > +}
> > +
> > +static void spacc_unregister_algs(void)
> > +{
> > +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
> > +     spacc_unregister_hash_algs();
> > +#endif
> > +#if  IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
> > +     spacc_unregister_aead_algs();
> > +#endif
> > +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
> > +     spacc_unregister_cipher_algs();
> > +#endif
> > +}
> > +
> > +
> > +static int spacc_crypto_probe(struct platform_device *pdev)
> > +{
> > +     int rc;
> > +
> > +     rc =3D spacc_init_device(pdev);
> > +     if (rc < 0)
> > +             goto err;
> > +
> > +     spacc_pdev[0] =3D pdev;
>
> You have an array of devices, but always write to index 0?
PK: This array will be removed, its a stale design.
       The vSPAccs are handled differently.
>
> > +
> > +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_HASH)
> > +     rc =3D probe_hashes(pdev);
> > +     if (rc < 0)
> > +             goto err;
> > +#endif
> > +
> > +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_CIPHER)
> > +     rc =3D probe_ciphers(pdev);
> > +     if (rc < 0)
> > +             goto err;
> > +#endif
> > +
> > +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AEAD)
> > +     rc =3D probe_aeads(pdev);
> > +     if (rc < 0)
> > +             goto err;
> > +#endif
> > +
> > +     return 0;
> > +err:
> > +     spacc_unregister_algs();
> > +
> > +     return rc;
> > +}
> > +
> > +static void spacc_crypto_remove(struct platform_device *pdev)
> > +{
> > +     spacc_unregister_algs();
> > +     spacc_remove(pdev);
> > +}
> > +
> > +static struct platform_driver spacc_driver =3D {
> > +     .probe  =3D spacc_crypto_probe,
> > +     .remove =3D spacc_crypto_remove,
> > +     .driver =3D {
> > +             .name  =3D "spacc",
> > +             .of_match_table =3D snps_spacc_id,
> > +             .owner =3D THIS_MODULE,
> > +     },
> > +};
> > +
> > +module_platform_driver(spacc_driver);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Synopsys, Inc.");
> > +MODULE_DESCRIPTION("SPAcc Crypto Accelerator Driver");
> > diff --git a/drivers/crypto/dwc-spacc/spacc_device.h b/drivers/crypto/d=
wc-spacc/spacc_device.h
> > new file mode 100644
> > index 000000000000..2223c3cfcf18
> > --- /dev/null
> > +++ b/drivers/crypto/dwc-spacc/spacc_device.h
> > @@ -0,0 +1,228 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef SPACC_DEVICE_H_
> > +#define SPACC_DEVICE_H_
> > +
> > +#include <crypto/hash.h>
> > +#include <crypto/ctr.h>
> > +#include <crypto/internal/aead.h>
> > +#include <linux/of.h>
> > +#include "spacc_core.h"
> > +
> > +#define MODE_TAB_AEAD(_name, _ciph, _hash, _hashlen, _ivlen, _blocklen=
) \
> > +     .name =3D _name, .aead =3D { .ciph =3D _ciph, .hash =3D _hash }, =
\
> > +     .hashlen =3D _hashlen, .ivlen =3D _ivlen, .blocklen =3D _blocklen
> > +
> > +/* Helper macros for initializing the hash/cipher tables. */
> > +#define MODE_TAB_COMMON(_name, _id_name, _blocklen) \
> > +     .name =3D _name, .id =3D CRYPTO_MODE_##_id_name, .blocklen =3D _b=
locklen
> > +
> > +#define MODE_TAB_HASH(_name, _id_name, _hashlen, _blocklen) \
> > +     MODE_TAB_COMMON(_name, _id_name, _blocklen), \
> > +     .hashlen =3D _hashlen, .testlen =3D _hashlen
> > +
> > +#define MODE_TAB_CIPH(_name, _id_name, _ivlen, _blocklen) \
> > +     MODE_TAB_COMMON(_name, _id_name, _blocklen), \
> > +     .ivlen =3D _ivlen
> > +
> > +#define MODE_TAB_HASH_XCBC   0x8000
> > +
> > +#define SPACC_MAX_DIGEST_SIZE        64
> > +#define SPACC_MAX_KEY_SIZE   32
> > +#define SPACC_MAX_IV_SIZE    16
> > +
> > +#define SPACC_DMA_ALIGN              4
> > +#define SPACC_DMA_BOUNDARY   0x10000
> > +
> > +#define MAX_DEVICES          2
> > +/* flag means the IV is computed from setkey and crypt*/
> > +#define SPACC_MANGLE_IV_FLAG 0x8000
> > +
> > +/* we're doing a CTR mangle (for RFC3686/IPsec)*/
> > +#define SPACC_MANGLE_IV_RFC3686      0x0100
> > +
> > +/* we're doing GCM */
> > +#define SPACC_MANGLE_IV_RFC4106      0x0200
> > +
> > +/* we're doing GMAC */
> > +#define SPACC_MANGLE_IV_RFC4543      0x0300
> > +
> > +/* we're doing CCM */
> > +#define SPACC_MANGLE_IV_RFC4309      0x0400
> > +
> > +/* we're doing SM4 GCM/CCM */
> > +#define SPACC_MANGLE_IV_RFC8998      0x0500
> > +
> > +#define CRYPTO_MODE_AES_CTR_RFC3686 (CRYPTO_MODE_AES_CTR \
> > +             | SPACC_MANGLE_IV_FLAG \
> > +             | SPACC_MANGLE_IV_RFC3686)
> > +#define CRYPTO_MODE_AES_GCM_RFC4106 (CRYPTO_MODE_AES_GCM \
> > +             | SPACC_MANGLE_IV_FLAG \
> > +             | SPACC_MANGLE_IV_RFC4106)
> > +#define CRYPTO_MODE_AES_GCM_RFC4543 (CRYPTO_MODE_AES_GCM \
> > +             | SPACC_MANGLE_IV_FLAG \
> > +             | SPACC_MANGLE_IV_RFC4543)
> > +#define CRYPTO_MODE_AES_CCM_RFC4309 (CRYPTO_MODE_AES_CCM \
> > +             | SPACC_MANGLE_IV_FLAG \
> > +             | SPACC_MANGLE_IV_RFC4309)
> > +#define CRYPTO_MODE_SM4_GCM_RFC8998 (CRYPTO_MODE_SM4_GCM)
> > +#define CRYPTO_MODE_SM4_CCM_RFC8998 (CRYPTO_MODE_SM4_CCM)
> > +
> > +struct spacc_crypto_ctx {
> > +     struct device *dev;
> > +
> > +     spinlock_t lock;
> > +     struct list_head jobs;
> > +     int handle, mode, auth_size, key_len;
> > +     unsigned char *cipher_key;
> > +
> > +     /*
> > +      * Indicates that the H/W context has been setup and can be used =
for
> > +      * crypto; otherwise, the software fallback will be used.
> > +      */
> > +     bool ctx_valid;
> > +     unsigned int flag_ppp;
> > +
> > +     /* salt used for rfc3686/givencrypt mode */
> > +     unsigned char csalt[16];
> > +     u8 ipad[128] __aligned(sizeof(u32));
> > +     u8 digest_ctx_buf[128] __aligned(sizeof(u32));
> > +     u8 tmp_buffer[128] __aligned(sizeof(u32));
> > +
> > +     /* Save keylen from setkey */
> > +     int keylen;
> > +     u8  key[256];
> > +     int zero_key;
> > +     unsigned char *tmp_sgl_buff;
> > +     struct scatterlist *tmp_sgl;
> > +
> > +     union{
> > +             struct crypto_ahash      *hash;
> > +             struct crypto_aead       *aead;
> > +             struct crypto_skcipher   *cipher;
> > +     } fb;
> > +};
> > +
> > +struct spacc_crypto_reqctx {
> > +     struct pdu_ddt src, dst;
> > +     void *digest_buf, *iv_buf;
> > +     dma_addr_t digest_dma;
> > +     int dst_nents, src_nents, aead_nents, total_nents;
> > +     int encrypt_op, mode, single_shot;
> > +     unsigned int spacc_cipher_cryptlen, rem_nents;
> > +
> > +     struct aead_cb_data {
> > +             int new_handle;
> > +             struct spacc_crypto_ctx    *tctx;
> > +             struct spacc_crypto_reqctx *ctx;
> > +             struct aead_request        *req;
> > +             struct spacc_device        *spacc;
> > +     } cb;
> > +
> > +     struct ahash_cb_data {
> > +             int new_handle;
> > +             struct spacc_crypto_ctx    *tctx;
> > +             struct spacc_crypto_reqctx *ctx;
> > +             struct ahash_request       *req;
> > +             struct spacc_device        *spacc;
> > +     } acb;
> > +
> > +     struct cipher_cb_data {
> > +             int new_handle;
> > +             struct spacc_crypto_ctx    *tctx;
> > +             struct spacc_crypto_reqctx *ctx;
> > +             struct skcipher_request    *req;
> > +             struct spacc_device        *spacc;
> > +     } ccb;
> > +
> > +     union {
> > +             struct ahash_request hash_req;
> > +             struct skcipher_request cipher_req;
> > +             struct aead_request aead_req;
> > +     } fb;
> > +};
> > +
> > +struct mode_tab {
> > +     char name[128];
> > +
> > +     int valid;
> > +
> > +     /* mode ID used in hash/cipher mode but not aead*/
> > +     int id;
> > +
> > +     /* ciph/hash mode used in aead */
> > +     struct {
> > +             int ciph, hash;
> > +     } aead;
> > +
> > +     unsigned int hashlen, ivlen, blocklen, keylen[3];
> > +     unsigned int keylen_mask, testlen;
> > +     unsigned int chunksize, walksize, min_keysize, max_keysize;
> > +
> > +     bool sw_fb;
> > +
> > +     union {
> > +             unsigned char hash_test[SPACC_MAX_DIGEST_SIZE];
> > +             unsigned char ciph_test[3][2 * SPACC_MAX_IV_SIZE];
> > +     };
> > +};
> > +
> > +struct spacc_alg {
> > +     struct mode_tab *mode;
> > +     unsigned int keylen_mask;
> > +
> > +     struct device *dev[MAX_DEVICES];
> > +
> > +     struct list_head list;
> > +     struct crypto_alg *calg;
> > +     struct crypto_tfm *tfm;
> > +
> > +     union {
> > +             struct ahash_alg hash;
> > +             struct aead_alg aead;
> > +             struct skcipher_alg skcipher;
> > +     } alg;
> > +};
> > +
> > +static inline const struct spacc_alg *spacc_tfm_ahash(struct crypto_tf=
m *tfm)
> > +{
> > +     const struct crypto_alg *calg =3D tfm->__crt_alg;
> > +
> > +     if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D CRYPTO_ALG_TY=
PE_AHASH)
> > +             return container_of(calg, struct spacc_alg, alg.hash.halg=
.base);
> > +
> > +     return NULL;
> > +}
> > +
> > +static inline const struct spacc_alg *spacc_tfm_skcipher(struct crypto=
_tfm *tfm)
> > +{
> > +     const struct crypto_alg *calg =3D tfm->__crt_alg;
> > +
> > +     if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D
> > +                                     CRYPTO_ALG_TYPE_SKCIPHER)
> > +             return container_of(calg, struct spacc_alg, alg.skcipher.=
base);
> > +
> > +     return NULL;
> > +}
> > +
> > +static inline const struct spacc_alg *spacc_tfm_aead(struct crypto_tfm=
 *tfm)
> > +{
> > +     const struct crypto_alg *calg =3D tfm->__crt_alg;
> > +
> > +     if ((calg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D CRYPTO_ALG_TY=
PE_AEAD)
> > +             return container_of(calg, struct spacc_alg, alg.aead.base=
);
> > +
> > +     return NULL;
> > +}
> > +
> > +int probe_hashes(struct platform_device *spacc_pdev);
> > +int spacc_unregister_hash_algs(void);
> > +
> > +int probe_aeads(struct platform_device *spacc_pdev);
> > +int spacc_unregister_aead_algs(void);
> > +
> > +int probe_ciphers(struct platform_device *spacc_pdev);
> > +int spacc_unregister_cipher_algs(void);
> > +
> > +irqreturn_t spacc_irq_handler(int irq, void *dev);
> > +#endif
> > diff --git a/drivers/crypto/dwc-spacc/spacc_hal.c b/drivers/crypto/dwc-=
spacc/spacc_hal.c
> > new file mode 100644
> > index 000000000000..0d460c4df542
> > --- /dev/null
> > +++ b/drivers/crypto/dwc-spacc/spacc_hal.c
> > @@ -0,0 +1,367 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/dmapool.h>
> > +#include <linux/dma-mapping.h>
> > +#include "spacc_hal.h"
> > +
> > +static struct dma_pool *ddt_pool, *ddt16_pool, *ddt4_pool;
> > +static struct device *ddt_device;
> > +
> > +#define PDU_REG_SPACC_VERSION   0x00180UL
> > +#define PDU_REG_SPACC_CONFIG    0x00184UL
> > +#define PDU_REG_SPACC_CONFIG2   0x00190UL
> > +#define PDU_REG_SPACC_IV_OFFSET 0x00040UL
> > +#define PDU_REG_PDU_CONFIG      0x00188UL
> > +#define PDU_REG_SECURE_LOCK     0x001C0UL
> > +
> > +int pdu_get_version(void __iomem *dev, struct pdu_info *inf)
> > +{
> > +     unsigned long tmp;
> > +
> > +     if (!inf)
> > +             return -1;
> > +
> > +     memset(inf, 0, sizeof(*inf));
> > +     tmp =3D readl(dev + PDU_REG_SPACC_VERSION);
> > +
> > +     /* Read the SPAcc version block this tells us the revision,
> > +      * project, and a few other feature bits
> > +      *
> > +      * layout for v6.5+
> > +      */
> > +     inf->spacc_version =3D (struct spacc_version_block) {
> > +             .minor      =3D SPACC_ID_MINOR(tmp),
> > +             .major      =3D SPACC_ID_MAJOR(tmp),
> > +             .version    =3D (SPACC_ID_MAJOR(tmp) << 4) | SPACC_ID_MIN=
OR(tmp),
> > +             .qos        =3D SPACC_ID_QOS(tmp),
> > +             .is_spacc   =3D SPACC_ID_TYPE(tmp) =3D=3D SPACC_TYPE_SPAC=
CQOS,
> > +             .is_pdu     =3D SPACC_ID_TYPE(tmp) =3D=3D SPACC_TYPE_PDU,
> > +             .aux        =3D SPACC_ID_AUX(tmp),
> > +             .vspacc_idx =3D SPACC_ID_VIDX(tmp),
> > +             .partial    =3D SPACC_ID_PARTIAL(tmp),
> > +             .project    =3D SPACC_ID_PROJECT(tmp),
> > +     };
> > +
> > +     /* try to autodetect */
> > +     writel(0x80000000, dev + PDU_REG_SPACC_IV_OFFSET);
> > +
> > +     if (readl(dev + PDU_REG_SPACC_IV_OFFSET) =3D=3D 0x80000000)
> > +             inf->spacc_version.ivimport =3D 1;
> > +     else
> > +             inf->spacc_version.ivimport =3D 0;
> > +
> > +
> > +     /* Read the SPAcc config block (v6.5+) which tells us how many
> > +      * contexts there are and context page sizes
> > +      * this register is only available in v6.5 and up
> > +      */
> > +     tmp =3D readl(dev + PDU_REG_SPACC_CONFIG);
> > +     inf->spacc_config =3D (struct spacc_config_block) {
> > +             SPACC_CFG_CTX_CNT(tmp),
> > +             SPACC_CFG_VSPACC_CNT(tmp),
> > +             SPACC_CFG_CIPH_CTX_SZ(tmp),
> > +             SPACC_CFG_HASH_CTX_SZ(tmp),
> > +             SPACC_CFG_DMA_TYPE(tmp),
> > +             0, 0, 0, 0
> > +     };
> > +
> > +     /* CONFIG2 only present in v6.5+ cores */
> > +     tmp =3D readl(dev + PDU_REG_SPACC_CONFIG2);
> > +     if (inf->spacc_version.qos) {
> > +             inf->spacc_config.cmd0_fifo_depth =3D
> > +                             SPACC_CFG_CMD0_FIFO_QOS(tmp);
> > +             inf->spacc_config.cmd1_fifo_depth =3D
> > +                             SPACC_CFG_CMD1_FIFO(tmp);
> > +             inf->spacc_config.cmd2_fifo_depth =3D
> > +                             SPACC_CFG_CMD2_FIFO(tmp);
> > +             inf->spacc_config.stat_fifo_depth =3D
> > +                             SPACC_CFG_STAT_FIFO_QOS(tmp);
> > +     } else {
> > +             inf->spacc_config.cmd0_fifo_depth =3D
> > +                             SPACC_CFG_CMD0_FIFO(tmp);
> > +             inf->spacc_config.stat_fifo_depth =3D
> > +                             SPACC_CFG_STAT_FIFO(tmp);
> > +     }
> > +
> > +     /* only read PDU config if it's actually a PDU engine */
> > +     if (inf->spacc_version.is_pdu) {
> > +             tmp =3D readl(dev + PDU_REG_PDU_CONFIG);
> > +             inf->pdu_config =3D (struct pdu_config_block)
> > +                     {SPACC_PDU_CFG_MINOR(tmp),
> > +                      SPACC_PDU_CFG_MAJOR(tmp)};
> > +
> > +             /* unlock all cores by default */
> > +             writel(0, dev + PDU_REG_SECURE_LOCK);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +void pdu_to_dev(void __iomem *addr_, uint32_t *src, unsigned long nwor=
d)
> > +{
> > +     void __iomem *addr =3D addr_;
> > +
> > +     while (nword--) {
> > +             writel(*src++, addr);
> > +             addr +=3D 4;
> > +     }
> > +}
> > +
> > +void pdu_from_dev(u32 *dst, void __iomem *addr_, unsigned long nword)
> > +{
> > +     void __iomem *addr =3D addr_;
> > +
> > +     while (nword--) {
> > +             *dst++ =3D readl(addr);
> > +             addr +=3D 4;
> > +     }
> > +}
> > +
> > +static void pdu_to_dev_big(void __iomem *addr_, const unsigned char *s=
rc,
> > +                        unsigned long nword)
> > +{
> > +     unsigned long v;
> > +     void __iomem *addr =3D addr_;
> > +
> > +     while (nword--) {
> > +             v =3D 0;
> > +             v =3D (v << 8) | ((unsigned long)*src++);
> > +             v =3D (v << 8) | ((unsigned long)*src++);
> > +             v =3D (v << 8) | ((unsigned long)*src++);
> > +             v =3D (v << 8) | ((unsigned long)*src++);
>
> The kernel has helpers for endian conversion and types that define
> endianness of buffers (e.g. __be32). Use them.
PK: Will fix it.
>
> > +             writel(v, addr);
> > +             addr +=3D 4;
> > +     }
> > +}
