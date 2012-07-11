From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [linuxppc-release] [PATCH 4/4] Talitos: fix the issue of dma
 memory leak
Date: Wed, 11 Jul 2012 02:30:48 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C0296@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1341900014-20915-1-git-send-email-qiang.liu@freescale.com>
 <4FFC9DE1.5060502@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
 "David S. Miller" <davem@davemloft.net>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Li Yang-R58472 <r58472@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <4FFC9DE1.5060502@freescale.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

> -----Original Message-----
> From: Tabi Timur-B04825
> Sent: Wednesday, July 11, 2012 5:26 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Herbert
> Xu; Li Yang-R58472; David S. Miller
> Subject: Re: [linuxppc-release] [PATCH 4/4] Talitos: fix the issue of dma
> memory leak
> 
> Qiang Liu wrote:
> > An error will be happened when test with mass data:
> 
> Please don't use the phrase "fix the issue" in patch summaries.  It's
> redundant.
> 
> This patch should be titled,
> 
> "drivers/crypto: fix memory leak in Talitos driver"
> 
> > diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c index
> > 81f8497..a7da48c 100644
> > --- a/drivers/crypto/talitos.c
> > +++ b/drivers/crypto/talitos.c
> > @@ -264,7 +264,7 @@ static void flush_channel(struct device *dev, int
> ch, int error, int reset_ch)
> >  			else
> >  				status = error;
> >
> > -		dma_unmap_single(dev, request->dma_desc,
> > +		 dma_unmap_single(priv->dev, request->dma_desc,
> 
> You have an indentation problem here.
My fault, I will correct it and resend again. Thanks.

> 
> --
> Timur Tabi
> Linux kernel developer at Freescale
