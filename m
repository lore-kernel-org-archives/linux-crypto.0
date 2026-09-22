Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F4152CCDD;
	Tue, 22 Sep 2026 12:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790079535; cv=none; b=n5T4hlkl8GDKsvy6r8JlUaecJsxx9B4FMdocA1FllIVU3vlzKLfxdT0ZY+eGJYvWP1MEfPg2TCk+z45x/pl20Bp6hok60mIo7R2VX6zNOaNxxanJxFKl57QTKlPXscfOQ3CoP1hMHXcXueJkw1tqMiH7djRkIEmaiZG7WajIQT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790079535; c=relaxed/simple;
	bh=IhVHYuh708wIgCRXNQ++esuYVAi1rvWzhiAREt8f/3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BBTp1ejaOuHT7TytW84mvUbfRJkp+B8xEw8e+fMdeGWz/f7gyQ/0BxqEug7n1IlMrs07BY9IxWkRY8h4lK9GDQA1aljV0/rvujS1aJ+ZAk+LTm3hODYCJLh+cF7J1Z8YFVCjV75RuV1hu2Bjf8a2SIY+BTaqh1CM0GrG0NQOzAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPUo9dAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPUo9dAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84C91F000FF;
	Tue, 22 Sep 2026 12:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790079534;
	bh=4M++b2C/tawZhIyaIO/1xeaH0HPHV7NcaX36JloMDQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TPUo9dAdOCPzqp3HzDUJEpJVbFSj49xi2Ayf9zXIZgXd1ui24qH1bHqMHOMxAxoCz
	 Fwb3pQG7E0Se9a7M5bmpTXrBI1J/Gnu+blFBSIQFsElt2KgTrtrSXDFhEn3cPsJrp+
	 Ro0dd+xyjWnamyA+0i015UhlCp0mtxpNSm54/n+M=
Date: Tue, 22 Sep 2026 14:13:13 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Weili Qian <qianweili@huawei.com>
Cc: herbert@gondor.apana.org.au, wangzhou1@hisilicon.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	huangchenghai2@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH 1/2] uacce: add device usage sysfs interface
Message-ID: <2026092235-unfrosted-concept-4bd9@gregkh>
References: <20260921075131.1062155-1-qianweili@huawei.com>
 <20260921075131.1062155-2-qianweili@huawei.com>
 <2026092125-define-unit-ac52@gregkh>
 <fd71cb7c-b9da-5cd9-c52e-ee287923073b@huawei.com>
 <2026092205-wrist-growing-0f04@gregkh>
 <d171b247-bcd3-bffe-ec74-4ae2df4faef5@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d171b247-bcd3-bffe-ec74-4ae2df4faef5@huawei.com>

On Tue, Sep 22, 2026 at 07:57:14PM +0800, Weili Qian wrote:
> 
> 
> On 2026/9/22 17:21, Greg KH wrote:
> > On Tue, Sep 22, 2026 at 05:11:55PM +0800, qianweili wrote:
> > > 
> > > On 2026/9/21 16:12, Greg KH wrote:
> > > > On Mon, Sep 21, 2026 at 03:51:30PM +0800, Weili Qian wrote:
> > > > > Userspace has no way to query the runtime usage of a UACCE
> > > > > device; it can only be inferred indirectly from queue state, which is
> > > > > neither accurate nor uniform across drivers.
> > > > > 
> > > > > Add a read-only dev_usage sysfs attribute and a get_dev_usage callback
> > > > > in struct uacce_ops. A driver implementing the callback writes the
> > > > > current usage as a percentage (0-100) string into the caller-provided
> > > > > buffer and returns the number of bytes written; dev_usage_show()
> > > > > appends the trailing newline. The attribute is hidden via
> > > > > uacce_dev_is_visible() when the driver does not provide the callback.
> > > > > 
> > > > > The corresponding ABI entry is added to Documentation/ABI/testing/
> > > > > sysfs-driver-uacce.
> > > > > 
> > > > > Signed-off-by: Weili Qian <qianweili@huawei.com>
> > > > > ---
> > > > >    Documentation/ABI/testing/sysfs-driver-uacce |  9 +++++++++
> > > > >    drivers/misc/uacce/uacce.c                   | 19 +++++++++++++++++++
> > > > >    include/linux/uacce.h                        |  5 +++++
> > > > >    3 files changed, 33 insertions(+)
> > > > > 
> > > > > diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
> > > > > index d3f0b8f3c589..3e4af4c1e5a9 100644
> > > > > --- a/Documentation/ABI/testing/sysfs-driver-uacce
> > > > > +++ b/Documentation/ABI/testing/sysfs-driver-uacce
> > > > > @@ -55,3 +55,12 @@ Date:           Feb 2020
> > > > >    KernelVersion:  5.7
> > > > >    Contact:        linux-accelerators@lists.ozlabs.org
> > > > >    Description:    Size (bytes) of dus region queue file
> > > > > +
> > > > > +What:           /sys/class/uacce/<dev_name>/dev_usage
> > > > > +Date:           Sep 2026
> > > > > +KernelVersion:  7.3
> > > > That's not going to happen here :(
> > > I'll change it to 7.4 in the next version.
> > > > > +Contact:        linux-accelerators@lists.ozlabs.org
> > > > > +Description:    (R) Current usage of the device, reported as a driver-defined
> > > > > +                string of up to PAGE_SIZE - 1 bytes. Usage is expressed as a
> > > > > +                percentage (0-100). The attribute is hidden if the driver does
> > > > > +                not implement the get_dev_usage callback.
> > > > > diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> > > > > index 45521d4a56d1..545ba35a590b 100644
> > > > > --- a/drivers/misc/uacce/uacce.c
> > > > > +++ b/drivers/misc/uacce/uacce.c
> > > > > @@ -433,6 +433,20 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
> > > > >    	return count;
> > > > >    }
> > > > > +static ssize_t dev_usage_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > > > +{
> > > > > +	struct uacce_device *uacce = to_uacce_device(dev);
> > > > > +	int ret;
> > > > > +
> > > > > +	ret = uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE - 1);
> > > > Why can't you use sysfs_emit()?  That way you don't have to worry about
> > > > PAGE_SIZE, and you don't have to do:
> > > > 
> > > > > +	if (ret < 0)
> > > > > +		return ret;
> > > > > +
> > > > > +	buf[ret++] = '\n';
> > > > That type of thing :(
> > > > 
> > > > Also, you got your math wrong above :(
> > > sysfs_emit() is useful when the framework side knows the format string
> > > upfront.  Here get_dev_usage is a driver callback that dynamically
> > > generates content -- the format is not known to the framework, so
> > > there is no format string to emit.  Having the callback write into a
> > > temporary buffer and then sysfs_emit(buf, "%s", tmp) in the show
> > > function would just add an unnecessary copy without gaining the
> > > overflow protection that sysfs_emit normally provides.
> > Then that is going to be a mess, sysfs files should be in a consistant
> > way, don't have random formats for the same filename depending on random
> > hardware types.  Use different sysfs files if you want to do that.
> > 
> > And this is just going to be a single value, nothing complex, so why do
> > you need a callback for that?
> A single device may run multiple independent algorithms in parallel
> -- e.g. the HiSilicon ZIP device has separate compression and
> decompression engines whose usage rates are independent and cannot
> be aggregated into one meaningful number.

Then that can not be a sysfs file, as sysfs files are "one value per
file".

> Following your suggestion of different sysfs files, one approach is
> to expose one file per algorithm.  Each file contains a single int
> (0-100) formatted with sysfs_emit(), and the callback returns int.
> But the number of algorithms is driver-specific (1 to 3 in the
> HiSilicon drivers), so the framework would need to create attributes
> dynamically at registration time, which adds complexity.
> 
> I'm not sure this is the best approach.  Do you have a better
> suggestion for handling this case?

I don't know, just don't violate the one-version-per-file rule AND
always have the same type of data in the file with the same name (i.e.
don't have a file that can contain different types of data.)

This propose api seems to violate all of that, so I wouldn't recommend
it at all.

Why is this info needed in userspace at all?  What is userspace going to
do with it?

thanks,

greg k-h
