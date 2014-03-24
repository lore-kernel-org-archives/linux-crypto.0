From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC PATCH 03/22] staging: crypto: skein: allow building
 statically
Date: Sun, 23 Mar 2014 22:22:10 -0400
Message-ID: <20140324022210.GD28304@titan.lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <e3d822cba2ff9e9bbb57fc613039bd0983186c05.1394570067.git.jason@lakedaemon.net>
 <20140317215252.GA24150@kroah.com>
 <20140318125849.GQ15608@titan.lakedaemon.net>
 <20140318142820.GA11892@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, "David S. Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140318142820.GA11892@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 18, 2014 at 02:28:20PM +0000, Greg KH wrote:
> On Tue, Mar 18, 2014 at 08:58:49AM -0400, Jason Cooper wrote:
> > On Mon, Mar 17, 2014 at 02:52:52PM -0700, Greg KH wrote:
> > > On Tue, Mar 11, 2014 at 09:32:35PM +0000, Jason Cooper wrote:
> > > > These are the minimum changes required to get the code to build
> > > > statically in the kernel.  It's necessary to do this first so that we
> > > > can empirically determine that future cleanup patches aren't changing
> > > > the generated object code.
> > > > 
> > > > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > > 
> > > This doesn't apply to my latest tree :(
> > 
> > Ah, ok.  I'll rebase this series on the staging tree.

Done, submitted.

> > > > --- a/drivers/staging/Makefile
> > > > +++ b/drivers/staging/Makefile
> > > > @@ -65,3 +65,4 @@ obj-$(CONFIG_XILLYBUS)		+= xillybus/
> > > >  obj-$(CONFIG_DGNC)			+= dgnc/
> > > >  obj-$(CONFIG_DGAP)			+= dgap/
> > > >  obj-$(CONFIG_MTD_SPINAND_MT29F)	+= mt29f_spinand/
> > > > +obj-$(CONFIG_CRYPTO_SKEIN) += skein/
> > > 
> > > Care to align these up with the way this file is formatted?
> > 
> > Of course, not sure what happened there (well, other than the obvious
> > :-P)

dabbit.  I thought I remembered everything.  I'll do a V3 of this patch.

> > > And I have no objection to taking the drivers/staging/ patches, the
> > > script looks useful, but I can't take it through the staging tree,
> > > sorry.
> > 
> > Ok, I'll pull that out as a separate branch.

s/branch/patch/.  Done.

thx,

Jason.
