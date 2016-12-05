From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/2] Add crypto driver support for some MediaTek chips
Date: Mon, 5 Dec 2016 09:52:20 +0100
Message-ID: <20161205085220.GA333@Red>
References: <1480921284-45827-1-git-send-email-ryder.lee@mediatek.com>
 <1480921284-45827-2-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
 Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Roy Luo <cheng-hao.luo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480921284-45827-2-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello

I have two minor comment.

On Mon, Dec 05, 2016 at 03:01:23PM +0800, Ryder Lee wrote:
> This adds support for the MediaTek hardware accelerator on
> mt7623/mt2701/mt8521p SoC.
> 
> This driver currently implement:
> - SHA1 and SHA2 family(HMAC) hash alogrithms.

There is a typo for algorithms.

[...]
> +/**
> + * struct mtk_desc - DMA descriptor
> + * @hdr:	the descriptor control header
> + * @buf:	DMA address of input buffer segment
> + * @ct:		DMA address of command token that control operation flow
> + * @ct_hdr:	the command token control header
> + * @tag:	the user-defined field
> + * @tfm:	DMA address of transform state
> + * @bound:	align descriptors offset boundary
> + *
> + * Structure passed to the crypto engine to describe where source
> + * data needs to be fetched and how it needs to be processed.
> + */
> +struct mtk_desc {
> +	u32 hdr;
> +	u32 buf;
> +	u32 ct;
> +	u32 ct_hdr;
> +	u32 tag;
> +	u32 tfm;
> +	u32 bound[2];
> +};

Do you have tested this descriptor with BE/LE kernel ?

Regards
Corentin Labbe
