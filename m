Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00D02417C7;
	Mon, 17 Mar 2025 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742221899; cv=none; b=RYTgYM08deMeEi4hG/0c/NW7WlGRqQzh2IylM6TpMsQvHbqFkBk8wIMMbznmd5c9aeoQCgotf3w57LguEZjvizjCTU6uwDy9cmi2jXUxB9H998PSiBmHe3ElYk/UNsgsqW/hvoaq8Vmsm6XXPhDtxEhA6m3KNt4Mmw49ddWWBaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742221899; c=relaxed/simple;
	bh=LGXVZ3hhL8osdTBzm7kPyXNbARxeGCAupiFiB3aHIqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+AU79XRHwFew22/kEwy6HR1od3VKsZ+Bm9tXueLxevDOOuspe9vu+d2e8/Z5xfHD91vJRf9SL42SBqlMVyFw92aspuQJRYIayT3sba8GBJkrWgsfxd33f+lk2gGuqETM9LEc7iSzMW3g5V7qLrAl8N8vhD9dmWwLK5MR+K/8Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUav38EU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUav38EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE38C4CEED;
	Mon, 17 Mar 2025 14:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742221899;
	bh=LGXVZ3hhL8osdTBzm7kPyXNbARxeGCAupiFiB3aHIqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUav38EUZs4/Ki9zAwRFWm7l5LnnyeJbEJE2gcOmROP0e4OLDXYUVL3CPOwPytCoz
	 YqdWg1Crn+j0Hkn1/YzfsmwLNbSknnW2FXcAgYE7iey+1rAGajS9OL0OtK1dfG9Mjo
	 YZ7mrE+JxtxZkCX8XihdDFzaY2EZYqGR10dXeeDI=
Date: Mon, 17 Mar 2025 15:30:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/9] hwrng: arm-smccc-trng - transition to the faux
 device interface
Message-ID: <2025031709-unmoved-carton-c130@gregkh>
References: <20250317-plat2faux_dev-v1-0-5fe67c085ad5@arm.com>
 <20250317-plat2faux_dev-v1-2-5fe67c085ad5@arm.com>
 <2025031748-deface-wasting-b635@gregkh>
 <Z9gwNaUoTmqViPrh@bogus>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9gwNaUoTmqViPrh@bogus>

On Mon, Mar 17, 2025 at 02:22:45PM +0000, Sudeep Holla wrote:
> On Mon, Mar 17, 2025 at 02:04:27PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Mar 17, 2025 at 10:13:14AM +0000, Sudeep Holla wrote:
> > > +MODULE_ALIAS("faux:smccc_trng");
> > 
> > Why do you need a branch new alias you just made up?  Please don't add
> > that for these types of devices, that's not going to work at all (just
> > like the platform alias really doesn't work well.
> > 
> 
> Sure I will drop all of those alias. One question I have if the idea of
> creating a macro for this is good or bad ? I need this initial condition
> flag to make use of such a macro, so I didn't go for it, but it does
> remove some boiler-plate code.
> 
> Let me know what do you think of it ?
> 
> Regards,
> Sudeep
> 
> -->8 
> diff --git i/include/linux/device/faux.h w/include/linux/device/faux.h
> index 9f43c0e46aa4..8af3eaef281a 100644
> --- i/include/linux/device/faux.h
> +++ w/include/linux/device/faux.h
> @@ -66,4 +66,30 @@ static inline void faux_device_set_drvdata(struct faux_device *faux_dev, void *d
>  	dev_set_drvdata(&faux_dev->dev, data);
>  }
>  
> +#define module_faux_driver(name, tag, init_cond)			\
> +static struct faux_device_ops tag##_ops = {				\
> +	.probe = tag##_probe,						\
> +	.remove = tag##_remove,						\
> +};									\
> +									\
> +static struct faux_device *tag##_dev;					\
> +									\
> +static int __init tag##_init(void)					\
> +{									\
> +	if (!(init_cond))						\
> +		return 0;						\
> +	tag##_dev = faux_device_create(name, NULL, &tag##_ops);		\
> +	if (!tag##_dev)							\
> +		return -ENODEV;						\
> +									\
> +	return 0;							\
> +}									\
> +module_init(tag##_init);						\
> +									\
> +static void __exit tag##_exit(void)					\
> +{									\
> +	faux_device_destroy(tag##_dev);					\
> +}									\
> +module_exit(tag##_exit);						\

Yes, I see that some of your changes could be moved to use this, so I
think it is worth it.

But why can't you use module_driver() here?  Ah, that init_cond?  And
the device.  Hm, why not put the init_cond in the probe callback?  That
should make this macro simpler.

And don't use "tag", that's an odd term here, just copy what
module_driver() does instead please.

thanks,

greg k-h
