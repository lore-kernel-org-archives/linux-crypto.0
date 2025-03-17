Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6641D8F4A;
	Mon, 17 Mar 2025 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742221371; cv=none; b=HRzVCCm1+Kris0KqJfpLivn4WC5UlGss+gogKk3uHi2goOf7pBicpZMGBU+Nmqupazvk6rKRNksdmaCN2qqx2Dtp0ETS9QtNUZM/ORhwyA/XboPGoBHS1CGIZbQAGC4hQ4QH3U0FhuCvCCFGKLxQrpf4XHYfYNpyqE3I5Dr2Abg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742221371; c=relaxed/simple;
	bh=JML17x1ArQHdjXBR7PRwTnBDDRX4qykPz2U6h/tv+xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWRY/fSPVUmv3ghUdd1ZELweByeVHxw1g5PdMFEK5cWOVcnlUw7NQZs/OnnohoP+Lzxf2U3zsfY/306Avkt4DsSw0zEXRDyaF9FvM8vdZb57gKUuMac4FwFLc65bj8fY2g+H48QIVYQ5KQijRxSx1p/MzSPIrxC6u2CchGfyEs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB6A313D5;
	Mon, 17 Mar 2025 07:22:58 -0700 (PDT)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFF0A3F63F;
	Mon, 17 Mar 2025 07:22:48 -0700 (PDT)
Date: Mon, 17 Mar 2025 14:22:45 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/9] hwrng: arm-smccc-trng - transition to the faux
 device interface
Message-ID: <Z9gwNaUoTmqViPrh@bogus>
References: <20250317-plat2faux_dev-v1-0-5fe67c085ad5@arm.com>
 <20250317-plat2faux_dev-v1-2-5fe67c085ad5@arm.com>
 <2025031748-deface-wasting-b635@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025031748-deface-wasting-b635@gregkh>

On Mon, Mar 17, 2025 at 02:04:27PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Mar 17, 2025 at 10:13:14AM +0000, Sudeep Holla wrote:
> > +MODULE_ALIAS("faux:smccc_trng");
> 
> Why do you need a branch new alias you just made up?  Please don't add
> that for these types of devices, that's not going to work at all (just
> like the platform alias really doesn't work well.
> 

Sure I will drop all of those alias. One question I have if the idea of
creating a macro for this is good or bad ? I need this initial condition
flag to make use of such a macro, so I didn't go for it, but it does
remove some boiler-plate code.

Let me know what do you think of it ?

Regards,
Sudeep

-->8 
diff --git i/include/linux/device/faux.h w/include/linux/device/faux.h
index 9f43c0e46aa4..8af3eaef281a 100644
--- i/include/linux/device/faux.h
+++ w/include/linux/device/faux.h
@@ -66,4 +66,30 @@ static inline void faux_device_set_drvdata(struct faux_device *faux_dev, void *d
 	dev_set_drvdata(&faux_dev->dev, data);
 }
 
+#define module_faux_driver(name, tag, init_cond)			\
+static struct faux_device_ops tag##_ops = {				\
+	.probe = tag##_probe,						\
+	.remove = tag##_remove,						\
+};									\
+									\
+static struct faux_device *tag##_dev;					\
+									\
+static int __init tag##_init(void)					\
+{									\
+	if (!(init_cond))						\
+		return 0;						\
+	tag##_dev = faux_device_create(name, NULL, &tag##_ops);		\
+	if (!tag##_dev)							\
+		return -ENODEV;						\
+									\
+	return 0;							\
+}									\
+module_init(tag##_init);						\
+									\
+static void __exit tag##_exit(void)					\
+{									\
+	faux_device_destroy(tag##_dev);					\
+}									\
+module_exit(tag##_exit);						\
+
 #endif /* _FAUX_DEVICE_H_ */

