Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7610D3AEF3E
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280538; cv=none; b=mmEQukFWwRDlA8PIkpqZcgbFCCeisRAUGu1C0+YkJMnWR1gNP8RMCi9cqrW+46rhRbN7WoPEx0oXjdnZermn8d9xa0uL7Evl0gyDCEZjp3hyOz7X0w3kgpaHSn4OYF++Y98gfrDnrUtFjDu3wZrfKqnEkZZvggiwrnRLd4v4Sqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280538; c=relaxed/simple;
	bh=syd5jmAK0dbXIr/H1nDlRPXvR1U8hPWgf/tfmtcGroM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hdhzixgu5+LY8PKHX+lEGVEjXvFWGPIyb6wsCnVeDoX6VjmAYyrtO5XrzoGIp610jv2y3FeUefkrOyQCdV8M5z124gUrE6ltTbz+TYNVwRTIm4uqf/fYvyhdqMeL03znWl470v7uWM4uY2t/oBX6CzOOTAdXqSdImlftTtpasek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HbBqrkk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HbBqrkk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D67DC2BCB6
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280538;
	bh=syd5jmAK0dbXIr/H1nDlRPXvR1U8hPWgf/tfmtcGroM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HbBqrkk879Zxj+OazU/8OhcZk9srb4RW8qob89iZgw47pqV2vBIveB8vcdLQjJ+wW
	 FRtGYj2MOtCpQMA/Ng6scCmAz/YvzRTbmxBNg0xlOJjfCIyfc0Dl8MqdxWVkyAIPtD
	 MaHS2eAJACF9TGLoPVVZb2gCPVaEJ5eeY+3zVv3KjFMK59P2GrgIi38T67zMZWjEFo
	 dSO23RgTylX0XYH1u7Kbc1gm3S7o85zTwawRRew+6hJiYUZSuOuUxfy3DlL++Kr/48
	 PwoYmZ3uNDuUCmQJ116kKCkiT0gYqNE6SKkiQ/IHKTK6qzn2M7RtKUJFjT1AA+DyJN
	 5ONt9op/EFHgA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ba3115fe0d5so1779072466b.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:02:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/BspEp2j+U1hIldujIpPSELQuvx8CTwMie5acGxLLS+jAhalctliBFchpe6wi/jemtUwFnT0Zcfwi0Kgg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeIa+B0jbZsKlG1NlJu2fU6hO7peJqyW/FjFSQVO40YivwUKkR
	uUGdvF8nf90Zpu9lUffJVcUZQFOvUONr4CT/soAKNMsFN0GXx5xAn8es0qG7Jv7aBamOSjW6ifi
	Wd0Nh+ICJV/SaWOGFYgJF22Kbx9UbFKw=
X-Received: by 2002:a17:906:fe45:b0:bad:820:65b4 with SMTP id
 a640c23a62f3a-bad08207055mr639367866b.16.1777280536538; Mon, 27 Apr 2026
 02:02:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
In-Reply-To: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 27 Apr 2026 17:02:31 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7cYTW+6aHHtA9c77XMOhnUrAC_rW25s9d6+xED2oGyAw@mail.gmail.com>
X-Gm-Features: AVHnY4L_x6emsDaLOCLXhiPKDGUHtTueTuOOYBaDk6uowWVQ64l7pbp9QsUedYA
Message-ID: <CAAhV-H7cYTW+6aHHtA9c77XMOhnUrAC_rW25s9d6+xED2oGyAw@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: loongson-se: Add multi-node support
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Qunqin,

On Mon, Apr 27, 2026 at 4:55=E2=80=AFPM Qunqin Zhao <zhaoqunqin@loongson.cn=
> wrote:
>
> On the Loongson platform, each node is equipped with a security engine
> device. However, due to a hardware flaw, only the device on node 0 can
> trigger interrupts. Therefore, interrupts from other nodes are forwarded
> by node 0. We need to check in the interrupt handler of node 0 whether
> this interrupt is intended for other nodes.
Multi-node or multi-package? In my opinion SE has no relationship with
NUMA node, so maybe package?

Huacai

>
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> ---
> Changes in v2:
>         -Resending due to no feedback for one month.
>         -Rebased on top of latest mainline (7.1-rc1) to ensure the patch
>          applies cleanly.
>         -No functional changes since the previous submission.
>
> Link to v1:
> https://lore.kernel.org/all/20260226102225.19516-1-zhaoqunqin@loongson.cn=
/#t
>
>  drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++------
>  include/linux/mfd/loongson-se.h |  3 +++
>  2 files changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 3902ba377d6..40e18c21268 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -37,6 +37,9 @@ struct loongson_se_controller_cmd {
>         u32 info[7];
>  };
>
> +static DECLARE_COMPLETION(node0);
> +static struct loongson_se *se_node[SE_MAX_NODES];
> +
>  static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>  {
>         u32 status;
> @@ -133,8 +136,8 @@ EXPORT_SYMBOL_GPL(loongson_se_init_engine);
>  static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  {
>         struct loongson_se *se =3D dev_id;
> -       u32 int_status;
> -       int id;
> +       u32 int_status, node_irq =3D 0;
> +       int id, node;
>
>         spin_lock(&se->dev_lock);
>
> @@ -147,6 +150,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev=
_id)
>                 writel(SE_INT_CONTROLLER, se->base + SE_S2LINT_CL);
>         }
>
> +       if (int_status & SE_INT_OTHER_NODE) {
> +               int_status &=3D ~SE_INT_OTHER_NODE;
> +               node_irq =3D 1;
> +       }
> +
>         /* For engines */
>         while (int_status) {
>                 id =3D __ffs(int_status);
> @@ -157,6 +165,14 @@ static irqreturn_t se_irq_handler(int irq, void *dev=
_id)
>
>         spin_unlock(&se->dev_lock);
>
> +       if (node_irq) {
> +               writel(SE_INT_OTHER_NODE, se->base + SE_S2LINT_CL);
> +               for (node =3D 1; node < SE_MAX_NODES; node++) {
> +                       if (se_node[node])
> +                               se_irq_handler(irq, se_node[node]);
> +               }
> +       }
> +
>         return IRQ_HANDLED;
>  }
>
> @@ -189,6 +205,7 @@ static int loongson_se_probe(struct platform_device *=
pdev)
>         struct loongson_se *se;
>         int nr_irq, irq, err, i;
>         dma_addr_t paddr;
> +       int node =3D dev_to_node(dev);
>
>         se =3D devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
>         if (!se)
> @@ -213,9 +230,16 @@ static int loongson_se_probe(struct platform_device =
*pdev)
>
>         writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
>
> -       nr_irq =3D platform_irq_count(pdev);
> -       if (nr_irq <=3D 0)
> -               return -ENODEV;
> +       if (node =3D=3D 0 || node =3D=3D NUMA_NO_NODE) {
> +               nr_irq =3D platform_irq_count(pdev);
> +               if (nr_irq <=3D 0)
> +                       return -ENODEV;
> +       } else {
> +               /* Only the device on node 0 can trigger interrupts */
> +               nr_irq =3D 0;
> +               wait_for_completion_interruptible(&node0);
> +               se_node[node] =3D se;
> +       }
>
>         for (i =3D 0; i < nr_irq; i++) {
>                 irq =3D platform_get_irq(pdev, i);
> @@ -228,7 +252,9 @@ static int loongson_se_probe(struct platform_device *=
pdev)
>         if (err)
>                 return err;
>
> -       return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
> +       complete_all(&node0);
> +
> +       return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
>                                     ARRAY_SIZE(engines), NULL, 0, NULL);
>  }
>
> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson=
-se.h
> index 07afa0c2524..a80e06eb017 100644
> --- a/include/linux/mfd/loongson-se.h
> +++ b/include/linux/mfd/loongson-se.h
> @@ -20,6 +20,9 @@
>
>  #define SE_INT_ALL                     0xffffffff
>  #define SE_INT_CONTROLLER              BIT(0)
> +#define SE_INT_OTHER_NODE              BIT(31)
> +
> +#define SE_MAX_NODES                   8
>
>  #define SE_ENGINE_MAX                  16
>  #define SE_ENGINE_RNG                  1
>
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> --
> 2.47.2
>
>
