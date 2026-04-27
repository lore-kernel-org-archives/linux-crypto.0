Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F71439023D
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777282642; cv=none; b=d68k4QQ5Y4LP9r5YzavxHxG/zpI0G6cuoqyDPyorXeuUOHuyR0IkYvnkT20nnX7EmTJbhOEIzBplBX5k9RaYKGpgcoqh6sRhZ1mbFQ3zTwfuQI33bXdrGX53r/h2AQRgUxgnHLV+L/zrIh4BcyehBVm06NjgaVgCevU3GYDdrpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777282642; c=relaxed/simple;
	bh=NhdaM94EkZZFuNYKkzBbvUu9GrtGRITXFQiXArHpqQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tXcWmoT6ND7TstLnV5JrxeyiFsneJBt+W6YB/qKKmOAZ/2w0gH/nEnlopPLekinJjkn20GaOKkoCa3sYm+BTxPRkveGiLIkjYgSaPaveJEu8m3GDWiQcei0oumjVhOgeNMAa1QamxVfvvXUolQVVUgLHtIPCklNgQHTgaE5IyUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=biShBBIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="biShBBIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E585DC2BCB4
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777282641;
	bh=NhdaM94EkZZFuNYKkzBbvUu9GrtGRITXFQiXArHpqQM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=biShBBImCUi2SPOH6+x1yR0fZj0aRFMDaIPwbdmVahq3NAKV10D9G27cRTABNXCKa
	 U1OyVL7ZIn2ze5c2e1flelf9PiKAfjKkdHu2byMzWK4AvmFyPHh1OYvShym/KS3uga
	 BlD3hx+7YvBzPk4okmL7lfiBREWMlzKMs9MytGmzPD5Ga/aYI0osj86HHY506LHmVP
	 gj5qnoc2N4A0XfDkfzXhB6SDSjCbCZTUm5Yt1dfJoQdJ8R5LPz3caI1gWmvPIzNViO
	 JHG42fwXiaK6kSW2lFrpj7NAfKFOnB4dFBJITjv8XuoZb3CElf/Rx+qIOpu9yGV6gt
	 xU48zr61vHwKA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-676fec7e946so7380238a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:37:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ82UXGQY/HLLK01iW0eCFTip+/sYHD9CchDDttP0mLOFZz+8tGwZ5iqb5Rk9Rl+B7yOpWjx2XVl34L+a9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWE2Ee9ixiChSCtGFCbTDHqjRsCT4/L1kiZPVRLhmGsx1x4Vba
	b6g2srNLr6ImhOqwU7/fInxwPpBTd7D62Km6GWRjdyC/hBmjrIamxQMNJ9okqiY/wBSdieLbryo
	cFhqdlNlwBMKu8f+R05Pd+1zJRgAnZTg=
X-Received: by 2002:a17:906:4fc6:b0:bab:f5c7:23ca with SMTP id
 a640c23a62f3a-babf5c7241amr917545166b.38.1777282640280; Mon, 27 Apr 2026
 02:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
 <CAAhV-H7cYTW+6aHHtA9c77XMOhnUrAC_rW25s9d6+xED2oGyAw@mail.gmail.com> <586ee1d1-c1c4-06fe-992f-c8e43cd9c778@loongson.cn>
In-Reply-To: <586ee1d1-c1c4-06fe-992f-c8e43cd9c778@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 27 Apr 2026 17:37:34 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7nbnLcYs=74pub6SXXrRRv-xPWTXN78wxaRPyGodUaxg@mail.gmail.com>
X-Gm-Features: AVHnY4JCkq7-VKUNT_A-cOZQ6W3fFU3I9a4XtOC2yf2sroba3K8YTJ3jAbv4bkg
Message-ID: <CAAhV-H7nbnLcYs=74pub6SXXrRRv-xPWTXN78wxaRPyGodUaxg@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: loongson-se: Add multi-node support
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 5:24=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongson.cn=
> wrote:
>
>
> =E5=9C=A8 2026/4/27 =E4=B8=8B=E5=8D=885:02, Huacai Chen =E5=86=99=E9=81=
=93:
> > Hi, Qunqin,
> >
> > On Mon, Apr 27, 2026 at 4:55=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongso=
n.cn> wrote:
> >> On the Loongson platform, each node is equipped with a security engine
> >> device. However, due to a hardware flaw, only the device on node 0 can
> >> trigger interrupts. Therefore, interrupts from other nodes are forward=
ed
> >> by node 0. We need to check in the interrupt handler of node 0 whether
> >> this interrupt is intended for other nodes.
> > Multi-node or multi-package? In my opinion SE has no relationship with
> > NUMA node, so maybe package?
>
> Here is the output of lscpu from my machine:
>
> [loongson@localhost ~]$ lscpu
> Architecture:          loongarch64
>    CPU op-mode(s):      32-bit, 64-bit
>    Address sizes:       48 bits physical, 48 bits virtual
>    Byte Order:          Little Endian
> CPU(s):                128
>    On-line CPU(s) list: 0-127
> Model name:            Loongson-3C6000/D
>    CPU family:          Loongson-64bit
>    Model:               0x11
>    Thread(s) per core:  2
>    Core(s) per socket:  32
>    Socket(s):           2
>    BogoMIPS:            4200.00
>    Flags:               cpucfg lam ual fpu lsx lasx crc32 complex crypto
> lvz lbt_x86 lbt_arm lbt_mips
> Caches (sum of all):
>    L1d:                 4 MiB (64 instances)
>    L1i:                 4 MiB (64 instances)
>    L2:                  16 MiB (64 instances)
>    L3:                  128 MiB (4 instances)
> NUMA:
>    NUMA node(s):        4
>    NUMA node0 CPU(s):   0-31
>    NUMA node1 CPU(s):   32-63
>    NUMA node2 CPU(s):   64-95
>    NUMA node3 CPU(s):   96-127
>
> There are four SE devices in my system, one for each NUMA node.
For Loongson-3C6000 node is the same as package. You should consider
Loongson-3C5000L, one package contains four nodes.

Huacai

>
> Qunqin,
>
> Thanks
>
> >
> > Huacai
> >
> >> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> >> ---
> >> Changes in v2:
> >>          -Resending due to no feedback for one month.
> >>          -Rebased on top of latest mainline (7.1-rc1) to ensure the pa=
tch
> >>           applies cleanly.
> >>          -No functional changes since the previous submission.
> >>
> >> Link to v1:
> >> https://lore.kernel.org/all/20260226102225.19516-1-zhaoqunqin@loongson=
.cn/#t
> >>
> >>   drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++----=
--
> >>   include/linux/mfd/loongson-se.h |  3 +++
> >>   2 files changed, 35 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> >> index 3902ba377d6..40e18c21268 100644
> >> --- a/drivers/mfd/loongson-se.c
> >> +++ b/drivers/mfd/loongson-se.c
> >> @@ -37,6 +37,9 @@ struct loongson_se_controller_cmd {
> >>          u32 info[7];
> >>   };
> >>
> >> +static DECLARE_COMPLETION(node0);
> >> +static struct loongson_se *se_node[SE_MAX_NODES];
> >> +
> >>   static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
> >>   {
> >>          u32 status;
> >> @@ -133,8 +136,8 @@ EXPORT_SYMBOL_GPL(loongson_se_init_engine);
> >>   static irqreturn_t se_irq_handler(int irq, void *dev_id)
> >>   {
> >>          struct loongson_se *se =3D dev_id;
> >> -       u32 int_status;
> >> -       int id;
> >> +       u32 int_status, node_irq =3D 0;
> >> +       int id, node;
> >>
> >>          spin_lock(&se->dev_lock);
> >>
> >> @@ -147,6 +150,11 @@ static irqreturn_t se_irq_handler(int irq, void *=
dev_id)
> >>                  writel(SE_INT_CONTROLLER, se->base + SE_S2LINT_CL);
> >>          }
> >>
> >> +       if (int_status & SE_INT_OTHER_NODE) {
> >> +               int_status &=3D ~SE_INT_OTHER_NODE;
> >> +               node_irq =3D 1;
> >> +       }
> >> +
> >>          /* For engines */
> >>          while (int_status) {
> >>                  id =3D __ffs(int_status);
> >> @@ -157,6 +165,14 @@ static irqreturn_t se_irq_handler(int irq, void *=
dev_id)
> >>
> >>          spin_unlock(&se->dev_lock);
> >>
> >> +       if (node_irq) {
> >> +               writel(SE_INT_OTHER_NODE, se->base + SE_S2LINT_CL);
> >> +               for (node =3D 1; node < SE_MAX_NODES; node++) {
> >> +                       if (se_node[node])
> >> +                               se_irq_handler(irq, se_node[node]);
> >> +               }
> >> +       }
> >> +
> >>          return IRQ_HANDLED;
> >>   }
> >>
> >> @@ -189,6 +205,7 @@ static int loongson_se_probe(struct platform_devic=
e *pdev)
> >>          struct loongson_se *se;
> >>          int nr_irq, irq, err, i;
> >>          dma_addr_t paddr;
> >> +       int node =3D dev_to_node(dev);
> >>
> >>          se =3D devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
> >>          if (!se)
> >> @@ -213,9 +230,16 @@ static int loongson_se_probe(struct platform_devi=
ce *pdev)
> >>
> >>          writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
> >>
> >> -       nr_irq =3D platform_irq_count(pdev);
> >> -       if (nr_irq <=3D 0)
> >> -               return -ENODEV;
> >> +       if (node =3D=3D 0 || node =3D=3D NUMA_NO_NODE) {
> >> +               nr_irq =3D platform_irq_count(pdev);
> >> +               if (nr_irq <=3D 0)
> >> +                       return -ENODEV;
> >> +       } else {
> >> +               /* Only the device on node 0 can trigger interrupts */
> >> +               nr_irq =3D 0;
> >> +               wait_for_completion_interruptible(&node0);
> >> +               se_node[node] =3D se;
> >> +       }
> >>
> >>          for (i =3D 0; i < nr_irq; i++) {
> >>                  irq =3D platform_get_irq(pdev, i);
> >> @@ -228,7 +252,9 @@ static int loongson_se_probe(struct platform_devic=
e *pdev)
> >>          if (err)
> >>                  return err;
> >>
> >> -       return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
> >> +       complete_all(&node0);
> >> +
> >> +       return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
> >>                                      ARRAY_SIZE(engines), NULL, 0, NUL=
L);
> >>   }
> >>
> >> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loong=
son-se.h
> >> index 07afa0c2524..a80e06eb017 100644
> >> --- a/include/linux/mfd/loongson-se.h
> >> +++ b/include/linux/mfd/loongson-se.h
> >> @@ -20,6 +20,9 @@
> >>
> >>   #define SE_INT_ALL                     0xffffffff
> >>   #define SE_INT_CONTROLLER              BIT(0)
> >> +#define SE_INT_OTHER_NODE              BIT(31)
> >> +
> >> +#define SE_MAX_NODES                   8
> >>
> >>   #define SE_ENGINE_MAX                  16
> >>   #define SE_ENGINE_RNG                  1
> >>
> >> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> >> --
> >> 2.47.2
> >>
> >>
>
>
