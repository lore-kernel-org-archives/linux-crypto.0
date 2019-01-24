Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5500BC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 12:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 105A82184B
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 12:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="fbea0lXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfAXMbG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 07:31:06 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37103 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfAXMbG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 07:31:06 -0500
Received: by mail-wr1-f67.google.com with SMTP id s12so6275355wrt.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 04:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V/v0frL8+qQM7571F76HEmdaJOQxUITPVIsAvitHRCA=;
        b=fbea0lXub9lLd/1i+T2Vps7l/Z7U7YA0qRjnZOuFcLgvqEy1Bx37zlRrLsbh3hBD6T
         rr/fJ5gbK2kpDkSntAcumVUf03tuh6+qmaR3ZRo9lDp5lnietXqLGwYOMb4DnySu1D1J
         6sMrOj3lGbmAvRF3YEV8U1HLo0+u5oCy7Y60c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V/v0frL8+qQM7571F76HEmdaJOQxUITPVIsAvitHRCA=;
        b=KNFi00p8EpmLF+FOGkp2pVRDGtbKvlhGDVvnFhYnDROPsFpUvJGzH7twvo0Im7pcvI
         jjL2MACMPDKymiPOzb+l3O4pkjNBcfmYuKSniF7ImNN+bty1U9BqJbRNgmFPpRAxIrFq
         RqVL1Q/1LSV6/2rcNVuLvOsXWZWIsLQ7/6SaZinz/Fa4wAQd+gCbGxmfyOZsptQZuQ0d
         eUPdLErihz+YH/2vSI7tJlXweruFB2OunibpDnS4h/bj4AuIMf2SOhpQYqsbFazgyzdD
         Df/8z6EjChkEjFJYZdNCkgZXWRqaARBp8yl18SUNUBEmR6s3ut0S+AGLmbSP0LiFIbBE
         zhJQ==
X-Gm-Message-State: AJcUukeucpKIATWfvlzMr7VV4dF8rjf2E8UMvb9G5y1zz5izK5AkB9Rs
        pATFTRWa7Z6vgEiskWcSIB2lJw==
X-Google-Smtp-Source: ALg8bN5aPlO5L+jsEp2Fs18fzdwfgQrOT1fwvnPMLM2kasrnQRaWuFebxMCvxUHE58NoJ5it8aVdnQ==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr7006744wrt.180.1548333063178;
        Thu, 24 Jan 2019 04:31:03 -0800 (PST)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id a62sm51252540wmf.47.2019.01.24.04.31.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 04:31:01 -0800 (PST)
Date:   Thu, 24 Jan 2019 12:30:58 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au,
        ard.biesheuvel@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        yamada.masahiro@socionext.com, michal.lkml@markovi.net,
        mpm@selenic.com, robh+dt@kernel.org, mark.rutland@arm.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org
Subject: Re: [PATCH v5 4/4] hwrng: add OP-TEE based rng driver
Message-ID: <20190124123058.yluhsd4f523dakhx@holly.lan>
References: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
 <1548309279-5281-5-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548309279-5281-5-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 11:24:39AM +0530, Sumit Garg wrote:
> On ARM SoC's with TrustZone enabled, peripherals like entropy sources
> might not be accessible to normal world (linux in this case) and rather
> accessible to secure world (OP-TEE in this case) only. So this driver
> aims to provides a generic interface to OP-TEE based random number
> generator service.
> 
> This driver registers on TEE bus to interact with OP-TEE based rng
> device/service.
> 
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  MAINTAINERS                        |   5 +
>  drivers/char/hw_random/Kconfig     |  15 ++
>  drivers/char/hw_random/Makefile    |   1 +
>  drivers/char/hw_random/optee-rng.c | 274 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 295 insertions(+)
>  create mode 100644 drivers/char/hw_random/optee-rng.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 51029a4..dcef7e9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11262,6 +11262,11 @@ M:	Jens Wiklander <jens.wiklander@linaro.org>
>  S:	Maintained
>  F:	drivers/tee/optee/
>  
> +OP-TEE RANDOM NUMBER GENERATOR (RNG) DRIVER
> +M:	Sumit Garg <sumit.garg@linaro.org>
> +S:	Maintained
> +F:	drivers/char/hw_random/optee-rng.c
> +
>  OPA-VNIC DRIVER
>  M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
>  M:	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index dac895d..25a7d8f 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -424,6 +424,21 @@ config HW_RANDOM_EXYNOS
>  	  will be called exynos-trng.
>  
>  	  If unsure, say Y.
> +
> +config HW_RANDOM_OPTEE
> +	tristate "OP-TEE based Random Number Generator support"
> +	depends on OPTEE
> +	default HW_RANDOM
> +	help
> +	  This  driver provides support for OP-TEE based Random Number
> +	  Generator on ARM SoCs where hardware entropy sources are not
> +	  accessible to normal world (Linux).
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called optee-rng.
> +
> +	  If unsure, say Y.
> +
>  endif # HW_RANDOM
>  
>  config UML_RANDOM
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index e35ec3c..7c9ef4a 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -38,3 +38,4 @@ obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
>  obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
>  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
>  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
> +obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> new file mode 100644
> index 0000000..4ad0eca
> --- /dev/null
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -0,0 +1,274 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2018-2019 Linaro Ltd.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/of.h>
> +#include <linux/hw_random.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/tee_drv.h>
> +#include <linux/uuid.h>
> +
> +#define DRIVER_NAME "optee-rng"
> +
> +#define TEE_ERROR_HEALTH_TEST_FAIL	0x00000001
> +
> +/*
> + * TA_CMD_GET_ENTROPY - Get Entropy from RNG
> + *
> + * param[0] (inout memref) - Entropy buffer memory reference
> + * param[1] unused
> + * param[2] unused
> + * param[3] unused
> + *
> + * Result:
> + * TEE_SUCCESS - Invoke command success
> + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> + * TEE_ERROR_NOT_SUPPORTED - Requested entropy size greater than size of pool
> + * TEE_ERROR_HEALTH_TEST_FAIL - Continuous health testing failed
> + */
> +#define TA_CMD_GET_ENTROPY		0x0
> +
> +/*
> + * TA_CMD_GET_RNG_INFO - Get RNG information
> + *
> + * param[0] (out value) - value.a: RNG data-rate in bytes per second
> + *                        value.b: Quality/Entropy per 1024 bit of data
> + * param[1] unused
> + * param[2] unused
> + * param[3] unused
> + *
> + * Result:
> + * TEE_SUCCESS - Invoke command success
> + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> + */
> +#define TA_CMD_GET_RNG_INFO		0x1
> +
> +#define MAX_ENTROPY_REQ_SZ		(4 * 1024)
> +
> +static struct tee_context *ctx;
> +static struct tee_shm *entropy_shm_pool;
> +static u32 ta_rng_data_rate;
> +static u32 ta_rng_session_id;
> +
> +static size_t get_optee_rng_data(void *buf, size_t req_size)
> +{
> +	u32 ret = 0;
> +	u8 *rng_data = NULL;
> +	size_t rng_size = 0;
> +	struct tee_ioctl_invoke_arg inv_arg = {0};
> +	struct tee_param param[4] = {0};
> +
> +	/* Invoke TA_CMD_GET_ENTROPY function of Trusted App */
> +	inv_arg.func = TA_CMD_GET_ENTROPY;
> +	inv_arg.session = ta_rng_session_id;
> +	inv_arg.num_params = 4;
> +
> +	/* Fill invoke cmd params */
> +	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
> +	param[0].u.memref.shm = entropy_shm_pool;
> +	param[0].u.memref.size = req_size;
> +	param[0].u.memref.shm_offs = 0;
> +
> +	ret = tee_client_invoke_func(ctx, &inv_arg, param);
> +	if ((ret < 0) || (inv_arg.ret != 0)) {
> +		pr_err("TA_CMD_GET_ENTROPY invoke function error: %x\n",
> +		       inv_arg.ret);

Why can't these be dev_err()?


> +		return 0;
> +	}
> +
> +	rng_data = tee_shm_get_va(entropy_shm_pool, 0);
> +	if (IS_ERR(rng_data)) {
> +		pr_err("tee_shm_get_va failed\n");
> +		return 0;
> +	}
> +
> +	rng_size = param[0].u.memref.size;
> +	memcpy(buf, rng_data, rng_size);
> +
> +	return rng_size;
> +}
> +
> +static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +	u8 *data = buf;
> +	size_t read = 0, rng_size = 0;
> +	int timeout = 1;
> +
> +	if (max > MAX_ENTROPY_REQ_SZ)
> +		max = MAX_ENTROPY_REQ_SZ;
> +
> +	while (read == 0) {
> +		rng_size = get_optee_rng_data(data, (max - read));
> +
> +		data += rng_size;
> +		read += rng_size;
> +
> +		if (wait) {
> +			if (timeout-- == 0)
> +				return read;
> +			msleep((1000 * (max - read)) / ta_rng_data_rate);
> +		} else {
> +			return read;
> +		}
> +	}
> +
> +	return read;
> +}
> +
> +static int optee_rng_init(struct hwrng *rng)
> +{
> +	entropy_shm_pool = tee_shm_alloc(ctx, MAX_ENTROPY_REQ_SZ,
> +					 TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> +	if (IS_ERR(entropy_shm_pool)) {
> +		pr_err("tee_shm_alloc failed\n");

This one is slightly annoying. It could be a dev_err() but needs quite
a bit of machinary hooked up (optee_rng_private) to allow you to look up
the device from the hwrng.

It would allow you to move all those statics (like entropy_shm_pool)
into a proper context structure though...


Daniel.



> +		return PTR_ERR(entropy_shm_pool);
> +	}
> +
> +	return 0;
> +}
> +
> +static void optee_rng_cleanup(struct hwrng *rng)
> +{
> +	tee_shm_free(entropy_shm_pool);
> +}
> +
> +static struct hwrng optee_rng = {
> +	.name		= DRIVER_NAME,
> +	.init		= optee_rng_init,
> +	.cleanup	= optee_rng_cleanup,
> +	.read		= optee_rng_read,
> +};
> +
> +static int get_optee_rng_info(struct device *dev)
> +{
> +	u32 ret = 0;
> +	struct tee_ioctl_invoke_arg inv_arg = {0};
> +	struct tee_param param[4] = {0};
> +
> +	/* Invoke TA_CMD_GET_RNG_INFO function of Trusted App */
> +	inv_arg.func = TA_CMD_GET_RNG_INFO;
> +	inv_arg.session = ta_rng_session_id;
> +	inv_arg.num_params = 4;
> +
> +	/* Fill invoke cmd params */
> +	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_OUTPUT;
> +
> +	ret = tee_client_invoke_func(ctx, &inv_arg, param);
> +	if ((ret < 0) || (inv_arg.ret != 0)) {
> +		dev_err(dev, "TA_CMD_GET_RNG_INFO invoke func error: %x\n",
> +			inv_arg.ret);
> +		return -EINVAL;
> +	}
> +
> +	ta_rng_data_rate = param[0].u.value.a;
> +	optee_rng.quality = param[0].u.value.b;
> +
> +	return 0;
> +}
> +
> +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> +{
> +	if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int optee_rng_probe(struct device *dev)
> +{
> +	struct tee_client_device *rng_device = to_tee_client_device(dev);
> +	int ret = 0, err = -ENODEV;
> +	struct tee_ioctl_open_session_arg sess_arg = {0};
> +
> +	/* Open context with TEE driver */
> +	ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
> +	if (IS_ERR(ctx))
> +		return -ENODEV;
> +
> +	/* Open session with hwrng Trusted App */
> +	memcpy(sess_arg.uuid, rng_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
> +	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> +	sess_arg.num_params = 0;
> +
> +	ret = tee_client_open_session(ctx, &sess_arg, NULL);
> +	if ((ret < 0) || (sess_arg.ret != 0)) {
> +		dev_err(dev, "tee_client_open_session failed, error: %x\n",
> +			sess_arg.ret);
> +		err = -EINVAL;
> +		goto out_ctx;
> +	}
> +	ta_rng_session_id = sess_arg.session;
> +
> +	err = get_optee_rng_info(dev);
> +	if (err)
> +		goto out_sess;
> +
> +	err = hwrng_register(&optee_rng);
> +	if (err) {
> +		dev_err(dev, "hwrng registration failed (%d)\n", err);
> +		goto out_sess;
> +	}
> +
> +	return 0;
> +
> +out_sess:
> +	tee_client_close_session(ctx, ta_rng_session_id);
> +out_ctx:
> +	tee_client_close_context(ctx);
> +
> +	return err;
> +}
> +
> +static int optee_rng_remove(struct device *dev)
> +{
> +	hwrng_unregister(&optee_rng);
> +	tee_client_close_session(ctx, ta_rng_session_id);
> +	tee_client_close_context(ctx);
> +
> +	return 0;
> +}
> +
> +const struct tee_client_device_id optee_rng_id_table[] = {
> +	{UUID_INIT(0xab7a617c, 0xb8e7, 0x4d8f,
> +		   0x83, 0x01, 0xd0, 0x9b, 0x61, 0x03, 0x6b, 0x64)},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(tee, optee_rng_id_table);
> +
> +static struct tee_client_driver optee_rng_driver = {
> +	.id_table	= optee_rng_id_table,
> +	.driver		= {
> +		.name		= DRIVER_NAME,
> +		.bus		= &tee_bus_type,
> +		.probe		= optee_rng_probe,
> +		.remove		= optee_rng_remove,
> +	},
> +};
> +
> +static int __init optee_rng_mod_init(void)
> +{
> +	int rc;
> +
> +	rc = driver_register(&optee_rng_driver.driver);
> +	if (rc)
> +		pr_warn("driver registration failed, err: %d", rc);
> +
> +	return rc;
> +}
> +
> +static void __exit optee_rng_mod_exit(void)
> +{
> +	driver_unregister(&optee_rng_driver.driver);
> +}
> +
> +module_init(optee_rng_mod_init);
> +module_exit(optee_rng_mod_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Sumit Garg <sumit.garg@linaro.org>");
> -- 
> 2.7.4
> 
