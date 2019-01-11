Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:47040 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389736AbfAKPJW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 10:09:22 -0500
Received: by mail-pg1-f193.google.com with SMTP id w7so6410441pgp.13
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 07:09:21 -0800 (PST)
Subject: Re: [PATCH v3 1/4] tee: add bus driver framework for TEE based
 devices
To: Sumit Garg <sumit.garg@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jens.wiklander@linaro.org,
        mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        tee-dev@lists.linaro.org
References: <1547207251-9372-1-git-send-email-sumit.garg@linaro.org>
 <1547207251-9372-2-git-send-email-sumit.garg@linaro.org>
From: Bhupesh Sharma <bhsharma@redhat.com>
Message-ID: <6a01fee4-4331-be63-9a78-c4d646b43d29@redhat.com>
Date: Fri, 11 Jan 2019 20:39:13 +0530
MIME-Version: 1.0
In-Reply-To: <1547207251-9372-2-git-send-email-sumit.garg@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sumit,

Thanks for the patch. Some nitpicks in-line:

On 01/11/2019 05:17 PM, Sumit Garg wrote:
> Introduce a generic TEE bus driver concept for TEE based kernel drivers
> which would like to communicate with TEE based devices/services.
> 
> In this TEE bus concept, devices/services are identified via Universally
> Unique Identifier (UUID) and drivers register a table of device UUIDs
> which they can support.
> 
> So this TEE bus framework registers a match() callback function which
> iterates over the driver UUID table to find a corresponding match for
> device UUID. If a match is found, then this particular device is probed
> via corresponding probe api registered by the driver. This process
> happens whenever a device or a driver is registered with TEE bus.
> 
> Also this framework allows for device enumeration to be specific to
> corresponding TEE implementation like OP-TEE etc.
> 
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>   drivers/tee/tee_core.c  | 43 ++++++++++++++++++++++++++++++++++++++++---
>   include/linux/tee_drv.h | 36 ++++++++++++++++++++++++++++++++++++
>   2 files changed, 76 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index 7b2bb4c..a685940 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -15,7 +15,6 @@
>   #define pr_fmt(fmt) "%s: " fmt, __func__
>   
>   #include <linux/cdev.h>
> -#include <linux/device.h>
>   #include <linux/fs.h>
>   #include <linux/idr.h>
>   #include <linux/module.h>
> @@ -1027,6 +1026,30 @@ int tee_client_invoke_func(struct tee_context *ctx,
>   }
>   EXPORT_SYMBOL_GPL(tee_client_invoke_func);
>   
> +static int tee_client_device_match(struct device *dev,
> +				   struct device_driver *drv)
> +{
> +	struct tee_client_device *tee_device;
> +	const struct tee_client_device_id *id_table;
> +
> +	tee_device = to_tee_client_device(dev);
> +	id_table = to_tee_client_driver(drv)->id_table;
> +
> +	while (!uuid_is_null(&id_table->uuid)) {
> +		if (uuid_equal(&tee_device->id.uuid, &id_table->uuid))
> +			return 1;
> +		id_table++;
> +	}
> +
> +	return 0;
> +}
> +
> +struct bus_type tee_bus_type = {
> +	.name		= "tee",
> +	.match		= tee_client_device_match,
> +};
> +EXPORT_SYMBOL_GPL(tee_bus_type);
> +
>   static int __init tee_init(void)
>   {
>   	int rc;
> @@ -1040,10 +1063,23 @@ static int __init tee_init(void)
>   	rc = alloc_chrdev_region(&tee_devt, 0, TEE_NUM_DEVICES, "tee");
>   	if (rc) {
>   		pr_err("failed to allocate char dev region\n");
> -		class_destroy(tee_class);
> -		tee_class = NULL;
> +		goto chrdev_err;
>   	}
>   
> +	rc = bus_register(&tee_bus_type);
> +	if (rc) {
> +		pr_err("failed to register tee bus\n");
> +		goto bus_err;
> +	}
> +
> +	return 0;
> +
> +bus_err:
> +	unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> +chrdev_err:
> +	class_destroy(tee_class);
> +	tee_class = NULL;
> +

Hmm.. these error paths/labels look out-of-order.
See 'drivers/i2c/i2c-dev.c' for example.

Normally our error paths in an __init function is of the same order as 
the __exit function implementation. So this should be changed to 
something like:

   +out_unreg_class:
   +	class_destroy(tee_class);
   +	tee_class = NULL;
   +out_unreg_chrdev:
   +	unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);

>   	return rc;
>   }
>   
> @@ -1052,6 +1088,7 @@ static void __exit tee_exit(void)
>   	class_destroy(tee_class);
>   	tee_class = NULL;
>   	unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> +	bus_unregister(&tee_bus_type);

Since the __exit function order is the reverse of the __init one, lets 
reorder this as:

  +	bus_unregister(&tee_bus_type);
   	class_destroy(tee_class);
    	tee_class = NULL;
    	unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);

See 'drivers/i2c/i2c-dev.c' for example.

>   }
>   
>   subsys_initcall(tee_init);
> diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
> index 6cfe058..ed16bf1 100644
> --- a/include/linux/tee_drv.h
> +++ b/include/linux/tee_drv.h
> @@ -20,6 +20,8 @@
>   #include <linux/kref.h>
>   #include <linux/list.h>
>   #include <linux/tee.h>
> +#include <linux/device.h>
> +#include <linux/uuid.h>

If possible, let's keep alphabetical order of header files when making 
changes in the patch.

>   
>   /*
>    * The file describes the API provided by the generic TEE driver to the
> @@ -538,4 +540,38 @@ static inline bool tee_param_is_memref(struct tee_param *param)
>   	}
>   }
>   
> +extern struct bus_type tee_bus_type;
> +
> +/**
> + * struct tee_client_device_id - tee based device identifier
> + * @uuid:		For TEE based client devices we use the device uuid
> + *			as the identifier.
> + */
> +struct tee_client_device_id {
> +	uuid_t uuid;
> +};

Hmm.. Do we really need a struct for a single element, rather lets use a 
simple typedef here.

> +
> +/**
> + * struct tee_client_device - tee based device
> + * @id:			device identifier
> + * @dev:		device structure
> + */
> +struct tee_client_device {
> +	struct tee_client_device_id id;
> +	struct device dev;
> +};

Add a blank line here.

> +#define to_tee_client_device(d) container_of(d, struct tee_client_device, dev)
> +
> +/**
> + * struct tee_client_driver - tee client driver
> + * @id_table:		device id table supported by this driver
> + * @driver:		driver structure
> + */
> +struct tee_client_driver {
> +	const struct tee_client_device_id *id_table;
> +	struct device_driver driver;
> +};

Add a blank line here.
> +#define to_tee_client_driver(d) \
> +		container_of(d, struct tee_client_driver, driver)
> +
>   #endif /*__TEE_DRV_H*/
> 

Thanks,
Bhupesh
