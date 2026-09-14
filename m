Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0731C3F4859
	for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2026 07:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371392; cv=none; b=lE0F0yT8gvMYbvQhA+xAM3f+PxcdG19KbeZJkvGWUIWVK9HxaXZIvzbptDKxJ59N3r2isGjMLajhNmZdNOVWy6YLbKn2Z+VK97fs7BSGzLrF5CEgZJEmR4YV9RRbs5DUJsZh+Pc2l+crmhicDY3LlCKHcf8ecDXGMBsW9wnwva0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371392; c=relaxed/simple;
	bh=hEm/bEks3irY7+02kfdkjDPhk7yQ+7iNnmO2cR5K+R8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PbzRmJFvRPwJcTdxSPWrkh1cm0Q9SR8coWP5zET6iHu9+9nkJiPLDDGEWnIpoWlizWip1c+YUG+9vedsHLOdBV+FCoMcyIYFUK2XWGNO1quLToiAlO7ZsIg02JKPaaBK/uB4V0viL+VJmJ0fQytJ9+P0u1i2uuufgFgA4ZlrL9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8HKUh7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8HKUh7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9125D1F0089C
	for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2026 07:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789371389;
	bh=iieWhL4+NDVY5pvVLQHdGLRs9vjEjFm1op0rBHnDsvg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=K8HKUh7Kwa+c+t+xaa+26eldeQDTIZjvbrnIlXkgbjKdcUW84gLPrLIrY3E9B8LJ3
	 TWzAvv1BJCSAO0sYRxnVzNFWxkWBGNVvGLSnBpQLUXJhimg+VxZIF5yLK0v1gSpYpU
	 VMZ22DFtf5etuMFSomEmDX2unX9G2cXzGMaBZpVGp7vdlnB48oaXyzI0RMpLNbVqJA
	 gvNW9wyzm1Vm5m0nN9OeCDglS71RRJ41I58Qy/ahMqai0bFVKjo1ohOHClBWZqsOJL
	 sV8nz6S0CNPdlLpRLKFjeX2MnygOCwoTaA9gWA/h+gPhPmOgzHzYNhCAaHjlCO001I
	 eX+RWnnMGB05Q==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a67fa7a64eso3085752a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2026 00:36:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByj+cPRnZY2t98K4/0POGBzJdizB/K15Va256oglm+Ic8elml5Azz/S5y1ohDtbHVjpewHPSTHV7zIjVV0=@vger.kernel.org
X-Gm-Message-State: AFuF++neV9di8t7QkjnEXkMD3lhIgnYs5HaoHsXX6bmN8zA8+XSsRWnf
	YQeXvxbmcXv8qDYG70uFSSXXymtTxR4mwo/NgV4LQhg3RY3WuUNAh+GsY52PZqxUMrcKm9BprjD
	M4TmA2XBrv7VCUAeGqBW4MK8RoNk9Kh0=
X-Received: by 2002:a05:6402:24d9:b0:6a9:ce09:dbc1 with SMTP id
 4fb4d7f45d1cf-6a9f6227995mr664006a12.5.1789371388125; Mon, 14 Sep 2026
 00:36:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911090256.7834-1-zhaoqunqin@163.com> <20260911090256.7834-3-zhaoqunqin@163.com>
In-Reply-To: <20260911090256.7834-3-zhaoqunqin@163.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 14 Sep 2026 15:36:15 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4VEtZJAoYBz24=ab37fdpLL_kSS92vxMn61Rcq0C33aQ@mail.gmail.com>
X-Gm-Features: AcwNN1W4J0VXunkboYJGsDo05xNt8zCnA_A78X63I9pY7tbgd8CpbxBMHPTJSJI
Message-ID: <CAAhV-H4VEtZJAoYBz24=ab37fdpLL_kSS92vxMn61Rcq0C33aQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Qunqin Zhao <zhaoqunqin@163.com>
Cc: lee@kernel.org, zhaoqunqin@loongson.cn, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-crypto@vger.kernel.org, mfd@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Qunqin,

On Fri, Sep 11, 2026 at 5:03=E2=80=AFPM Qunqin Zhao <zhaoqunqin@163.com> wr=
ote:
>
> From: Qunqin Zhao <zhaoqunqin@loongson.cn>
>
> Address multiple historical driver issues discovered by the Sashiko
> Automation system within the loongson_se_probe() initialization flow
> and the driver's interrupt service routines [1].
>
> - Add an explicit bounds check in se_irq_handler() before accessing
>   the engines array to prevent an out-of-bounds memory access.
>
> - Validate the id argument in loongson_se_init_engine() and reject
>   engine 0, whose data buffer is reused for the command buffers of all
>   other engines, to prevent out-of-bounds accesses and overlapping DMA
>   buffers.
>
> - Switch from devm_kmalloc() to devm_kzalloc() and initialize all
>   engine completion structures in probe(), dropping the redundant
>   init_completion() in loongson_se_init_engine().
>
> - Introduce loongson_se_reinit_completion() to mask the target
>   interrupt, clear any pending status, and reset the completion under
>   dev_lock before a command is issued, then re-enable the interrupt
>   under the same lock after the command has been triggered.  This
>   closes the race where a stale interrupt from a previously
>   interrupted command could complete the current command's completion.
>   A new poll_lock serializes the trigger and poll busy-wait so
>   interrupts are not disabled for up to 10 ms.
The locking of this driver is more and more complicated, I doubt
whether AI's review is really correct here. For me, the existing
locking code is just fine and simple.

Huacai

>
> - Wait for controller command completion with a bounded
>   non-interruptible wait so a pending signal cannot leave the
>   controller running while its DMA buffers are being torn down, and a
>   wedged controller cannot hang the kernel indefinitely.
>
> - Fix EPROBE_DEFER handling: propagate the error directly from
>   platform_irq_count() instead of overwriting it with ENODEV so that
>   probe deferral works when the interrupt provider is not yet ready.
>
> - Validate dmam_size from firmware against the minimum required size
>   to keep the command buffers of all engines within engine 0's data
>   region and prevent overlapping DMA buffers.
>
> - Return the error code from devm_request_irq() instead of silently
>   continuing to prevent an indefinite hang.
>
> - Add a loongson_se_stop() cleanup handler registered with
>   devm_add_action_or_reset() before loongson_se_init() so that a
>   failed init still stops the controller and masks all interrupts via
>   devres, preventing DMA access to freed memory.
>
> - Zero-initialize the local controller command structures in
>   loongson_se_init() and loongson_se_init_engine() to prevent
>   uninitialized stack data from being written to device registers.
>
> - Add the SE_CMD_STOP command definition.
>
> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1=
]
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip =
controller")
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> ---
>  drivers/mfd/loongson-se.c       | 112 ++++++++++++++++++++++++++++----
>  include/linux/mfd/loongson-se.h |   1 +
>  2 files changed, 102 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 7f552a8ee..18075d4fa 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -23,6 +23,8 @@
>  struct loongson_se {
>         void __iomem *base;
>         spinlock_t dev_lock;
> +       /* Synchronizes command submission between users of different eng=
ines */
> +       spinlock_t poll_lock;
>         struct completion cmd_completion;
>
>         void *dmam_base;
> @@ -42,7 +44,7 @@ static int loongson_se_poll(struct loongson_se *se, u32=
 int_bit)
>         u32 status;
>         int err;
>
> -       spin_lock_irq(&se->dev_lock);
> +       spin_lock(&se->poll_lock);
>
>         /* Notify the controller that the engine needs to be started */
>         writel(int_bit, se->base + SE_L2SINT_SET);
> @@ -52,17 +54,51 @@ static int loongson_se_poll(struct loongson_se *se, u=
32 int_bit)
>                                                 !(status & int_bit),
>                                                 1, LOONGSON_ENGINE_CMD_TI=
MEOUT_US);
>
> +       spin_unlock(&se->poll_lock);
> +
> +       spin_lock_irq(&se->dev_lock);
> +       /*
> +        * Re-enable the interrupt that loongson_se_reinit_completion() m=
asked.
> +        * The hardware guarantees that once the interrupt is re-enabled,=
 only
> +        * interrupts for the command just issued can arrive, so a stale
> +        * interrupt from a previously interrupted command can never comp=
lete
> +        * this command's completion.
> +        */
> +       writel(int_bit | readl(se->base + SE_S2LINT_EN), se->base + SE_S2=
LINT_EN);
> +
>         spin_unlock_irq(&se->dev_lock);
>
>         return err;
>  }
>
> +/*
> + * Prepare a completion for a new command: mask the corresponding interr=
upt,
> + * clear any pending interrupt status, and reset the completion.  This r=
uns
> + * under dev_lock so that the IRQ handler cannot race with it.  The inte=
rrupt
> + * is re-enabled in loongson_se_poll() after the command has been issued=
.
> + */
> +static void loongson_se_reinit_completion(struct loongson_se *se,
> +                                         struct completion *completion, =
u32 int_bit)
> +{
> +       spin_lock_irq(&se->dev_lock);
> +
> +       writel(readl(se->base + SE_S2LINT_EN) & ~int_bit, se->base + SE_S=
2LINT_EN);
> +
> +       writel(int_bit, se->base + SE_S2LINT_CL);
> +
> +       reinit_completion(completion);
> +
> +       spin_unlock_irq(&se->dev_lock);
> +}
> +
>  static int loongson_se_send_controller_cmd(struct loongson_se *se,
>                                            struct loongson_se_controller_=
cmd *cmd)
>  {
>         u32 *send_cmd =3D (u32 *)cmd;
>         int err, i;
>
> +       loongson_se_reinit_completion(se, &se->cmd_completion, SE_INT_CON=
TROLLER);
> +
>         for (i =3D 0; i < SE_SEND_CMD_REG_LEN; i++)
>                 writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
>
> @@ -70,17 +106,31 @@ static int loongson_se_send_controller_cmd(struct lo=
ongson_se *se,
>         if (err)
>                 return err;
>
> -       return wait_for_completion_interruptible(&se->cmd_completion);
> +       /*
> +        * Wait for the controller to complete the command.  Use a bounde=
d
> +        * non-interruptible wait: a pending signal must not leave the
> +        * controller running while its DMA buffers are being torn down.
> +        * One second is far more than any controller command should take=
,
> +        * while still bounding the wait if the hardware wedges.
> +        */
> +       if (!wait_for_completion_timeout(&se->cmd_completion, HZ))
> +               return -ETIMEDOUT;
> +
> +       return 0;
>  }
>
>  int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
>  {
> +       int err;
> +
> +       loongson_se_reinit_completion(engine->se, &engine->completion, BI=
T(engine->id));
> +
>         /*
>          * After engine initialization, the controller already knows
>          * where to obtain engine commands from. Now all we need to
>          * do is notify the controller that the engine needs to be starte=
d.
>          */
> -       int err =3D loongson_se_poll(engine->se, BIT(engine->id));
> +       err =3D loongson_se_poll(engine->se, BIT(engine->id));
>
>         if (err)
>                 return err;
> @@ -92,12 +142,17 @@ EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
>  struct loongson_se_engine *loongson_se_init_engine(struct device *dev, i=
nt id)
>  {
>         struct loongson_se *se =3D dev_get_drvdata(dev);
> -       struct loongson_se_engine *engine =3D &se->engines[id];
> -       struct loongson_se_controller_cmd cmd;
> +       struct loongson_se_engine *engine;
> +       struct loongson_se_controller_cmd cmd =3D {0};
> +
> +       /* Engine 0 does not exist and its data buffer is reused for comm=
ands */
> +       if (id <=3D 0 || id >=3D SE_ENGINE_MAX)
> +               return NULL;
> +
> +       engine =3D &se->engines[id];
>
>         engine->se =3D se;
>         engine->id =3D id;
> -       init_completion(&engine->completion);
>
>         /* Divide DMA memory equally among all engines */
>         engine->buffer_size =3D se->dmam_size / SE_ENGINE_MAX;
> @@ -155,7 +210,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_=
id)
>         /* For engines */
>         while (int_status) {
>                 id =3D __ffs(int_status);
> -               complete(&se->engines[id].completion);
> +               if (id < SE_ENGINE_MAX)
> +                       complete(&se->engines[id].completion);
>                 int_status &=3D ~BIT(id);
>                 writel(BIT(id), se->base + SE_S2LINT_CL);
>         }
> @@ -167,7 +223,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_=
id)
>
>  static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int=
 size)
>  {
> -       struct loongson_se_controller_cmd cmd;
> +       struct loongson_se_controller_cmd cmd =3D {0};
>         int err;
>
>         cmd.command_id =3D SE_CMD_START;
> @@ -188,6 +244,17 @@ static const struct mfd_cell engines[] =3D {
>         { .name =3D "tpm_loongson" },
>  };
>
> +static void loongson_se_stop(void *data)
> +{
> +       struct loongson_se *se =3D data;
> +       struct loongson_se_controller_cmd cmd =3D {0};
> +
> +       cmd.command_id =3D SE_CMD_STOP;
> +       loongson_se_send_controller_cmd(se, &cmd);
> +
> +       writel(0, se->base + SE_S2LINT_EN);
> +}
> +
>  static int loongson_se_probe(struct platform_device *pdev)
>  {
>         struct device *dev =3D &pdev->dev;
> @@ -195,19 +262,34 @@ static int loongson_se_probe(struct platform_device=
 *pdev)
>         int nr_irq, irq, err, i;
>         dma_addr_t paddr;
>
> -       se =3D devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
> +       se =3D devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
>         if (!se)
>                 return -ENOMEM;
>
>         dev_set_drvdata(dev, se);
>         init_completion(&se->cmd_completion);
>         spin_lock_init(&se->dev_lock);
> +       spin_lock_init(&se->poll_lock);
>         mutex_init(&se->engine_init_lock);
>
> +       for (i =3D 0; i < SE_ENGINE_MAX; i++)
> +               init_completion(&se->engines[i].completion);
> +
>         dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
>         if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
>                 return -ENODEV;
>
> +       /*
> +        * Engine 0 does not exist and its data buffer is reused as the c=
ommand
> +        * buffer for the other engines.  The command buffers of all engi=
nes
> +        * therefore must fit within engine 0's data region, i.e.
> +        * dmam_size / SE_ENGINE_MAX >=3D SE_ENGINE_MAX * 2 * SE_ENGINE_C=
MD_SIZE.
> +        * Enforce this to keep each engine's data and command buffers fr=
om
> +        * overlapping.
> +        */
> +       if ((se->dmam_size / SE_ENGINE_MAX) < (SE_ENGINE_MAX * 2 * SE_ENG=
INE_CMD_SIZE))
> +               return -EINVAL;
> +
>         se->dmam_base =3D dmam_alloc_coherent(dev, se->dmam_size, &paddr,=
 GFP_KERNEL);
>         if (!se->dmam_base)
>                 return -ENOMEM;
> @@ -217,20 +299,28 @@ static int loongson_se_probe(struct platform_device=
 *pdev)
>                 return PTR_ERR(se->base);
>
>         nr_irq =3D platform_irq_count(pdev);
> -       if (nr_irq <=3D 0)
> +       if (nr_irq =3D=3D 0)
>                 return -ENODEV;
> +       if (nr_irq < 0)
> +               return nr_irq;
>
>         writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
>
>         for (i =3D 0; i < nr_irq; i++) {
>                 irq =3D platform_get_irq(pdev, i);
>                 err =3D devm_request_irq(dev, irq, se_irq_handler, IRQF_S=
HARED, "loongson-se", se);
> -               if (err)
> +               if (err) {
>                         dev_err(dev, "failed to request IRQ: %d\n", irq);
> +                       return err;
> +               }
>         }
>
>         writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
>
> +       err =3D devm_add_action_or_reset(dev, loongson_se_stop, se);
> +       if (err)
> +               return err;
> +
>         err =3D loongson_se_init(se, paddr, se->dmam_size);
>         if (err)
>                 return err;
> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson=
-se.h
> index 07afa0c25..8237ccab7 100644
> --- a/include/linux/mfd/loongson-se.h
> +++ b/include/linux/mfd/loongson-se.h
> @@ -9,6 +9,7 @@
>  #define SE_SEND_CMD_REG_LEN            0x8
>  /* Controller command ID */
>  #define SE_CMD_START                   0x0
> +#define SE_CMD_STOP                    0x1
>  #define SE_CMD_SET_DMA                 0x3
>  #define SE_CMD_SET_ENGINE_CMDBUF       0x4
>
> --
> 2.47.2
>
