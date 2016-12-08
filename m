From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/2] Add crypto driver support for some MediaTek chips
Date: Thu, 8 Dec 2016 17:05:26 +0800
Message-ID: <1481187926.14860.19.camel@mtkswgap22>
References: <1480921284-45827-1-git-send-email-ryder.lee@mediatek.com>
         <1480921284-45827-2-git-send-email-ryder.lee@mediatek.com>
         <20161205085220.GA333@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Roy Luo <cheng-hao.luo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
To: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161205085220.GA333@Red>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On Mon, 2016-12-05 at 09:52 +0100, Corentin Labbe wrote:
> Hello
> 
> I have two minor comment.
> 
> On Mon, Dec 05, 2016 at 03:01:23PM +0800, Ryder Lee wrote:
> > This adds support for the MediaTek hardware accelerator on
> > mt7623/mt2701/mt8521p SoC.
> > 
> > This driver currently implement:
> > - SHA1 and SHA2 family(HMAC) hash alogrithms.
> 
> There is a typo for algorithms.
> 
> [...]
> > +/**
> > + * struct mtk_desc - DMA descriptor
> > + * @hdr:	the descriptor control header
> > + * @buf:	DMA address of input buffer segment
> > + * @ct:		DMA address of command token that control operation flow
> > + * @ct_hdr:	the command token control header
> > + * @tag:	the user-defined field
> > + * @tfm:	DMA address of transform state
> > + * @bound:	align descriptors offset boundary
> > + *
> > + * Structure passed to the crypto engine to describe where source
> > + * data needs to be fetched and how it needs to be processed.
> > + */
> > +struct mtk_desc {
> > +	u32 hdr;
> > +	u32 buf;
> > +	u32 ct;
> > +	u32 ct_hdr;
> > +	u32 tag;
> > +	u32 tfm;
> > +	u32 bound[2];
> > +};
> 
> Do you have tested this descriptor with BE/LE kernel ?

I did not test it with BE kernel, because both CPU and accelerator in
our SoC just run on LE system. 

Thanks for reminding me, i will use byteorder conversion macros and type
identifiers.

> Regards
> Corentin Labbe




--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
