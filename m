From: Li Yang <leoyang.li@nxp.com>
Subject: Re: [PATCH v2 03/12] soc: fsl: dpio: add frame list format support
Date: Fri, 14 Sep 2018 18:26:48 -0500
Message-ID: <CADRPPNQYPZGPo0y7pv3CFFJH6Kn4rL42w8YgH-d3pMrU=Q0FFQ@mail.gmail.com>
References: <20180912085937.22489-1-horia.geanta@nxp.com> <20180912085937.22489-4-horia.geanta@nxp.com>
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
In-Reply-To: <20180912085937.22489-4-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 12, 2018 at 4:02 AM Horia Geantă <horia.geanta@nxp.com> wrote:
>
> Add support for dpaa2_fd_list format, i.e. dpaa2_fl_entry structure
> and accessors.
>
> Frame list entries (FLEs) are similar, but not identical to FDs:
> + "F" (final) bit
> - FMT[b'01] is reserved
> - DD, SC, DROPP bits (covered by "FD compatibility" field in FLE case)
> - FLC[5:0] not used for stashing
>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Acked-by: Li Yang <leoyang.li@nxp.com>

> ---
>  include/soc/fsl/dpaa2-fd.h | 242 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 242 insertions(+)
>
