Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25703C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 10:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1678218A2
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 10:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="A6Q3I0F7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfAXKPP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:15:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35963 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfAXKPP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 05:15:15 -0500
Received: by mail-wr1-f65.google.com with SMTP id u4so5827300wrp.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 02:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1R+OtakCaOngfOWwGZS/UHwpASgFhCWjKwVIIO0AIJ8=;
        b=A6Q3I0F7BQ8JM5MgrsqZEy9C/Ssy8zv3lt1iU1n2nJehmGslQ/oT9qrnWLgvavgQmq
         YSpNiZfBS7Y6ZN3RdKXVOd4BfLSkSV9RUBpHj/gsjCr0gMU9edt1e/NsweiQeeMsetla
         bfV8BPMltDixD0Llyb/wht/NU3m7O4GNEbdnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1R+OtakCaOngfOWwGZS/UHwpASgFhCWjKwVIIO0AIJ8=;
        b=X8DlbOygfV+N7hJv5+IF+Xz9a8118NWyXDuWB026InHI1PeKF4idaW9T+sCqNy1U35
         RJnvfC4pX3kAtbaMklFLqqvC3wFd/drjqbL2kiohZ9ttJJQsHAbda0n+oAWXb1rXmmAK
         guTJBzR2W95raPxf+tkk+my1GjsxhcaPKoI+oqtO0YlP15qppRr2dUEVVUpGqx8wkxVg
         F2f2Wl4k0Qs4qmN5soEInh020kq8lDQbM0bokJqJ7SB/Ls28qVnGPfmNO6PPsI4Ui3rg
         VaOT2m/ElgiTCBsKIdsCuGDUEj2ALC6A/Chyz7vOWM5tJ/DsRBe78CwZFrknLQFP+wED
         tESQ==
X-Gm-Message-State: AJcUukd9Xmm/OiDPXY1KqIm5zhoLZxpWHSBCzbWY3de9wjfPoFkITzPY
        zKfFHbIj+3fmEcdmW67IDLeQIA==
X-Google-Smtp-Source: ALg8bN7O1syVwAFBlsL+UGlpSUSNMM7UtIbQzCF1jXj+8ta8EAXIF+Cp2JxbcxoLwZdmiw7yj9eNkA==
X-Received: by 2002:a5d:550f:: with SMTP id b15mr6727740wrv.330.1548324912528;
        Thu, 24 Jan 2019 02:15:12 -0800 (PST)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id b12sm30046148wmj.3.2019.01.24.02.15.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 02:15:11 -0800 (PST)
Date:   Thu, 24 Jan 2019 10:15:09 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au,
        ard.biesheuvel@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        yamada.masahiro@socionext.com, michal.lkml@markovi.net,
        mpm@selenic.com, robh+dt@kernel.org, mark.rutland@arm.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org
Subject: Re: [PATCH v5 3/4] tee: optee: add TEE bus device enumeration support
Message-ID: <20190124101509.yrhyaj4xh32bn6pu@holly.lan>
References: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
 <1548309279-5281-4-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548309279-5281-4-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 11:24:38AM +0530, Sumit Garg wrote:
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
>  drivers/tee/optee/device.c        | 153 ++++++++++++++++++++++++++++++++++++++
>  drivers/tee/optee/optee_private.h |   3 +
>  4 files changed, 161 insertions(+)
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
> index 0000000..987e552
> --- /dev/null
> +++ b/drivers/tee/optee/device.c
> @@ -0,0 +1,153 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Linaro Ltd.
> + */
> +

Does there need to be a pr_fmt() here (to make the pr_*() messages from
this file match those from the optee/core.c):
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Alternatively you could get the probe function to pass the optee device
and use dev_*()...

TBH this is pretty severe nitpicking so feel free to add my reviewed
by the next time this patch comes around:

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>


Daniel.

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
> +		       struct tee_shm *device_shm, u32 *shm_size)
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
> +	param[0].u.memref.shm = device_shm;
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
> +static int optee_register_device(const uuid_t *device_uuid, u32 device_id)
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
> +	if (rc) {
> +		pr_err("device registration failed, err: %d\n", rc);
> +		kfree(optee_device);
> +	}
> +
> +	return rc;
> +}
> +
> +int optee_enumerate_devices(void)
> +{
> +	const uuid_t pta_uuid =
> +		UUID_INIT(0x7011a688, 0xddde, 0x4053,
> +			  0xa5, 0xa9, 0x7b, 0x3c, 0x4d, 0xdf, 0x13, 0xb8);
> +	struct tee_ioctl_open_session_arg sess_arg = {0};
> +	struct tee_shm *device_shm = NULL;
> +	const uuid_t *device_uuid = NULL;
> +	struct tee_context *ctx = NULL;
> +	u32 shm_size = 0, idx, num_devices = 0;
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
> +	rc = get_devices(ctx, sess_arg.session, NULL, &shm_size);
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
> +	num_devices = shm_size / sizeof(uuid_t);
> +
> +	for (idx = 0; idx < num_devices; idx++) {
> +		rc = optee_register_device(&device_uuid[idx], idx);
> +		if (rc)
> +			goto out_shm;
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
