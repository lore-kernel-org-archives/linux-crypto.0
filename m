Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C3130566F
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 12:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789821189; cv=none; b=htgw8eUMokTPPueYI4+XoGYj/iU+cfM3ZMUYIBxqxF0jMGv5bKvJah3s4R/yNjAXSlSYFQv5iDFgBD9Uy2eVUSOK7+mSoAN34gDcQvui3IMly23jX4JQRMBo3XzAccVlSTwJAMXmcXAqqPAQRbglPLjatXCxe6ixSoLM969yRcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789821189; c=relaxed/simple;
	bh=7jVdOIwnSf+42QEHYNgqOexHDxam0d/y2ep6AAKO81Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cxvLuUnQRC7AE6PkrZLY/w3jwrHIvpg2B3jMI/ZrjdkU2DWMccBvmUBSxwRIssyHTNv7yW4LPMdV8luNCzbxHoKhCu3Y72h8xIROEYHdbQ1dNnhxwhBEHsfu0Dgls2PkkT89JlDdqm4UKBNWxnFmZ/a4opMt12viRJJ0Lq62+HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XPj2g7Ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XPj2g7Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905031F00899
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789821187;
	bh=S+slOutsptpQKxCXzYRDJtxLUn/ORsrVG8i3SLOQcUI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XPj2g7Ap69b9CvDt6meAlapmal5kWSBAFtDSCsQoS8PJUfbf65/W4S6v7rEzE743q
	 gbpl+tEs72qzLRJlf/AnGjZNCtOrFuYFQAcG8OdFw0tkovoEdCoNLA7YgtK7t7j8op
	 46wC9gHYsGUDNZBiRsa3OXPujCnPO3WDQrMVaZdULHYcBNjmyuKu8r5Uhup1ezeKrV
	 hkoYUBZ6ZPKdOf80pVYK1f1Q47UHtet2ZMVgp7T13N+js+80fH0KdeBGcq5tdST7lb
	 dI+bHqAfjTPGkmfSB0tj333HXHzL2dqs49TbSSrHr6+/ncKb9GXNTojfOBECGRn81S
	 4EeDMwY/2W1Xw==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a98505364aso2662631a12.3
        for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 05:33:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw+jJuxnG057vL9V8OzsMkeSkXlJJSj/Xt+AdcD0QYL1ajJdYhgpK1TXKYTu9nuRRIi9sqcX28FZRYM8t8=@vger.kernel.org
X-Gm-Message-State: AFuF++mr9bJb0H/yLFktFnfzUgMzzV3eQRQj90aZTpv4dA8Td+NiJf5G
	yuNw+395QL6h+/2Bm2n0FdQSTUbEq7tfvnhyHgAOME66++2cUXo9F5Itx33YjaKT6LvBZMA8wXW
	+tiSRzngqSVthfKeiY+dQUbb2Z5A3kdY=
X-Received: by 2002:a05:6402:510d:b0:6a9:b519:eb3f with SMTP id
 4fb4d7f45d1cf-6aa53cb3d0bmr3772826a12.29.1789821186189; Sat, 19 Sep 2026
 05:33:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911090256.7834-1-zhaoqunqin@163.com> <20260911090256.7834-3-zhaoqunqin@163.com>
 <CAAhV-H4VEtZJAoYBz24=ab37fdpLL_kSS92vxMn61Rcq0C33aQ@mail.gmail.com> <4ca28c4a-1a4d-4f12-b9c0-10f092e93a66@loongson.cn>
In-Reply-To: <4ca28c4a-1a4d-4f12-b9c0-10f092e93a66@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 19 Sep 2026 20:32:56 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6w6Tu5sbcGC5CezXH8SJ=d4t_F2x1cDjQKab6bxVx_VA@mail.gmail.com>
X-Gm-Features: AcwNN1VJc4kZAJPyaHmDmXfXvbD4BMMqTHRkLwCismJ6vJ-oTJbCRLkVZ1aUsCo
Message-ID: <CAAhV-H6w6Tu5sbcGC5CezXH8SJ=d4t_F2x1cDjQKab6bxVx_VA@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] mfd: loongson-se: Fix miscellaneous issues
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: Qunqin Zhao <zhaoqunqin@163.com>, lee@kernel.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-crypto@vger.kernel.org, mfd@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 4:22=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongson.cn=
> wrote:
>
>
> =E5=9C=A8 2026/9/14 15:36, Huacai Chen =E5=86=99=E9=81=93:
> > Hi, Qunqin,
> >
> > On Fri, Sep 11, 2026 at 5:03=E2=80=AFPM Qunqin Zhao <zhaoqunqin@163.com=
> wrote:
> >> From: Qunqin Zhao <zhaoqunqin@loongson.cn>
> >>
> >> Address multiple historical driver issues discovered by the Sashiko
> >> Automation system within the loongson_se_probe() initialization flow
> >> and the driver's interrupt service routines [1].
> >>
> >> - Add an explicit bounds check in se_irq_handler() before accessing
> >>   the engines array to prevent an out-of-bounds memory access.
> >>
> >> - Validate the id argument in loongson_se_init_engine() and reject
> >>   engine 0, whose data buffer is reused for the command buffers of all
> >>   other engines, to prevent out-of-bounds accesses and overlapping DMA
> >>   buffers.
> >>
> >> - Switch from devm_kmalloc() to devm_kzalloc() and initialize all
> >>   engine completion structures in probe(), dropping the redundant
> >>   init_completion() in loongson_se_init_engine().
> >>
> >> - Introduce loongson_se_reinit_completion() to mask the target
> >>   interrupt, clear any pending status, and reset the completion under
> >>   dev_lock before a command is issued, then re-enable the interrupt
> >>   under the same lock after the command has been triggered.  This
> >>   closes the race where a stale interrupt from a previously
> >>   interrupted command could complete the current command's completion.
> >>   A new poll_lock serializes the trigger and poll busy-wait so
> >>   interrupts are not disabled for up to 10 ms.
> > The locking of this driver is more and more complicated, I doubt
> > whether AI's review is really correct here. For me, the existing
> > locking code is just fine and simple.
>
> I'm not sure  whether disabling interrupts for 10 ms will cause kernel da=
mage.
>
> Or keep the current lock and fix it if we actually run into problems?
I think we can do it like this.

Huacai

>
> After all, this extreme case will not occur. In practical tests, polling
>
> averages only a few microseconds, with the worst case under 1 ms.
>
> Thanks.
>
> >
> > Huacai
> >
> >> - Wait for controller command completion with a bounded
> >>   non-interruptible wait so a pending signal cannot leave the
> >>   controller running while its DMA buffers are being torn down, and a
> >>   wedged controller cannot hang the kernel indefinitely.
> >>
> >> - Fix EPROBE_DEFER handling: propagate the error directly from
> >>   platform_irq_count() instead of overwriting it with ENODEV so that
> >>   probe deferral works when the interrupt provider is not yet ready.
> >>
> >> - Validate dmam_size from firmware against the minimum required size
> >>   to keep the command buffers of all engines within engine 0's data
> >>   region and prevent overlapping DMA buffers.
> >>
> >> - Return the error code from devm_request_irq() instead of silently
> >>   continuing to prevent an indefinite hang.
> >>
> >> - Add a loongson_se_stop() cleanup handler registered with
> >>   devm_add_action_or_reset() before loongson_se_init() so that a
> >>   failed init still stops the controller and masks all interrupts via
> >>   devres, preventing DMA access to freed memory.
> >>
> >> - Zero-initialize the local controller command structures in
> >>   loongson_se_init() and loongson_se_init_engine() to prevent
> >>   uninitialized stack data from being written to device registers.
> >>
> >> - Add the SE_CMD_STOP command definition.
> >>
> >> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/=
 [1]
> >> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine ch=
ip controller")
> >> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> >> ---
> >>  drivers/mfd/loongson-se.c       | 112 ++++++++++++++++++++++++++++---=
-
> >>  include/linux/mfd/loongson-se.h |   1 +
> >>  2 files changed, 102 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> >> index 7f552a8ee..18075d4fa 100644
> >> --- a/drivers/mfd/loongson-se.c
> >> +++ b/drivers/mfd/loongson-se.c
> >> @@ -23,6 +23,8 @@
> >>  struct loongson_se {
> >>         void __iomem *base;
> >>         spinlock_t dev_lock;
> >> +       /* Synchronizes command submission between users of different =
engines */
> >> +       spinlock_t poll_lock;
> >>         struct completion cmd_completion;
> >>
> >>         void *dmam_base;
> >> @@ -42,7 +44,7 @@ static int loongson_se_poll(struct loongson_se *se, =
u32 int_bit)
> >>         u32 status;
> >>         int err;
> >>
> >> -       spin_lock_irq(&se->dev_lock);
> >> +       spin_lock(&se->poll_lock);
> >>
> >>         /* Notify the controller that the engine needs to be started *=
/
> >>         writel(int_bit, se->base + SE_L2SINT_SET);
> >> @@ -52,17 +54,51 @@ static int loongson_se_poll(struct loongson_se *se=
, u32 int_bit)
> >>                                                 !(status & int_bit),
> >>                                                 1, LOONGSON_ENGINE_CMD=
_TIMEOUT_US);
> >>
> >> +       spin_unlock(&se->poll_lock);
> >> +
> >> +       spin_lock_irq(&se->dev_lock);
> >> +       /*
> >> +        * Re-enable the interrupt that loongson_se_reinit_completion(=
) masked.
> >> +        * The hardware guarantees that once the interrupt is re-enabl=
ed, only
> >> +        * interrupts for the command just issued can arrive, so a sta=
le
> >> +        * interrupt from a previously interrupted command can never c=
omplete
> >> +        * this command's completion.
> >> +        */
> >> +       writel(int_bit | readl(se->base + SE_S2LINT_EN), se->base + SE=
_S2LINT_EN);
> >> +
> >>         spin_unlock_irq(&se->dev_lock);
> >>
> >>         return err;
> >>  }
> >>
>
>
