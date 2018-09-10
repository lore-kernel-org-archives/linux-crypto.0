From: Li Yang <leoyang.li@nxp.com>
Subject: Re: [PATCH 04/11] soc: fsl: dpio: add congestion notification support
Date: Mon, 10 Sep 2018 15:11:48 -0500
Message-ID: <CADRPPNQ=sw-3=LO5SmUnhQnixNUUDgTz6oCweORtbyahNLizUg@mail.gmail.com>
References: <20180910171550.5659-1-horia.geanta@nxp.com> <20180910171550.5659-5-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        David Miller <davem@davemloft.net>, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
To: Horia Geanta <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910171550.5659-5-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 10, 2018 at 12:19 PM Horia Geantă <horia.geanta@nxp.com> wrote:
>
> Add support for Congestion State Change Notifications (CSCN), which
> allow DPIO users to be notified when a congestion group changes its
> state (due to hitting the entrance / exit threshold).
>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  include/soc/fsl/dpaa2-global.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/include/soc/fsl/dpaa2-global.h b/include/soc/fsl/dpaa2-global.h
> index 9bc0713346a8..2bfc379d3dc9 100644
> --- a/include/soc/fsl/dpaa2-global.h
> +++ b/include/soc/fsl/dpaa2-global.h
> @@ -174,4 +174,19 @@ static inline const struct dpaa2_fd *dpaa2_dq_fd(const struct dpaa2_dq *dq)
>         return (const struct dpaa2_fd *)&dq->dq.fd[0];
>  }
>
> +#define DPAA2_CSCN_SIZE                sizeof(struct dpaa2_dq)
> +#define DPAA2_CSCN_ALIGN       16
> +#define DPAA2_CSCN_STATE_CG    BIT(0)
> +
> +/**
> + * dpaa2_cscn_state_congested() - Check congestion state
> + * @cscn: congestion SCN (delivered to WQ or memory)
> + *
> +i * Return true is congested.
> + */
> +static inline bool dpaa2_cscn_state_congested(struct dpaa2_dq *cscn)
> +{
> +       return !!(cscn->scn.state & DPAA2_CSCN_STATE_CG);
> +}
> +
>  #endif /* __FSL_DPAA2_GLOBAL_H */
> --
> 2.16.2
>
