From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] crypto: omap-sham - potential Oops on error in probe
Date: Wed, 18 May 2016 14:44:43 +0300
Message-ID: <20160518114443.GG11011@mwanda>
References: <20160518103905.GA10470@mwanda>
 <21712178-666f-e2e2-24f3-fb0c513acc83@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21712178-666f-e2e2-24f3-fb0c513acc83@ti.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 18, 2016 at 01:42:36PM +0300, Peter Ujfalusi wrote:
> On 05/18/16 13:39, Dan Carpenter wrote:
> > This if statement is reversed so we end up either leaking or Oopsing on
> > error.
> 
> Oops, sorry for that.
> Probably the other omap-* crypto drivers have the same issue? Can you send a
> patch for them or should I do it?

I didn't see those static checker warnings so probably it means I can't
compile the drivers.  Could you do it?

regards,
dan carpenter

