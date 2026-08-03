Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD13ACA6C
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 08:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785744069; cv=none; b=X6hpUoH9NxwC8WtEZQI1q48nO7O0EORTiTZJdOweywSaXrfV27ARguGCKCnt68iiWCQIeO09yxFeWQUEH/gIMrX9KgOsw1hZ9fFtCWDf/+ARJriB9p66E4D8RuV5IarRIeBFCICgLii40K1ksaEuwHK+nODJvko4rOm0c6VyH70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785744069; c=relaxed/simple;
	bh=h5sg9DZwCkSNHbPIGJMwafaq4oq3yh479kR5y7of5GY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DvmkL8PaKU1qfTqfZAouFksXAMFlnN5nzdCyoOjzXUBnKZ8dRHrZflqhkoGMAm+GpawJxMj7eYyhHHg71MT/b+AiCvdv6ZGTdWAAjj3ywDJtFalxp0kPitM6G/MaazQziwUHETWx1ylmcC3FkGKflkhAw+876+CaIjztYmwMAcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOCvKnCx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOCvKnCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803811F00A3A
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785744067;
	bh=xV4Rx+36FglM5iHb2ywHipygTwiMFY5frV0+5rahrio=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JOCvKnCxtyhav1tc8aqFB7Wzl5RXZY1PqGegHra9Cnm/iluR+ceoVPRzEoYZXIggu
	 6KCHc0l45AOVT3w0Z5YJcFoEoBCIk81xaXSVmf8lRmpgqyiVExmOYASqYz334gPHHT
	 SxuL4WJXSQdyUTVhTNar/j1T2vv3kSdR9cKLHA7A7dR7L0pFCdfOzMNS0JxG+68FnU
	 wj8jfha9dFs3kmGG8MgPIgXaRj9dcZdw6cKz5nQdH0LxaUGOU7HqGIPEvCGI2iacj/
	 VpOSzSg4WGfUBGpTn1av7ChJ3vIzxrHfmg+5r+yarQYYQFB2g1zPpHaLfa8y7iFoVE
	 WfsuUgPCElVCw==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a0cb6e96dcso1950935a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2026 01:01:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpg44KbtLmDCCEhDpJnLRJfel2MFfbuFlXprfXA3M3dkKxFBIw8OWOm9b/kfsEtz//JXblnNzqt4BfLikk=@vger.kernel.org
X-Gm-Message-State: AOJu0YybETTwPx9ru9l/2DqG/2sDRJodcHuTraDbDYc1RC2e0NXGeU5q
	RBtxsFwPwV/Oz+G1jgZHFwALFECtCoIWFSqHtYIiwB8BgoIHuhzpAYBF5sC/MB2JtAxtifaBE5e
	5j7mpTYj1sS6NZpPXTJ75WkyM305EGtA=
X-Received: by 2002:a05:6402:5046:b0:699:fbe4:16d4 with SMTP id
 4fb4d7f45d1cf-6a0a7cb31e1mr6349306a12.18.1785744065921; Mon, 03 Aug 2026
 01:01:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730082608.1929-1-zhaoqunqin@loongson.cn> <20260730082608.1929-3-zhaoqunqin@loongson.cn>
In-Reply-To: <20260730082608.1929-3-zhaoqunqin@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 3 Aug 2026 16:01:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4V6NWDcw1nVZzaXKJF_QS0sz5jTsrnwbq-xki2mJLVtQ@mail.gmail.com>
X-Gm-Features: AUfX_mz0beBkinpveN76Fxyhrfx8V9PN3Mj2z0nrH4fWsnyXZf1ulyPC7ZymtK0
Message-ID: <CAAhV-H4V6NWDcw1nVZzaXKJF_QS0sz5jTsrnwbq-xki2mJLVtQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Qunqin,

On Thu, Jul 30, 2026 at 4:41=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongson.cn=
> wrote:
>
> Address multiple historical driver issues discovered by the Sashiko
> Automation system within the loongson_se_probe() initialization flow
> and the driver's interrupt service routines [1].
>
> - Add an explicit bounds check in se_irq_handler() before accessing
>   the engines array to prevent out-of-bounds memory writes.
>
> - Switch from devm_kmalloc() to devm_kzalloc() and explicitly
>   initialize all engine completion structures in probe() to avoid a
>   kernel panic from complete() dereferencing a NULL wait head when a
>   spurious interrupt fires before child drivers call
>   loongson_se_init_engine().
>
> - Replace engine_init_lock with a broader cmd_lock mutex that
>   serializes all command submissions, and move the lock into
>   loongson_se_send_controller_cmd() and
>   loongson_se_send_engine_cmd() to cover the full register write +
>   poll + wait sequence.
>
> - Drop the spin_lock_irq from loongson_se_poll() so that interrupts
>   are not disabled for up to 10 ms during the poll.  Keep the
>   readl_relaxed_poll_timeout_atomic() busy-wait to avoid scheduling
>   latency for fast hardware completions.
>
> - Add reinit_completion() to loongson_se_send_controller_cmd() and
>   loongson_se_send_engine_cmd() before waiting to prevent stale
>   completions from falsely returning success after a signal
>   interruption.
>
> - Fix EPROBE_DEFER handling: propagate the error directly from
>   platform_irq_count() instead of overwriting it with ENODEV so that
>   probe deferral works when the interrupt provider is not yet ready.
>
> - Validate dmam_size from firmware against the minimum required size
>   to prevent command buffers from pointing outside the allocated
>   DMA region.
>
> - Return the error code from devm_request_irq() instead of silently
>   continuing to prevent an indefinite hang.
>
> - Disable hardware interrupts in the probe error path when
>   loongson_se_init() fails to prevent an unhandled interrupt storm.
>
> - Add a loongson_se_stop() cleanup handler registered with
>   devm_add_action_or_reset() to send SE_CMD_STOP to the controller
>   and mask all interrupts during device removal.  Using devres
>   ensures that child MFD devices are unbound before the controller
>   is stopped.  The STOP command uses a non-interruptible wait to
>   avoid leaving hardware running while DMA buffers are freed.
>
> - Zero-initialize the local controller command structure in
>   loongson_se_init() to prevent uninitialized stack memory from
>   being written to device registers.
>
> - Add the SE_CMD_STOP command definition.
>
> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1=
]
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip =
controller")
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> ---
>  drivers/mfd/loongson-se.c       | 87 ++++++++++++++++++++++++++-------
>  include/linux/mfd/loongson-se.h |  1 +
>  2 files changed, 69 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 7f552a8ee6..2c8afad1b0 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -28,7 +28,7 @@ struct loongson_se {
>         void *dmam_base;
>         int dmam_size;
>
> -       struct mutex engine_init_lock;
> +       struct mutex cmd_lock;
>         struct loongson_se_engine engines[SE_ENGINE_MAX];
>  };
>
> @@ -42,8 +42,6 @@ static int loongson_se_poll(struct loongson_se *se, u32=
 int_bit)
>         u32 status;
>         int err;
>
> -       spin_lock_irq(&se->dev_lock);
You said you don't want to disable irq here, but I think the spinlock
is still needed. That means you should use spin_lock/spin_unlock to
replace spin_lock_irq/spin_unlock_irq.

> -
>         /* Notify the controller that the engine needs to be started */
>         writel(int_bit, se->base + SE_L2SINT_SET);
>
> @@ -52,8 +50,6 @@ static int loongson_se_poll(struct loongson_se *se, u32=
 int_bit)
>                                                 !(status & int_bit),
>                                                 1, LOONGSON_ENGINE_CMD_TI=
MEOUT_US);
>
> -       spin_unlock_irq(&se->dev_lock);
> -
>         return err;
>  }
>
> @@ -63,24 +59,40 @@ static int loongson_se_send_controller_cmd(struct loo=
ngson_se *se,
>         u32 *send_cmd =3D (u32 *)cmd;
>         int err, i;
>
> +       mutex_lock(&se->cmd_lock);
> +
> +       reinit_completion(&se->cmd_completion);
> +
>         for (i =3D 0; i < SE_SEND_CMD_REG_LEN; i++)
>                 writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
>
>         err =3D loongson_se_poll(se, SE_INT_CONTROLLER);
>         if (err)
> -               return err;
> +               goto out;
> +
> +       err =3D wait_for_completion_interruptible(&se->cmd_completion);
>
> -       return wait_for_completion_interruptible(&se->cmd_completion);
> +out:
> +       mutex_unlock(&se->cmd_lock);
> +       return err;
>  }
>
>  int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
>  {
> +       int err;
> +
> +       mutex_lock(&engine->se->cmd_lock);
> +
> +       reinit_completion(&engine->completion);
> +
>         /*
>          * After engine initialization, the controller already knows
>          * where to obtain engine commands from. Now all we need to
>          * do is notify the controller that the engine needs to be starte=
d.
>          */
> -       int err =3D loongson_se_poll(engine->se, BIT(engine->id));
> +       err =3D loongson_se_poll(engine->se, BIT(engine->id));
> +
> +       mutex_unlock(&engine->se->cmd_lock);
>
>         if (err)
>                 return err;
> @@ -97,7 +109,7 @@ struct loongson_se_engine *loongson_se_init_engine(str=
uct device *dev, int id)
>
>         engine->se =3D se;
>         engine->id =3D id;
> -       init_completion(&engine->completion);
> +       reinit_completion(&engine->completion);
I'm not sure, but I think loongson_se_init_engine() is only called at
init, so we need init_completion here.

Huacai

>
>         /* Divide DMA memory equally among all engines */
>         engine->buffer_size =3D se->dmam_size / SE_ENGINE_MAX;
> @@ -113,8 +125,6 @@ struct loongson_se_engine *loongson_se_init_engine(st=
ruct device *dev, int id)
>         engine->command =3D se->dmam_base + id * (2 * SE_ENGINE_CMD_SIZE)=
;
>         engine->command_ret =3D engine->command + SE_ENGINE_CMD_SIZE;
>
> -       mutex_lock(&se->engine_init_lock);
> -
>         /* Tell the controller where to find engine command */
>         cmd.command_id =3D SE_CMD_SET_ENGINE_CMDBUF;
>         cmd.info[0] =3D id;
> @@ -124,8 +134,6 @@ struct loongson_se_engine *loongson_se_init_engine(st=
ruct device *dev, int id)
>         if (loongson_se_send_controller_cmd(se, &cmd))
>                 engine =3D NULL;
>
> -       mutex_unlock(&se->engine_init_lock);
> -
>         return engine;
>  }
>  EXPORT_SYMBOL_GPL(loongson_se_init_engine);
> @@ -155,7 +163,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_=
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
> @@ -167,7 +176,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_=
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
> @@ -188,6 +197,30 @@ static const struct mfd_cell engines[] =3D {
>         { .name =3D "tpm_loongson" },
>  };
>
> +static void loongson_se_stop(void *data)
> +{
> +       struct loongson_se *se =3D data;
> +       struct loongson_se_controller_cmd cmd =3D {0};
> +       u32 *send_cmd =3D (u32 *)&cmd;
> +       int i;
> +
> +       mutex_lock(&se->cmd_lock);
> +
> +       cmd.command_id =3D SE_CMD_STOP;
> +
> +       reinit_completion(&se->cmd_completion);
> +
> +       for (i =3D 0; i < SE_SEND_CMD_REG_LEN; i++)
> +               writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
> +
> +       if (!loongson_se_poll(se, SE_INT_CONTROLLER))
> +               wait_for_completion(&se->cmd_completion);
> +
> +       writel(0, se->base + SE_S2LINT_EN);
> +
> +       mutex_unlock(&se->cmd_lock);
> +}
> +
>  static int loongson_se_probe(struct platform_device *pdev)
>  {
>         struct device *dev =3D &pdev->dev;
> @@ -195,19 +228,25 @@ static int loongson_se_probe(struct platform_device=
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
> -       mutex_init(&se->engine_init_lock);
> +       mutex_init(&se->cmd_lock);
> +
> +       for (i =3D 0; i < SE_ENGINE_MAX; i++)
> +               init_completion(&se->engines[i].completion);
>
>         dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
>         if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
>                 return -ENODEV;
>
> +       if (se->dmam_size < (SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE))
> +               return -EINVAL;
> +
>         se->dmam_base =3D dmam_alloc_coherent(dev, se->dmam_size, &paddr,=
 GFP_KERNEL);
>         if (!se->dmam_base)
>                 return -ENOMEM;
> @@ -217,21 +256,31 @@ static int loongson_se_probe(struct platform_device=
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
>         err =3D loongson_se_init(se, paddr, se->dmam_size);
> +       if (err) {
> +               writel(0, se->base + SE_S2LINT_EN);
> +               return err;
> +       }
> +
> +       err =3D devm_add_action_or_reset(dev, loongson_se_stop, se);
>         if (err)
>                 return err;
>
> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson=
-se.h
> index 07afa0c252..8237ccab7b 100644
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
> 2.47.3
>
