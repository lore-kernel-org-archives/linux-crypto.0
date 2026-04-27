Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7703043C9
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 10:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777284125; cv=none; b=YYxLHjnhrJc/UipzLtLttYNX9bmqP5TTdbYVLAfqEMTjlrKmvrrqyDuvUy3fpE0+lXsXwg5zlM7MiUrcVTKdQpgGPapom8H9unC1I7ofwZgFMPBYmkPzMmEqY9960bTQx8rVt2YarLvUIzWhxiucQPQKBS9uYZmk0bLIZbu9KoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777284125; c=relaxed/simple;
	bh=OdOCIqAL9B52XtUj9SuFxp9CkA/uvVVcMKqPDROTwzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ri6togAzgHotE9kBMbPIySgpsozCHYRRdC4p5PCPu0ZUVC73DYfvwTXDNd9QANGlvElB5Ua81t35xfD4cQJcwBeKP8XYPQ4ScQCWO2xKD+VI6bVe552bCoZzmpS/zLr8/m+AJz2o0gSXT/FqstPxruIOGxT/p4DrXhc8vfA8zUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyA7n5B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyA7n5B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75117C19425
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777284125;
	bh=OdOCIqAL9B52XtUj9SuFxp9CkA/uvVVcMKqPDROTwzE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GyA7n5B5atHuEw68Ew5ilUBhV8v8U7tZiUWSsLLb+LHiNZ+Y7V89BWKOGUFPu5CT1
	 Hi/iYps/GwhnrnrlA+cgjjQC2jBKVE/9Ly2R78sM3Hzk31q3EokpIsY8qmhtX3RVxi
	 IVZJRo2J0Agd6GIjFT4+jXq02ljqOCZDpYPNelD6ezYELX/ckxQ8O7M8S2eyGiYvIo
	 Rlz4BN03mWOlan6RF8toVA0Diz5X5Qihl5qISgGJJYNakII2nKyZDr3eLHCeuWEBTa
	 VyiZXRFJaSUMOYClahUUtCNE4QNDTni2YKGLc1IQEA2v6pW6/8BlGK5v2KC4XNnkRq
	 ocW2rCXg835Wg==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67929ff6dbfso1748515a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 03:02:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/qMCTtVMyz+bTMfFbekAfHOZVeLAP1IJWc8RoJ4M2B3d4+AZ8lu8+h1mx0FompYlgdr0KHu53l6nIbmF4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1LMmbgVgnc+bm51v7Kdjx/SdF9V8wIysRyDIzJbCP4+/UQ1qu
	6t48bjtyZD09gkpjwZgOqMTbYjWQ0Os6+5fQNIVWDGSJ3kBQBv3Rifdh6GP0zNJutsvxG5kuSRX
	ZcMZGHFFg2LVlwiCqynBQO2sNum17LYs=
X-Received: by 2002:a17:906:f583:b0:bac:8445:78df with SMTP id
 a640c23a62f3a-bac84457c1emr933524866b.2.1777284123850; Mon, 27 Apr 2026
 03:02:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
 <CAAhV-H7cYTW+6aHHtA9c77XMOhnUrAC_rW25s9d6+xED2oGyAw@mail.gmail.com>
 <586ee1d1-c1c4-06fe-992f-c8e43cd9c778@loongson.cn> <CAAhV-H7nbnLcYs=74pub6SXXrRRv-xPWTXN78wxaRPyGodUaxg@mail.gmail.com>
 <9fd34867-9b1d-e097-f800-875efc6c44bd@loongson.cn>
In-Reply-To: <9fd34867-9b1d-e097-f800-875efc6c44bd@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 27 Apr 2026 18:02:18 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7SYoN49ZoFi+4V=qyctdzJG0hD=WUBBozewkQzKYia5w@mail.gmail.com>
X-Gm-Features: AVHnY4L6tmaCLvZ4OJISfl3Sc4qYxNurMkske6xszaYjGwPCK5KxwVlptr4iMu8
Message-ID: <CAAhV-H7SYoN49ZoFi+4V=qyctdzJG0hD=WUBBozewkQzKYia5w@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: loongson-se: Add multi-node support
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 5:52=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongson.cn=
> wrote:
>
>
> =E5=9C=A8 2026/4/27 =E4=B8=8B=E5=8D=885:37, Huacai Chen =E5=86=99=E9=81=
=93:
> > On Mon, Apr 27, 2026 at 5:24=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongso=
n.cn> wrote:
> >>
> >> =E5=9C=A8 2026/4/27 =E4=B8=8B=E5=8D=885:02, Huacai Chen =E5=86=99=E9=
=81=93:
> >>> Hi, Qunqin,
> >>>
> >>> On Mon, Apr 27, 2026 at 4:55=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loong=
son.cn> wrote:
> >>>> On the Loongson platform, each node is equipped with a security engi=
ne
> >>>> device. However, due to a hardware flaw, only the device on node 0 c=
an
> >>>> trigger interrupts. Therefore, interrupts from other nodes are forwa=
rded
> >>>> by node 0. We need to check in the interrupt handler of node 0 wheth=
er
> >>>> this interrupt is intended for other nodes.
> >>> Multi-node or multi-package? In my opinion SE has no relationship wit=
h
> >>> NUMA node, so maybe package?
> >> Here is the output of lscpu from my machine:
> >>
> >> [loongson@localhost ~]$ lscpu
> >> Architecture:          loongarch64
> >>     CPU op-mode(s):      32-bit, 64-bit
> >>     Address sizes:       48 bits physical, 48 bits virtual
> >>     Byte Order:          Little Endian
> >> CPU(s):                128
> >>     On-line CPU(s) list: 0-127
> >> Model name:            Loongson-3C6000/D
> >>     CPU family:          Loongson-64bit
> >>     Model:               0x11
> >>     Thread(s) per core:  2
> >>     Core(s) per socket:  32
> >>     Socket(s):           2
> >>     BogoMIPS:            4200.00
> >>     Flags:               cpucfg lam ual fpu lsx lasx crc32 complex cry=
pto
> >> lvz lbt_x86 lbt_arm lbt_mips
> >> Caches (sum of all):
> >>     L1d:                 4 MiB (64 instances)
> >>     L1i:                 4 MiB (64 instances)
> >>     L2:                  16 MiB (64 instances)
> >>     L3:                  128 MiB (4 instances)
> >> NUMA:
> >>     NUMA node(s):        4
> >>     NUMA node0 CPU(s):   0-31
> >>     NUMA node1 CPU(s):   32-63
> >>     NUMA node2 CPU(s):   64-95
> >>     NUMA node3 CPU(s):   96-127
> >>
> >> There are four SE devices in my system, one for each NUMA node.
> > For Loongson-3C6000 node is the same as package. You should consider
> > Loongson-3C5000L, one package contains four nodes.
>
> I am not familiar with the SE-related components on the 3C5000L, and
> this driver is not compatible with the 5000 series.
Whether it is compatible to Loongson-3C5000L is not important. The
importance is package is not always equal to node, and we should
consider whether SE is per-node or per-package.

Huacai

>
> Qunqin,
>
> Thanks.
>
> >
> > Huacai
> >
> >> Qunqin,
> >>
> >> Thanks
> >>
> >>> Huacai
> >>>
> >>>> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> >>>> ---
> >>>> Changes in v2:
> >>>>           -Resending due to no feedback for one month.
> >>>>           -Rebased on top of latest mainline (7.1-rc1) to ensure the=
 patch
> >>>>            applies cleanly.
> >>>>           -No functional changes since the previous submission.
> >>>>
> >>>> Link to v1:
> >>>> https://lore.kernel.org/all/20260226102225.19516-1-zhaoqunqin@loongs=
on.cn/#t
> >>>>
> >>>>    drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++-=
-----
> >>>>    include/linux/mfd/loongson-se.h |  3 +++
> >>>>    2 files changed, 35 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> >>>> index 3902ba377d6..40e18c21268 100644
> >>>> --- a/drivers/mfd/loongson-se.c
> >>>> +++ b/drivers/mfd/loongson-se.c
> >>>> @@ -37,6 +37,9 @@ struct loongson_se_controller_cmd {
> >>>>           u32 info[7];
> >>>>    };
> >>>>
> >>>> +static DECLARE_COMPLETION(node0);
> >>>> +static struct loongson_se *se_node[SE_MAX_NODES];
> >>>> +
> >>>>    static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
> >>>>    {
> >>>>           u32 status;
> >>>> @@ -133,8 +136,8 @@ EXPORT_SYMBOL_GPL(loongson_se_init_engine);
> >>>>    static irqreturn_t se_irq_handler(int irq, void *dev_id)
> >>>>    {
> >>>>           struct loongson_se *se =3D dev_id;
> >>>> -       u32 int_status;
> >>>> -       int id;
> >>>> +       u32 int_status, node_irq =3D 0;
> >>>> +       int id, node;
> >>>>
> >>>>           spin_lock(&se->dev_lock);
> >>>>
> >>>> @@ -147,6 +150,11 @@ static irqreturn_t se_irq_handler(int irq, void=
 *dev_id)
> >>>>                   writel(SE_INT_CONTROLLER, se->base + SE_S2LINT_CL)=
;
> >>>>           }
> >>>>
> >>>> +       if (int_status & SE_INT_OTHER_NODE) {
> >>>> +               int_status &=3D ~SE_INT_OTHER_NODE;
> >>>> +               node_irq =3D 1;
> >>>> +       }
> >>>> +
> >>>>           /* For engines */
> >>>>           while (int_status) {
> >>>>                   id =3D __ffs(int_status);
> >>>> @@ -157,6 +165,14 @@ static irqreturn_t se_irq_handler(int irq, void=
 *dev_id)
> >>>>
> >>>>           spin_unlock(&se->dev_lock);
> >>>>
> >>>> +       if (node_irq) {
> >>>> +               writel(SE_INT_OTHER_NODE, se->base + SE_S2LINT_CL);
> >>>> +               for (node =3D 1; node < SE_MAX_NODES; node++) {
> >>>> +                       if (se_node[node])
> >>>> +                               se_irq_handler(irq, se_node[node]);
> >>>> +               }
> >>>> +       }
> >>>> +
> >>>>           return IRQ_HANDLED;
> >>>>    }
> >>>>
> >>>> @@ -189,6 +205,7 @@ static int loongson_se_probe(struct platform_dev=
ice *pdev)
> >>>>           struct loongson_se *se;
> >>>>           int nr_irq, irq, err, i;
> >>>>           dma_addr_t paddr;
> >>>> +       int node =3D dev_to_node(dev);
> >>>>
> >>>>           se =3D devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
> >>>>           if (!se)
> >>>> @@ -213,9 +230,16 @@ static int loongson_se_probe(struct platform_de=
vice *pdev)
> >>>>
> >>>>           writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
> >>>>
> >>>> -       nr_irq =3D platform_irq_count(pdev);
> >>>> -       if (nr_irq <=3D 0)
> >>>> -               return -ENODEV;
> >>>> +       if (node =3D=3D 0 || node =3D=3D NUMA_NO_NODE) {
> >>>> +               nr_irq =3D platform_irq_count(pdev);
> >>>> +               if (nr_irq <=3D 0)
> >>>> +                       return -ENODEV;
> >>>> +       } else {
> >>>> +               /* Only the device on node 0 can trigger interrupts =
*/
> >>>> +               nr_irq =3D 0;
> >>>> +               wait_for_completion_interruptible(&node0);
> >>>> +               se_node[node] =3D se;
> >>>> +       }
> >>>>
> >>>>           for (i =3D 0; i < nr_irq; i++) {
> >>>>                   irq =3D platform_get_irq(pdev, i);
> >>>> @@ -228,7 +252,9 @@ static int loongson_se_probe(struct platform_dev=
ice *pdev)
> >>>>           if (err)
> >>>>                   return err;
> >>>>
> >>>> -       return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engine=
s,
> >>>> +       complete_all(&node0);
> >>>> +
> >>>> +       return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engine=
s,
> >>>>                                       ARRAY_SIZE(engines), NULL, 0, =
NULL);
> >>>>    }
> >>>>
> >>>> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loo=
ngson-se.h
> >>>> index 07afa0c2524..a80e06eb017 100644
> >>>> --- a/include/linux/mfd/loongson-se.h
> >>>> +++ b/include/linux/mfd/loongson-se.h
> >>>> @@ -20,6 +20,9 @@
> >>>>
> >>>>    #define SE_INT_ALL                     0xffffffff
> >>>>    #define SE_INT_CONTROLLER              BIT(0)
> >>>> +#define SE_INT_OTHER_NODE              BIT(31)
> >>>> +
> >>>> +#define SE_MAX_NODES                   8
> >>>>
> >>>>    #define SE_ENGINE_MAX                  16
> >>>>    #define SE_ENGINE_RNG                  1
> >>>>
> >>>> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> >>>> --
> >>>> 2.47.2
> >>>>
> >>>>
> >>
>
