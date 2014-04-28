From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Tue, 29 Apr 2014 00:29:40 +0200
Message-ID: <201404290029.40807.marex@denx.de>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com> <201404282128.41302.marex@denx.de> <20140428215323.GA22018@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Horia Geanta <horia.geanta@freescale.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>,
	Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:53717 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbaD1Wqy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Apr 2014 18:46:54 -0400
In-Reply-To: <20140428215323.GA22018@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, April 28, 2014 at 11:53:23 PM, Herbert Xu wrote:
> On Mon, Apr 28, 2014 at 09:28:41PM +0200, Marek Vasut wrote:
> > On Monday, April 28, 2014 at 12:24:41 PM, Herbert Xu wrote:
> > > On Fri, Apr 18, 2014 at 01:01:42PM +0300, Horia Geanta wrote:
> > > > GFP_ATOMIC memory allocation could fail.
> > > > In this case, avoid NULL pointer dereference and notify user.
> > > > 
> > > > Cc: <stable@vger.kernel.org> # 3.2+
> > > > Cc: Kim Phillips <kim.phillips@freescale.com>
> > > > Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> > > 
> > > Patch applied to the crypto tree.  Thanks.
> > 
> > Hi Herbert,
> > 
> > Don't you instead want to apply my 11-patch series from
> > Message-Id: <1398362722-16430-1-git-send-email-marex@denx.de>
> > Subject: [PATCH 00/11] crypto: caam: Error reporting fixes
> > which actually fixes this SPRINTFCAT() horror properly please ?
> 
> This patch is going into the current release while your patches
> are better suited for the next merge window.

I agree with you that we're rather late in the RC now, but I also believe this 
patch is just hiding the real bug and that we should fix the root cause of the 
problem instead of adding a plaster over it.

I also believe that while my 11-patch series is big, it should go into -stable 
eventually, since it fixes the real problem.

Best regards,
Marek Vasut
