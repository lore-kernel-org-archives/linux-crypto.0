From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Mon, 28 Apr 2014 21:28:41 +0200
Message-ID: <201404282128.41302.marex@denx.de>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com> <1397815302-15915-2-git-send-email-horia.geanta@freescale.com> <20140428102441.GA17037@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Horia Geanta <horia.geanta@freescale.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49883 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaD1VwM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Apr 2014 17:52:12 -0400
In-Reply-To: <20140428102441.GA17037@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, April 28, 2014 at 12:24:41 PM, Herbert Xu wrote:
> On Fri, Apr 18, 2014 at 01:01:42PM +0300, Horia Geanta wrote:
> > GFP_ATOMIC memory allocation could fail.
> > In this case, avoid NULL pointer dereference and notify user.
> > 
> > Cc: <stable@vger.kernel.org> # 3.2+
> > Cc: Kim Phillips <kim.phillips@freescale.com>
> > Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> 
> Patch applied to the crypto tree.  Thanks.

Hi Herbert,

Don't you instead want to apply my 11-patch series from
Message-Id: <1398362722-16430-1-git-send-email-marex@denx.de>
Subject: [PATCH 00/11] crypto: caam: Error reporting fixes
which actually fixes this SPRINTFCAT() horror properly please ?

Best regards,
Marek Vasut
