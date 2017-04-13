From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 2/2] hwrng: mtk: Add driver for hardware random generator
 on MT7623 SoC
Date: Thu, 13 Apr 2017 14:09:45 +0530
Message-ID: <CANc+2y4Oj-sbSKnsTSK+kRYNewp7Pj0fEk_=dqULxWG08L77Eg@mail.gmail.com>
References: <1492067108-14748-1-git-send-email-sean.wang@mediatek.com> <1492067108-14748-3-git-send-email-sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        shannon.nelson@oracle.com, Wei Yongjun <weiyongjun1@huawei.com>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
To: sean.wang@mediatek.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492067108-14748-3-git-send-email-sean.wang@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Sean,

Mostly looks good, have few minor comments.

On 13 April 2017 at 12:35,  <sean.wang@mediatek.com> wrote:
> +static bool mtk_rng_wait_ready(struct hwrng *rng, bool wait)
> +{
> +       struct mtk_rng *priv = to_mtk_rng(rng);
> +       int ready;
> +
> +       ready = readl(priv->base + RNG_CTRL) & RNG_READY;
> +       if (!ready && wait)
> +               readl_poll_timeout_atomic(priv->base + RNG_CTRL, ready,
> +                                         ready & RNG_READY, USEC_POLL,
> +                                         TIMEOUT_POLL);
> +       return !!ready;
> +}

Use readl_poll_timeout_atomic's return value or -EIO instead of
!!ready. This will simplify mtk_rng_read.

> +static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +       struct mtk_rng *priv = to_mtk_rng(rng);
> +       int retval = 0;
> +
> +       while (max >= sizeof(u32)) {
> +               if (!mtk_rng_wait_ready(rng, wait))
> +                       break;
> +
> +               *(u32 *)buf = readl(priv->base + RNG_DATA);
> +               retval += sizeof(u32);
> +               buf += sizeof(u32);
> +               max -= sizeof(u32);
> +       }
> +
> +       if (unlikely(wait && max))
> +               dev_warn(priv->dev, "timeout might be not properly set\n");

Is this really necessary? Better to choose proper timeout than
providing this warning message. In rare cases if the timeout could
occur due to some reason (may be a hardware fault) print appropriate
warning message.

> +       return retval || !wait ? retval : -EIO;
> +}

Set retavl to mtk_rng_wait_ready and return retval.

Regards,
Prasanna
