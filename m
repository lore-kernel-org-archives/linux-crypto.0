From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure
 handling in SPRINTFCAT macro
Date: Tue, 29 Apr 2014 05:53:23 +0800
Message-ID: <20140428215323.GA22018@gondor.apana.org.au>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
 <1397815302-15915-2-git-send-email-horia.geanta@freescale.com>
 <20140428102441.GA17037@gondor.apana.org.au>
 <201404282128.41302.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia Geanta <horia.geanta@freescale.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>
To: Marek Vasut <marex@denx.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201404282128.41302.marex@denx.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 28, 2014 at 09:28:41PM +0200, Marek Vasut wrote:
> On Monday, April 28, 2014 at 12:24:41 PM, Herbert Xu wrote:
> > On Fri, Apr 18, 2014 at 01:01:42PM +0300, Horia Geanta wrote:
> > > GFP_ATOMIC memory allocation could fail.
> > > In this case, avoid NULL pointer dereference and notify user.
> > > 
> > > Cc: <stable@vger.kernel.org> # 3.2+
> > > Cc: Kim Phillips <kim.phillips@freescale.com>
> > > Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> > 
> > Patch applied to the crypto tree.  Thanks.
> 
> Hi Herbert,
> 
> Don't you instead want to apply my 11-patch series from
> Message-Id: <1398362722-16430-1-git-send-email-marex@denx.de>
> Subject: [PATCH 00/11] crypto: caam: Error reporting fixes
> which actually fixes this SPRINTFCAT() horror properly please ?

This patch is going into the current release while your patches
are better suited for the next merge window.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
