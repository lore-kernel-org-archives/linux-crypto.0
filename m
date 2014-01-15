From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: mxs - Fix sparse non static symbol warning
Date: Wed, 15 Jan 2014 11:42:51 +0800
Message-ID: <20140115034251.GB13556@gondor.apana.org.au>
References: <CAPgLHd8_6_3CvqoSSPvynx3dVgqm_BiX=dLAt9WzNmdXNVC8Ng@mail.gmail.com>
 <201401091543.01821.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wei Yongjun <weiyj.lk@gmail.com>, grant.likely@linaro.org,
	robh+dt@kernel.org, yongjun_wei@trendmicro.com.cn,
	linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:41419 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaAODn2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jan 2014 22:43:28 -0500
Content-Disposition: inline
In-Reply-To: <201401091543.01821.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 09, 2014 at 03:43:01PM +0100, Marek Vasut wrote:
> On Wednesday, January 08, 2014 at 02:48:56 PM, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Fixes the following sparse warning:
> > 
> > drivers/crypto/mxs-dcp.c:103:1: warning:
> >  symbol 'global_mutex' was not declared. Should it be static?
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  drivers/crypto/mxs-dcp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> > index d41917c..a6db7fa 100644
> > --- a/drivers/crypto/mxs-dcp.c
> > +++ b/drivers/crypto/mxs-dcp.c
> > @@ -100,7 +100,7 @@ struct dcp_sha_req_ctx {
> >   * design of Linux Crypto API.
> >   */
> >  static struct dcp *global_sdcp;
> > -DEFINE_MUTEX(global_mutex);
> > +static DEFINE_MUTEX(global_mutex);
> > 
> >  /* DCP register layout. */
> >  #define MXS_DCP_CTRL				0x00
> 
> Thank you.
> 
> Acked-by: Marek Vasut <marex@denx.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
