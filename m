Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DE23EFFC3
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785853826; cv=none; b=pWlA4zKykuwW10f+VQ3S3DD2QX6o3Z/R28duiipiNTU23UZa2kbvQP/CN9zV+0j2dyXjPLmViQO+rtU+HL5wc9yCWENzPluuQVoqrCVWvZEvt0ajTh9uL6jIj7Nv/47eTstcYR1m1Bning3P7sjNy27kS3ndT+gwpx8sEGffebQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785853826; c=relaxed/simple;
	bh=/worik6565MmGqxB83xHC4oGsL7LqUXQzALqNM6g5s0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kkNNWulTYN2lokcfxU1UuXwTVNYUXrqW5deBQLT2Igz7XUVfzGPbbex866c4LNLUXuPN3M0KAnHG+wy/8OYJDz/Q3sVBqpemxdVaZSmL62SSUYS24leJcqBXEDp9FP2IVlyrpTljSKL+cX3s6M0sLELsS4X1fDtdk42f78EMJgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dh3UmXMA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dh3UmXMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1948A1F00A3F
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785853803;
	bh=TN+O16PcjDT2/zjFc4V9cDVHBtAUzFJCqlHG51a8Lvo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dh3UmXMAhpMYfZE6RWWeqC+IqXicIzqAKczm7wsYxDuL8SZxNSvwecMYzZm/IEzaF
	 3khuLuwUwBIeKvJljnsR6HGQANmOyV5tXMMZxqzqDZxmuOq+F69wXvccaw4bTkt66S
	 YNme0nvfV8Vnk1iMcLdniEEuecgJMIo708dqGEiFIZiC6aq75atkZzY52gr0MzMmAr
	 uBIFSihTioKTkeMeJPa5kpSkI3wQ6Glqqi8nZ18pGijTm1h3sxHrJm25cwiLqNzl2Q
	 0UWwUxcUgImR7T2bQgrsNX+LX7pWNPvLv6zxxKtcsnALhORUjuUa73sZEn32N20szQ
	 HTsoMZHXqJBZA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a144c8eea2so421739a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 07:30:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqqTROF8/gB8LKzCGOiVM+A+M80RukCidSmp/bwyOtTpx1yDywALtz2ABzV08t1OPBa0yhgH6idK7MlWaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqKkorwf51iZLGpGDscDZjXC7F+ctk2dVVvGM/sK7ByIn9ysFu
	lU+hpg6EqB0n+3fQ4cKDnx2AMEXxQbRvb2txpBIusCTXCDMXuLj8RJ4L9aqAY1A9vlEAlAH0AX4
	fCoDpEnX4VMIJfCkWXvVHqyxbhWc2zV8=
X-Received: by 2002:a05:6402:21cf:b0:697:5140:a146 with SMTP id
 4fb4d7f45d1cf-6a0a7c60f80mr12328098a12.5.1785853801090; Tue, 04 Aug 2026
 07:30:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730082608.1929-1-zhaoqunqin@loongson.cn> <20260730082608.1929-3-zhaoqunqin@loongson.cn>
 <CAAhV-H4V6NWDcw1nVZzaXKJF_QS0sz5jTsrnwbq-xki2mJLVtQ@mail.gmail.com> <b284a9a5-6f71-46c7-80f1-ed15276330da@loongson.cn>
In-Reply-To: <b284a9a5-6f71-46c7-80f1-ed15276330da@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 4 Aug 2026 22:29:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H79JdBRmNpCKPEfHxMARr5zNVAnP3mJYOWo6zwBpF2q2Q@mail.gmail.com>
X-Gm-Features: AUfX_mwaemQ5Zfj5LQECc_lmJjGuSKKQLXSC8JsWrz0Hlk2yLKHvGjQrzbl3zAo
Message-ID: <CAAhV-H79JdBRmNpCKPEfHxMARr5zNVAnP3mJYOWo6zwBpF2q2Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 10:09=E2=80=AFAM Qunqin Zhao <zhaoqunqin@loongson.cn=
> wrote:
>
>
> =E5=9C=A8 2026/8/3 16:01, Huacai Chen =E5=86=99=E9=81=93:
> > Hi, Qunqin,
> >
> > On Thu, Jul 30, 2026 at 4:41=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongso=
n.cn> wrote:
> >> Address multiple historical driver issues discovered by the Sashiko
> >> Automation system within the loongson_se_probe() initialization flow
> >> and the driver's interrupt service routines [1].
> >>
> >> - Add an explicit bounds check in se_irq_handler() before accessing
> >>    the engines array to prevent out-of-bounds memory writes.
> >>
> >> - Switch from devm_kmalloc() to devm_kzalloc() and explicitly
> >>    initialize all engine completion structures in probe() to avoid a
> >>    kernel panic from complete() dereferencing a NULL wait head when a
> >>    spurious interrupt fires before child drivers call
> >>    loongson_se_init_engine().
> >>
> >> - Replace engine_init_lock with a broader cmd_lock mutex that
> >>    serializes all command submissions, and move the lock into
> >>    loongson_se_send_controller_cmd() and
> >>    loongson_se_send_engine_cmd() to cover the full register write +
> >>    poll + wait sequence.
> >>
> >> - Drop the spin_lock_irq from loongson_se_poll() so that interrupts
> >>    are not disabled for up to 10 ms during the poll.  Keep the
> >>    readl_relaxed_poll_timeout_atomic() busy-wait to avoid scheduling
> >>    latency for fast hardware completions.
> >>
> >> - Add reinit_completion() to loongson_se_send_controller_cmd() and
> >>    loongson_se_send_engine_cmd() before waiting to prevent stale
> >>    completions from falsely returning success after a signal
> >>    interruption.
> >>
> >> - Fix EPROBE_DEFER handling: propagate the error directly from
> >>    platform_irq_count() instead of overwriting it with ENODEV so that
> >>    probe deferral works when the interrupt provider is not yet ready.
> >>
> >> - Validate dmam_size from firmware against the minimum required size
> >>    to prevent command buffers from pointing outside the allocated
> >>    DMA region.
> >>
> >> - Return the error code from devm_request_irq() instead of silently
> >>    continuing to prevent an indefinite hang.
> >>
> >> - Disable hardware interrupts in the probe error path when
> >>    loongson_se_init() fails to prevent an unhandled interrupt storm.
> >>
> >> - Add a loongson_se_stop() cleanup handler registered with
> >>    devm_add_action_or_reset() to send SE_CMD_STOP to the controller
> >>    and mask all interrupts during device removal.  Using devres
> >>    ensures that child MFD devices are unbound before the controller
> >>    is stopped.  The STOP command uses a non-interruptible wait to
> >>    avoid leaving hardware running while DMA buffers are freed.
> >>
> >> - Zero-initialize the local controller command structure in
> >>    loongson_se_init() to prevent uninitialized stack memory from
> >>    being written to device registers.
> >>
> >> - Add the SE_CMD_STOP command definition.
> >>
> >> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/=
 [1]
> >> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine ch=
ip controller")
> >> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> >> ---
> >>   drivers/mfd/loongson-se.c       | 87 ++++++++++++++++++++++++++-----=
--
> >>   include/linux/mfd/loongson-se.h |  1 +
> >>   2 files changed, 69 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> >> index 7f552a8ee6..2c8afad1b0 100644
> >> --- a/drivers/mfd/loongson-se.c
> >> +++ b/drivers/mfd/loongson-se.c
> >> @@ -28,7 +28,7 @@ struct loongson_se {
> >>          void *dmam_base;
> >>          int dmam_size;
> >>
> >> -       struct mutex engine_init_lock;
> >> +       struct mutex cmd_lock;
> >>          struct loongson_se_engine engines[SE_ENGINE_MAX];
> >>   };
> >>
> >> @@ -42,8 +42,6 @@ static int loongson_se_poll(struct loongson_se *se, =
u32 int_bit)
> >>          u32 status;
> >>          int err;
> >>
> >> -       spin_lock_irq(&se->dev_lock);
> > You said you don't want to disable irq here, but I think the spinlock
> > is still needed. That means you should use spin_lock/spin_unlock to
> > replace spin_lock_irq/spin_unlock_irq.
> Since loongson_se_poll always executes in the thread context, is it
> better to use mutex_lock(
> mutex_lock(&se->cmd_lock)  outside of loongson_se_poll) for
> synchronization?
If all callers have used mutex_lock(&se->cmd_lock), then spinlock is
unnecessary.

> >
> >> -
> >>          /* Notify the controller that the engine needs to be started =
*/
> >>          writel(int_bit, se->base + SE_L2SINT_SET);
> >>
> >> @@ -52,8 +50,6 @@ static int loongson_se_poll(struct loongson_se *se, =
u32 int_bit)
> >>                                                  !(status & int_bit),
> >>                                                  1, LOONGSON_ENGINE_CM=
D_TIMEOUT_US);
> >>
> >> -       spin_unlock_irq(&se->dev_lock);
> >> -
> >>          return err;
> >>   }
> >>
> >> @@ -63,24 +59,40 @@ static int loongson_se_send_controller_cmd(struct =
loongson_se *se,
> >>          u32 *send_cmd =3D (u32 *)cmd;
> >>          int err, i;
> >>
> >> +       mutex_lock(&se->cmd_lock);
> >> +
> >> +       reinit_completion(&se->cmd_completion);
> >> +
> >>          for (i =3D 0; i < SE_SEND_CMD_REG_LEN; i++)
> >>                  writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * =
4);
> >>
> >>          err =3D loongson_se_poll(se, SE_INT_CONTROLLER);
> >>          if (err)
> >> -               return err;
> >> +               goto out;
> >> +
> >> +       err =3D wait_for_completion_interruptible(&se->cmd_completion)=
;
> >>
> >> -       return wait_for_completion_interruptible(&se->cmd_completion);
> >> +out:
> >> +       mutex_unlock(&se->cmd_lock);
> >> +       return err;
> >>   }
> >>
> >>   int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
> >>   {
> >> +       int err;
> >> +
> >> +       mutex_lock(&engine->se->cmd_lock);
> >> +
> >> +       reinit_completion(&engine->completion);
> >> +
> >>          /*
> >>           * After engine initialization, the controller already knows
> >>           * where to obtain engine commands from. Now all we need to
> >>           * do is notify the controller that the engine needs to be st=
arted.
> >>           */
> >> -       int err =3D loongson_se_poll(engine->se, BIT(engine->id));
> >> +       err =3D loongson_se_poll(engine->se, BIT(engine->id));
> >> +
> >> +       mutex_unlock(&engine->se->cmd_lock);
> >>
> >>          if (err)
> >>                  return err;
> >> @@ -97,7 +109,7 @@ struct loongson_se_engine *loongson_se_init_engine(=
struct device *dev, int id)
> >>
> >>          engine->se =3D se;
> >>          engine->id =3D id;
> >> -       init_completion(&engine->completion);
> >> +       reinit_completion(&engine->completion);
> > I'm not sure, but I think loongson_se_init_engine() is only called at
> > init, so we need init_completion here.
>
> To prevent an spurious interrupt from completing an uninitialized object,
> all objects have already been fully initialized with init_completion duri=
ng the probe stage.
In my opinion, if a function can be called multiple times, we need
reinit_completion(), if it is only called for probe, we need
init_completion(), and loongson_se_init_engine() looks like the later
case.

Huacai

>
> >
> > Huacai
> >
> >>          /* Divide DMA memory equally among all engines */
> >>          engine->buffer_size =3D se->dmam_size / SE_ENGINE_MAX;
> >> @@ -113,8 +125,6 @@ struct loongson_se_engine *loongson_se_init_engine=
(struct device *dev, int id)
> >>          engine->command =3D se->dmam_base + id * (2 * SE_ENGINE_CMD_S=
IZE);
> >>          engine->command_ret =3D engine->command + SE_ENGINE_CMD_SIZE;
> >>
> >> -       mutex_lock(&se->engine_init_lock);
> >> -
> >>          /* Tell the controller where to find engine command */
> >>          cmd.command_id =3D SE_CMD_SET_ENGINE_CMDBUF;
> >>          cmd.info[0] =3D id;
> >> @@ -124,8 +134,6 @@ struct loongson_se_engine *loongson_se_init_engine=
(struct device *dev, int id)
> >>          if (loongson_se_send_controller_cmd(se, &cmd))
> >>                  engine =3D NULL;
> >>
> >> -       mutex_unlock(&se->engine_init_lock);
> >> -
> >>          return engine;
> >>   }
> >>   EXPORT_SYMBOL_GPL(loongson_se_init_engine);
> >> @@ -155,7 +163,8 @@ static irqreturn_t se_irq_handler(int irq, void *d=
ev_id)
> >>          /* For engines */
> >>          while (int_status) {
> >>                  id =3D __ffs(int_status);
> >> -               complete(&se->engines[id].completion);
> >> +               if (id < SE_ENGINE_MAX)
> >> +                       complete(&se->engines[id].completion);
> >>                  int_status &=3D ~BIT(id);
> >>                  writel(BIT(id), se->base + SE_S2LINT_CL);
> >>          }
> >> @@ -167,7 +176,7 @@ static irqreturn_t se_irq_handler(int irq, void *d=
ev_id)
> >>
> >>   static int loongson_se_init(struct loongson_se *se, dma_addr_t addr,=
 int size)
> >>   {
> >> -       struct loongson_se_controller_cmd cmd;
> >> +       struct loongson_se_controller_cmd cmd =3D {0};
> >>          int err;
> >>
> >>          cmd.command_id =3D SE_CMD_START;
> >> @@ -188,6 +197,30 @@ static const struct mfd_cell engines[] =3D {
> >>          { .name =3D "tpm_loongson" },
> >>   };
> >>
> >> +static void loongson_se_stop(void *data)
> >> +{
> >> +       struct loongson_se *se =3D data;
> >> +       struct loongson_se_controller_cmd cmd =3D {0};
> >> +       u32 *send_cmd =3D (u32 *)&cmd;
> >> +       int i;
> >> +
> >> +       mutex_lock(&se->cmd_lock);
> >> +
> >> +       cmd.command_id =3D SE_CMD_STOP;
> >> +
> >> +       reinit_completion(&se->cmd_completion);
> >> +
> >> +       for (i =3D 0; i < SE_SEND_CMD_REG_LEN; i++)
> >> +               writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4=
);
> >> +
> >> +       if (!loongson_se_poll(se, SE_INT_CONTROLLER))
> >> +               wait_for_completion(&se->cmd_completion);
> >> +
> >> +       writel(0, se->base + SE_S2LINT_EN);
> >> +
> >> +       mutex_unlock(&se->cmd_lock);
> >> +}
> >> +
> >>   static int loongson_se_probe(struct platform_device *pdev)
> >>   {
> >>          struct device *dev =3D &pdev->dev;
> >> @@ -195,19 +228,25 @@ static int loongson_se_probe(struct platform_dev=
ice *pdev)
> >>          int nr_irq, irq, err, i;
> >>          dma_addr_t paddr;
> >>
> >> -       se =3D devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
> >> +       se =3D devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
> >>          if (!se)
> >>                  return -ENOMEM;
> >>
> >>          dev_set_drvdata(dev, se);
> >>          init_completion(&se->cmd_completion);
> >>          spin_lock_init(&se->dev_lock);
> >> -       mutex_init(&se->engine_init_lock);
> >> +       mutex_init(&se->cmd_lock);
> >> +
> >> +       for (i =3D 0; i < SE_ENGINE_MAX; i++)
> >> +               init_completion(&se->engines[i].completion);
> Thanks
>
