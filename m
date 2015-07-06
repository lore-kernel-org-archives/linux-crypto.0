From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH v2] crypto/nx-842-{powerpc,pseries}: reduce chattiness of
  platform drivers
Date: Mon, 6 Jul 2015 10:06:21 -0700
Message-ID: <20150706170621.GA3578@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
 <20150702224049.GE1712@linux.vnet.ibm.com>
 <1435887032.3665.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Streetman <ddstreet@us.ibm.com>, linux-crypto@vger.kernel.org,
	gustavold@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:43145 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbGFRGa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 13:06:30 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Mon, 6 Jul 2015 13:06:29 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id EEFAA38C805E
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2015 13:06:25 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t66H6PgZ23593064
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2015 17:06:25 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t66H6NMp016770
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2015 13:06:25 -0400
Content-Disposition: inline
In-Reply-To: <1435887032.3665.1.camel@ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03.07.2015 [11:30:32 +1000], Michael Ellerman wrote:
> On Thu, 2015-07-02 at 15:40 -0700, Nishanth Aravamudan wrote:
> > While we never would successfully load on the wrong machine type, there
> > is extra output by default regardless of machine type.
> > 
> > For instance, on a PowerVM LPAR, we see the following:
> > 
> > nx_compress_powernv: loading
> > nx_compress_powernv: no coprocessors found
> > 
> > even though those coprocessors could never be found. Similar pseries
> > messages are printed on powernv.
> 
> I know I've been converting init calls to machine_initcalls() to avoid
> these sort of issues in platform code. But for a driver it should be
> trivial for it to only probe when the hardware is found.
> 
> By which I mean I think we shouldn't need these.

Ok.

> > diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> > index 33b3b0abf4ae..6b5e5143c95b 100644
> > --- a/drivers/crypto/nx/nx-842-powernv.c
> > +++ b/drivers/crypto/nx/nx-842-powernv.c
> > @@ -594,6 +594,9 @@ static __init int nx842_powernv_init(void)
> >  	BUILD_BUG_ON(DDE_BUFFER_ALIGN % DDE_BUFFER_SIZE_MULT);
> >  	BUILD_BUG_ON(DDE_BUFFER_SIZE_MULT % DDE_BUFFER_LAST_MULT);
> >  
> > +	if (!machine_is(powernv))
> > +		return -ENODEV;
> > +
> >  	pr_info("loading\n");
> 
> This is just too chatty, drop it.
> 
> >  	for_each_compatible_node(dn, NULL, "ibm,power-nx")
> 
> It shouldn't be printing anything unless it finds some devices in this loop.
> 
> And you should drop the print in here:
> 
> 	if (!nx842_ct) {
> 		pr_err("no coprocessors found\n");
> 		return -ENODEV;
> 	}
> 
> And that should mean no output unless hardware is found I think?

Yep, will adjust.

> > @@ -625,6 +628,9 @@ static void __exit nx842_powernv_exit(void)
> >  {
> >  	struct nx842_coproc *coproc, *n;
> >  
> > +	if (!machine_is(powernv))
> > +		return;
> 
> You shouldn't need to touch the exit paths if the drivers were never
> loaded?

Duh, yep.

> > diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
> > index b84b0ceeb46e..75a7bfdc160e 100644
> > --- a/drivers/crypto/nx/nx-842-pseries.c
> > +++ b/drivers/crypto/nx/nx-842-pseries.c
> > @@ -1091,6 +1091,9 @@ static int __init nx842_pseries_init(void)
> >  	struct nx842_devdata *new_devdata;
> >  	int ret;
> >  
> > +	if (!machine_is(pseries))
> > +		return -ENODEV;
> > +
> >  	pr_info("Registering IBM Power 842 compression driver\n");
> 
> Again this is too chatty, just remove it.

Will do.

> >  	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
> 		return -ENODEV;
> 
> That should do the trick shouldn't it?

Yep, I think so.

Thanks Michael!


While we never would successfully load on the wrong machine type, there
is extra output by default regardless of machine type.

For instance, on a PowerVM LPAR, we see the following:

nx_compress_powernv: loading
nx_compress_powernv: no coprocessors found

even though those coprocessors could never be found.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Dan Streetman <ddstreet@us.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org

---
v2:
  Rather than not loading, just reduce the verbosity

 drivers/crypto/nx/nx-842-powernv.c | 10 +---------
 drivers/crypto/nx/nx-842-pseries.c |  3 ---
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 33b3b0abf4ae..7e474562058d 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -594,15 +594,11 @@ static __init int nx842_powernv_init(void)
 	BUILD_BUG_ON(DDE_BUFFER_ALIGN % DDE_BUFFER_SIZE_MULT);
 	BUILD_BUG_ON(DDE_BUFFER_SIZE_MULT % DDE_BUFFER_LAST_MULT);
 
-	pr_info("loading\n");
-
 	for_each_compatible_node(dn, NULL, "ibm,power-nx")
 		nx842_powernv_probe(dn);
 
-	if (!nx842_ct) {
-		pr_err("no coprocessors found\n");
+	if (!nx842_ct)
 		return -ENODEV;
-	}
 
 	if (!nx842_platform_driver_set(&nx842_powernv_driver)) {
 		struct nx842_coproc *coproc, *n;
@@ -615,8 +611,6 @@ static __init int nx842_powernv_init(void)
 		return -EEXIST;
 	}
 
-	pr_info("loaded\n");
-
 	return 0;
 }
 module_init(nx842_powernv_init);
@@ -631,7 +625,5 @@ static void __exit nx842_powernv_exit(void)
 		list_del(&coproc->list);
 		kfree(coproc);
 	}
-
-	pr_info("unloaded\n");
 }
 module_exit(nx842_powernv_exit);
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index b84b0ceeb46e..d44524da6589 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1091,8 +1091,6 @@ static int __init nx842_pseries_init(void)
 	struct nx842_devdata *new_devdata;
 	int ret;
 
-	pr_info("Registering IBM Power 842 compression driver\n");
-
 	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
 		return -ENODEV;
 
@@ -1129,7 +1127,6 @@ static void __exit nx842_pseries_exit(void)
 	struct nx842_devdata *old_devdata;
 	unsigned long flags;
 
-	pr_info("Exiting IBM Power 842 compression driver\n");
 	nx842_platform_driver_unset(&nx842_pseries_driver);
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
-- 
2.1.4
