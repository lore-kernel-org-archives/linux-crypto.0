From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH 15/17] powerpc: crypto: sysfs routines and docs for the
 nx device driver
Date: Wed, 21 Mar 2012 17:46:05 -0500
Message-ID: <1332369965.3858.68.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <1332366080.3858.52.camel@key-ThinkPad-W510>
	 <20120321221122.GA30748@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
	linuxppc-dev@lists.ozlabs.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50950 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2CUWpl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Mar 2012 18:45:41 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <key@linux.vnet.ibm.com>;
	Wed, 21 Mar 2012 16:45:40 -0600
In-Reply-To: <20120321221122.GA30748@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Greg,

On Wed, 2012-03-21 at 15:11 -0700, Greg KH wrote:
> On Wed, Mar 21, 2012 at 04:41:20PM -0500, Kent Yoder wrote:
> > These routines add sysfs files supporting the Power7+ in-Nest encryption
> > accelerator driver.
> > 
> > Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> > ---
> >  Documentation/powerpc/pfo-nx-crypto.txt |   52 ++++++++
> 
> Please put sysfs file information in Documentation/ABI/ where it
> belongs.

  Will do, I see debugfs docs in there too.

> Shouldn't the first just be debugfs files, as no "normal" user will ever
> care about such a thing?
> 
> Actually, why are these sysfs files at all, how about all of this going
> into debugfs?

  Yes, that's fine.  These really are just for checking 'am I really
doing hardware encryption' and debugging any return codes that may come
back from the hcall. The error return is probably more easily dev_err'd
though.

> 
> > +Error Detection
> > +===============
> 
> <snip>
> 
> What can anyone do with any of these files?  What use are they to users?
> 
> > +Device Use
> > +==========
> 
> Again, what does a user care about these items for?
> 
> > +int
> > +nx_sysfs_init(struct device_driver *drv)
> > +{
> > +	int rc;
> > +
> > +	rc = driver_create_file(drv, &driver_attr_aes_ops);
> > +	if (rc)
> > +		goto out;
> 
> <snip>
> 
> Oh, ${DIETY}, no.  Please don't create files one by one, we do have
> functions that do all of this for you automatically, why aren't you
> using them?

  Ok, I'll go look for some debugfs wrappers.

> > +void
> > +nx_sysfs_fini(struct device_driver *drv)
> > +{
> > +	driver_remove_file(drv, &driver_attr_sync_ops);
> > +	driver_remove_file(drv, &driver_attr_aes_bytes);
> > +	driver_remove_file(drv, &driver_attr_aes_ops);
> > +	driver_remove_file(drv, &driver_attr_sha256_bytes);
> > +	driver_remove_file(drv, &driver_attr_sha256_ops);
> > +	driver_remove_file(drv, &driver_attr_sha512_bytes);
> > +	driver_remove_file(drv, &driver_attr_sha512_ops);
> 
> Same here, don't do this, do it all at once.
> 
> > +}
> 
> Who is calling these functions?  Where in the device lifecycle are the
> files being created?  Did you just race userspace with how they are
> created, or are you doing it "properly"?  (hint, odds are, as you are
> trying to manually create and remove these by hand, you aren't doing it
> properly...)

  We're not racing here, other than with cat.  Just so an admin can see
his workload is getting offloaded.

Thanks,
Kent

> thanks,
> 
> greg k-h
> 
