Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34613 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfAJOTC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 09:19:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id j2so11616424wrw.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2019 06:19:00 -0800 (PST)
Date: Thu, 10 Jan 2019 14:18:56 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Sumit Garg <sumit.garg@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, jens.wiklander@linaro.org,
        mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        ard.biesheuvel@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org
Subject: Re: [PATCH v2 2/4] tee: optee: add TEE bus device enumeration support
Message-ID: <20190110141856.p3evqyf34py74gkg@holly.lan>
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-3-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547123097-16431-3-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2019 at 05:54:55PM +0530, Sumit Garg wrote:
> OP-TEE provides a pseudo TA to enumerate TAs which can act as devices/
> services for TEE bus. So implement device enumeration using invoke
> function: PTA_CMD_GET_DEVICES provided by pseudo TA to fetch array of
> device UUIDs. Also register these enumerated devices with TEE bus as
> "optee-clntX" device.
> 
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/tee/optee/Makefile        |   1 +
>  drivers/tee/optee/core.c          |   4 +
>  drivers/tee/optee/device.c        | 150 ++++++++++++++++++++++++++++++++++++++
>  drivers/tee/optee/optee_private.h |   3 +
>  4 files changed, 158 insertions(+)
>  create mode 100644 drivers/tee/optee/device.c
> 
> diff --git a/drivers/tee/optee/Makefile b/drivers/tee/optee/Makefile
> index 48d262a..56263ae 100644
> --- a/drivers/tee/optee/Makefile
> +++ b/drivers/tee/optee/Makefile
> @@ -5,3 +5,4 @@ optee-objs += call.o
>  optee-objs += rpc.o
>  optee-objs += supp.o
>  optee-objs += shm_pool.o
> +optee-objs += device.o
> diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
> index e5efce3..ac59c77 100644
> --- a/drivers/tee/optee/core.c
> +++ b/drivers/tee/optee/core.c
> @@ -634,6 +634,10 @@ static struct optee *optee_probe(struct device_node *np)
>  	if (optee->sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
>  		pr_info("dynamic shared memory is enabled\n");
>  
> +	rc = optee_enumerate_devices();
> +	if (rc)
> +		goto err;
> +
>  	pr_info("initialized driver\n");
>  	return optee;
>  err:
> diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
> new file mode 100644
> index 0000000..b38d24b
> --- /dev/null
> +++ b/drivers/tee/optee/device.c
> @@ -0,0 +1,150 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Linaro Ltd.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/tee_drv.h>
> +#include <linux/uuid.h>
> +#include "optee_private.h"
> +
> +/*
> + * Get device UUIDs
> + *
> + * [out]     memref[0]        Array of device UUIDs
> + *
> + * Return codes:
> + * TEE_SUCCESS - Invoke command success
> + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> + * TEE_ERROR_SHORT_BUFFER - Output buffer size less than required
> + */
> +#define PTA_CMD_GET_DEVICES		0x0
> +
> +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> +{
> +	if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int get_devices(struct tee_context *ctx, u32 session,
> +		       struct tee_shm *device_uuid, u32 *shm_size)

Missing const on device_uuid?


> +{
> +	u32 ret = 0;
> +	struct tee_ioctl_invoke_arg inv_arg = {0};
> +	struct tee_param param[4] = {0};
> +
> +	/* Invoke PTA_CMD_GET_DEVICES function */
> +	inv_arg.func = PTA_CMD_GET_DEVICES;
> +	inv_arg.session = session;
> +	inv_arg.num_params = 4;
> +
> +	/* Fill invoke cmd params */
> +	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
> +	param[0].u.memref.shm = device_uuid;
> +	param[0].u.memref.size = *shm_size;
> +	param[0].u.memref.shm_offs = 0;
> +
> +	ret = tee_client_invoke_func(ctx, &inv_arg, param);
> +	if ((ret < 0) || ((inv_arg.ret != TEEC_SUCCESS) &&
> +			  (inv_arg.ret != TEEC_ERROR_SHORT_BUFFER))) {
> +		pr_err("PTA_CMD_GET_DEVICES invoke function err: %x\n",
> +		       inv_arg.ret);
> +		return -EINVAL;
> +	}
> +
> +	*shm_size = param[0].u.memref.size;
> +
> +	return 0;
> +}
> +
> +static int optee_register_device(uuid_t *device_uuid, u32 device_id)

const?


> +{
> +	struct tee_client_device *optee_device = NULL;
> +	int rc;
> +
> +	optee_device = kzalloc(sizeof(*optee_device), GFP_KERNEL);
> +	if (!optee_device)
> +		return -ENOMEM;
> +
> +	optee_device->dev.bus = &tee_bus_type;
> +	dev_set_name(&optee_device->dev, "optee-clnt%u", device_id);
> +	uuid_copy(&optee_device->id.uuid, device_uuid);
> +
> +	rc = device_register(&optee_device->dev);
> +	if (rc)
> +		pr_err("device registration failed, err: %d\n", rc);

Leak optee_device?


> +
> +	return rc;
> +}
> +
> +int optee_enumerate_devices(void)
> +{
> +	uuid_t pta_uuid =
> +		UUID_INIT(0x7011a688, 0xddde, 0x4053,
> +			  0xa5, 0xa9, 0x7b, 0x3c, 0x4d, 0xdf, 0x13, 0xb8);

I think this could/should be const too.


> +	struct tee_ioctl_open_session_arg sess_arg = {0};
> +	struct tee_shm *device_shm = NULL;
> +	uuid_t *device_uuid = NULL;
> +	struct tee_context *ctx = NULL;
> +	u32 shm_size = 0, idx = 0;
> +	int rc;
> +
> +	/* Open context with OP-TEE driver */
> +	ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
> +	if (IS_ERR(ctx))
> +		return -ENODEV;
> +
> +	/* Open session with device enumeration pseudo TA */
> +	memcpy(sess_arg.uuid, pta_uuid.b, TEE_IOCTL_UUID_LEN);
> +	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> +	sess_arg.num_params = 0;
> +
> +	rc = tee_client_open_session(ctx, &sess_arg, NULL);
> +	if ((rc < 0) || (sess_arg.ret != TEEC_SUCCESS)) {
> +		/* Device enumeration pseudo TA not found */
> +		rc = 0;
> +		goto out_ctx;
> +	}
> +
> +	rc = get_devices(ctx, sess_arg.session, device_shm, &shm_size);

Use NULL and 0 directly here instead of relying on initialized values.
This makes it clear we are fetching the size of a buffer and are doing
something different to the next call to get_devices().


> +	if (rc < 0)
> +		goto out_sess;
> +
> +	device_shm = tee_shm_alloc(ctx, shm_size,
> +				   TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> +	if (IS_ERR(device_shm)) {
> +		pr_err("tee_shm_alloc failed\n");
> +		rc = PTR_ERR(device_shm);
> +		goto out_sess;
> +	}
> +
> +	rc = get_devices(ctx, sess_arg.session, device_shm, &shm_size);
> +	if (rc < 0)
> +		goto out_shm;
> +
> +	device_uuid = tee_shm_get_va(device_shm, 0);
> +	if (IS_ERR(device_uuid)) {
> +		pr_err("tee_shm_get_va failed\n");
> +		rc = PTR_ERR(device_uuid);
> +		goto out_shm;
> +	}
> +
> +	while (idx < shm_size / sizeof(uuid_t)) {

This is a very uncommon way to write a for loop ;-).


> +		rc = optee_register_device(&device_uuid[idx], idx);
> +		if (rc)
> +			goto out_shm;
> +		idx++;
> +	}
> +
> +out_shm:
> +	tee_shm_free(device_shm);
> +out_sess:
> +	tee_client_close_session(ctx, sess_arg.session);
> +out_ctx:
> +	tee_client_close_context(ctx);
> +
> +	return rc;
> +}
> diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
> index 35e7938..a5e84af 100644
> --- a/drivers/tee/optee/optee_private.h
> +++ b/drivers/tee/optee/optee_private.h
> @@ -28,6 +28,7 @@
>  #define TEEC_ERROR_BAD_PARAMETERS	0xFFFF0006
>  #define TEEC_ERROR_COMMUNICATION	0xFFFF000E
>  #define TEEC_ERROR_OUT_OF_MEMORY	0xFFFF000C
> +#define TEEC_ERROR_SHORT_BUFFER		0xFFFF0010
>  
>  #define TEEC_ORIGIN_COMMS		0x00000002
>  
> @@ -181,6 +182,8 @@ void optee_free_pages_list(void *array, size_t num_entries);
>  void optee_fill_pages_list(u64 *dst, struct page **pages, int num_pages,
>  			   size_t page_offset);
>  
> +int optee_enumerate_devices(void);
> +
>  /*
>   * Small helpers
>   */
> -- 
> 2.7.4
> 
