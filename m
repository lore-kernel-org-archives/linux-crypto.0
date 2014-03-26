From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Fix late crypto work queue initialization
Date: Tue, 25 Mar 2014 17:14:49 -0700
Message-ID: <20140326001449.GA29250@kroah.com>
References: <1395100347.2970.14.camel@schen9-DESK>
 <20140321144040.GD25820@gondor.apana.org.au>
 <1395790856.2970.33.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Huang, Ying" <ying.huang@intel.com>, stable@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1395790856.2970.33.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 25, 2014 at 04:40:56PM -0700, Tim Chen wrote:
> On Fri, 2014-03-21 at 22:40 +0800, Herbert Xu wrote:
> > On Mon, Mar 17, 2014 at 04:52:26PM -0700, Tim Chen wrote:
> > > The crypto algorithm modules utilizing the crypto daemon could
> > > be used early when the system start up.  Using module_init
> > > does not guarantee that the daemon's work queue is initialized
> > > when the cypto alorithm depending on crypto_wq starts.  It is necessary
> > > to initialize the crypto work queue earlier at the subsystem
> > > init time to make sure that it is initialized
> > > when used.
> > > 
> > > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > 
> > Patch applied.
> 
> Herbert,
> 
> Probably this patch should go to the stable patches as well.
> Copying Greg.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
