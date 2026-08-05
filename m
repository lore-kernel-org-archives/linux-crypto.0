Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929E9472557
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785937257; cv=none; b=PUMRcqeLvenXY+1o7VjzSZvAcxfvBsfu+jx91P4WK+qzfSgH/Xakuu+1Vi6kpR+LyY+l9ORGg0izTadA0Z5Zl7PvDB16vBUzOP+stZHOIqWDGBZpLlFg0QXQfLaUuVtUEmQpmaG1kczeBF12Lt+wv/kKht3ucAqRjWHJeYWsyAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785937257; c=relaxed/simple;
	bh=QEljO1I158O5rRgqB81L1M6+WWgDpYQPAaOD2d3dg1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mzVSOboIbdAeze2tKik2qcnltvmfVjK1zcSFLLDGrxlYfLUjRT3qisriEatCHLK2gVa9b0ddC7LzWA/GYHPNBRWNFf55Hyx6eomOC8JX2AbKLVavnaNp7qJK3vEDqc9SYNEBstKgbM+FtyL0EBSWeOBRL0FhfgKitNY5OmBHMNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDobYiv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDobYiv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DCE1F000E9
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785937255;
	bh=w8NGKFLAyWuaO56r8nUaQw6Z3QZlPWFtmAq84YHz0Xg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eDobYiv50LAXRadWTiKRfmlQSgbJ0hUEU6X+8ud+G1yd5oUjY1z5JWSI/RgARKEB5
	 fJE2JCEUeELA9i4gLXwimErncybIXMaNSQS5hsskGiSnFSAByIK0pV5ikPHUi+ZfrA
	 eqExRzMFiX1ThJp+WGPwpVaaaKtX1gViuy/dvt/QWpHVecCKjtIpGI1TUyEVp4hC2g
	 0w9gtS7DQhBuV7/xlvg5X0CId4jsQJP18SgAOI6fq5JehZbSBLDrPaT/1uIiD5ZjQi
	 nnM1guPbdFENDUlciXOPTP3XxLTw8SZ0Z+xvIcWQhR0i+5fKQwIToMuYASCeSoNGVR
	 8Nete9GPYuZXg==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso1501177a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 Aug 2026 06:40:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoGZCIMulccA+1rrVihwyP46v90kVd+xhHMr6gL9ozY1fkC3/CEldCqakh4yM6AskVkNex683sw1cbF7v4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTSSO8cJ1vv/q2iIAPbXYjRaSWG4guKtahsrDO0SXqwk0u3Osu
	3uD83jQcfFKQNt77+iy8CsvLyBL/ARMHVUcGAgS7HW1+g5CZDQwHs7Nq9EmIs9m4ZCQ++xBdQ1T
	iMKFgpLQbXbUiKdDubgnwn5vMRXafvVI=
X-Received: by 2002:a05:6402:e93:b0:69a:928:9405 with SMTP id
 4fb4d7f45d1cf-6a14f09ff2cmr3648158a12.1.1785937253855; Wed, 05 Aug 2026
 06:40:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730082608.1929-1-zhaoqunqin@loongson.cn> <20260730082608.1929-3-zhaoqunqin@loongson.cn>
 <CAAhV-H4V6NWDcw1nVZzaXKJF_QS0sz5jTsrnwbq-xki2mJLVtQ@mail.gmail.com>
 <b284a9a5-6f71-46c7-80f1-ed15276330da@loongson.cn> <CAAhV-H79JdBRmNpCKPEfHxMARr5zNVAnP3mJYOWo6zwBpF2q2Q@mail.gmail.com>
In-Reply-To: <CAAhV-H79JdBRmNpCKPEfHxMARr5zNVAnP3mJYOWo6zwBpF2q2Q@mail.gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 5 Aug 2026 21:40:44 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7xAOK4m2D-x23gOgYnxhn4pteb0x5rfd7GtT=YHOXgfQ@mail.gmail.com>
X-Gm-Features: AUfX_mwikE-JmkZve0HP1lElJDxXTLgPv1QPqldQIirjZE46OXYHBjDNsScDyuY
Message-ID: <CAAhV-H7xAOK4m2D-x23gOgYnxhn4pteb0x5rfd7GtT=YHOXgfQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 10:29=E2=80=AFPM Huacai Chen <chenhuacai@kernel.org>=
 wrote:
>
> On Tue, Aug 4, 2026 at 10:09=E2=80=AFAM Qunqin Zhao <zhaoqunqin@loongson.=
cn> wrote:
> >
> >
> > =E5=9C=A8 2026/8/3 16:01, Huacai Chen =E5=86=99=E9=81=93:
> > > Hi, Qunqin,
> > >
> > > On Thu, Jul 30, 2026 at 4:41=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loong=
son.cn> wrote:
> > >> Address multiple historical driver issues discovered by the Sashiko
> > >> Automation system within the loongson_se_probe() initialization flow
> > >> and the driver's interrupt service routines [1].
> > >>
> > >> - Add an explicit bounds check in se_irq_handler() before accessing
> > >>    the engines array to prevent out-of-bounds memory writes.
> > >>
> > >> - Switch from devm_kmalloc() to devm_kzalloc() and explicitly
> > >>    initialize all engine completion structures in probe() to avoid a
> > >>    kernel panic from complete() dereferencing a NULL wait head when =
a
> > >>    spurious interrupt fires before child drivers call
> > >>    loongson_se_init_engine().
> > >>
> > >> - Replace engine_init_lock with a broader cmd_lock mutex that
> > >>    serializes all command submissions, and move the lock into
> > >>    loongson_se_send_controller_cmd() and
> > >>    loongson_se_send_engine_cmd() to cover the full register write +
> > >>    poll + wait sequence.
> > >>
> > >> - Drop the spin_lock_irq from loongson_se_poll() so that interrupts
> > >>    are not disabled for up to 10 ms during the poll.  Keep the
> > >>    readl_relaxed_poll_timeout_atomic() busy-wait to avoid scheduling
> > >>    latency for fast hardware completions.
> > >>
> > >> - Add reinit_completion() to loongson_se_send_controller_cmd() and
> > >>    loongson_se_send_engine_cmd() before waiting to prevent stale
> > >>    completions from falsely returning success after a signal
> > >>    interruption.
> > >>
> > >> - Fix EPROBE_DEFER handling: propagate the error directly from
> > >>    platform_irq_count() instead of overwriting it with ENODEV so tha=
t
> > >>    probe deferral works when the interrupt provider is not yet ready=
.
> > >>
> > >> - Validate dmam_size from firmware against the minimum required size
> > >>    to prevent command buffers from pointing outside the allocated
> > >>    DMA region.
> > >>
> > >> - Return the error code from devm_request_irq() instead of silently
> > >>    continuing to prevent an indefinite hang.
> > >>
> > >> - Disable hardware interrupts in the probe error path when
> > >>    loongson_se_init() fails to prevent an unhandled interrupt storm.
> > >>
> > >> - Add a loongson_se_stop() cleanup handler registered with
> > >>    devm_add_action_or_reset() to send SE_CMD_STOP to the controller
> > >>    and mask all interrupts during device removal.  Using devres
> > >>    ensures that child MFD devices are unbound before the controller
> > >>    is stopped.  The STOP command uses a non-interruptible wait to
> > >>    avoid leaving hardware running while DMA buffers are freed.
> > >>
> > >> - Zero-initialize the local controller command structure in
> > >>    loongson_se_init() to prevent uninitialized stack memory from
> > >>    being written to device registers.
> > >>
> > >> - Add the SE_CMD_STOP command definition.
> > >>
> > >> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.co=
m/ [1]
> > >> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine =
chip controller")
> > >> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> > >> ---
> > >>   drivers/mfd/loongson-se.c       | 87 ++++++++++++++++++++++++++---=
----
> > >>   include/linux/mfd/loongson-se.h |  1 +
> > >>   2 files changed, 69 insertions(+), 19 deletions(-)
> > >>
> > >> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> > >> index 7f552a8ee6..2c8afad1b0 100644
> > >> --- a/drivers/mfd/loongson-se.c
> > >> +++ b/drivers/mfd/loongson-se.c
> > >> @@ -28,7 +28,7 @@ struct loongson_se {
> > >>          void *dmam_base;
> > >>          int dmam_size;
> > >>
> > >> -       struct mutex engine_init_lock;
> > >> +       struct mutex cmd_lock;
> > >>          struct loongson_se_engine engines[SE_ENGINE_MAX];
> > >>   };
> > >>
> > >> @@ -42,8 +42,6 @@ static int loongson_se_poll(struct loongson_se *se=
, u32 int_bit)
> > >>          u32 status;
> > >>          int err;
> > >>
> > >> -       spin_lock_irq(&se->dev_lock);
> > > You said you don't want to disable irq here, but I think the spinlock
> > > is still needed. That means you should use spin_lock/spin_unlock to
> > > replace spin_lock_irq/spin_unlock_irq.
> > Since loongson_se_poll always executes in the thread context, is it
> > better to use mutex_lock(
> > mutex_lock(&se->cmd_lock)  outside of loongson_se_poll) for
> > synchronization?
> If all callers have used mutex_lock(&se->cmd_lock), then spinlock is
> unnecessary.
After some thinking, maybe the AI suggestion is wrong, we shouldn't
use mutex to replace spinlock here.

Yes, loongson_se_poll() is executed in process context, but there
isn't a rule "don't use spinlock in process context".

The real rules are:
1. Keep critical sections as short as possible.
2. Don't use sleepable functions in spinlock critical sections.

writel() and readl_relaxed_poll_timeout_atomic() are not sleepable
functions, so spinlock is just fine.


Huacai

>
> > >
> > >> -
> > >>          /* Notify the controller that the engine needs to be starte=
d */
> > >>          writel(int_bit, se->base + SE_L2SINT_SET);
> > >>
> > >> @@ -52,8 +50,6 @@ static int loongson_se_poll(struct loongson_se *se=
, u32 int_bit)
> > >>                                                  !(status & int_bit)=
,
> > >>                                                  1, LOONGSON_ENGINE_=
CMD_TIMEOUT_US);
> > >>
> > >> -       spin_unlock_irq(&se->dev_lock);
> > >> -
> > >>          return err;
> > >>   }
> > >>
> > >> @@ -63,24 +59,40 @@ static int loongson_se_send_controller_cmd(struc=
t loongson_se *se,
> > >>          u32 *send_cmd =3D (u32 *)cmd;
> > >>          int err, i;
> > >>
> > >> +       mutex_lock(&se->cmd_lock);
> > >> +
> > >> +       reinit_completion(&se->cmd_completion);
> > >> +
> > >>          for (i =3D 0; i < SE_SEND_CMD_REG_LEN; i++)
> > >>                  writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i =
* 4);
> > >>
> > >>          err =3D loongson_se_poll(se, SE_INT_CONTROLLER);
> > >>          if (err)
> > >> -               return err;
> > >> +               goto out;
> > >> +
> > >> +       err =3D wait_for_completion_interruptible(&se->cmd_completio=
n);
> > >>
> > >> -       return wait_for_completion_interruptible(&se->cmd_completion=
);
> > >> +out:
> > >> +       mutex_unlock(&se->cmd_lock);
> > >> +       return err;
> > >>   }
> > >>
> > >>   int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
> > >>   {
> > >> +       int err;
> > >> +
> > >> +       mutex_lock(&engine->se->cmd_lock);
> > >> +
> > >> +       reinit_completion(&engine->completion);
> > >> +
> > >>          /*
> > >>           * After engine initialization, the controller already know=
s
> > >>           * where to obtain engine commands from. Now all we need to
> > >>           * do is notify the controller that the engine needs to be =
started.
> > >>           */
> > >> -       int err =3D loongson_se_poll(engine->se, BIT(engine->id));
> > >> +       err =3D loongson_se_poll(engine->se, BIT(engine->id));
> > >> +
> > >> +       mutex_unlock(&engine->se->cmd_lock);
> > >>
> > >>          if (err)
> > >>                  return err;
> > >> @@ -97,7 +109,7 @@ struct loongson_se_engine *loongson_se_init_engin=
e(struct device *dev, int id)
> > >>
> > >>          engine->se =3D se;
> > >>          engine->id =3D id;
> > >> -       init_completion(&engine->completion);
> > >> +       reinit_completion(&engine->completion);
> > > I'm not sure, but I think loongson_se_init_engine() is only called at
> > > init, so we need init_completion here.
> >
> > To prevent an spurious interrupt from completing an uninitialized objec=
t,
> > all objects have already been fully initialized with init_completion du=
ring the probe stage.
> In my opinion, if a function can be called multiple times, we need
> reinit_completion(), if it is only called for probe, we need
> init_completion(), and loongson_se_init_engine() looks like the later
> case.
>
> Huacai
>
> >
> > >
> > > Huacai
> > >
> > >>          /* Divide DMA memory equally among all engines */
> > >>          engine->buffer_size =3D se->dmam_size / SE_ENGINE_MAX;
> > >> @@ -113,8 +125,6 @@ struct loongson_se_engine *loongson_se_init_engi=
ne(struct device *dev, int id)
> > >>          engine->command =3D se->dmam_base + id * (2 * SE_ENGINE_CMD=
_SIZE);
> > >>          engine->command_ret =3D engine->command + SE_ENGINE_CMD_SIZ=
E;
> > >>
> > >> -       mutex_lock(&se->engine_init_lock);
> > >> -
> > >>          /* Tell the controller where to find engine command */
> > >>          cmd.command_id =3D SE_CMD_SET_ENGINE_CMDBUF;
> > >>          cmd.info[0] =3D id;
> > >> @@ -124,8 +134,6 @@ struct loongson_se_engine *loongson_se_init_engi=
ne(struct device *dev, int id)
> > >>          if (loongson_se_send_controller_cmd(se, &cmd))
> > >>                  engine =3D NULL;
> > >>
> > >> -       mutex_unlock(&se->engine_init_lock);
> > >> -
> > >>          return engine;
> > >>   }
> > >>   EXPORT_SYMBOL_GPL(loongson_se_init_engine);
> > >> @@ -155,7 +163,8 @@ static irqreturn_t se_irq_handler(int irq, void =
*dev_id)
> > >>          /* For engines */
> > >>          while (int_status) {
> > >>                  id =3D __ffs(int_status);
> > >> -               complete(&se->engines[id].completion);
> > >> +               if (id < SE_ENGINE_MAX)
> > >> +                       complete(&se->engines[id].completion);
> > >>                  int_status &=3D ~BIT(id);
> > >>                  writel(BIT(id), se->base + SE_S2LINT_CL);
> > >>          }
> > >> @@ -167,7 +176,7 @@ static irqreturn_t se_irq_handler(int irq, void =
*dev_id)
> > >>
> > >>   static int loongson_se_init(struct loongson_se *se, dma_addr_t add=
r, int size)
> > >>   {
> > >> -       struct loongson_se_controller_cmd cmd;
> > >> +       struct loongson_se_controller_cmd cmd =3D {0};
> > >>          int err;
> > >>
> > >>          cmd.command_id =3D SE_CMD_START;
> > >> @@ -188,6 +197,30 @@ static const struct mfd_cell engines[] =3D {
> > >>          { .name =3D "tpm_loongson" },
> > >>   };
> > >>
> > >> +static void loongson_se_stop(void *data)
> > >> +{
> > >> +       struct loongson_se *se =3D data;
> > >> +       struct loongson_se_controller_cmd cmd =3D {0};
> > >> +       u32 *send_cmd =3D (u32 *)&cmd;
> > >> +       int i;
> > >> +
> > >> +       mutex_lock(&se->cmd_lock);
> > >> +
> > >> +       cmd.command_id =3D SE_CMD_STOP;
> > >> +
> > >> +       reinit_completion(&se->cmd_completion);
> > >> +
> > >> +       for (i =3D 0; i < SE_SEND_CMD_REG_LEN; i++)
> > >> +               writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i *=
 4);
> > >> +
> > >> +       if (!loongson_se_poll(se, SE_INT_CONTROLLER))
> > >> +               wait_for_completion(&se->cmd_completion);
> > >> +
> > >> +       writel(0, se->base + SE_S2LINT_EN);
> > >> +
> > >> +       mutex_unlock(&se->cmd_lock);
> > >> +}
> > >> +
> > >>   static int loongson_se_probe(struct platform_device *pdev)
> > >>   {
> > >>          struct device *dev =3D &pdev->dev;
> > >> @@ -195,19 +228,25 @@ static int loongson_se_probe(struct platform_d=
evice *pdev)
> > >>          int nr_irq, irq, err, i;
> > >>          dma_addr_t paddr;
> > >>
> > >> -       se =3D devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
> > >> +       se =3D devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
> > >>          if (!se)
> > >>                  return -ENOMEM;
> > >>
> > >>          dev_set_drvdata(dev, se);
> > >>          init_completion(&se->cmd_completion);
> > >>          spin_lock_init(&se->dev_lock);
> > >> -       mutex_init(&se->engine_init_lock);
> > >> +       mutex_init(&se->cmd_lock);
> > >> +
> > >> +       for (i =3D 0; i < SE_ENGINE_MAX; i++)
> > >> +               init_completion(&se->engines[i].completion);
> > Thanks
> >
